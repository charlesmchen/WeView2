//
//  WeView2LinearLayout.h
//  Unknown Project
//
//  Copyright (c) 2013 Charles Matthew Chen. All rights reserved.
//

#pragma once

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "WeView2Layout.h"

@interface WeView2LinearLayout : WeView2Layout

// Factory method.
//
// Lays out subviews horizontally, left-to-right.
+ (WeView2LinearLayout *)horizontalLayout;

// Factory method.
//
// Lays out subviews vertically, top-to-bottom.
+ (WeView2LinearLayout *)verticalLayout;

@end
