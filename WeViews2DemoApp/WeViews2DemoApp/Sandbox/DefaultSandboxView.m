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
#import "WeView2BlockLayout.h"

@interface DefaultSandboxView ()

@property (nonatomic) DemoModel *demoModel;

@end

#pragma mark -

@implementation DefaultSandboxView

- (id)init
{
    self = [super init];
    if (self)
    {
        [self setVLinearLayout];
        self.margin = 40;
        self.opaque = YES;
        self.backgroundColor = [UIColor whiteColor];

        [self addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)]];
    }
    return self;
}

- (void)createContents
{
    UILabel *resizeInstructionsLabel = [DemoViewFactory createLabel:@"Drag in this window to resize"
                                                           fontSize:24.f
                                                          textColor:[DemoViewFactory colorWithRGBHex:0xcccccc]];
    [self addSubview:resizeInstructionsLabel
          withLayout:[WeView2BlockLayout create:^(UIView *superview, UIView *subview) {
        WeView2Assert(subview);
        WeView2Assert(subview.superview);
        const int kHMargin = 20;
        const int kVMargin = 20;
        subview.right = subview.superview.width - kHMargin;
        subview.bottom = subview.superview.height - kVMargin;
    }]];

    UIButton *desiredSizeButton = [DemoViewFactory createFlatUIButton:@"Snap To Desired Size"
                                                            textColor:[UIColor colorWithWhite:1.f alpha:1.f]
                                                          buttonColor:[UIColor colorWithWhite:0.5f alpha:1.f]
                                                               target:self
                                                             selector:@selector(snapToDesiredSize:)];
    [self addSubview:desiredSizeButton
          withLayout:[WeView2BlockLayout create:^(UIView *superview, UIView *subview) {
        WeView2Assert(subview);
        WeView2Assert(subview.superview);
        const int kHMargin = 20;
        const int kVMargin = 20;
        subview.x = kHMargin;
        subview.bottom = subview.superview.height - kVMargin;
    }]];
}

- (void)snapToDesiredSize:(id)sender
{
    [self setCenterLayout];
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

        [self setNoopLayout];

        self.demoModel.rootView.size = CGSizeRound(CGSizeMake(distance.x * 2.f,
                                                              distance.y * 2.f));
        [self.demoModel.rootView centerHorizontallyInSuperview];
        [self.demoModel.rootView centerVerticallyInSuperview];
    }
}

- (void)displayDemoModel:(DemoModel *)demoModel
{
    [self removeAllSubviews];
    [self setHLinearLayout];
    self.demoModel = demoModel;
    self.demoModel.selection = self.demoModel.rootView;

    [self createContents];

    [self addSubviews:@[
     self.demoModel.rootView,
     ]];
}

@end
