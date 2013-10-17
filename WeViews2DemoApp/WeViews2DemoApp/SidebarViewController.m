//
//  SidebarViewController.m
//  WeView v2
//
//  Copyright (c) 2013 Charles Matthew Chen. All rights reserved.
//
//  Distributed under the Apache License v2.0.
//  http://www.apache.org/licenses/LICENSE-2.0.html
//

#import "UIView+WeView.h"
#import "WeView.h"
#import "SidebarViewController.h"

@interface SidebarViewController ()

@property (nonatomic) WeView *rootView;

@end

#pragma mark -

@implementation SidebarViewController

- (id)init
{
    self = [super init];
    if (self)
    {
        self.selectDemoViewController = [[SelectDemoViewController alloc] init];
        [self addWrappedViewController:self.selectDemoViewController];

        self.viewTreeViewController = [[ViewTreeViewController alloc] init];
        [self addWrappedViewController:self.viewTreeViewController];

        self.viewEditorController = [[ViewEditorController alloc] init];
        [self addWrappedViewController:self.viewEditorController];
    }

    return self;
}

- (void)addWrappedViewController:(UIViewController *)viewController
{
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self addChildViewController:navigationController];
}

- (void)loadView
{
    self.rootView = [[WeView alloc] init];
//    self.rootView.debugLayout = YES;
    self.rootView.opaque = YES;
    self.rootView.backgroundColor = [UIColor whiteColor];
    self.view = self.rootView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSMutableArray *subviews = [NSMutableArray array];
    for (UIViewController *childViewController in self.childViewControllers)
    {
        [subviews addObject:[childViewController.view setStretchesIgnoringDesiredSize]];
    }

    [self.rootView addSubviewsWithVerticalLayout:subviews];
//    self.rootView.debugLayout = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
