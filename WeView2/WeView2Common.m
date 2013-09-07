//
//  WeView2Common.m
//  Unknown Project
//
//  Copyright (c) 2013 Charles Matthew Chen. All rights reserved.
//
//  Distributed under the Apache License v2.0.
//  http://www.apache.org/licenses/LICENSE-2.0.html
//

#import <assert.h>
#import <objc/runtime.h>

#import "WeView2Common.h"
#import "WeView2Macros.h"

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
            WeView2Assert(0);
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
            WeView2Assert(0);
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
            WeView2Assert(0);
            return nil;
    }
}

CGRect alignSizeWithinRect(CGSize size, CGRect rect, HAlign hAlign, VAlign vAlign)
{
    CGRect result;
    result.size = size;

    switch (hAlign)
    {
        case H_ALIGN_LEFT:
            result.origin.x = 0;
            break;
        case H_ALIGN_CENTER:
            result.origin.x = (rect.size.width - size.width) / 2;
            break;
        case H_ALIGN_RIGHT:
            result.origin.x = rect.size.width - size.width;
            break;
        default:
            NSLog(@"Unknown hAlign: %d", hAlign);
            assert(0);
            break;
    }
    switch (vAlign)
    {
        case V_ALIGN_TOP:
            result.origin.y = 0;
            break;
        case V_ALIGN_CENTER:
            result.origin.y = (rect.size.height - size.height) / 2;
            break;
        case V_ALIGN_BOTTOM:
            result.origin.y = rect.size.height - size.height;
            break;
        default:
            NSLog(@"Unknown vAlign: %d", vAlign);
            assert(0);
            break;
    }
    result.origin = CGPointRound(CGPointAdd(result.origin, rect.origin));
    return result;
}
