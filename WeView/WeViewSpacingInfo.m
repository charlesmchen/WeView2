//
//  WeViewSpacingInfo.m
//  WeView v2
//
//  Copyright (c) 2014 Charles Matthew Chen. All rights reserved.
//
//  Distributed under the Apache License v2.0.
//  http://www.apache.org/licenses/LICENSE-2.0.html
//

#import "WeViewSpacingInfo.h"

@implementation WeViewSpacingInfo

+ (WeViewSpacingInfo *)spacingWithFixedSize:(int)fixedSize
{
    WeViewSpacingInfo *result = [[WeViewSpacingInfo alloc] init];
    result.fixedSize = @(fixedSize);
    return result;
}

+ (WeViewSpacingInfo *)spacingWithStretchWeight:(CGFloat)stretchWeight
{
    WeViewSpacingInfo *result = [[WeViewSpacingInfo alloc] init];
    result.stretchWeight = @(stretchWeight);
    return result;
}

+ (WeViewSpacingInfo *)spacingWithFixedSize:(int)fixedSize
                              stretchWeight:(CGFloat)stretchWeight
{
    WeViewSpacingInfo *result = [[WeViewSpacingInfo alloc] init];
    result.fixedSize = @(fixedSize);
    result.stretchWeight = @(stretchWeight);
    return result;
}

@end
