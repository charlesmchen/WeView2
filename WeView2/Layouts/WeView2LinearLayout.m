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

+ (WeView2LinearLayout *)hLinearLayout
{
    WeView2LinearLayout *layout = [[WeView2LinearLayout alloc] init];
    layout.isHorizontal = YES;
    return layout;
}

+ (WeView2LinearLayout *)vLinearLayout
{
    WeView2LinearLayout *layout = [[WeView2LinearLayout alloc] init];
    layout.isHorizontal = NO;
    return layout;
}

- (CGSize)desiredItemSize:(UIView *)subview
                  maxSize:(CGSize)maxSize
{
    return [subview sizeThatFits:maxSize];
}

- (CGPoint)insetOriginOfView:(UIView *)view
{
    // TODO: We need to always round (up) the border width.
    // TODO: Should we round margins?  Where?
    int borderWidth = ceilf(view.layer.borderWidth);
    return CGPointMake(view.leftMargin + borderWidth,
                       view.topMargin + borderWidth);
}

- (CGSize)insetSizeOfView:(UIView *)view
{
    int borderWidth = ceilf(view.layer.borderWidth);
    return CGSizeMake(view.leftMargin + view.rightMargin + 2 * borderWidth,
                      view.topMargin + view.bottomMargin + 2 * borderWidth);
}

- (CGRect)contentBoundsOfView:(UIView *)view
                      forSize:(CGSize)size
{
    CGRect result;
    result.origin = [self insetOriginOfView:view];
    result.size = CGSizeMax(CGSizeZero, CGSizeSubtract(size, [self insetSizeOfView:view]));
    return result;
}

- (CGSize)emptySizeOfView:(UIView *)view
{
    // Calculate the maximum size of any given subview,
    // ie. the total size less margins and spacing.
    int subviewCount = [[view subviews] count];
    BOOL horizontal = self.isHorizontal;
    CGSize result = [self insetSizeOfView:view];
    CGFloat spacing = horizontal ? view.hSpacing : view.vSpacing;
    if (horizontal)
    {
        result.width += spacing * (subviewCount - 1);
    }
    else
    {
        result.height += spacing * (subviewCount - 1);
    }
    return result;
}

