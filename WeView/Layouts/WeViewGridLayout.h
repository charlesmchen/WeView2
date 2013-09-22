//
//  WeViewGridLayout.h
//  WeView 2
//
//  Copyright (c) 2013 Charles Matthew Chen. All rights reserved.
//
//  Distributed under the Apache License v2.0.
//  http://www.apache.org/licenses/LICENSE-2.0.html
//

#pragma once

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "WeViewLayout.h"

typedef enum
{
    // If there is extra space in the layout, stretch the cells to fill it, distributing the extra
    // space equally among the cells.
    GRID_STRETCH_POLICY_STRETCH_CELLS,

    // If there is extra space in the layout, stretch the spacing between the cells to fill it,
    // distributing the extra space equally among the spacings.
    GRID_STRETCH_POLICY_STRETCH_SPACING,

    // If there is extra space in the layout, stretch nothing.  Instead align the grid body within
    // the cell content bounds.
    GRID_STRETCH_POLICY_NO_STRETCH,
} GridStretchPolicy;

#pragma mark -

@interface WeViewGridLayout : WeViewLayout

// Use this factory method if you want to specify a cellSizeHint.
//
// columnCount: The number of columns in the grid.
// isGridUniform: If true, the layout guarantees that the cell sizes will all be nearly equal.
//                Each column will be as wide as the widest column.
//                Each row will be as tall as the tallest row.
// stretchPolicy: See the GridStretchPolicy enum.
// cellSizeHint: The base cell size to use. The cell sizes will not reflect the desired sizes of
//                their contents.
+ (WeViewGridLayout *)gridLayoutWithColumns:(int)columnCount
                              isGridUniform:(BOOL)isGridUniform
                              stretchPolicy:(GridStretchPolicy)stretchPolicy
                               cellSizeHint:(CGSize)cellSizeHint;

// Use this factory method if the size of the cells should be based on their contents.
//
// columnCount: The number of columns in the grid.
// isGridUniform: If true, the layout guarantees that the cell sizes will all be nearly equal.
//                Each column will be as wide as the widest column.
//                Each row will be as tall as the tallest row.
// stretchPolicy: See the GridStretchPolicy enum.
+ (WeViewGridLayout *)gridLayoutWithColumns:(int)columnCount
                              isGridUniform:(BOOL)isGridUniform
                              stretchPolicy:(GridStretchPolicy)stretchPolicy;

@end
