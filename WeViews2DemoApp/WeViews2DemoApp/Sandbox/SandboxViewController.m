//
//  SandboxViewController.m
//  WeView v2
//
//  Copyright (c) 2013 Charles Matthew Chen. All rights reserved.
//
//  Distributed under the Apache License v2.0.
//  http://www.apache.org/licenses/LICENSE-2.0.html
//

#import <AVFoundation/AVFoundation.h>
#import <CoreText/CoreText.h>
#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <QuartzCore/QuartzCore.h>

#import "DefaultSandboxView.h"
#import "DemoCodeGeneration.h"
#import "DemoViewFactory.h"
#import "SandboxViewController.h"
#import "WeView.h"
#import "WeViewDemoConstants.h"
#import "WeViewMacros.h"

typedef enum {
    SANDBOX_VIDEO_MODE_SANDBOX,
//    SANDBOX_VIDEO_MODE_CODE,
    SANDBOX_VIDEO_MODE_SANDBOX_AND_CODE,
    SANDBOX_VIDEO_MODE_APP,
} SandboxVideoMode;

@interface SandboxSnapshotTextLine : NSObject

@property (assign, nonatomic) CTLineRef ctLine;

@end

#pragma mark -

@implementation SandboxSnapshotTextLine

- (void)dealloc
{
    if (self.ctLine)
    {
        CFRelease(self.ctLine);
        self.ctLine = nil;
    }
}

+ (SandboxSnapshotTextLine *)createLineWithText:(NSString *)text
                                         ctFont:(CTFontRef)ctFont
                                      textColor:(UIColor *)textColor
{
    SandboxSnapshotTextLine *result = [[SandboxSnapshotTextLine alloc] init];

    NSDictionary *attrs = @{
                            (__bridge NSString *) kCTFontAttributeName:(__bridge id) ctFont,
                            (__bridge NSString *) kCTForegroundColorAttributeName:(__bridge id) textColor.CGColor,
                            };
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:text
                                                                           attributes:attrs];
    result.ctLine = CTLineCreateWithAttributedString((__bridge CFAttributedStringRef) attributedString);
    return result;
}

- (CGRect)lineBounds
{
    return CTLineGetBoundsWithOptions(self.ctLine, 0);
}

@end

#pragma mark -

@interface SandboxSnapshot : NSObject

@property (nonatomic) CGSize contentSize;
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

@property (nonatomic) WeView *rootView;
@property (nonatomic) SandboxView *sandboxView;
@property (nonatomic) WeView *sandboxPanel;

@property (nonatomic) UITextView *generatedCodeView;
@property (nonatomic) WeView *generatedCodePanel;

@property (nonatomic) DemoModel *demoModel;

@property (nonatomic) NSMutableArray *snapshots;
@property (nonatomic) NSMutableArray *codeSnapshots;
@property (nonatomic) NSString *snapshotsFolderPath;

