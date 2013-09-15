//
//  SandboxViewController.m
//  WeViews2DemoApp
//
//  Copyright (c) 2013 Charles Matthew Chen. All rights reserved.
//
//  Distributed under the Apache License v2.0.
//  http://www.apache.org/licenses/LICENSE-2.0.html
//

#import "WeView.h"
#import "SandboxViewController.h"
#import "WeViewMacros.h"
#import "WeViewDemoConstants.h"
#import "DefaultSandboxView.h"
#import <QuartzCore/QuartzCore.h>
#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/MobileCoreServices.h>

#import <AVFoundation/AVFoundation.h>
#import <QuartzCore/QuartzCore.h>

@interface SandboxSnapshot : NSObject

//@property (nonatomic) UIImage *image;
@property (nonatomic) CGSize rootViewSize;
@property (nonatomic) NSString *filePath;

@end

#pragma mark -

@implementation SandboxSnapshot

- (void)setImage:(UIImage *)image
{
    NSString *imageUuid = [[NSProcessInfo processInfo] globallyUniqueString];
    self.filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"snapshot-%@.png",
                                                                                 imageUuid]];
    [UIImagePNGRepresentation(image) writeToFile:self.filePath
                                      atomically:YES];
}

- (UIImage *)image
{
    return [UIImage imageWithContentsOfFile:self.filePath];
}

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

    [[UIColor colorWithWhite:0.5f alpha:0.5f] setStroke];
    CGContextSetLineWidth(context, 1.f);
    CGContextStrokeRect(context, CGRectMake(0, 0, imageSize.width, imageSize.height));

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

@property (nonatomic) CADisplayLink *displayLink;
//@property (nonatomic) NSDate *videoStartDate;
//@property (nonatomic) AVAssetWriterInput *writerInput;
//@property (nonatomic) AVAssetWriter *videoWriter;
//@property (nonatomic) AVAssetWriterInputPixelBufferAdaptor *adaptor;
//@property (nonatomic) int videoFrameCount;

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
    self.navigationItem.rightBarButtonItems = @[
                                                [[UIBarButtonItem alloc] initWithTitle:@"Record"
                                                                                 style:UIBarButtonItemStyleBordered
                                                                                target:self
                                                                                action:@selector(startVideo:)],
                                                [[UIBarButtonItem alloc] initWithTitle:@"Cut"
                                                                                 style:UIBarButtonItemStyleBordered
                                                                                target:self
                                                                                action:@selector(stopVideo:)],
                                                ];
#endif
}

- (void)startVideo:(id)sender
{
    if (!self.displayLink)
    {
        self.displayLink = [[UIScreen mainScreen] displayLinkWithTarget:self
                                                               selector:@selector(grabVideoFrame)];
        [self.displayLink setFrameInterval:1];
        [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];

        [self startVideoSession];
    }
    else
    {
        if (self.displayLink.paused)
        {
            self.displayLink.paused = NO;
        }
    }
}

- (void)stopVideo:(id)sender
{
    if (self.displayLink)
    {
        [self.displayLink invalidate];
        self.displayLink = nil;

        [self endVideoSession];
    }
}

- (id)lastResponderOfKind:(Class)clazz
            ignoringClass:(Class)ignoringClass
{
    UIResponder *responder = self;
    id result = nil;
    while (responder != nil)
    {
        if (ignoringClass && [responder isKindOfClass:ignoringClass])
        {
            // Ignore.
        }
        else if ([responder isKindOfClass:clazz])
        {
            result = responder;
        }
        responder = [responder nextResponder];
    }
    return result;
}

- (UIViewController *)lastViewControllerInResponderChain
{
    return [self lastResponderOfKind:[UIViewController class]
                       ignoringClass:[UIWindow class]];
}

- (void)startVideoSession
{
}

- (void)grabVideoFrame
{
    [self addSnapshot:nil];
}

