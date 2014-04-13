//
//  WeViewLayoutUtils.m
//  WeView v2
//
//  Copyright (c) 2014 Charles Matthew Chen. All rights reserved.
//
//  Distributed under the Apache License v2.0.
//  http://www.apache.org/licenses/LICENSE-2.0.html
//

#import "WeViewLayoutUtils.h"

CGFloat WeViewSumFloats(NSArray *values)
{
    CGFloat result = 0;
    for (NSNumber *value in values)
    {
        result += [value floatValue];
    }
    return result;
}

int WeViewSumInts(NSArray *values)
{
    CGFloat result = 0;
    for (NSNumber *value in values)
    {
        result += [value intValue];
    }
    return result;
}

CGFloat WeViewMaxFloats(NSArray *values)
{
    CGFloat result = 0;
    for (NSNumber *value in values)
    {
        result = MAX(result, [value floatValue]);
    }
    return result;
}

NSMutableArray *WeViewArrayOfFloatsWithValue(CGFloat value, int count)
{
    NSMutableArray *result = [NSMutableArray array];
    for (int i=0; i < count; i++)
    {
        [result addObject:@(value)];
    }
    return result;
}