@property (nonatomic) CADisplayLink *displayLink;
@property (nonatomic) int transformBlockCounter;
@property (nonatomic) SandboxVideoMode videoMode;

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
        self.codeSnapshots = [NSMutableArray array];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)loadView
{
    self.sandboxView = [[DefaultSandboxView alloc] init];
    self.sandboxView.debugName = @"sandboxView";
    self.sandboxView.clipsToBounds = YES;

    self.sandboxPanel = [[WeView alloc] init];
    [self.sandboxPanel addSubviewWithFillLayout:[[self.sandboxView setStretches] setIgnoreDesiredSize]];

    self.generatedCodeView = [[UITextView alloc] init];
    self.generatedCodeView.backgroundColor = [UIColor whiteColor];
    self.generatedCodeView.opaque = YES;
    self.generatedCodeView.textColor = [UIColor colorWithWhite:0.f
                                                         alpha:0.8f];
//    self.generatedCodeView.font = [UIFont fontWithName:@"Inconsolata-Bold"
    self.generatedCodeView.font = [UIFont fontWithName:@"Inconsolata-Regular"
                                                  size:13.f];
    self.generatedCodeView.editable = NO;

    UIButton *logGeneratedCodeButton = [DemoViewFactory createFlatUIButton:@"Log Generated Code"
                                                                 textColor:[UIColor whiteColor]
                                                               buttonColor:[UIColor colorWithWhite:0.5f alpha:1.f]
                                                                    target:self
                                                                  selector:@selector(logGeneratedCode:)];

    self.generatedCodePanel = [[WeView alloc] init];
    [self.generatedCodePanel addSubviewWithFillLayout:[[self.generatedCodeView setStretches] setIgnoreDesiredSize]];
    [[[[self.generatedCodePanel addSubviewWithCustomLayout:logGeneratedCodeButton]
       setHAlign:H_ALIGN_RIGHT]
      setVAlign:V_ALIGN_BOTTOM]
     setMargin:10];

    self.rootView = [[WeView alloc] init];
    self.rootView.backgroundColor = [UIColor colorWithWhite:0.5f alpha:1.f];
    self.rootView.opaque = YES;
    [[self.rootView addSubviewsWithVerticalLayout:@[
      [[self.sandboxPanel setStretchWeight:4.f]
       setIgnoreDesiredSize],
      [[self.generatedCodePanel setStretchWeight:1.f]
       setIgnoreDesiredSize],
      ]]
     setSpacing:2];

    self.view = self.rootView;
}

- (void)updateGeneratedCode
{
    self.generatedCodeView.text = [[[[DemoCodeGeneration alloc] init] generateCodeForView:self.demoModel.rootView]
                                   stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

#ifdef TUTORIAL
    self.navigationItem.leftBarButtonItems = @[
#if TARGET_IPHONE_SIMULATOR
                                               [[UIBarButtonItem alloc] initWithTitle:@"Snapshot"
                                                                                style:UIBarButtonItemStyleBordered
                                                                               target:self
                                                                               action:@selector(addSnapshot:)],
#endif
                                               [[UIBarButtonItem alloc] initWithTitle:@"Transform"
                                                                                style:UIBarButtonItemStyleBordered
                                                                               target:self
                                                                               action:@selector(transformDemoModel:)],
                                               [[UIBarButtonItem alloc] initWithTitle:@"Source"
                                                                                style:UIBarButtonItemStyleBordered
                                                                               target:self
                                                                               action:@selector(toggleGeneratedCodeView:)],
//                                               [[UIBarButtonItem alloc] initWithTitle:@"i"
//                                                                                style:UIBarButtonItemStyleBordered
//                                                                               target:self
//                                                                               action:@selector(selectIPhoneMode:)],
                                               ];
    self.navigationItem.rightBarButtonItems = @[
#if TARGET_IPHONE_SIMULATOR
                                                [[UIBarButtonItem alloc] initWithTitle:@"V Sandbox"
                                                                                 style:UIBarButtonItemStyleBordered
                                                                                target:self
                                                                                action:@selector(startSandboxVideo:)],
                                                [[UIBarButtonItem alloc] initWithTitle:@"V Code"
                                                                                 style:UIBarButtonItemStyleBordered
                                                                                target:self
                                                                                action:@selector(startSandboxAndCodeVideo:)],
                                                [[UIBarButtonItem alloc] initWithTitle:@"V App"
                                                                                 style:UIBarButtonItemStyleBordered
                                                                                target:self
                                                                                action:@selector(startFullscreenVideo:)],
                                                [[UIBarButtonItem alloc] initWithTitle:@"Cut"
                                                                                 style:UIBarButtonItemStyleBordered
                                                                                target:self
                                                                                action:@selector(stopVideo:)],
#endif
                                                ];
#endif
}

- (void)logGeneratedCode:(id)sender
{
    NSLog(@"\n\n%@\n\n", [[[DemoCodeGeneration alloc] init] generateCodeForView:self.demoModel.rootView]);
}

- (void)toggleGeneratedCodeView:(id)sender
{
    if (self.generatedCodePanel.vStretchWeight > 0)
    {
        [self.generatedCodePanel setStretchWeight:0.f];
    }
    else
    {
        [self.generatedCodePanel setStretchWeight:1.f];
    }
}

//- (void)selectIPhoneMode:(id)sender
//{
//}

- (void)transformDemoModel:(id)sender
{
    if (self.demoModel.transformBlocks &&
        [self.demoModel.transformBlocks count] > 0)
    {
        self.transformBlockCounter = (self.transformBlockCounter + 1) % [self.demoModel.transformBlocks count];
        DemoModelTransformBlock transformBlock = self.demoModel.transformBlocks[self.transformBlockCounter];
        transformBlock();
    }
}

- (void)startSandboxVideo:(id)sender
{
    self.videoMode = SANDBOX_VIDEO_MODE_SANDBOX;
    [self startVideo];
}

- (void)startSandboxAndCodeVideo:(id)sender
{
    self.videoMode = SANDBOX_VIDEO_MODE_SANDBOX_AND_CODE;
    [self startVideo];
}

- (void)startFullscreenVideo:(id)sender
{
    self.videoMode = SANDBOX_VIDEO_MODE_APP;
    [self startVideo];
}

- (void)startVideo
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
    if (self.videoMode == SANDBOX_VIDEO_MODE_SANDBOX_AND_CODE)
    {
        [self.snapshots addObject:[self createSnapshot:SANDBOX_VIDEO_MODE_SANDBOX]];
        [self.codeSnapshots addObject:[self renderGeneratedCodeSnapshot]];
    }
    else
    {
        [self.snapshots addObject:[self createSnapshot:self.videoMode]];
    }
}

