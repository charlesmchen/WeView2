//
//  WeView2LinearLayout.m
//  Unknown Project
//
//  Copyright (c) 2013 Charles Matthew Chen. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "UIView+WeView2.h"
#import "WeView2LinearLayout.h"
#import "WeView2Macros.h"

@interface WeView2LinearLayout ()

@end

#pragma mark -

@implementation WeView2LinearLayout

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

+ (WeView2LinearLayout *)horizontalLayout
{
    WeView2LinearLayout *layout = [[WeView2LinearLayout alloc] init];
    layout.isHorizontal = YES;
    return layout;
}

+ (WeView2LinearLayout *)verticalLayout
{
    WeView2LinearLayout *layout = [[WeView2LinearLayout alloc] init];
    layout.isHorizontal = NO;
    return layout;
}

- (IntSize)sumContentSize:(CGSize *)subviewSizes
             subviewCount:(int)subviewCount
               horizontal:(BOOL)horizontal
{
    // Sum the "content size" ie. the minimum desired size of the subviews.
    // This doesn't include the margins, border, spacing, etc.
    IntSize result = IntSizeZero();
    for (int i=0; i < subviewCount; i++)
    {
        if (horizontal)
        {
            result.width += subviewSizes[i].width;
            result.height = MAX(result.height, subviewSizes[i].height);
        }
        else
        {
            result.width = MAX(result.width, subviewSizes[i].width);
            result.height += subviewSizes[i].height;
        }
    }
    return result;
}

