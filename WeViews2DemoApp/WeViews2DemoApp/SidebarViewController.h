//
//  SidebarViewController.h
//  WeViews2DemoApp
//
//  Copyright (c) 2013 Charles Matthew Chen. All rights reserved.
//

#pragma once

#import <UIKit/UIKit.h>

#import "DemoDescriptionViewController.h"
#import "SelectDemoViewController.h"

@interface SidebarViewController : UIViewController

@property (nonatomic) SelectDemoViewController *selectDemoViewController;

@property (nonatomic) DemoDescriptionViewController *demoDescriptionViewController;

@end