- (CGSize)getMaxContentSize:(CGSize)size
                       view:(UIView *)view
{
    // Calculate the maximum size of any given subview,
    // ie. the total size less margins and spacing.
    CGSize result = CGSizeSubtract(size, [self emptySizeOfView:view]);

    result = CGSizeMax(result, CGSizeZero);
    return result;
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

- (CGFloat)viewStretchWeight:(UIView *)view
{
    return (self.isHorizontal
            ? view.hStretchWeight
            : view.vStretchWeight);
}

- (BOOL)viewStretchesAlongCrossAxis:(UIView *)view
{
    return (!self.isHorizontal
            ? view.hStretchWeight
            : view.vStretchWeight) > 0;
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
        stretchWeights[i] = [self viewStretchWeight:subview];
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

- (void)getIdealSizesForSubviews:(NSArray *)subviews
                    subviewCount:(int)subviewCount
                  maxContentSize:(CGSize)maxContentSize
                    subviewSizes:(CGSize *)subviewSizes
{
    for (int i=0; i < subviewCount; i++)
    {
        UIView* subview = subviews[i];

        CGSize idealSize = CGSizeZero;

        if (!subview.ignoreNaturalSize)
        {
            // TODO: In our initial pass, should we be using a guide size of
            // CGFLOAT_MAX, CGFLOAT_MAX?
            idealSize = [self desiredItemSize:subview
                                      maxSize:maxContentSize];
        }

        CGSize subviewMinSize = subview.minSize;
        CGSize subviewMaxSize = subview.maxSize;
        WeView2Assert(subviewMinSize.width <= subviewMaxSize.width);
        WeView2Assert(subviewMinSize.height <= subviewMaxSize.height);

        subviewSizes[i] = CGSizeMax(subviewMinSize,
                                    CGSizeMin(subviewMaxSize, idealSize));
    }
}

// TODO: Honor max/min widths in the earlier phases, of "min size" and "layout" functions.
// TODO: Do we need to honor other params as well?
- (CGSize)minSizeOfContentsView:(UIView *)view
                   thatFitsSize:(CGSize)guideSize
{
    BOOL debugLayout = view.debugLayout;
    if (debugLayout)
    {
        NSLog(@"+ minSizeOfContentsView: %@ thatFitsSize: %@", [view class], NSStringFromCGSize(guideSize));
    }

    BOOL horizontal = self.isHorizontal;
    NSArray *subviews = view.subviews;
    int subviewCount = [view.subviews count];

    CGFloat totalStretchWeight;
    int stretchCount;
    CGFloat stretchWeights[subviewCount];
    [self getStretchWeightsForSubviews:subviews
                          subviewCount:subviewCount
                        stretchWeights:&(stretchWeights[0])
                    totalStretchWeight:&totalStretchWeight
                          stretchCount:&stretchCount];

    CGSize maxContentSize = [self getMaxContentSize:guideSize
                                               view:view];

    if (debugLayout)
    {
        NSLog(@"getMaxContentSize: maxContentSize: %@, guideSize: %@, insetSizeOfView: %@, emptySizeOfView: %@",
              FormatSize(maxContentSize),
              FormatSize(guideSize),
              FormatSize([self insetSizeOfView:view]),
              FormatSize([self emptySizeOfView:view]));
    }

    // On the first pass, we want to calculate the desired size of all subviews.
    CGSize subviewSizes[subviewCount];
    [self getIdealSizesForSubviews:subviews
                      subviewCount:subviewCount
                    maxContentSize:maxContentSize
                      subviewSizes:&(subviewSizes[0])];

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
        int extraAxisSpaceRaw = maxContentSize.width - contentSize.width;

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
                                                                          maxContentSize.height)].height;
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

    // If any subview of the view can stretch, we want to do another pass that takes advantage
    // of any free or unclaimed space.
    //
    // TODO: We probably need to rewrite this.
    if (stretchCount > 0)
    {
        WeView2Assert(totalStretchWeight > 0);

        int stretchCountRemainder = stretchCount;
        int stretchTotal;
        if (horizontal)
        {
            stretchTotal = maxContentSize.width - contentSize.width;
        }
        else
        {
            stretchTotal = maxContentSize.height - contentSize.height;
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

                CGSize maxStretchItemSize = maxContentSize;
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
                              [self emptySizeOfView:view]);
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
              //        NSLog(@"\t%@[%d] %@ size: %@, isSpacer: %@, stretchWeight: %f",
              label,
              i,
              [subview class],
              FormatSize(subviewSizes[i]),
              //              isSpacer[i] ? @"YES" : @"NO",
              stretchWeights[i]);
    }
}

