//
//  ViewTreeViewController.m
//  WeViews2DemoApp
//
//  Copyright (c) 2013 Charles Matthew Chen. All rights reserved.
//

#import "UIView+WeView2.h"
#import "ViewTreeViewController.h"
#import "ViewHierarchyTree.h"

@interface ViewTreeViewController ()

@property (nonatomic) WeView2 *rootView;

@property (nonatomic) ViewHierarchyTree *viewHierarchyTree;

@end

#pragma mark -

@implementation ViewTreeViewController

- (id)init
{
    self = [super init];
    if (self)
    {
        self.title = NSLocalizedString(@"View Hierarchy", nil);
    }
    return self;
}

- (void)loadView
{
    self.rootView = [[[WeView2 alloc] init]
                     setVLinearLayout];
    [self.rootView setVAlign:V_ALIGN_TOP];
    //    self.rootView.debugLayout = YES;
    self.rootView.opaque = YES;
    self.rootView.backgroundColor = [UIColor whiteColor];
    self.view = self.rootView;

    [self updateDemoModel:[DemoModel create]];
}

- (void)updateDemoModel:(DemoModel *)demoModel
{
    [self.rootView removeAllSubviews];
    self.viewHierarchyTree = [ViewHierarchyTree create:demoModel];
    [self.rootView addSubviews:@[self.viewHierarchyTree]];
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

@end
