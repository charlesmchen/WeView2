//
//  WeView2StackLayout.m
//  Unknown Project
//
//  Copyright (c) 2013 Charles Matthew Chen. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "WeView2StackLayout.h"
#import "UIView+WeView2.h"
#import "WeView2Macros.h"

@implementation WeView2StackLayout

+ (WeView2StackLayout *)stackLayout
{
    WeView2StackLayout *layout = [[WeView2StackLayout alloc] init];
    return layout;
}

// TODO: Honor max/min widths in the earlier phases, of "min size" and "layout" functions.
// TODO: Do we need to honor other params as well?
- (CGSize)minSizeOfContentsView:(UIView *)view
                       subviews:(NSArray *)subviews
                   thatFitsSize:(CGSize)guideSize
{
    BOOL debugMinSize = [self debugMinSize:view];
    if (debugMinSize)
    {
        NSLog(@"+ minSizeOfContentsView: %@ thatFitsSize: %@", [view class], NSStringFromCGSize(guideSize));
    }

    CGRect contentBounds = [self contentBoundsOfView:view
                                             forSize:view.size];

    if (debugMinSize)
    {
        NSLog(@"getMaxContentSize: contentBounds: %@, guideSize: %@, insetSizeOfView: %@",
              FormatRect(contentBounds),
              FormatSize(guideSize),
              FormatSize([self insetSizeOfView:view]));
    }

    CGSize maxSubviewSize = CGSizeZero;
    for (int i=0; i < [subviews count]; i++)
    {
        UIView* subview = subviews[i];

        // TODO: In our initial pass, should we be using a guide size of
        // CGFLOAT_MAX, CGFLOAT_MAX?
        CGSize subviewSize = [self desiredItemSize:subview
                                           maxSize:contentBounds.size];
        maxSubviewSize = CGSizeMax(maxSubviewSize, subviewSize);
    }

    CGSize result = CGSizeAdd(maxSubviewSize,
                              [self insetSizeOfView:view]);
    if (debugMinSize)
    {
        NSLog(@"- minSizeOfContentsView: %@ thatFitsSize: = %@", [view class], NSStringFromCGSize(result));
    }
    return result;
}

- (void)layoutContentsOfView:(UIView *)view
                    subviews:(NSArray *)subviews
{
    CGSize guideSize = view.size;
    BOOL debugLayout = [self debugLayout:view];
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

    BOOL cropSubviewOverflow = [self cropSubviewOverflow:view];
    CellPositioningMode cellPositioning = [self cellPositioning:view];
    for (int i=0; i < [subviews count]; i++)
    {
        UIView* subview = subviews[i];

        CGSize subviewSize = [self desiredItemSize:subview
                                           maxSize:contentBounds.size];

        if (cropSubviewOverflow)
        {
            subviewSize = CGSizeMin(subviewSize, contentBounds.size);
        }

        [self positionSubview:subview
                  inSuperview:view
                     withSize:subviewSize
                 inCellBounds:contentBounds
              cellPositioning:cellPositioning];
    }
}

@end
