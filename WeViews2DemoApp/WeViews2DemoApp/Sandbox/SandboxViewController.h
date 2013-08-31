//
//  SandboxViewController.h
//  WeViews2DemoApp
//
//  Copyright (c) 2013 Charles Matthew Chen. All rights reserved.
//

#pragma once

#import <UIKit/UIKit.h>

#import "Demo.h"
#import "SandboxView.h"

//@protocol SandboxViewControllerDelegate <NSObject>
//
////- (void)demoViewChanged:(UIView *)view;
//- (void)demoModelChanged:(DemoModel *)demoModel;
//
//@end
//
//#pragma mark -

@interface SandboxViewController : UIViewController

//@property (nonatomic, weak) id<SandboxViewControllerDelegate> delegate;

- (void)displayDemo:(Demo *)demo;

@end
