//
//  SandboxView.h
//  WeView v2
//
//  Copyright (c) 2013 Charles Matthew Chen. All rights reserved.
//
//  Distributed under the Apache License v2.0.
//  http://www.apache.org/licenses/LICENSE-2.0.html
//

#pragma once

#import <UIKit/UIKit.h>

#import "WeView.h"

#import "Demo.h"

@interface SandboxView : WeView

- (void)displayDemoModel:(DemoModel *)demoModel;
- (CGSize)rootViewSize;
- (CGSize)maxViewSize;
- (void)setControlsHidden:(BOOL)value;

- (void)animateRelayout;

@end
