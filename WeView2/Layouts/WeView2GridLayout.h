//
//  WeView2GridLayout.h
//  Unknown Project
//
//  Copyright (c) 2013 Charles Matthew Chen. All rights reserved.
//

#pragma once

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "WeView2Layout.h"

typedef enum
{
    GRID_STRETCH_POLICY_STRETCH_CELLS,
    GRID_STRETCH_POLICY_STRETCH_SPACING,
    GRID_STRETCH_POLICY_NO_STRETCH,
} GridStretchPolicy;

@interface WeView2GridLayout : WeView2Layout

//@property (nonatomic) BOOL isHorizontal;
//
// Factory method.
//+ (WeView2GridLayout *)gridLayout
//columnCount:(int)columnCount
//isGridUniform:(BOOL)isGridUniform;
//
//+ (WeView2GridLayout *)horizontalLayout;
//
//+ (WeView2GridLayout *)verticalLayout;

@end