- (void)endVideoSession
{
    if ([self.snapshots count] < 1)
    {
        return;
    }

    CGSize maxSnapshotSize = CGSizeZero;
//    NSArray *snapshots = self.snapshots;
    int frameCount = [self.snapshots count];
    for (NSUInteger i = 0; i < frameCount; i++)
    {
        SandboxSnapshot *snapshot = self.snapshots[i];
        maxSnapshotSize = CGSizeMax(maxSnapshotSize, snapshot.rootViewSize);
    }
    DebugSize(@"maxSnapshotSize", maxSnapshotSize);
    CGSize frameSize = CGSizeAdd(CGSizeFloor(maxSnapshotSize), CGSizeMake(20, 20));
    // Handbrake doesn't handle odd frame sizes well, so ensure that the width and height are even
    // multiples of 4.
    frameSize = CGSizeScale(CGSizeFloor(CGSizeScale(frameSize, 1 / 4.f)), 4.f);
    DebugSize(@"frameSize", frameSize);

    [self ensureSnapshotsFolderPath];

    NSString *videoUuid = [[NSProcessInfo processInfo] globallyUniqueString];
    NSString *filePath = [self.snapshotsFolderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"video-%@.mov",
                                                                                   videoUuid]];
    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:filePath
                                            isDirectory:NO];

    NSError *error = nil;

    AVAssetWriter *videoWriter = [[AVAssetWriter alloc] initWithURL:fileURL
                                                 fileType:AVFileTypeQuickTimeMovie
                                                    error:&error];
    WeViewAssert(videoWriter);
    WeViewAssert(!error);
    NSParameterAssert(videoWriter);

    NSDictionary *outputSettings = @{
                                    AVVideoCodecKey: AVVideoCodecH264,
                                    AVVideoWidthKey: @(frameSize.width),
                                    AVVideoHeightKey: @(frameSize.height),
//                                    AVVideoCompressionPropertiesKey: @{
//                                            AVVideoAverageBitRateKey: @(4*(1024.0*1024.0)),
//                                            },
//                                    [compressionSettings setValue: AVVideoProfileLevelH264Main41 forKey: AVVideoProfileLevelKey];
                                    };
    AVAssetWriterInput *writerInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo
                                                          outputSettings:outputSettings];
    WeViewAssert(writerInput);

    NSDictionary *sourcePixelBufferAttributes = @{
                                                  (__bridge NSString *) kCVPixelBufferPixelFormatTypeKey: @(kCVPixelFormatType_32ARGB),
                                                  };
    AVAssetWriterInputPixelBufferAdaptor *adaptor = [AVAssetWriterInputPixelBufferAdaptor assetWriterInputPixelBufferAdaptorWithAssetWriterInput:writerInput
                                                                                    sourcePixelBufferAttributes:sourcePixelBufferAttributes];
    WeViewAssert(adaptor);

    NSParameterAssert(writerInput);
    NSParameterAssert([videoWriter canAddInput:writerInput]);
    [videoWriter addInput:writerInput];

    [videoWriter startWriting];
    [videoWriter startSessionAtSourceTime:kCMTimeZero];

    int videoFrameCount = 0;
    while ([self.snapshots count] > 0)
//    for (NSUInteger i = 0; i < frameCount; i++)
    {
        {
            NSDate *maxDate = [NSDate dateWithTimeIntervalSinceNow:0.01];
            [[NSRunLoop currentRunLoop] runUntilDate:maxDate];
        }

        @autoreleasepool
        {
            SandboxSnapshot *snapshot = self.snapshots[0];
            [self.snapshots removeObjectAtIndex:0];

            UIImage *image = [snapshot cropSnapshotWithSize:frameSize];
            NSParameterAssert(image);
            WeViewAssert(image);

            CVPixelBufferRef pixelBuffer = [self pixelBufferFromCGImage:image.CGImage];
            NSParameterAssert(pixelBuffer);

            CMTime frameTime = CMTimeMake(videoFrameCount, 30);

            while (!adaptor.assetWriterInput.readyForMoreMediaData)
            {
                NSDate *maxDate = [NSDate dateWithTimeIntervalSinceNow:0.1];
                [[NSRunLoop currentRunLoop] runUntilDate:maxDate];
            }

            [adaptor appendPixelBuffer:pixelBuffer
                  withPresentationTime:frameTime];
            CVPixelBufferRelease(pixelBuffer);

            videoFrameCount++;
        }
    }

    [self.snapshots removeAllObjects];

    [writerInput markAsFinished];
    CMTime frameTime = CMTimeMake(videoFrameCount, 30);
    [videoWriter endSessionAtSourceTime:frameTime];

    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^{
        [videoWriter finishWriting];
    });
}