- (void)getStretchWeightsForSubviews:(NSArray *)subviews
                        subviewCount:(int)subviewCount
                      stretchWeights:(CGFloat *)stretchWeights
                  totalStretchWeight:(CGFloat *)totalStretchWeight
                        stretchCount:(int *)stretchCount
{
    WeView2Assert([subviews count] == subviewCount);

    // Total stretch weight of subviews along the axis of layout.
    *totalStretchWeight = 0;
    // The number of subviews with flexible size along the axis of layout.
    *stretchCount = 0;

    for (int i=0; i < subviewCount; i++)
    {
        UIView* subview = subviews[i];
        stretchWeights[i] = (self.isHorizontal
                             ? subview.hStretchWeight
                             : subview.vStretchWeight);

        WeView2Assert(stretchWeights[i] >= 0);
        // TODO: Should not be necessary.
        stretchWeights[i] = fabsf(stretchWeights[i]);

        if (stretchWeights[i] > 0)
        {
            *totalStretchWeight += stretchWeights[i];
            *stretchCount = *stretchCount + 1;
        }
    }
}

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

    BOOL horizontal = self.isHorizontal;
    int subviewCount = [subviews count];

    CGFloat totalStretchWeight;
    int stretchCount;
    CGFloat stretchWeights[subviewCount];
    [self getStretchWeightsForSubviews:subviews
                          subviewCount:subviewCount
                        stretchWeights:&(stretchWeights[0])
                    totalStretchWeight:&totalStretchWeight
                          stretchCount:&stretchCount];

    CGFloat spacing = ceilf(horizontal ? view.hSpacing : view.vSpacing);
    CGRect contentBounds = [self contentBoundsOfView:view
                                             forSize:guideSize];
    CGSize maxSubviewSize = contentBounds.size;
    if (horizontal)
    {
        maxSubviewSize.width = MAX(0, maxSubviewSize.width - spacing * (subviewCount - 1));
    }
    else
    {
        maxSubviewSize.height = MAX(0, maxSubviewSize.height - spacing * (subviewCount - 1));
    }

    if (debugLayout)
    {
        NSLog(@"minSizeOfContentsView: contentBounds: %@, guideSize: %@, insetSizeOfView: %@",
              FormatRect(contentBounds),
              FormatSize(guideSize),
              FormatSize([self insetSizeOfView:view]));
    }

    CGSize subviewSizes[subviewCount];
    for (int i=0; i < subviewCount; i++)
    {
        UIView* subview = subviews[i];

        // TODO: In our initial pass, should we be using a guide size of
        // CGFLOAT_MAX, CGFLOAT_MAX?
        subviewSizes[i] = [self desiredItemSize:subview
                                        maxSize:maxSubviewSize];
    }

    IntSize contentSize = [self sumContentSize:&subviewSizes[0]
                                  subviewCount:subviewCount
                                    horizontal:horizontal];

    if (debugLayout)
    {
        [self dumpItemSizes:@"minSizeOfContentsView: thatFitsSize: (ideal)"
                   subviews:subviews
               subviewSizes:subviewSizes
             stretchWeights:stretchWeights];
        NSLog(@"minSizeOfContentsView (%@ %@) (ideal) contentSize: %@",
              [view class], view.debugName,
              FormatIntSize(contentSize));
    }

    // In a second pass, we check whether the total subview size has overflowed the "size"
    // param which is a hint about available space.  If so, we _try_ to squeeze the subviews
    // into the available space.  Note: subviews are free to insist (via the return value of
    // [sizeThatFits:] on a size that is larger than the available space.  Since we are not
    // doing actual layout at this point, we are free to do the same as well.
    if (horizontal)
    {
        int axisSize = contentSize.width;
        int extraAxisSpaceRaw = maxSubviewSize.width - contentSize.width;

        if (extraAxisSpaceRaw < 0)
        {
            // Can't fit everything; we need to crop.
            int totalCropAmount = -extraAxisSpaceRaw;
            int remainingCropAmount = totalCropAmount;
            // We want to crop proportionally, so that we crop more
            // from larger subviews.
            CGFloat cropFactor = clamp01(remainingCropAmount / (CGFloat) axisSize);
            for (int i=0; i < subviewCount; i++)
            {
                int cropAmount;
                // round up the amount to crop.
                if (horizontal)
                {
                    cropAmount = ceilf(subviewSizes[i].width * cropFactor);
                }
                else
                {
                    cropAmount = ceilf(subviewSizes[i].height * cropFactor);
                }
                // Don't crop more than enough to exactly fit subviews in panel.
                cropAmount = MIN(remainingCropAmount, cropAmount);
                remainingCropAmount -= cropAmount;

                int newItemWidth = subviewSizes[i].width - cropAmount;

                // For "wrapping" subviews, reducing the width can increase
                // the height.
                UIView* subview = subviews[i];
                subviewSizes[i].height = [subview sizeThatFits:CGSizeMake(newItemWidth,
                                                                          maxSubviewSize.height)].height;
            }

            // Update content size
            contentSize = [self sumContentSize:&subviewSizes[0]
                                  subviewCount:subviewCount
                                    horizontal:horizontal];

            if (debugLayout)
            {
                [self dumpItemSizes:@"minSizeOfContentsView: thatFitsSize: (after crop)"
                           subviews:subviews
                       subviewSizes:subviewSizes
                     stretchWeights:stretchWeights];
                NSLog(@"minSizeOfContentsView (%@ %@) (after crop) contentSize: %@",
                      [view class], view.debugName,
                      FormatIntSize(contentSize));
            }

        }
    }

    // If any subviews can stretch, we want distribute any remaining space along the axis of layout,
    // dividing it among them on the basis of their stretch weights.
    //
    // TODO: We probably need to rewrite this.
    if (stretchCount > 0)
    {
        WeView2Assert(totalStretchWeight > 0);

        int stretchCountRemainder = stretchCount;
        int stretchTotal;
        if (horizontal)
        {
            stretchTotal = maxSubviewSize.width - contentSize.width;
        }
        else
        {
            stretchTotal = maxSubviewSize.height - contentSize.height;
        }
        // The amount of extra space in the layout along the axis of layout.
        // It should be divided amongst the subviews on the basis of stretch weight.
        int stretchRemainder = stretchTotal;

        // If there is extra space available...
        if (stretchRemainder > 0)
        {
            for (int i=0; i < subviewCount; i++)
            {
                // ignore non-stretching subviews.
                if (!(stretchWeights[i] > 0))
                {
                    continue;
                }
                UIView* subview = subviews[i];

                // Divide the remaining stretch space evenly between the stretching
                // subviews in this layer.
                int subviewStretch;
                if (stretchCountRemainder == 1)
                {
                    subviewStretch = stretchRemainder;
                }
                else
                {
                    subviewStretch = floorf(stretchRemainder * stretchWeights[i] / totalStretchWeight);
                }
                stretchCountRemainder--;
                stretchRemainder -= subviewStretch;

                CGSize maxStretchItemSize = maxSubviewSize;
                if (horizontal)
                {
                    maxStretchItemSize.width = subviewStretch;
                }
                else
                {
                    maxStretchItemSize.height = subviewStretch;
                }

                // We now need to recalculate the subview's size as changing it's size along the
                // axis of layout may have changed it's size on the cross axis.
                subviewSizes[i] = [self desiredItemSize:subview
                                                maxSize:maxStretchItemSize];
            }
        }

        // Update content size
        contentSize = [self sumContentSize:&subviewSizes[0]
                              subviewCount:subviewCount
                                horizontal:horizontal];
    }

    if (debugLayout)
    {
        [self dumpItemSizes:@"minSizeOfContentsView: thatFitsSize: (final)"
                   subviews:subviews
               subviewSizes:subviewSizes
             stretchWeights:stretchWeights];
        NSLog(@"minSizeOfContentsView (%@ %@) (final) contentSize: %@",
              [view class], view.debugName,
              FormatIntSize(contentSize));
    }

    // Add margins and return.
    CGSize result = CGSizeAdd(CGSizeFromIntSize(contentSize),
                              [self insetSizeOfView:view]);

    if (horizontal)
    {
        result.width += spacing * (subviewCount - 1);
    }
    else
    {
        result.height += spacing * (subviewCount - 1);
    }

    if (debugLayout)
    {
        NSLog(@"- minSizeOfContentsView: %@ thatFitsSize: = %@", [view class], NSStringFromCGSize(result));
    }
    return result;
}

