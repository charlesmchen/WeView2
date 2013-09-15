//
//  TutorialCode.m
//  WeViews2DemoApp
//
//  Copyright (c) 2013 Charles Matthew Chen. All rights reserved.
//
//  Distributed under the Apache License v2.0.
//  http://www.apache.org/licenses/LICENSE-2.0.html
//

#import "WeView.h"
#import "TutorialCode.h"

@implementation TutorialCode

+ (void)iPhoneTutorial
{
    WeView *rootView = [[WeView alloc] init];

    UIToolbar *toolbar = [[UIToolbar alloc] init];
    [toolbar setItems:@[
     [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:nil action:nil],
     [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
     [[UIBarButtonItem alloc] initWithTitle:@"Demo" style:UIBarButtonItemStylePlain target:nil action:nil],
     [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
     ]
             animated:NO];

    WeView *bodyView = [[WeView alloc] init];

    [rootView addSubviewsWithVerticalLayout:@[
     toolbar,
     [[bodyView setStretches]
      setIgnoreDesiredSize],
     ]];

    // Add image that exactly fills the background of the body panel while retaining its aspect ratio.
    UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"farquharson.jpg"]];
    [bodyView addSubviewWithFillLayoutWAspectRatio:background];
    bodyView.clipsToBounds = YES;

    // Add pillbox buttons.
    [[[bodyView addSubviewsWithHorizontalLayout:@[
       [self buttonWithImageName:@"gray_pillbox_left"],
       [self buttonWithImageName:@"gray_pillbox_center"],
       [self buttonWithImageName:@"gray_pillbox_right"],
       ]]
      setBottomMargin:20]
     setVAlign:V_ALIGN_BOTTOM];

    // Add activity indicator.
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [activityIndicatorView startAnimating];
    [bodyView addSubviewWithCustomLayout:activityIndicatorView];
}

+ (id)buttonWithImageName:(id)ignore
{
    return nil;
}

@end
