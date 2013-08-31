//
//  WeView2CenterLayout.m
//  Unknown Project
//
//  Copyright (c) 2013 Charles Matthew Chen. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "WeView2CenterLayout.h"
#import "UIView+WeView2.h"
#import "WeView2Macros.h"

@implementation WeView2CenterLayout

+ (WeView2CenterLayout *)centerLayout
{
    WeView2CenterLayout *layout = [[WeView2CenterLayout alloc] init];
    return layout;
}

// TODO: Honor max/min widths in the earlier phases, of "min size" and "layout" functions.
// TODO: Do we need to honor other params as well?
- (CGSize)minSizeOfContentsView:(UIView *)view
                       subviews:(NSArray *)subviews
                   thatFitsSize:(CGSize)guideSize
{
    BOOL debugLayout = view.debugLayout;
    if (debugLayout)
    {
        NSLog(@"+ minSizeOfContentsView: %@ thatFitsSize: %@", [view class], NSStringFromCGSize(guideSize));
    }

    CGRect contentBounds = [self contentBoundsOfView:view
                                             forSize:view.size];

    if (debugLayout)
    {
        NSLog(@"getMaxContentSize: contentBounds: %@, guideSize: %@, insetSizeOfView: %@",
              FormatRect(contentBounds),
              FormatSize(guideSize),
              FormatSize([self insetSizeOfView:view]));
    }

    CGSize result = CGSizeZero;
    for (int i=0; i < [subviews count]; i++)
    {
        UIView* subview = subviews[i];

        CGSize idealSize = CGSizeZero;

        if (!subview.ignoreDesiredSize)
        {
            // TODO: In our initial pass, should we be using a guide size of
            // CGFLOAT_MAX, CGFLOAT_MAX?
            idealSize = [self desiredItemSize:subview
                                      maxSize:contentBounds.size];
        }

        result = CGSizeMax(result,
                           CGSizeMax(subview.minSize,
                                     CGSizeMin(subview.maxSize, idealSize)));
    }

    result = CGSizeCeil(result);
    if (debugLayout)
    {
        NSLog(@"- minSizeOfContentsView: %@ thatFitsSize: = %@", [view class], NSStringFromCGSize(result));
    }
    return result;
}

- (void)layoutContentsOfView:(UIView *)view
                    subviews:(NSArray *)subviews
{
    CGSize guideSize = view.size;
    BOOL debugLayout = view.debugLayout;
    if (debugLayout)
    {
        NSLog(@"+ minSizeOfContentsView: %@ thatFitsSize: %@", [view class], NSStringFromCGSize(guideSize));
    }

    CGRect contentBounds = [self contentBoundsOfView:view
                                             forSize:view.size];

    if (debugLayout)
    {
        NSLog(@"getMaxContentSize: contentBounds: %@, guideSize: %@, insetSizeOfView: %@",
              FormatRect(contentBounds),
              FormatSize(guideSize),
              FormatSize([self insetSizeOfView:view]));
    }

    for (int i=0; i < [subviews count]; i++)
    {
        UIView* subview = subviews[i];

        CGSize subviewSize = CGSizeZero;

        if (!subview.ignoreDesiredSize)
        {
            subviewSize = [self desiredItemSize:subview
                                        maxSize:contentBounds.size];
        }

        [self positionSubview:subview
                  inSuperview:view
                     withSize:subviewSize
                 inCellBounds:contentBounds];
    }
}

@end
