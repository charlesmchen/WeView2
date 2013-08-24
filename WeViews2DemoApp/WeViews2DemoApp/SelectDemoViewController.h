//
//  SelectDemoViewController.h
//  WeViews2DemoApp
//
//  Copyright (c) 2013 Charles Matthew Chen. All rights reserved.
//

#pragma once

#import <UIKit/UIKit.h>

#import "Demo.h"

@protocol SelectDemoViewControllerDelegate <NSObject>

- (void)demoSelected:(Demo *)demo;

@end

#pragma mark -

@interface SelectDemoViewController : UITableViewController

@property (nonatomic, weak) id<SelectDemoViewControllerDelegate> delegate;

@end
