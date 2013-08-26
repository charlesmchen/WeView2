//
//  SidebarViewController.m
//  WeViews2DemoApp
//
//  Copyright (c) 2013 Charles Matthew Chen. All rights reserved.
//

#import "UIView+WeView2.h"
#import "WeView2.h"
#import "SidebarViewController.h"

@interface SidebarViewController ()

@property (nonatomic) WeView2 *rootView;
//@property (nonatomic) UINavigationController *nav0;
//@property (nonatomic) UINavigationController *nav1;
//@property (nonatomic) UINavigationController *nav2;

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

        self.demoDescriptionViewController = [[DemoDescriptionViewController alloc] init];
        [self addWrappedViewController:self.demoDescriptionViewController];

        self.viewTreeViewController = [[ViewTreeViewController alloc] init];
        [self addWrappedViewController:self.viewTreeViewController];
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
    self.rootView = [[[WeView2 alloc] init]
                     setVLinearLayout];
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
        [subviews addObject:[childViewController.view withPureStretch]];
    }

    [self.rootView addSubviews:subviews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
