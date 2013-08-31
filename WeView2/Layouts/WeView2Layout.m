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
                    subviews:(NSArray *)subviews
{
    assert(0);
}

- (CGSize)minSizeOfContentsView:(UIView *)view
                       subviews:(NSArray *)subviews
                   thatFitsSize:(CGSize)guideSize
{
    assert(0);
    return CGSizeZero;
}

- (void)positionSubview:(UIView *)subview
            inSuperview:(UIView *)superview
               withSize:(CGSize)subviewSize
           inCellBounds:(CGRect)cellBounds
{
    if (subview.hStretchWeight > 0)
    {
        subviewSize.width = cellBounds.size.width;
    }
    if (subview.vStretchWeight > 0)
    {
        subviewSize.height = cellBounds.size.height;
    }
//    subviewSize = CGSizeMax(CGSizeZero, CGSizeFloor(CGSizeMin(cellBounds.size, subviewSize)));
    subviewSize = CGSizeMax(CGSizeZero, CGSizeFloor(subviewSize));
    subview.frame = alignSizeWithinRect(subviewSize, cellBounds, superview.hAlign, superview.vAlign);
}

- (CGPoint)insetOriginOfView:(UIView *)view
{
    return [self contentBoundsOfView:view
                             forSize:view.size].origin;
}

- (CGRect)contentBoundsOfView:(UIView *)view
                      forSize:(CGSize)size
{
    CGFloat borderWidth = view.layer.borderWidth;

    int left = ceilf(view.leftMargin + borderWidth);
    int top = ceilf(view.topMargin + borderWidth);
    int right = ceilf(size.width - (view.rightMargin + borderWidth));
    int bottom = ceilf(size.height - (view.bottomMargin + borderWidth));

    return CGRectMake(left,
                      top,
                      MAX(0, right - left),
                      MAX(0, bottom - top));
}

- (CGSize)insetSizeOfView:(UIView *)view
{
    int borderWidth = ceilf(view.layer.borderWidth);
    return CGSizeFloor(CGSizeMake(view.leftMargin + view.rightMargin + 2 * borderWidth,
                                  view.topMargin + view.bottomMargin + 2 * borderWidth));
}

- (CGSize)desiredItemSize:(UIView *)subview
                  maxSize:(CGSize)maxSize
{
    return CGSizeMax(CGSizeZero,
                     CGSizeCeil(CGSizeMax(subview.minSize,
                                          CGSizeMin(subview.maxSize,
                                                    [subview sizeThatFits:maxSize]))));
}

@end