//- (void)startVideoSession
//{
//    [self ensureSnapshotsFolderPath];
//
//    UIViewController *rootViewController = [self lastViewControllerInResponderChain];
//
//    NSString *videoUuid = [[NSProcessInfo processInfo] globallyUniqueString];
//    NSString *filePath = [self.snapshotsFolderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"video-%@.mov",
//                                                                                   videoUuid]];
//    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:filePath
//                                            isDirectory:NO];
//
//    NSError *error = nil;
//    self.videoWriter = [[AVAssetWriter alloc] initWithURL:fileURL
//                                                 fileType:AVFileTypeQuickTimeMovie
//                                                    error:&error];
//    WeViewAssert(self.videoWriter);
//    WeViewAssert(!error);
//    NSParameterAssert(self.videoWriter);
//
//    NSDictionary *videoSettings = @{
//                                    AVVideoCodecKey: AVVideoCodecH264,
//                                    AVVideoWidthKey: @(rootViewController.view.width),
//                                    AVVideoHeightKey: @(rootViewController.view.height),
//                                    };
//    [NSDictionary dictionaryWithObjectsAndKeys:
//                                   AVVideoCodecH264, AVVideoCodecKey,
//                                   [NSNumber numberWithInt:703], AVVideoWidthKey,
//                                   [NSNumber numberWithInt:704], AVVideoHeightKey,
//                                   nil];
//    self.writerInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo
//                                                          outputSettings:videoSettings];
//    WeViewAssert(self.writerInput);
//
//    NSDictionary *sourcePixelBufferAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
//                                                 [NSNumber numberWithInt:kCVPixelFormatType_32ARGB], kCVPixelBufferPixelFormatTypeKey, nil];
//    self.adaptor = [AVAssetWriterInputPixelBufferAdaptor assetWriterInputPixelBufferAdaptorWithAssetWriterInput:self.writerInput
//                                                                                    sourcePixelBufferAttributes:sourcePixelBufferAttributes];
//    WeViewAssert(self.adaptor);
//
//
//    NSParameterAssert(self.writerInput);
//    NSParameterAssert([self.videoWriter canAddInput:self.writerInput]);
//    [self.videoWriter addInput:self.writerInput];
//
//    [self.videoWriter startWriting];
//    [self.videoWriter startSessionAtSourceTime:kCMTimeZero];
//    self.videoStartDate = [NSDate date];
//    self.videoFrameCount = 0;
//}
//
//- (void)grabVideoFrame
//{
//    WeViewAssert(self.videoWriter);
//    WeViewAssert(self.writerInput);
//    WeViewAssert(self.adaptor);
//
//    CVPixelBufferRef pixelBuffer = [self grabPixelBuffer];
//
//    CMTime frameTime = CMTimeMake(self.videoFrameCount, 30);
//
//    [self.adaptor appendPixelBuffer:pixelBuffer
//               withPresentationTime:frameTime];
//    CVPixelBufferRelease(pixelBuffer);
//
//    self.videoFrameCount++;
//}
//
//- (void)endVideoSession
//{
//    [self.writerInput markAsFinished];
//    CMTime frameTime = CMTimeMake(self.videoFrameCount, 30);
//    [self.videoWriter endSessionAtSourceTime:frameTime];
//
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
//    dispatch_async(queue, ^{
//        [self.videoWriter finishWriting];
//
//        self.writerInput = nil;
//        self.videoWriter = nil;
//        self.adaptor = nil;
//    });
//}