- (void)dumpItemSizes:(NSString *)label
             subviews:(NSArray *)subviews
         subviewSizes:(CGSize *)subviewSizes
       stretchWeights:(CGFloat *)stretchWeights
{
    for (int i=0; i < [subviews count]; i++)
    {
        UIView* subview = subviews[i];

        NSLog(@"\t%@[%d] %@ size: %@, stretchWeight: %f",
              label,
              i,
              [subview class],
              FormatSize(subviewSizes[i]),
              stretchWeights[i]);
    }
}

- (void)layoutContentsOfView:(UIView *)view
                    subviews:(NSArray *)subviews
{
    BOOL debugLayout = view.debugLayout;
    if (debugLayout)
    {
        NSLog(@"layoutContentsOfView: %@ (%@) %@",
              [view class], view.debugName, NSStringFromCGSize(view.size));
    }

    BOOL horizontal = self.isHorizontal;
    int subviewCount = [subviews count];

    CGFloat totalStretchWeight;
    int stretchCount;
    CGFloat stretchWeights[subviewCount];
    [self getStretchWeightsForSubviews:subviews
                          subviewCount:subviewCount
                        stretchWeights:&(stretchWeights[0])
                    totalStretchWeight:&totalStretchWeight
                          stretchCount:&stretchCount];

    CGSize guideSize = view.size;
    CGFloat spacing = ceilf(horizontal ? view.hSpacing : view.vSpacing);
    CGRect contentBounds = [self contentBoundsOfView:view
                                             forSize:guideSize];
    CGSize maxSubviewSize = contentBounds.size;
    if (horizontal)
    {
        maxSubviewSize.width = MAX(0, maxSubviewSize.width - spacing * (subviewCount - 1));
    }
    else
    {
        maxSubviewSize.height = MAX(0, maxSubviewSize.height - spacing * (subviewCount - 1));
    }

    if (debugLayout)
    {
        NSLog(@"minSizeOfContentsView: contentBounds: %@, guideSize: %@, insetSizeOfView: %@",
              FormatRect(contentBounds),
              FormatSize(guideSize),
              FormatSize([self insetSizeOfView:view]));
    }

    CGSize subviewSizes[subviewCount];
    for (int i=0; i < subviewCount; i++)
    {
        UIView* subview = subviews[i];

        subviewSizes[i] = [self desiredItemSize:subview
                                        maxSize:maxSubviewSize];
    }

    if (debugLayout)
    {
        NSLog(@"layoutContentsOfView (%@ %@) maxSubviewSize: %@, guideSize: %@, insetSizeOfView: %@",
              [view class], view.debugName,
              FormatSize(maxSubviewSize),
              FormatSize(view.size),
              FormatSize([self insetSizeOfView:view]));
    }

    IntSize contentSize = [self sumContentSize:&subviewSizes[0]
                                  subviewCount:subviewCount
                                    horizontal:horizontal];

    if (debugLayout)
    {
        [self dumpItemSizes:@"layoutContentsOfView: (ideal)"
                   subviews:subviews
               subviewSizes:subviewSizes
             stretchWeights:stretchWeights];
    }

    // Check to see if we need to crop our content.
    if (YES)
    {
        int extraAxisSpaceRaw;
        int axisSize;
        if (horizontal)
        {
            axisSize = contentSize.width;
            extraAxisSpaceRaw = maxSubviewSize.width - contentSize.width;
        }
        else
        {
            axisSize = contentSize.height;
            extraAxisSpaceRaw = maxSubviewSize.height - contentSize.height;
        }

        if (debugLayout)
        {
            NSLog(@"\t axisSize: %d, extraAxisSpaceRaw: %d, contentSize: %@, maxSubviewSize: %@",
                  axisSize,
                  extraAxisSpaceRaw,
                  FormatIntSize(contentSize),
                  FormatSize(maxSubviewSize)
                  );
        }

        if (extraAxisSpaceRaw < 0)
        {
            // Can't fit everything; we need to crop.
            int totalCropAmount = -extraAxisSpaceRaw;
            int remainingCropAmount = totalCropAmount;
            // We want to crop proportionally, so that we crop more
            // from larger subviews.
            CGFloat cropFactor = clamp01(remainingCropAmount / (CGFloat) axisSize);
            for (int i=0; i < subviewCount; i++)
            {
                int cropAmount;
                // round up the amount to crop.
                if (horizontal)
                {
                    cropAmount = ceilf(subviewSizes[i].width * cropFactor);
                }
                else
                {
                    cropAmount = ceilf(subviewSizes[i].height * cropFactor);
                }
                // Don't crop more than enough to exactly fit non-stretch subviews in panel.
                cropAmount = MIN(remainingCropAmount, cropAmount);
                remainingCropAmount -= cropAmount;
                if (horizontal)
                {
                    subviewSizes[i].width -= cropAmount;

                    // For "wrapping" subviews, reducing the width can increase
                    // the height.
                    UIView* subview = subviews[i];
                    subviewSizes[i].height = [subview sizeThatFits:CGSizeMake(subviewSizes[i].width,
                                                                              maxSubviewSize.height)].height;
                }
                else
                {
                    subviewSizes[i].height -= cropAmount;
                }
            }

            // Update content size
            contentSize = [self sumContentSize:&subviewSizes[0]
                                  subviewCount:subviewCount
                                    horizontal:horizontal];

            if (debugLayout)
            {
                [self dumpItemSizes:@"layoutContentsOfView: (after crop)"
                           subviews:subviews
                       subviewSizes:subviewSizes
                     stretchWeights:stretchWeights];
            }
        }
    }

    // If layer stretches, we want to do a second pass that calculates the
    // size of stretching subviews.
    if (YES)
    {
        int stretchCountRemainder = stretchCount;
        int stretchTotal;
        if (horizontal)
        {
            stretchTotal = maxSubviewSize.width - contentSize.width;
        }
        else
        {
            stretchTotal = maxSubviewSize.height - contentSize.height;
        }
        int stretchRemainder = stretchTotal;

        if (debugLayout)
        {
            NSLog(@"contentSize.width: %d, contentSize.height: %d, stretchCountRemainder: %d, stretchTotal: %d, stretchRemainder: %d, totalStretchWeight: %f",
                  contentSize.width,
                  contentSize.height,
                  stretchCountRemainder,
                  stretchTotal,
                  stretchRemainder,
                  totalStretchWeight);
        }

        if (stretchRemainder > 0 && stretchCountRemainder > 0)
        {
            // This is actually a series of passes.
            // With each "stretch" pass, we evenly divide the remainder of the available
            // space between the remaining stretch subviews based on their stretch weight.
            //
            // More than one pass is necessary, since subviews may have a maximum stretch
            // size.
            while (stretchRemainder > 0 && stretchCountRemainder > 0)
            {
                for (int i=0; i < subviewCount; i++)
                {
                    // ignore non-stretching subviews.
                    if (!(stretchWeights[i] > 0))
                    {
                        continue;
                    }

                    // Divide the remaining stretch space evenly between the stretching
                    // subviews in this layer.
                    int subviewStretch;
                    if (stretchCountRemainder == 1)
                    {
                        subviewStretch = stretchRemainder;
                    }
                    else
                    {
                        subviewStretch = floorf(stretchTotal * stretchWeights[i] / totalStretchWeight);
                    }
                    stretchCountRemainder--;
                    stretchRemainder -= subviewStretch;

                    CGSize subviewSize = subviewSizes[i];
                    if (horizontal)
                    {
                        subviewSize.width += subviewStretch;
                    }
                    else
                    {
                        subviewSize.height += subviewStretch;
                    }
                    subviewSizes[i] = subviewSize;
                }
            }

            // Update content size
            contentSize = [self sumContentSize:&subviewSizes[0]
                                  subviewCount:subviewCount
                                    horizontal:horizontal];

            if (debugLayout)
            {
                [self dumpItemSizes:@"layoutContentsOfView: (after stretch)"
                           subviews:subviews
                       subviewSizes:subviewSizes
                     stretchWeights:stretchWeights];

                NSLog(@"contentSize: %@",
                      FormatIntSize(contentSize));
            }
        }
    }

    int crossSize = horizontal ? maxSubviewSize.height : maxSubviewSize.width;
    int axisIndex = horizontal ? contentBounds.origin.x : contentBounds.origin.y;

    // Honor the axis alignment.
    if (horizontal)
    {
        int extraAxisSpace = maxSubviewSize.width - contentSize.width;
        switch (view.hAlign)
        {
            case H_ALIGN_LEFT:
                break;
            case H_ALIGN_CENTER:
                axisIndex += extraAxisSpace / 2;
                break;
            case H_ALIGN_RIGHT:
                axisIndex += extraAxisSpace;
                break;
            default:
                WeView2Assert(0);
                break;
        }
    }
    else
    {
        int extraAxisSpace = maxSubviewSize.height - contentSize.height;
        switch (view.vAlign)
        {
            case V_ALIGN_BOTTOM:
                axisIndex += extraAxisSpace;
                break;
            case V_ALIGN_CENTER:
                axisIndex += extraAxisSpace / 2;
                break;
            case V_ALIGN_TOP:
                break;
            default:
                WeView2Assert(0);
                break;
        }
    }

    // Calculate and apply the subviews' frames.
    for (int i=0; i < subviewCount; i++)
    {
        UIView* subview = subviews[i];
        CGSize subviewSize = subviewSizes[i];

        int crossIndex = horizontal ? contentBounds.origin.y : contentBounds.origin.x;
        CGRect cellBounds = CGRectMake(horizontal ? axisIndex : crossIndex,
                                       horizontal ? crossIndex : axisIndex,
                                       horizontal ? subviewSize.width : crossSize,
                                       horizontal ? crossSize : subviewSize.height);

        [self positionSubview:subview
                  inSuperview:view
                     withSize:subviewSize
                 inCellBounds:cellBounds];

        if (debugLayout)
        {
            NSLog(@"layoutContentsOfView (%@ %@) final subview(%@): %@, raw subviewSize: %@",
                  [view class], view.debugName,
                  [subview class], FormatRect(subview.frame), FormatCGSize(subviewSize));
        }

        axisIndex = (horizontal ? subview.right : subview.bottom) + spacing;
    }
}

@end
