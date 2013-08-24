//
//  WeView2Layout.m
//  Unknown Project
//
//  Copyright (c) 2013 Charles Matthew Chen. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "UIView+WeView2.h"
#import "WeView2LinearLayout.h"
#import "WeView2Macros.h"

@interface WeView2Layout ()

@end

#pragma mark -

@implementation WeView2Layout

- (id)init
{
    self = [super init];
    if (self)
    {
    }
    return self;
}

- (void)dealloc
{
}

- (void)layoutContentsOfView:(UIView *)view
{
    assert(0);
}

- (CGSize)minSizeOfContentsView:(UIView *)view
                   thatFitsSize:(CGSize)guideSize
{
    assert(0);
    return CGSizeZero;
}

- (void)setSubviewFrame:(CGRect)frame
                subview:(UIView *)subview
{
    // Make sure the subview doesn't have a negative width or height.
    frame.origin = CGPointRound(frame.origin);
    frame.size = CGSizeMax(CGSizeZero, CGSizeRound(frame.size));
    subview.frame = frame;
}

@end
