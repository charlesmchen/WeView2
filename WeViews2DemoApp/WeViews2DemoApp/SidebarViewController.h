//
//  SidebarViewController.h
//  WeViews2DemoApp
//
//  Copyright (c) 2013 Charles Matthew Chen. All rights reserved.
//

#pragma once

#import <UIKit/UIKit.h>

#import "SelectDemoViewController.h"
#import "ViewTreeViewController.h"
#import "ViewEditorController.h"

@interface SidebarViewController : UIViewController

@property (nonatomic) SelectDemoViewController *selectDemoViewController;

@property (nonatomic) ViewTreeViewController *viewTreeViewController;

@property (nonatomic) ViewEditorController *viewEditorController;

@end
