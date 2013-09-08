//
//  SandboxViewController.m
//  WeViews2DemoApp
//
//  Copyright (c) 2013 Charles Matthew Chen. All rights reserved.
//
//  Distributed under the Apache License v2.0.
//  http://www.apache.org/licenses/LICENSE-2.0.html
//

#import "WeView2.h"
#import "SandboxViewController.h"
#import "WeView2Macros.h"
#import "WeView2DemoConstants.h"
#import "DefaultSandboxView.h"
#import <QuartzCore/QuartzCore.h>
#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface SandboxSnapshot : NSObject

@property (nonatomic) UIImage *image;
@property (nonatomic) CGSize rootViewSize;

@end

#pragma mark -

@implementation SandboxSnapshot

- (UIImage *)cropSnapshotWithSize:(CGSize)imageSize
{
    imageSize = CGSizeMin(imageSize, self.image.size);

    UIGraphicsBeginImageContext(imageSize);
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextTranslateCTM(context, 0.0, imageSize.height);
    CGContextScaleCTM(context, 1.0, -1.0);

    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    CGContextSetShouldAntialias(context, YES);
    CGContextSetAllowsAntialiasing(context, YES);
    CGContextSetShouldSmoothFonts(context, YES);
    CGContextSetAllowsFontSmoothing(context, YES);

    CGRect drawRect = CGRectZero;
    drawRect.size = self.image.size;
    drawRect.origin.x = roundf((imageSize.width - self.image.size.width) * 0.5f);
    drawRect.origin.y = roundf((imageSize.height - self.image.size.height) * 0.5f);
    CGContextDrawImage(context, drawRect, self.image.CGImage);

    UIImage* result = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return result;
}

@end

#pragma mark -

@interface SandboxViewController ()

@property (nonatomic) SandboxView *sandboxView;

@property (nonatomic) DemoModel *demoModel;

@property (nonatomic) NSMutableArray *snapshots;
@property (nonatomic) NSString *snapshotsFolderPath;
@property (nonatomic) int exportCounter;

@end

#pragma mark -

@implementation SandboxViewController

- (id)init
{
    self = [super init];
    if (self)
    {
        self.title = NSLocalizedString(@"Sandbox", nil);
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleSelectionAltered:)
                                                     name:NOTIFICATION_SELECTION_ALTERED
                                                   object:nil];
        self.snapshots = [NSMutableArray array];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

#ifdef TUTORIAL
    self.navigationItem.leftBarButtonItems = @[
                                               [[UIBarButtonItem alloc] initWithTitle:@"Snapshot"
                                                                                style:UIBarButtonItemStyleBordered
                                                                               target:self
                                                                               action:@selector(addSnapshot:)],
                                               [[UIBarButtonItem alloc] initWithTitle:@"Export"
                                                                                style:UIBarButtonItemStyleBordered
                                                                               target:self
                                                                               action:@selector(exportSnapshots:)],
                                               ];
#endif
}

- (void)addSnapshot:(id)sender
{
    CGSize imageSize = self.sandboxView.size;

    UIGraphicsBeginImageContext(imageSize);
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    CGContextSetShouldAntialias(context, YES);
    CGContextSetAllowsAntialiasing(context, YES);
    CGContextSetShouldSmoothFonts(context, YES);
    CGContextSetAllowsFontSmoothing(context, YES);

    [self.sandboxView setControlsHidden:YES];
    [self.sandboxView.layer renderInContext:context];
    [self.sandboxView setControlsHidden:NO];

    UIImage* viewImage = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    SandboxSnapshot *snapshot = [[SandboxSnapshot alloc] init];
    snapshot.image = viewImage;
    snapshot.rootViewSize = [self.sandboxView rootViewSize];
    [self.snapshots addObject:snapshot];
}

- (void)exportSnapshots:(id)sender
{
    if ([self.snapshots count] < 1)
    {
        return;
    }
    [self makeAnimatedGifWithSnapshots:self.snapshots];
    self.snapshots = [NSMutableArray array];
}

