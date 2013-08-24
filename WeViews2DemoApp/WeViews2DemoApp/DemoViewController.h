//
//  DemoViewController.h
//  WeViews2DemoApp
//
//  Copyright (c) 2013 Charles Matthew Chen. All rights reserved.
//

#pragma once

#import <UIKit/UIKit.h>

#import "Demo.h"

@protocol DemoViewControllerDelegate <NSObject>

- (void)demoViewChanged:(UIView *)view;

@end

#pragma mark -

@interface DemoViewController : UIViewController

@property (nonatomic, weak) id<DemoViewControllerDelegate> delegate;

- (void)displayDemo:(Demo *)demo;

@end
