//
//  DefaultSandboxView.m
//  WeViews2DemoApp
//
//  Copyright (c) 2013 Charles Matthew Chen. All rights reserved.
//

#import "WeView2.h"
#import "DefaultSandboxView.h"
#import "WeView2Macros.h"
#import "WeView2DemoConstants.h"
#import "DemoViewFactory.h"

typedef enum
{
    SANDBOX_MODE_DEFAULT,
    SANDBOX_MODE_IPHONE_4_PORTRAIT,
    SANDBOX_MODE_IPHONE_4_LANDSCAPE,
    SANDBOX_MODE_IPHONE_5_PORTRAIT,
    SANDBOX_MODE_IPHONE_5_LANDSCAPE,
} SandboxMode;

@interface DefaultSandboxView ()

@property (nonatomic) DemoModel *demoModel;
//@property (nonatomic) BOOL ;

@end

#pragma mark -

@implementation DefaultSandboxView

- (id)init
{
    self = [super init];
    if (self)
    {
        [self useHorizontalDefaultLayout];
        self.margin = 40;
        self.opaque = YES;
        //        self.backgroundColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"subtlepatterns.com/graphy/graphy"]];
        //        [view setOpaque:NO];
        //        [[view layer] setOpaque:NO];

        [self addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)]];
    }
    return self;
}

- (void)createContents:(SandboxMode)mode
{
    UILabel *resizeInstructionsLabel = [DemoViewFactory createLabel:@"Drag in this window to resize"
                                                           fontSize:14.f
                                                          textColor:[DemoViewFactory colorWithRGBHex:0x888888]];
    [self addSubview:resizeInstructionsLabel
     withLayoutBlock:^(UIView *superview, UIView *subview) {
         WeView2Assert(subview);
         WeView2Assert(subview.superview);
         const int kHMargin = 20 + 5;
         const int kVMargin = 20 + 5;
         subview.right = subview.superview.width - kHMargin;
         subview.bottom = subview.superview.height - kVMargin;
     }];

    WeView2 *modePanel = [[WeView2 alloc] init];
    [[[modePanel useVerticalDefaultLayout]
     setSpacing:10]
     setHAlign:H_ALIGN_LEFT];

     [modePanel addSubviews:@[
     [DemoViewFactory createFlatUIButton:@"Open layout at natural size"
                               textColor:[UIColor colorWithWhite:1.f alpha:1.f]
                             buttonColor:[UIColor colorWithWhite:0.5f alpha:1.f]
                                  target:self
                                selector:@selector(snapToDesiredSize:)],
      [DemoViewFactory createFlatUIButton:@"iPhone 4 (Portrait)"
                                textColor:[UIColor colorWithWhite:1.f alpha:1.f]
                              buttonColor:[UIColor colorWithWhite:0.5f alpha:1.f]
                                   target:self
                                 selector:@selector(snapToIPhone4Portrait:)],
      [DemoViewFactory createFlatUIButton:@"iPhone 4 (Landscape)"
                                textColor:[UIColor colorWithWhite:1.f alpha:1.f]
                              buttonColor:[UIColor colorWithWhite:0.5f alpha:1.f]
                                   target:self
                                 selector:@selector(snapToIPhone4Landscape:)],
      [DemoViewFactory createFlatUIButton:@"iPhone 5 (Portrait)"
                                textColor:[UIColor colorWithWhite:1.f alpha:1.f]
                              buttonColor:[UIColor colorWithWhite:0.5f alpha:1.f]
                                   target:self
                                 selector:@selector(snapToIPhone5Portrait:)],
      [DemoViewFactory createFlatUIButton:@"iPhone 5 (Landscape)"
                                textColor:[UIColor colorWithWhite:1.f alpha:1.f]
                              buttonColor:[UIColor colorWithWhite:0.5f alpha:1.f]
                                   target:self
                                 selector:@selector(snapToIPhone5Landscape:)],
     ]];

    [self addSubview:modePanel
     withLayoutBlock:^(UIView *superview, UIView *subview) {
         WeView2Assert(subview);
         WeView2Assert(subview.superview);
         const int kHMargin = 20;
         const int kVMargin = 20;
         [subview sizeToFit];
         subview.x = kHMargin;
         subview.bottom = subview.superview.height - kVMargin;
     }];
//    self.setNeedsLayout;
}

- (void)snapToDesiredSize:(id)sender
{
    [self displayDemoModel:self.demoModel
                      mode:SANDBOX_MODE_DEFAULT];
}

- (void)snapToIPhone4Portrait:(id)sender
{
    [self displayDemoModel:self.demoModel
                      mode:SANDBOX_MODE_IPHONE_4_PORTRAIT];
}

