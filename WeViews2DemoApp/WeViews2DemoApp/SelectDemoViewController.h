//
//  SelectDemoViewController.h
//  WeView v2
//
//  Copyright (c) 2014 Charles Matthew Chen. All rights reserved.
//
//  Distributed under the Apache License v2.0.
//  http://www.apache.org/licenses/LICENSE-2.0.html
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