- (CVPixelBufferRef)pixelBufferFromCGImage:(CGImageRef)image
{
    CGSize frameSize = CGSizeMake(CGImageGetWidth(image),
                                  CGImageGetHeight(image));

    //    NSLog(@"frameSize: %@", NSStringFromCGSize(frameSize));

    NSDictionary *options = @{
                              (NSString *)kCVPixelBufferCGImageCompatibilityKey: @YES,
                              (NSString *)kCVPixelBufferCGBitmapContextCompatibilityKey: @YES,
                              };
    CVPixelBufferRef pxbuffer = NULL;
    CVReturn status = CVPixelBufferCreate(kCFAllocatorDefault,
                                          frameSize.width,
                                          frameSize.height,
                                          kCVPixelFormatType_32ARGB,
                                          (__bridge CFDictionaryRef) options,
                                          &pxbuffer);
    NSParameterAssert(status == kCVReturnSuccess && pxbuffer != NULL);

    CVPixelBufferLockBaseAddress(pxbuffer, 0);
    void *pxdata = CVPixelBufferGetBaseAddress(pxbuffer);
    NSParameterAssert(pxdata != NULL);

//    CGAffineTransform frameTransform = CGAffineTransformIdentity;
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pxdata,
                                                 frameSize.width,
                                                 frameSize.height,
                                                 8,
//                                                 0,
                                                 CVPixelBufferGetBytesPerRow(pxbuffer),
                                                 rgbColorSpace,
                                                 kCGImageAlphaNoneSkipFirst);
    NSParameterAssert(context);

//    // Flip the y-axis
//    CGContextTranslateCTM(context, 0, CGBitmapContextGetHeight(context));
//    CGContextScaleCTM(context, 1.0, -1.0);

//    CGContextConcatCTM(context, frameTransform);
    CGContextDrawImage(context, CGRectMake(0, 0,
                                           CGImageGetWidth(image),
                                           CGImageGetHeight(image)),
                       image);
    CGColorSpaceRelease(rgbColorSpace);
    CGContextRelease(context);

    CVPixelBufferUnlockBaseAddress(pxbuffer, 0);

    return pxbuffer;
}

- (CVPixelBufferRef)grabPixelBuffer
{
    UIViewController *rootViewController = [self lastViewControllerInResponderChain];
    CGSize frameSize = rootViewController.view.size;
//    CGSize frameSize = CGSizeMake(CGImageGetWidth(image),
//                                  CGImageGetHeight(image));

//    frameSize.width = 700;
//    frameSize.height = 700;
//    NSLog(@"frameSize: %@", NSStringFromCGSize(frameSize));

    NSDictionary *options = @{
//                              (NSString *)kCVPixelBufferCGImageCompatibilityKey: @YES,
                              (NSString *)kCVPixelBufferCGBitmapContextCompatibilityKey: @YES,
                              };
    CVPixelBufferRef pxbuffer = NULL;
//    CVPixelBufferPoolCreatePixelBuffer()
    CVReturn status = CVPixelBufferCreate(kCFAllocatorDefault,
                                          frameSize.width,
                                          frameSize.height,
                                          kCVPixelFormatType_32ARGB,
                                          (__bridge CFDictionaryRef) options,
                                          &pxbuffer);
    NSParameterAssert(status == kCVReturnSuccess && pxbuffer != NULL);

    CVPixelBufferLockBaseAddress(pxbuffer, 0);
    void *pxdata = CVPixelBufferGetBaseAddress(pxbuffer);
    NSParameterAssert(pxdata != NULL);

//    CGAffineTransform frameTransform = CGAffineTransformIdentity;
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pxdata,
                                                 frameSize.width,
                                                 frameSize.height,
                                                 8,
//                                                 0,
                                                 CVPixelBufferGetBytesPerRow(pxbuffer),
//                                                 (int) (4 * roundf(frameSize.width)),
                                                 rgbColorSpace,
                                                 kCGImageAlphaNoneSkipFirst);
    NSParameterAssert(context);

    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    CGContextSetShouldAntialias(context, YES);
    CGContextSetAllowsAntialiasing(context, YES);
    CGContextSetShouldSmoothFonts(context, YES);
    CGContextSetAllowsFontSmoothing(context, YES);

