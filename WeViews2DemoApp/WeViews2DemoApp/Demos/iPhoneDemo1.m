//
//  iPhoneDemo1.m
//  WeViews2DemoApp
//
//  Copyright (c) 2013 Charles Matthew Chen. All rights reserved.
//

#import "WeView2.h"
#import "iPhoneDemo1.h"
#import "WeView2Macros.h"
#import "WeView2FitOrFillLayout.h"
#import "WeView2StackLayout.h"
#import "WeView2LinearLayout.h"

@implementation iPhoneDemo1

- (NSString *)name
{
    return @"iPhone 1";
}

- (DemoModel *)demoModel
{
    DemoModel *result = [DemoModel create];

    result.useIPhoneSandboxByDefault = YES;

    UIToolbar *toolbar = [[UIToolbar alloc] init];
    [toolbar setItems:@[
     [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:nil action:nil],
     [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
     [[UIBarButtonItem alloc] initWithTitle:@"Demo" style:UIBarButtonItemStylePlain target:nil action:nil],
     [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
     ]
             animated:NO];
    WeView2 *bodyView = [[WeView2 alloc] init];
    [[result.rootView addSubviews:@[
      toolbar,
      [bodyView withPureStretch],
      ]]
     useVerticalDefaultLayout];

    [bodyView addSubviews:@[
     [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Images/The_shortening_winters_day_is_near_a_close_Farquharson.jpg"]],
     ]
               withLayout:[WeView2FitOrFillLayout fillBoundsWithAspectRatioLayout]];
    bodyView.clipsToBounds = YES;

    [bodyView addSubviews:@[
     [self buttonWithImageName:@"Images/gray_pillbox_left"],
     [self buttonWithImageName:@"Images/gray_pillbox_center"],
     [self buttonWithImageName:@"Images/gray_pillbox_right"],
     ]
               withLayout:[[[WeView2LinearLayout horizontalLayout]
                            setBottomMargin:20]
                           setContentVAlign:V_ALIGN_BOTTOM]];

    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [activityIndicatorView startAnimating];
    [bodyView addSubviews:@[
     activityIndicatorView,
     ]
               withLayout:[WeView2StackLayout stackLayout]];

    result.rootView.debugName = @"iPhone 1";
    [result.rootView withPureStretch];
    return result;
}

- (UIButton *)buttonWithImageName:(NSString *)imageName
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:imageName]
            forState:UIControlStateNormal];
    [button sizeToFit];
    return button;
}

@end
