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

@implementation iPhoneDemo1

- (NSString *)name
{
    return @"iPhone 1";
}

- (DemoModel *)demoModel
{
    DemoModel *result = [DemoModel create];

    WeView2 *phoneScreen = [[WeView2 alloc] init];
    phoneScreen.backgroundColor = [UIColor whiteColor];
    phoneScreen.opaque = YES;

    UIImageView *phoneImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iphone_vertical"]];
    WeView2 *phoneContainer = [[WeView2 alloc] init];
    [[phoneContainer useStackDefaultLayout]
     addSubview:phoneImageView];
    phoneContainer.fixedSize = phoneImageView.image.size;
    [phoneContainer addSubview:phoneScreen
               withLayoutBlock:^(UIView *superview, UIView *subview) {
                   WeView2Assert(subview);
                   WeView2Assert(subview.superview);
                   subview.frame = CGRectMake(33, 133, 320, 480);
               }];

    [[result.rootView useStackDefaultLayout]
     addSubview:phoneContainer];

    UIToolbar *toolbar = [[UIToolbar alloc] init];
    [toolbar setItems:@[
     [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:nil action:nil],
     [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
     [[UIBarButtonItem alloc] initWithTitle:@"Demo" style:UIBarButtonItemStylePlain target:nil action:nil],
     [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
     ]
             animated:NO];
    WeView2 *bodyView = [[WeView2 alloc] init];
    [[phoneScreen addSubviews:@[
      toolbar,
      [bodyView withPureStretch],
      ]]
     useVerticalDefaultLayout];

    [bodyView addSubviews:@[
     [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Images/The_shortening_winters_day_is_near_a_close_Farquharson.jpg"]],
     ]
               withLayout:[WeView2FitOrFillLayout fillBoundsLayout]];
    bodyView.clipsToBounds = YES;

    WeView2 *pillboxView = [[WeView2 alloc] init];
    [[pillboxView addSubviews:@[
      [self buttonWithImageName:@"Images/gray_pillbox_left"],
      [self buttonWithImageName:@"Images/gray_pillbox_center"],
      [self buttonWithImageName:@"Images/gray_pillbox_right"],
      ]]
     useHorizontalDefaultLayout];
    pillboxView.bottomMargin = 20;
    pillboxView.vAlign = V_ALIGN_BOTTOM;

    [[bodyView addSubviews:@[
      [pillboxView withPureStretch],
      ]]
     useHorizontalDefaultLayout];

    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [activityIndicatorView startAnimating];
    [bodyView addSubviews:@[
     activityIndicatorView,
     ]
               withLayout:[WeView2StackLayout stackLayout]];

    result.rootView.debugName = @"iPhone 1";
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