//    CGContextConcatCTM(context, frameTransform);

    // Flip the y-axis
    CGContextTranslateCTM(context, 0, CGBitmapContextGetHeight(context));
    CGContextScaleCTM(context, 1.0, -1.0);

    [self.sandboxView setControlsHidden:YES];
    [rootViewController.view.layer renderInContext:context];
//    [self.sandboxView.layer renderInContext:context];
    [self.sandboxView setControlsHidden:NO];

    CGColorSpaceRelease(rgbColorSpace);
    CGContextRelease(context);

    CVPixelBufferUnlockBaseAddress(pxbuffer, 0);

    return pxbuffer;
}

- (UIImage *)takeSnapshot
{
    CGSize imageSize = self.sandboxView.size;
    if (imageSize.width * imageSize.height == 0)
    {
        return nil;
    }

    UIGraphicsBeginImageContext(imageSize);
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    CGContextSetShouldAntialias(context, YES);
    CGContextSetAllowsAntialiasing(context, YES);
    CGContextSetShouldSmoothFonts(context, YES);
    CGContextSetAllowsFontSmoothing(context, YES);

    [self.sandboxView setControlsHidden:YES];

    // -renderInContext: renders in the coordinate space of the layer,
    // so we must first apply the layer's geometry to the graphics context
    CGContextSaveGState(context);
    // Center the context around the window's anchor point
    CGContextTranslateCTM(context, [self.sandboxView center].x, [self.sandboxView center].y);
    // Apply the window's transform about the anchor point
    CGContextConcatCTM(context, [self.sandboxView transform]);
    // Offset by the portion of the bounds left of and above the anchor point
    CGContextTranslateCTM(context,
                          -[self.sandboxView bounds].size.width * [[self.sandboxView layer] anchorPoint].x,
                          -[self.sandboxView bounds].size.height * [[self.sandboxView layer] anchorPoint].y);

    // Render the layer hierarchy to the current context
    //
    // IMPORTANT: use presentation layer to reflect Core Animations.
    [[self.sandboxView layer].presentationLayer renderInContext:context];

    // Restore the context
    CGContextRestoreGState(context);

    [self.sandboxView setControlsHidden:NO];

    UIImage* viewImage = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return viewImage;
}

- (void)addSnapshot:(id)sender
{
    SandboxSnapshot *snapshot = [[SandboxSnapshot alloc] init];
    snapshot.image = [self takeSnapshot];
    if (!snapshot.image)
    {
        return;
    }
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

- (void)ensureSnapshotsFolderPath
{
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
        NSString *folderPath = [[[@"/Users/" stringByAppendingPathComponent:simulatorUser]
                                stringByAppendingPathComponent:@"Snapshots"]
                                stringByAppendingPathComponent:uuid];
        NSError *error;
        BOOL created = [[NSFileManager defaultManager] createDirectoryAtPath:folderPath
                                                 withIntermediateDirectories:YES
                                                                  attributes:nil
                                                                       error:&error];
        WeViewAssert(created);
        WeViewAssert(!error);
        self.snapshotsFolderPath = folderPath;
    }
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

    [self ensureSnapshotsFolderPath];

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
        WeViewAssert(0);
    }
    CFRelease(destination);

    self.exportCounter++;
}

- (void)handleSelectionAltered:(NSNotification *)notification
{
    [self.sandboxView animateRelayout];
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
