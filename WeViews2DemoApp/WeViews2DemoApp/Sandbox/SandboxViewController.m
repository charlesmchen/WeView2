//
//  SandboxViewController.m
//  WeViews2DemoApp
//
//  Copyright (c) 2013 Charles Matthew Chen. All rights reserved.
//

#import "WeView2.h"
#import "SandboxViewController.h"
#import "WeView2Macros.h"
#import "WeView2DemoConstants.h"
#import "DefaultSandboxView.h"

@interface SandboxViewController ()

@property (nonatomic) SandboxView *sandboxView;

@property (nonatomic) DemoModel *demoModel;

@end

#pragma mark -

@implementation SandboxViewController

- (id)init
{
    self = [super init];
    if (self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleSelectionAltered:)
                                                     name:NOTIFICATION_SELECTION_ALTERED
                                                   object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)handleSelectionAltered:(NSNotification *)notification
{
    [self.sandboxView setNeedsLayout];
}

- (void)loadView
{
    self.sandboxView = [[DefaultSandboxView alloc] init];
    self.sandboxView.debugName = @"sandboxView";
    self.view = self.sandboxView;
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
    self.demoModel = [demo demoModel];
    [self.sandboxView displayDemoModel:self.demoModel];
}

- (void)viewWillLayoutSubviews
{
}

- (void)viewDidLayoutSubviews
{
    dispatch_async(dispatch_get_main_queue(), ^{
//        NSLog(@"viewDidLayoutSubviews: %@ %d",
//              [self.demoModel.rootView debugName],
//              [self.demoModel.rootView.subviews count]);

        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_DEMO_CHANGED
                                                            object:self.demoModel];
    });
}

@end
