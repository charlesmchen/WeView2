//
//  DemoViewController.m
//  WeViews2DemoApp
//
//  Copyright (c) 2013 Charles Matthew Chen. All rights reserved.
//

#import "WeView2.h"
#import "DemoViewController.h"

@interface DemoViewController ()

@property (nonatomic) WeView2 *rootView;

@property (nonatomic) Demo *demo;
@property (nonatomic) UIView *demoView;

@end

#pragma mark -

@implementation DemoViewController

- (id)init
{
    self = [super init];
    if (self)
{
    }
    return self;
}

- (void)loadView
{
    self.rootView = [[[WeView2 alloc] init]
                      withVLinearLayout];
    self.rootView.margin = 40;
    self.rootView.opaque = YES;
    self.rootView.backgroundColor = [UIColor whiteColor];
    self.rootView.debugName = @"DemoViewController.rootView";
    self.view = self.rootView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)displayDemo:(Demo *)demo
{
    [self.rootView removeAllSubviews];
    self.demoView = [demo demoView];
    [self.rootView addSubviews:@[
     self.demoView,
     ]];
}

- (void)viewWillLayoutSubviews
{
}

- (void)viewDidLayoutSubviews
{
    dispatch_async(dispatch_get_main_queue(), ^{
//        [self.delegate demoViewChanged:self.rootView];
        [self.delegate demoViewChanged:self.demoView];
    });
}

@end
