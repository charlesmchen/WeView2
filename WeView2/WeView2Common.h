//
//  WeView2Common.h
//  Unknown Project
//
//  Copyright (c) 2013 Charles Matthew Chen. All rights reserved.
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

CGRect alignSizeWithinRect(CGSize size, CGRect rect, HAlign hAlign, VAlign vAlign);
