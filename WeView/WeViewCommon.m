//
//  WeViewCommon.m
//  Unknown Project
//
//  Copyright (c) 2013 Charles Matthew Chen. All rights reserved.
//
//  Distributed under the Apache License v2.0.
//  http://www.apache.org/licenses/LICENSE-2.0.html
//

#import <assert.h>
#import <objc/runtime.h>

#import "WeViewCommon.h"
#import "WeViewMacros.h"

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