- (void)makeAnimatedGifWithSnapshots:(NSArray *)snapshots
{
    // Code from: http://stackoverflow.com/questions/14915138/create-and-and-export-an-animated-gif-via-ios

    int frameCount = [snapshots count];
    CGFloat kFrameDuration = 1.f;

    // We'll need a property dictionary to specify the number of times the animation should repeat:
    NSDictionary *fileProperties = @{
                                     (__bridge id) kCGImagePropertyGIFDictionary: @{
                                             (__bridge id) kCGImagePropertyGIFLoopCount: @0,
                                             }
                                     };

    NSDictionary *frameProperties = @{
                                      (__bridge id) kCGImagePropertyGIFDictionary: @{
                                              // a float (not double!) in seconds, rounded to centiseconds in the GIF data
                                              (__bridge id) kCGImagePropertyGIFDelayTime: @(kFrameDuration),
                                              }
                                      };

    if (!self.snapshotsFolderPath)
    {
        // Create a URL for the GIF in our home directory:
        NSDictionary *env = [[NSProcessInfo processInfo] environment];
        NSString *simulatorUser = env[@"USER"];
        if (!simulatorUser)
        {
            NSLog(@"Can't identify simulator user.");
            return;
        }

        NSString *uuid = [[NSProcessInfo processInfo] globallyUniqueString];
        NSString *folderPath = [[@"/Users/" stringByAppendingPathComponent:simulatorUser]
                                stringByAppendingPathComponent:uuid];
        NSError *error;
        BOOL created = [[NSFileManager defaultManager] createDirectoryAtPath:folderPath
                                                 withIntermediateDirectories:NO
                                                                  attributes:nil
                                                                       error:&error];
        WeView2Assert(created);
        WeView2Assert(!error);
        self.snapshotsFolderPath = folderPath;
    }

    NSString *filePath = [self.snapshotsFolderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"snapshot-%d.gif",
                                                                                   self.exportCounter]];
    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:filePath
                                            isDirectory:NO];

    // Now we can create a CGImageDestination that writes a GIF to the specified URL:

    CGImageDestinationRef destination = CGImageDestinationCreateWithURL((__bridge CFURLRef) fileURL, kUTTypeGIF, frameCount, NULL);
    CGImageDestinationSetProperties(destination, (__bridge CFDictionaryRef)fileProperties);
    // I discovered that passing fileProperties as the last argument of CGImageDestinationCreateWithURL does not work. You have to use CGImageDestinationSetProperties.

    // Now we can create and write our frames:

    CGSize maxSnapshotSize = CGSizeZero;
    for (NSUInteger i = 0; i < frameCount; i++)
    {
        SandboxSnapshot *snapshot = snapshots[i];
        maxSnapshotSize = CGSizeMax(maxSnapshotSize, snapshot.rootViewSize);
    }
    CGSize frameSize = CGSizeAdd(maxSnapshotSize, CGSizeMake(20, 20));

    NSString *exportUuid = [[NSProcessInfo processInfo] globallyUniqueString];
    for (NSUInteger i = 0; i < frameCount; i++)
    {
        @autoreleasepool {
            SandboxSnapshot *snapshot = snapshots[i];

            UIImage *image = [snapshot cropSnapshotWithSize:frameSize];

            CGImageDestinationAddImage(destination,
                                       image.CGImage,
                                       (__bridge CFDictionaryRef) frameProperties);

            NSString *framePath = [self.snapshotsFolderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"snapshot-%@-%d.png",
                                                                                           exportUuid,
//                                                                                            self.exportCounter,
                                                                                            i]];
            [UIImagePNGRepresentation(image) writeToFile:framePath
                                                       atomically:YES];
        }
    }

    // Note that we pass the frame properties dictionary along with each frame image.
    //
    // After we've added exactly the specified number of frames, we finalize the destination and release it:

    if (!CGImageDestinationFinalize(destination))
    {
        WeView2Assert(0);
    }
    CFRelease(destination);

    self.exportCounter++;
}

- (void)handleSelectionAltered:(NSNotification *)notification
{
    [self.sandboxView setNeedsLayout];
}

- (void)loadView
{
    self.sandboxView = [[DefaultSandboxView alloc] init];
    self.sandboxView.debugName = @"sandboxView";
    self.view = self.sandboxView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)displayDemo:(Demo *)demo
{
    self.demoModel = demo.createDemoModelBlock();
    [self.sandboxView displayDemoModel:self.demoModel];

    dispatch_async(dispatch_get_main_queue(), ^{
//        NSLog(@"displayDemo: %@ %d",
//              [self.demoModel.rootView debugName],
//              [self.demoModel.rootView.subviews count]);

        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_DEMO_CHANGED
                                                            object:self.demoModel];
    });
}

- (void)viewWillLayoutSubviews
{
}

- (void)viewDidLayoutSubviews
{
    dispatch_async(dispatch_get_main_queue(), ^{
//        NSLog(@"viewDidLayoutSubviews: %@ %d",
//              [self.demoModel.rootView debugName],
//              [self.demoModel.rootView.subviews count]);

        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SELECTION_CHANGED
                                                            object:self.demoModel.selection];
    });
}

@end
