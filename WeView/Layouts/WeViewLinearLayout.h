//
//  WeViewLinearLayout.h
//  WeView v2
//
//  Copyright (c) 2014 Charles Matthew Chen. All rights reserved.
//
//  Distributed under the Apache License v2.0.
//  http://www.apache.org/licenses/LICENSE-2.0.html
//

#pragma once

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "WeViewLayout.h"

@interface WeViewLinearLayout : WeViewLayout

// Factory method.
//
// Lays out subviews horizontally, left-to-right.
+ (WeViewLinearLayout *)horizontalLayout;

// Factory method.
//
// Lays out subviews vertically, top-to-bottom.
+ (WeViewLinearLayout *)verticalLayout;

@end
