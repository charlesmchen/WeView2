//
//  WeViewStackLayout.m
//  WeView 2
//
//  Copyright (c) 2013 Charles Matthew Chen. All rights reserved.
//
//  Distributed under the Apache License v2.0.
//  http://www.apache.org/licenses/LICENSE-2.0.html
//

#import <QuartzCore/QuartzCore.h>

#import "WeViewStackLayout.h"
#import "UIView+WeView.h"
#import "WeViewMacros.h"

@implementation WeViewStackLayout

+ (WeViewStackLayout *)stackLayout
{
    WeViewStackLayout *layout = [[WeViewStackLayout alloc] init];
    return layout;
}

- (CGSize)minSizeOfContentsView:(UIView *)view
                       subviews:(NSArray *)subviews
                   thatFitsSize:(CGSize)guideSize
{
    if ([subviews count] < 1)
    {
        return [self insetSizeOfView:view];
    }

    BOOL debugMinSize = [self debugMinSize];
    int indent = 0;
    if (debugMinSize)
    {
        indent = [self viewHierarchyDistanceToWindow:view];
        NSLog(@"%@+ [%@ (%@) minSizeOfContentsView: %@] thatFitsSize: %@",
              [self indentPrefix:indent],
              [self class],
              view.debugName,
              [view class],
              NSStringFromCGSize(guideSize));
    }

    CGRect contentBounds = [self contentBoundsOfView:view
                                             forSize:guideSize];

    if (debugMinSize)
    {
        NSLog(@"%@ contentBounds: %@, guideSize: %@, insetSizeOfView: %@",
              [self indentPrefix:indent + 1],
              FormatCGRect(contentBounds),
              FormatCGSize(guideSize),
              FormatCGSize([self insetSizeOfView:view]));
    }

    CGSize maxSubviewSize = CGSizeZero;
    for (int i=0; i < [subviews count]; i++)
    {
        UIView* subview = subviews[i];

        CGSize subviewSize = [self desiredItemSize:subview
                                           maxSize:contentBounds.size];
        maxSubviewSize = CGSizeMax(maxSubviewSize, subviewSize);
    }

    CGSize result = CGSizeAdd(maxSubviewSize,
                              [self insetSizeOfView:view]);
    if (debugMinSize)
    {
        NSLog(@"%@ thatFitsSize: = %@",
              [self indentPrefix:indent + 1],
              NSStringFromCGSize(result));
    }
    return result;
}

- (void)layoutContentsOfView:(UIView *)view
                    subviews:(NSArray *)subviews
{
    if ([subviews count] < 1)
    {
        return;
    }

    BOOL debugLayout = [self debugLayout];
    int indent = 0;
    CGSize guideSize = view.size;
    if (debugLayout)
    {
        indent = [self viewHierarchyDistanceToWindow:view];
        NSLog(@"%@+ [%@ (%@) layoutContentsOfView: %@] : %@",
              [self indentPrefix:indent],
              [self class],
              view.debugName,
              [view class],
              NSStringFromCGSize(guideSize));
    }

    CGRect contentBounds = [self contentBoundsOfView:view
                                             forSize:view.size];

    if (debugLayout)
    {
        NSLog(@"%@ contentBounds: %@, guideSize: %@, insetSizeOfView: %@",
              [self indentPrefix:indent + 1],
              FormatCGRect(contentBounds),
              FormatCGSize(guideSize),
              FormatCGSize([self insetSizeOfView:view]));
    }

    BOOL cropSubviewOverflow = [self cropSubviewOverflow];
    CellPositioningMode cellPositioning = [self cellPositioning];
    for (int i=0; i < [subviews count]; i++)
    {
        UIView* subview = subviews[i];

        CGSize subviewSize = [self desiredItemSize:subview
                                           maxSize:contentBounds.size];

        if (cropSubviewOverflow)
        {
            subviewSize = CGSizeMin(subviewSize, contentBounds.size);
        }

        CGRect cellBounds = contentBounds;
        [self positionSubview:subview
                  inSuperview:view
                     withSize:subviewSize
                 inCellBounds:cellBounds
              cellPositioning:cellPositioning];

        if (debugLayout)
        {
            NSLog(@"%@ - final layout[%d] %@: %@, cellBounds: %@, subviewSize: %@",
                  [self indentPrefix:indent + 2],
                  i,
                  [subview class],
                  FormatCGRect(subview.frame),
                  FormatCGRect(cellBounds),
                  FormatCGSize(subviewSize));
        }
    }
}

@end
