//
//  WeView2NoopLayout.m
//  Unknown Project
//
//  Copyright (c) 2013 Charles Matthew Chen. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "WeView2NoopLayout.h"

@implementation WeView2NoopLayout

+ (WeView2NoopLayout *)noopLayout
{
    WeView2NoopLayout *layout = [[WeView2NoopLayout alloc] init];
    return layout;
}

- (CGSize)minSizeOfContentsView:(UIView *)view
                   thatFitsSize:(CGSize)guideSize
{
    return CGSizeZero;
}

- (void)layoutContentsOfView:(UIView *)view
{
}

@end