- (UIImage *)compositeScrenshotImage:(UIImage *)screenshotImage
                       withCodeImage:(UIImage *)codeImage
                          outputSize:(CGSize)outputSize
{
    UIGraphicsBeginImageContext(outputSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    WeViewAssert(context);

    CGRect outputRect = CGRectZero;
    outputRect.size = outputSize;
    [[UIColor whiteColor] setFill];
    CGContextFillRect(context, outputRect);

    [screenshotImage drawAtPoint:CGPointZero];
    [codeImage drawAtPoint:CGPointMake(0, screenshotImage.size.height)];

    UIImage* compositeImage = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return compositeImage;
}

- (void)endVideoSession
{
    if ([self.snapshots count] < 1)
    {
        return;
    }

    CGSize maxSnapshotImageSize = CGSizeZero;
    CGSize maxSnapshotContentSize = CGSizeZero;
    for (SandboxSnapshot *snapshot in self.snapshots)
    {
        if (self.videoMode == SANDBOX_VIDEO_MODE_APP)
        {
            maxSnapshotImageSize = maxSnapshotContentSize = snapshot.image.size;
            break;
        }
        maxSnapshotImageSize = CGSizeMax(maxSnapshotImageSize, snapshot.image.size);
        maxSnapshotContentSize = CGSizeMax(maxSnapshotContentSize, snapshot.contentSize);
    }

//    DebugCGSize(@"maxSnapshotContentSize", maxSnapshotContentSize);
//    DebugCGSize(@"maxSnapshotImageSize", maxSnapshotImageSize);

    CGSize outputSize = maxSnapshotContentSize;
    outputSize = CGSizeFloor(outputSize);
    if (self.videoMode != SANDBOX_VIDEO_MODE_APP)
    {
        outputSize = CGSizeAdd(outputSize, CGSizeMake(20, 20));
        outputSize = CGSizeMin(outputSize, maxSnapshotImageSize);
    }
    CGSize screenshotSize = outputSize;

    if (self.videoMode == SANDBOX_VIDEO_MODE_SANDBOX_AND_CODE)
    {
        WeViewAssert([self.snapshots count] == [self.codeSnapshots count]);

        CGSize maxCodeSnapshotSize = CGSizeZero;
        for (SandboxSnapshot *codeSnapshot in self.codeSnapshots)
        {
            maxCodeSnapshotSize = CGSizeMax(maxCodeSnapshotSize, codeSnapshot.contentSize);
        }
        maxCodeSnapshotSize = CGSizeFloor(maxCodeSnapshotSize);
//        DebugCGSize(@"maxCodeSnapshotSize", maxCodeSnapshotSize);
        outputSize.width = MIN(maxSnapshotImageSize.width,
                               MAX(outputSize.width,
                                   maxCodeSnapshotSize.width));
        outputSize.height += maxCodeSnapshotSize.height;
    }

//    DebugCGSize(@"maxSnapshotSize", maxSnapshotSize);
//    DebugCGSize(@"outputSize", outputSize);

    // Handbrake doesn't handle odd frame sizes well, so ensure that the width and height are even
    // multiples of 4.
    outputSize = CGSizeRound(CGSizeScale(CGSizeFloor(CGSizeScale(outputSize, 1 / 4.f)), 4.f));
    screenshotSize = CGSizeRound(CGSizeScale(CGSizeFloor(CGSizeScale(screenshotSize, 1 / 4.f)), 4.f));
//    DebugCGSize(@"outputSize", outputSize);
//    DebugCGSize(@"screenshotSize", screenshotSize);

    [self ensureSnapshotsFolderPath];

    NSString *videoUuid = [[NSProcessInfo processInfo] globallyUniqueString];
    NSString *filenameWOExt = [NSString stringWithFormat:@"video-%@", videoUuid];
    NSString *filename = [NSString stringWithFormat:@"video-%@.mov", videoUuid];
    NSString *filePath = [self.snapshotsFolderPath stringByAppendingPathComponent:filename];
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
                                    AVVideoWidthKey: @(outputSize.width),
                                    AVVideoHeightKey: @(outputSize.height),
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
    {
        {
            NSDate *maxDate = [NSDate dateWithTimeIntervalSinceNow:0.01];
            [[NSRunLoop currentRunLoop] runUntilDate:maxDate];
        }

        @autoreleasepool
        {
            SandboxSnapshot *snapshot = self.snapshots[0];
            [self.snapshots removeObjectAtIndex:0];

            UIImage *screenshotImage = [snapshot cropSnapshotWithSize:screenshotSize];
            NSParameterAssert(screenshotImage);
            WeViewAssert(screenshotImage);

            UIImage *frameImage = screenshotImage;

            if (self.videoMode == SANDBOX_VIDEO_MODE_SANDBOX_AND_CODE)
            {
                SandboxSnapshot *codeSnapshot = self.codeSnapshots[0];
                [self.codeSnapshots removeObjectAtIndex:0];
                WeViewAssert([self.snapshots count] == [self.codeSnapshots count]);

                frameImage = [self compositeScrenshotImage:screenshotImage
                                             withCodeImage:codeSnapshot.image
                                                outputSize:outputSize];
            }

            CVPixelBufferRef pixelBuffer = [self pixelBufferFromCGImage:frameImage.CGImage];
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

    NSLog(@"\n \
    <video WIDTH=\"%d\" HEIGHT=\"%d\" AUTOPLAY=\"true\" controls=\"true\" LOOP=\"true\" class=\"embedded_video\" >\n \
    <source src=\"videos/%@.mp4\" type=\"video/mp4\" />\n \
    <source src=\"videos/%@.webm\" type=\"video/webm\" />\n \
    </video>",
          (int) roundf(outputSize.width),
          (int) roundf(outputSize.height),
          filenameWOExt,
          filenameWOExt);
}

- (CVPixelBufferRef)pixelBufferFromCGImage:(CGImageRef)image
{
    CGSize frameSize = CGSizeMake(CGImageGetWidth(image),
                                  CGImageGetHeight(image));

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

- (SandboxSnapshot *)createSnapshot:(SandboxVideoMode)videoMode
{
    UIView *snapshotView;
    CGSize imageSize;
    CGSize contentSize;
    BOOL fullscreen = NO;
    switch (videoMode) {
        case SANDBOX_VIDEO_MODE_SANDBOX:
        {
            snapshotView = self.sandboxPanel;
            imageSize = snapshotView.size;
            contentSize = [self.sandboxView rootViewSize];
            break;
        }
        case SANDBOX_VIDEO_MODE_APP:
        {
            snapshotView = [self lastViewControllerInResponderChain].view;
            imageSize = CGSizeMake(snapshotView.size.height, snapshotView.size.width);
            contentSize = imageSize;
            fullscreen = YES;
            break;
        }
        default:
            WeViewAssert(0);
            break;
    }

    if (imageSize.width * imageSize.height == 0)
    {
        return nil;
    }

    SandboxSnapshot *snapshot = [[SandboxSnapshot alloc] init];
    snapshot.image = [self takeSnapshotOfView:snapshotView
                                    imageSize:imageSize
                                   fullscreen:fullscreen];
    snapshot.contentSize = contentSize;
    return snapshot;
}

- (UIImage *)takeSnapshotOfView:(UIView *)snapshotView
                      imageSize:(CGSize)imageSize
                     fullscreen:(BOOL)fullscreen
{
    UIGraphicsBeginImageContext(imageSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    WeViewAssert(context);

    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    CGContextSetShouldAntialias(context, YES);
    CGContextSetAllowsAntialiasing(context, YES);
    CGContextSetShouldSmoothFonts(context, YES);
    CGContextSetAllowsFontSmoothing(context, YES);

    [self.sandboxView setControlsHidden:YES];

    // -renderInContext: renders in the coordinate space of the layer,
    // so we must first apply the layer's geometry to the graphics context
    CGContextSaveGState(context);

    if (fullscreen)
    {
        // TODO: This can't be the best way of doing this but I can't be bothered to sort it out
        // properly for a demo.

        //    DebugCGPoint(@"snapshotView center", snapshotView.center);
        //    DebugCGPoint(@"snapshotView.origin", snapshotView.origin);
        //    DebugCGSize(@"imageSize", imageSize);
        CGContextRotateCTM(context, M_PI_2);
        CGContextTranslateCTM(context, 0, -imageSize.width);
        CGContextTranslateCTM(context, -[snapshotView origin].x, -[snapshotView origin].y);
    }
    CGContextTranslateCTM(context, [snapshotView center].x, [snapshotView center].y);
    // Apply the window's transform about the anchor point
    CGContextConcatCTM(context, [snapshotView transform]);
    // Offset by the portion of the bounds left of and above the anchor point
    CGContextTranslateCTM(context,
                          -[snapshotView bounds].size.width * [[snapshotView layer] anchorPoint].x,
                          -[snapshotView bounds].size.height * [[snapshotView layer] anchorPoint].y);

    // Render the layer hierarchy to the current context
    if (fullscreen)
    {
        // IMPORTANT: I don't know why, but trying to render the presentationLayer of the
        // root UIViewController's view when the "UITextView *generatedCodeView" is present
        // causes a EXC_BAD_ACCESS.
        [[snapshotView layer] renderInContext:context];
    }
    else
    {
        // IMPORTANT: use presentation layer to reflect Core Animations.
        [[snapshotView layer].presentationLayer renderInContext:context];
    }

    // Restore the context
    CGContextRestoreGState(context);

    [self.sandboxView setControlsHidden:NO];

    UIImage* viewImage = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return viewImage;
}

- (SandboxSnapshot *)renderGeneratedCodeSnapshot
{
    const int hMargin = 5;
    const int vMargin = 5;

    CTFontRef ctFont = CTFontCreateWithName((__bridge CFStringRef) self.generatedCodeView.font.fontName,
                                            self.generatedCodeView.font.pointSize,
                                            NULL);

    NSString *code = self.generatedCodeView.text;
    code = [code stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSArray *codeLines = [code componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    NSMutableArray *ctLines = [NSMutableArray array];
    CGFloat maxLineWidth = 0;
    for (NSString *codeLine in codeLines)
    {
        SandboxSnapshotTextLine *ctLine = [SandboxSnapshotTextLine createLineWithText:codeLine
                                                                               ctFont:ctFont
                                                                            textColor:self.generatedCodeView.textColor];
        maxLineWidth = MAX(maxLineWidth, [ctLine lineBounds].size.width);
        [ctLines addObject:ctLine];
    }

    CGFloat lineSpacing = (CTFontGetAscent(ctFont) + CTFontGetDescent(ctFont) + CTFontGetLeading(ctFont));
    CGSize imageSize = CGSizeMake(ceilf(maxLineWidth) + 2 * hMargin,
                                  ceilf(lineSpacing * [ctLines count]) + 2 * vMargin);

    UIGraphicsBeginImageContext(imageSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    WeViewAssert(context);

    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    CGContextSetShouldAntialias(context, YES);
    CGContextSetAllowsAntialiasing(context, YES);
    CGContextSetShouldSmoothFonts(context, YES);
    CGContextSetAllowsFontSmoothing(context, YES);

    CGContextSaveGState(context);

    [[UIColor whiteColor] setFill];
    CGContextFillRect(context, CGRectMake(0, 0, imageSize.width, imageSize.height));

    CGContextSetTextMatrix(context, CGAffineTransformMakeScale(1.0, -1.0));

    CGFloat renderOffset = CTFontGetAscent(ctFont) + CTFontGetLeading(ctFont) * 0.5f + 1;

    CGFloat y = vMargin;
    for (SandboxSnapshotTextLine *ctLine in ctLines)
    {
        CGContextSetTextPosition(context, hMargin,
                                 y + renderOffset);
        CTLineDraw(ctLine.ctLine, context);
        y += lineSpacing;
    }

    CGContextRestoreGState(context);

    UIImage* viewImage = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    SandboxSnapshot *snapshot = [[SandboxSnapshot alloc] init];
    snapshot.image = viewImage;
    snapshot.contentSize = imageSize;
    return snapshot;
}

- (void)addSnapshot:(id)sender
{
    @autoreleasepool {
        SandboxSnapshot *snapshot = [self createSnapshot:SANDBOX_VIDEO_MODE_SANDBOX];
//        SandboxSnapshot *snapshot = [self renderGeneratedCodeSnapshot];
        CGSize rootViewSize = snapshot.contentSize;

        [self ensureSnapshotsFolderPath];

        CGSize frameSize = CGSizeAdd(rootViewSize, CGSizeMake(20, 20));
        frameSize = CGSizeMin(frameSize,
                              [self.sandboxView maxViewSize]);

        NSString *exportUuid = [[NSProcessInfo processInfo] globallyUniqueString];

        UIImage *image = [snapshot cropSnapshotWithSize:frameSize];

        NSString *framePath = [self.snapshotsFolderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"snapshot-%@.png",
                                                                                        exportUuid]];
        [UIImagePNGRepresentation(image) writeToFile:framePath
                                          atomically:YES];
    }
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

- (void)handleSelectionAltered:(NSNotification *)notification
{
    [self.sandboxView animateRelayout];
    [self updateGeneratedCode];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)displayDemo:(Demo *)demo
{
    self.demoModel = demo.createDemoModelBlock();
    self.transformBlockCounter = 0;
    [self.sandboxView displayDemoModel:self.demoModel];

    dispatch_async(dispatch_get_main_queue(), ^{

        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_DEMO_CHANGED
                                                            object:self.demoModel];
    });

    [self updateGeneratedCode];
}

- (void)viewWillLayoutSubviews
{
}

- (void)viewDidLayoutSubviews
{
    dispatch_async(dispatch_get_main_queue(), ^{

        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SELECTION_CHANGED
                                                            object:self.demoModel.selection];
    });
}

@end
