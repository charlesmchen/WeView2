//
//  WeView2.m
//  Unknown Project
//
//  Copyright (c) 2013 Charles Matthew Chen. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "UIView+WeView2.h"
#import "WeView2.h"
#import "WeView2Layout.h"
#import "WeView2LinearLayout.h"
#import "WeView2Macros.h"

@interface WeView2 ()

@end

#pragma mark -

@implementation WeView2

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self withHLinearLayout];
    }
    return self;
}

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

- (id)withHLinearLayout
{
    self.layout = [WeView2LinearLayout hLinearLayout];
    return self;
}

- (id)withVLinearLayout
{
    self.layout = [WeView2LinearLayout vLinearLayout];
    return self;
}

- (void)layoutSubviews
{
    WeView2Assert(self.layout);
    [self.layout layoutContentsOfView:self];
}

- (CGSize)sizeThatFits:(CGSize)size
{
    WeView2Assert(self.layout);
    return [self.layout minSizeOfContentsView:self
                          thatFitsSize:size];
}

- (id)addSubviews:(NSArray *)subviews
{
    WeView2Assert(subviews);
    for (UIView *subview in subviews)
    {
        WeView2Assert(subview);
        [self addSubview:subview];
    }
    [self setNeedsLayout];
    return self;
}

- (void)removeAllSubviews
{
    for (UIView *subview in self.subviews)
    {
        [subview removeFromSuperview];
    }
}

@end