- (void)snapToIPhone4Landscape:(id)sender
{
    [self displayDemoModel:self.demoModel
                      mode:SANDBOX_MODE_IPHONE_4_LANDSCAPE];
}

- (void)snapToIPhone5Portrait:(id)sender
{
    [self displayDemoModel:self.demoModel
                      mode:SANDBOX_MODE_IPHONE_5_PORTRAIT];
}

- (void)snapToIPhone5Landscape:(id)sender
{
    [self displayDemoModel:self.demoModel
                      mode:SANDBOX_MODE_IPHONE_5_LANDSCAPE];
}

- (void)handlePan:(UIPanGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan ||
        sender.state == UIGestureRecognizerStateChanged ||
        sender.state == UIGestureRecognizerStateEnded)
    {
        CGPoint rootViewCenter = [self convertPoint:self.center
                                           fromView:self.superview];
        CGPoint gesturePoint = [sender locationInView:self];
        CGPoint distance = CGPointAbs(CGPointSubtract(rootViewCenter, gesturePoint));

        [self useNoDefaultLayout];

        self.demoModel.rootView.size = CGSizeRound(CGSizeMake(distance.x * 2.f,
                                                              distance.y * 2.f));
        [self.demoModel.rootView centerHorizontallyInSuperview];
        [self.demoModel.rootView centerVerticallyInSuperview];
    }
}

- (void)displayDemoModel:(DemoModel *)demoModel
{
    self.demoModel = demoModel;
    self.demoModel.selection = self.demoModel.rootView;
    [self displayDemoModel:demoModel
                      mode:(demoModel.useIPhoneSandboxByDefault
                            ? SANDBOX_MODE_IPHONE_4_PORTRAIT
                            : SANDBOX_MODE_DEFAULT)];
}

- (void)showDemoModelInIPhone:(DemoModel *)demoModel
                    imageName:(NSString *)imageName
                 screenBounds:(CGRect)screenBounds
{
    WeView2 *phoneScreen = [[WeView2 alloc] init];
    phoneScreen.backgroundColor = [UIColor whiteColor];
    phoneScreen.opaque = YES;

    UIImageView *phoneImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    WeView2Assert(phoneImageView.image);
    WeView2 *phoneContainer = [[WeView2 alloc] init];
    [[phoneContainer useStackDefaultLayout]
     addSubview:phoneImageView];
    phoneContainer.fixedSize = phoneImageView.image.size;
    [phoneContainer addSubview:phoneScreen
               withLayoutBlock:^(UIView *superview, UIView *subview) {
                   WeView2Assert(subview);
                   WeView2Assert(subview.superview);
                   subview.frame = screenBounds;
                   [subview setNeedsLayout];
               }];

    [self useStackDefaultLayout];
    [self addSubviews:@[
     phoneContainer
     ]];

    [phoneScreen useStackDefaultLayout];
    [phoneScreen addSubviews:@[
     self.demoModel.rootView,
     ]];
}

- (void)displayDemoModel:(DemoModel *)demoModel
                    mode:(SandboxMode)mode
{
    [self removeAllSubviews];
    [self resetAllLayoutProperties];
    WeView2Assert([self.subviews count] == 0);

    switch (mode) {
        case SANDBOX_MODE_DEFAULT:
        {
            [self useStackDefaultLayout];
//            [self useHorizontalDefaultLayout];
            [self addSubviews:@[
             demoModel.rootView,
             ]];

            break;
        }
        case SANDBOX_MODE_IPHONE_4_PORTRAIT:
            [self showDemoModelInIPhone:demoModel
                              imageName:@"Images/iphone_4_portrait"
                           screenBounds:CGRectMake(32, 133, 320, 480)];
            break;
        case SANDBOX_MODE_IPHONE_4_LANDSCAPE:
            [self showDemoModelInIPhone:demoModel
                              imageName:@"Images/iphone_4_landscape"
                           screenBounds:CGRectMake(133, 29, 480, 320)];
            break;
        case SANDBOX_MODE_IPHONE_5_PORTRAIT:
            [self showDemoModelInIPhone:demoModel
                              imageName:@"Images/iphone_5_portrait"
                           screenBounds:CGRectMake(34, 119, 320, 568)];
            break;
        case SANDBOX_MODE_IPHONE_5_LANDSCAPE:
            [self showDemoModelInIPhone:demoModel
                              imageName:@"Images/iphone_5_landscape"
                           screenBounds:CGRectMake(119, 29, 568, 320)];
            break;
        default:
            WeView2Assert(0);
            break;
    }

    [self createContents:mode];
}

@end
