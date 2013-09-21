//
//  WeViewCommon.h
//  Unknown Project
//
//  Copyright (c) 2013 Charles Matthew Chen. All rights reserved.
//
//  Distributed under the Apache License v2.0.
//  http://www.apache.org/licenses/LICENSE-2.0.html
//

#pragma once

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

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

NSString* FormatVAlign(VAlign value);
NSString* FormatHAlign(HAlign value);

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

NSString* FormatCellPositioningMode(CellPositioningMode value);
