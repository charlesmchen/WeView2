//
//  WeViewEnums.h
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

#import "WeViewMacros.h"

/**
 * Horizontal alignment constants.
 */
typedef enum
{
    H_ALIGN_LEFT = 0,
    H_ALIGN_CENTER = 1,
    H_ALIGN_RIGHT = 2,
} HAlign;

/**
 * Vertical alignment constants.
 */
typedef enum
{
    V_ALIGN_TOP = 0,
    V_ALIGN_CENTER = 1,
    V_ALIGN_BOTTOM = 2,
} VAlign;

CG_INLINE
NSString* FormatHAlign(HAlign value)
{
    switch (value)
    {
        case H_ALIGN_LEFT:
            return @"Left";
        case H_ALIGN_CENTER:
            return @"Center";
        case H_ALIGN_RIGHT:
            return @"Right";
        default:
            WeViewAssert(0);
            return nil;
    }
}

CG_INLINE
NSString* FormatVAlign(VAlign value)
{
    switch (value)
    {
        case V_ALIGN_TOP:
            return @"Top";
        case H_ALIGN_CENTER:
            return @"Center";
        case V_ALIGN_BOTTOM:
            return @"Bottom";
        default:
            WeViewAssert(0);
            return nil;
    }
}

typedef enum
{
    // Subviews are positioned within their layout cell using stretch, alignment, etc.
    CELL_POSITION_NORMAL,

    // Subviews occupy the entirety of their layout cell.
    CELL_POSITION_FILL,

    // Subviews are scaled to fill the bounds of their layout cell, but perserving their desired
    // aspect ratio.
    CELL_POSITION_FILL_W_ASPECT_RATIO,

    // Subviews are scaled to exactly fit inside the bounds of their layout cell, but perserving
    // their desired aspect ratio.
    CELL_POSITION_FIT_W_ASPECT_RATIO,
} CellPositioningMode;

CG_INLINE
NSString* FormatCellPositioningMode(CellPositioningMode value)
{
    switch (value)
    {
        case CELL_POSITION_NORMAL:
            return @"Normal";
        case CELL_POSITION_FILL:
            return @"Fill";
        case CELL_POSITION_FILL_W_ASPECT_RATIO:
            return @"Fill (AR)";
        case CELL_POSITION_FIT_W_ASPECT_RATIO:
            return @"Fit (AR)";
        default:
            WeViewAssert(0);
            return nil;
    }
}
