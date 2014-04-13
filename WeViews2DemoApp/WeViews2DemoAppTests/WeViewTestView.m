//
//  WeViewTestView.m
//  WeView v2
//
//  Copyright (c) 2014 Charles Matthew Chen. All rights reserved.
//
//  Distributed under the Apache License v2.0.
//  http://www.apache.org/licenses/LICENSE-2.0.html
//

#import "WeViewTestView.h"

@implementation WeViewTestView

- (id)initWithDesiredSize:(CGSize)desiredSize
{
    self = [super init];
    if (self)
    {
        self.desiredSize = desiredSize;
    }
    return self;
}

- (CGSize)sizeThatFits:(CGSize)size
{
    return self.desiredSize;
}

@end
