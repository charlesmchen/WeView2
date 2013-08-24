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
@property (nonatomic) UINavigationController *nav0;
@property (nonatomic) UINavigationController *nav1;

@end

#pragma mark -

@implementation SidebarViewController

- (id)init
{
    self = [super init];
    if (self)
    {
        self.selectDemoViewController = [[SelectDemoViewController alloc] init];
        //        UINavigationController *masterNavigationController = ;
        //    [self addChildViewController:self.selectDemoViewController];
        self.nav0 = [[UINavigationController alloc] initWithRootViewController:self.selectDemoViewController];
        [self addChildViewController:self.nav0];

        self.demoDescriptionViewController = [[DemoDescriptionViewController alloc] init];
        self.nav1 = [[UINavigationController alloc] initWithRootViewController:self.demoDescriptionViewController];
        [self addChildViewController:self.nav1];
    }
    return self;
}

- (void)loadView
{
    self.rootView = [[[WeView2 alloc] init]
                     withVLinearLayout];
    //    self.rootView.debugLayout = YES;
    self.rootView.opaque = YES;
    self.rootView.backgroundColor = [UIColor whiteColor];
    self.view = self.rootView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.rootView addSubviews:@[
     [self.nav0.view withPureStretch],
     [self.nav1.view withPureStretch],
     ]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