- (void)layoutContentsOfView:(UIView *)view
{
    BOOL debugLayout = view.debugLayout;
    if (debugLayout)
    {
        NSLog(@"layoutContentsOfView: %@ (%@) %@",
              [view class], view.debugName, NSStringFromCGSize(view.size));
    }

    BOOL horizontal = self.isHorizontal;
    NSArray *subviews = view.subviews;
    int subviewCount = [view.subviews count];

    CGFloat totalStretchWeight;
    int stretchCount;
    CGFloat stretchWeights[subviewCount];
    [self getStretchWeightsForSubviews:subviews
                          subviewCount:subviewCount
                        stretchWeights:&(stretchWeights[0])
                    totalStretchWeight:&totalStretchWeight
                          stretchCount:&stretchCount];

    CGSize maxContentSize = [self getMaxContentSize:view.size
                                               view:view];

    if (debugLayout)
    {
        NSLog(@"layoutContentsOfView (%@ %@) getMaxContentSize: maxContentSize: %@, guideSize: %@, insetSizeOfView: %@, emptySizeOfView: %@",
              [view class], view.debugName,
              FormatSize(maxContentSize),
              FormatSize(view.size),
              FormatSize([self insetSizeOfView:view]),
              FormatSize([self emptySizeOfView:view]));
    }

    // On the first pass, we want to calculate the desired size of all subviews.
    CGSize subviewSizes[subviewCount];
    [self getIdealSizesForSubviews:subviews
                      subviewCount:subviewCount
                    maxContentSize:maxContentSize
                      subviewSizes:&(subviewSizes[0])];

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
            extraAxisSpaceRaw = maxContentSize.width - contentSize.width;
        }
        else
        {
            axisSize = contentSize.height;
            extraAxisSpaceRaw = maxContentSize.height - contentSize.height;
        }

        if (debugLayout)
        {
            NSLog(@"\t axisSize: %d, extraAxisSpaceRaw: %d, contentSize: %@, maxContentSize: %@",
                  axisSize,
                  extraAxisSpaceRaw,
                  FormatIntSize(contentSize),
                  FormatSize(maxContentSize)
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
                                                                              maxContentSize.height)].height;
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
            stretchTotal = maxContentSize.width - contentSize.width;
        }
        else
        {
            stretchTotal = maxContentSize.height - contentSize.height;
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
//                        subviewSize.height = maxContentSize.height;
                    }
                    else
                    {
//                        subviewSize.width = maxContentSize.width;
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
            }
        }
    }

    CGRect contentBounds = [self contentBoundsOfView:view
                                             forSize:view.size];

    int crossSize = horizontal ? contentBounds.size.height : contentBounds.size.width;
    int axisIndex = horizontal ? contentBounds.origin.x : contentBounds.origin.y;

    HAlign hAlign = view.hAlign;
    VAlign vAlign = view.vAlign;
    if (YES)
    {
        // Honor the axis alignment.
        if (horizontal)
        {
            int extraAxisSpace = maxContentSize.width - contentSize.width;
            switch (hAlign)
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
            int extraAxisSpace = maxContentSize.height - contentSize.height;
            switch (vAlign)
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
    }

    // Final pass
    // Calculate and apply the subviews' frames.
    CGFloat spacing = horizontal ? view.hSpacing : view.vSpacing;
    for (int i=0; i < subviewCount; i++)
    {
        UIView* subview = subviews[i];
        CGSize subviewSize = subviewSizes[i];

        int subviewCrossSize, subviewAxisSize;
        if (horizontal)
        {
            subviewAxisSize = subviewSize.width;
            subviewCrossSize = subviewSize.height;
        }
        else
        {
            subviewCrossSize = subviewSize.width;
            subviewAxisSize = subviewSize.height;
        }

        int crossIndex = horizontal ? contentBounds.origin.y : contentBounds.origin.x;

        if ([self viewStretchesAlongCrossAxis:subview])
        {
            subviewCrossSize = crossSize;
        }
        else
        {
            // Limit cross size to container cross size.
            subviewCrossSize = MIN(subviewCrossSize, crossSize);

            // Respect cross alignment.
            if (horizontal)
            {
                switch (vAlign)
                {
                    case V_ALIGN_BOTTOM:
                        crossIndex += crossSize - subviewCrossSize;
                        break;
                    case V_ALIGN_CENTER:
                        crossIndex += (crossSize - subviewCrossSize) / 2;
                        break;
                    case V_ALIGN_TOP:
                        break;
                    default:
                        WeView2Assert(0);
                        break;
                }
            }
            else
            {
                switch (hAlign)
                {
                    case H_ALIGN_LEFT:
                        break;
                    case H_ALIGN_CENTER:
                        crossIndex += (crossSize - subviewCrossSize) / 2;
                        break;
                    case H_ALIGN_RIGHT:
                        crossIndex += crossSize - subviewCrossSize;
                        break;
                    default:
                        WeView2Assert(0);
                        break;
                }
            }
        }

        CGRect subviewFrame;
        if (horizontal)
        {
            subviewFrame = CGRectMake(axisIndex,
                                      crossIndex,
                                      subviewAxisSize,
                                      subviewCrossSize);
        }
        else
        {
            subviewFrame = CGRectMake(crossIndex,
                                      axisIndex,
                                      subviewCrossSize,
                                      subviewAxisSize);
        }
        [self setSubviewFrame:subviewFrame
                      subview:subview];

        if (debugLayout)
        {
            NSLog(@"layoutContentsOfView (%@ %@) final subview(%@): %@, raw subviewSize: %@",
                  [view class], view.debugName,
                  [subview class], FormatRect(subview.frame), FormatCGSize(subviewSize));
        }

        axisIndex += subviewAxisSize + spacing;
    }
}

@end
