//
//  DemoMacros.h
//  WeView 2
//
//  Copyright (c) 2013 Charles Matthew Chen. All rights reserved.
//
//  Distributed under the Apache License v2.0.
//  http://www.apache.org/licenses/LICENSE-2.0.html
//

#pragma once

CG_INLINE
NSString *FormatFloat(CGFloat value)
{
    if (value == CGFLOAT_MAX)
    {
        return @"\u221E";
    }
    else if (value == CGFLOAT_MIN)
    {
        return @"-\u221E";
    }
    else
    {
        return [@(value) description];
    }
}

CG_INLINE
NSString *FormatInt(int value)
{
    return [@(value) description];
}

CG_INLINE
NSString *FormatBoolean(BOOL value)
{
    return value ? @"YES" : @"NO";
}
