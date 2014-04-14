//
//  WeViewSpacing.m
//  WeView v2
//
//  Copyright (c) 2014 Charles Matthew Chen. All rights reserved.
//
//  Distributed under the Apache License v2.0.
//  http://www.apache.org/licenses/LICENSE-2.0.html
//

#import "WeViewSpacing.h"

@implementation WeViewSpacing

+ (WeViewSpacing *)spacingWithSize:(int)size
{
    WeViewSpacing *result = [[WeViewSpacing alloc] init];
    result.size = size;
    return result;
}

+ (WeViewSpacing *)spacingWithStretchWeight:(CGFloat)stretchWeight
{
    WeViewSpacing *result = [[WeViewSpacing alloc] init];
    result.stretchWeight = stretchWeight;
    return result;
}

+ (WeViewSpacing *)spacingWithSize:(int)size
                     stretchWeight:(CGFloat)stretchWeight
{
    WeViewSpacing *result = [[WeViewSpacing alloc] init];
    result.size = size;
    result.stretchWeight = stretchWeight;
    return result;
}

-(NSString*)description
{
    return [NSString stringWithFormat:@"[%@, size: %d, stretchWeight: %f]", self.class, self.size, self.stretchWeight];
}

@end
