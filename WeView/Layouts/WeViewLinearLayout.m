//
//  WeViewLinearLayout.m
//  WeView 2
//
//  Copyright (c) 2013 Charles Matthew Chen. All rights reserved.
//
//  Distributed under the Apache License v2.0.
//  http://www.apache.org/licenses/LICENSE-2.0.html
//

#import <QuartzCore/QuartzCore.h>

#import "UIView+WeView.h"
#import "WeViewLinearLayout.h"
#import "WeViewMacros.h"

@interface WeViewLinearLayout ()

@property (nonatomic) BOOL isHorizontal;

@end

#pragma mark -

@implementation WeViewLinearLayout

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

+ (WeViewLinearLayout *)horizontalLayout
{
    WeViewLinearLayout *layout = [[WeViewLinearLayout alloc] init];
    layout.isHorizontal = YES;
    return layout;
}

+ (WeViewLinearLayout *)verticalLayout
{
    WeViewLinearLayout *layout = [[WeViewLinearLayout alloc] init];
    layout.isHorizontal = NO;
    return layout;
}

- (CGFloat)sumFloats:(NSArray *)values
{
    CGFloat result = 0;
    for (NSNumber *value in values)
    {
        result += [value floatValue];
    }
    return result;
}

- (int)sumInts:(NSArray *)values
{
    CGFloat result = 0;
    for (NSNumber *value in values)
    {
        result += [value intValue];
    }
    return result;
}

- (CGFloat)maxFloats:(NSArray *)values
{
    CGFloat result = 0;
    for (NSNumber *value in values)
    {
        result = MAX(result, [value floatValue]);
    }
    return result;
}

- (NSArray *)getSpacings:(NSArray *)subviews
              horizontal:(BOOL)horizontal
{
    // Determine the spacing.
    int baseSpacing = MAX(0, ceilf(horizontal ? [self hSpacing] : [self vSpacing]));
    int totalSpacing = baseSpacing;
    NSMutableArray *spacings = [NSMutableArray array];
    {
        UIView* lastSubview = nil;
        for (UIView* subview in subviews)
        {
            if (lastSubview)
            {
                int spacing = roundf(baseSpacing +
                                     lastSubview.nextSpacingAdjustment +
                                     subview.previousSpacingAdjustment);
                totalSpacing += spacing;
                [spacings addObject:@(spacing)];
            }
            lastSubview = subview;
        }
    }
    return spacings;
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

    BOOL horizontal = self.isHorizontal;
    int subviewCount = [subviews count];

    NSArray *spacings = [self getSpacings:subviews
                               horizontal:horizontal];
    int totalSpacing = [self sumInts:spacings];

    CGRect contentBounds = [self contentBoundsOfView:view
                                             forSize:guideSize];
    CGSize totalSpacingSize = CGSizeMake(horizontal ? totalSpacing : 0.f,
                                         horizontal ? 0.f : totalSpacing);
    CGSize maxTotalSubviewsSize = CGSizeSubtract(contentBounds.size,
                                                 totalSpacingSize);

    if (debugMinSize)
    {
        NSLog(@"%@ contentBounds: %@, guideSize: %@, insetSizeOfView: %@",
              [self indentPrefix:indent + 1],
              FormatCGRect(contentBounds),
              FormatCGSize(guideSize),
              FormatCGSize([self insetSizeOfView:view]));
    }

    NSMutableArray *cellAxisSizes = [NSMutableArray array];
    NSMutableArray *cellCrossSizes = [NSMutableArray array];
    NSMutableArray *cellStretchWeights = [NSMutableArray array];
    BOOL hasCellWithStretch = NO;
    for (int i=0; i < subviewCount; i++)
    {
        UIView* subview = subviews[i];
        CGSize subviewSize = [self desiredItemSize:subview
                                           maxSize:maxTotalSubviewsSize];
        [cellAxisSizes addObject:@(horizontal
         ? subviewSize.width
                                : subviewSize.height)];
        [cellCrossSizes addObject:@(horizontal
         ? subviewSize.height
                                : subviewSize.width)];

        CGFloat cellStretchWeight = MAX(0, (horizontal
                                            ? subview.hStretchWeight
                                            : subview.vStretchWeight));
        [cellStretchWeights addObject:@(cellStretchWeight)];
        hasCellWithStretch |= cellStretchWeight > 0.f;
    }

    CGFloat maxCrossSize = horizontal ? maxTotalSubviewsSize.height : maxTotalSubviewsSize.width;
    CGFloat rawTotalAxisSize = [self sumFloats:cellAxisSizes];
    CGFloat maxTotalAxisSize = horizontal ? maxTotalSubviewsSize.width : maxTotalSubviewsSize.height;

    CGFloat extraAxisSpace = maxTotalAxisSize - rawTotalAxisSize;
    // TODO: Use hasNonEmptyGuideSize in other layouts as well.
    BOOL hasNonEmptyGuideSize = guideSize.width * guideSize.height > 0;
    if (extraAxisSpace < 0)
    {
        // TODO: crop from subviews with axis stretch first.  Then crop other subviews only if
        // necessary.
        BOOL cropSubviewOverflow = [self cropSubviewOverflow];
        if (cropSubviewOverflow && hasNonEmptyGuideSize)
        {
            [self distributeAdjustment:-extraAxisSpace
                          acrossValues:cellAxisSizes
                           withWeights:cellAxisSizes
                              withSign:-1.f
                           withMaxZero:YES];

            for (int i=0; i < subviewCount; i++)
            {
                UIView* subview = subviews[i];
                CGSize maxCellSize = CGSizeMake(horizontal ? [cellAxisSizes[i] floatValue] : maxCrossSize,
                                                horizontal ? maxCrossSize : [cellAxisSizes[i] floatValue]);
                CGSize subviewSize = [self desiredItemSize:subview
                                                   maxSize:maxCellSize];
                subviewSize = CGSizeMax(CGSizeZero,
                                        CGSizeCeil(subviewSize));
                cellAxisSizes[i] = @(horizontal ? subviewSize.width : subviewSize.height);
                cellCrossSizes[i] = @(horizontal ? subviewSize.height : subviewSize.width);
            }
        }
    }
    else if (extraAxisSpace > 0)
    {
        if (hasCellWithStretch && hasNonEmptyGuideSize && horizontal)
        {
            [self distributeAdjustment:extraAxisSpace
                          acrossValues:cellAxisSizes
                           withWeights:cellStretchWeights
                              withSign:+1.f
                           withMaxZero:YES];

            for (int i=0; i < subviewCount; i++)
            {
                UIView* subview = subviews[i];
                CGSize maxCellSize = CGSizeMake(horizontal ? [cellAxisSizes[i] floatValue] : maxCrossSize,
                                                horizontal ? maxCrossSize : [cellAxisSizes[i] floatValue]);
                CGSize subviewSize = [self desiredItemSize:subview
                                                   maxSize:maxCellSize];
                subviewSize = CGSizeMax(CGSizeZero,
                                        CGSizeCeil(subviewSize));
                cellAxisSizes[i] = @(horizontal ? subviewSize.width : subviewSize.height);
                cellCrossSizes[i] = @(horizontal ? subviewSize.height : subviewSize.width);
            }
        }
    }

    CGFloat largestCrossSize = [self maxFloats:cellCrossSizes];
    CGFloat totalAxisSize = [self sumFloats:cellAxisSizes];

    CGSize totalCellSize = CGSizeMake(horizontal ? totalAxisSize : largestCrossSize,
                                      horizontal ? largestCrossSize : totalAxisSize);
    CGSize result = CGSizeAdd([self insetSizeOfView:view],
                              CGSizeAdd(totalSpacingSize,
                                        totalCellSize));

    // TODO: Test that all layouts can handle only small subviews, ie. width: 0.0001f, height: 0.0001f.

    if (debugMinSize)
    {
        NSLog(@"%@ result: %@",
              [self indentPrefix:indent + 1],
              NSStringFromCGSize(result));
    }

    return result;
}

- (void)dumpItemSizes:(NSString *)label
             subviews:(NSArray *)subviews
         subviewSizes:(CGSize *)subviewSizes
       stretchWeights:(CGFloat *)stretchWeights
               indent:(int)indent
{
    for (int i=0; i < [subviews count]; i++)
    {
        UIView* subview = subviews[i];

        NSLog(@"%@ %@[%d] %@ size: %@, stretchWeight: %0.1f",
              [self indentPrefix:indent],
              label,
              i,
              [subview class],
              FormatCGSize(subviewSizes[i]),
              stretchWeights[i]);
    }
}

- (void)hAlignIndex:(CGFloat *)index
         extraSpace:(CGFloat)extraSpace
               view:(UIView *)view
{
    switch ([self hAlign])
    {
        case H_ALIGN_LEFT:
            break;
        case H_ALIGN_CENTER:
            *index = *index + roundf(extraSpace / 2);
            break;
        case H_ALIGN_RIGHT:
            *index = *index + extraSpace;
            break;
        default:
            WeViewAssert(0);
            break;
    }
}

- (void)vAlignIndex:(CGFloat *)index
         extraSpace:(CGFloat)extraSpace
               view:(UIView *)view
{
    switch ([self vAlign])
    {
        case V_ALIGN_TOP:
            break;
        case V_ALIGN_CENTER:
            *index = *index + roundf(extraSpace / 2);
            break;
        case V_ALIGN_BOTTOM:
            *index = *index + extraSpace;
            break;
        default:
            WeViewAssert(0);
            break;
    }
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

    BOOL horizontal = self.isHorizontal;
    int subviewCount = [subviews count];

    NSArray *spacings = [self getSpacings:subviews
                               horizontal:horizontal];
    int totalSpacing = [self sumInts:spacings];

    CGRect contentBounds = [self contentBoundsOfView:view
                                             forSize:guideSize];
    CGSize totalSpacingSize = CGSizeMake(horizontal ? totalSpacing : 0.f,
                                         horizontal ? 0.f : totalSpacing);
    CGSize maxTotalSubviewsSize = CGSizeSubtract(contentBounds.size,
                                                 totalSpacingSize);

    if (debugLayout)
    {
        NSLog(@"%@ contentBounds: %@, guideSize: %@, insetSizeOfView: %@",
              [self indentPrefix:indent + 1],
              FormatCGRect(contentBounds),
              FormatCGSize(guideSize),
              FormatCGSize([self insetSizeOfView:view]));
    }

    NSMutableArray *cellAxisSizes = [NSMutableArray array];
    NSMutableArray *cellCrossSizes = [NSMutableArray array];
    NSMutableArray *cellStretchWeights = [NSMutableArray array];
    BOOL hasCellWithAxisStretch = NO;
    BOOL hasCellWithCrossStretch = NO;
    for (int i=0; i < subviewCount; i++)
    {
        UIView* subview = subviews[i];
        CGSize subviewSize = [self desiredItemSize:subview
                                           maxSize:maxTotalSubviewsSize];

        if (debugLayout)
        {
            NSLog(@"%@ subviewSize[%d]: %@",
                  [self indentPrefix:indent + 1],
                  i,
                  FormatCGSize(subviewSize));
        }

        [cellAxisSizes addObject:@(horizontal
         ? subviewSize.width
                                : subviewSize.height)];
        [cellCrossSizes addObject:@(horizontal
         ? subviewSize.height
                                 : subviewSize.width)];

        CGFloat cellAxisStretchWeight = MAX(0, (horizontal
                                                ? subview.hStretchWeight
                                                : subview.vStretchWeight));
        CGFloat cellCrossStretchWeight = MAX(0, (horizontal
                                                 ? subview.vStretchWeight
                                                 : subview.hStretchWeight));
        [cellStretchWeights addObject:@(cellAxisStretchWeight)];
        hasCellWithAxisStretch |= cellAxisStretchWeight > 0.f;
        hasCellWithCrossStretch |= cellCrossStretchWeight > 0.f;
    }

    CGFloat maxCrossSize = horizontal ? maxTotalSubviewsSize.height : maxTotalSubviewsSize.width;
    CGFloat rawTotalAxisSize = [self sumFloats:cellAxisSizes];
    CGFloat maxTotalAxisSize = horizontal ? maxTotalSubviewsSize.width : maxTotalSubviewsSize.height;

    if (debugLayout)
    {
        NSLog(@"%@ maxTotalSubviewsSize: %@, maxCrossSize: %f, rawTotalAxisSize: %f, maxTotalAxisSize: %f, ",
              [self indentPrefix:indent + 1],
              FormatCGSize(maxTotalSubviewsSize),
              maxCrossSize,
              rawTotalAxisSize,
              maxTotalAxisSize);

        NSLog(@"%@ cellAxisSizes: %@",
              [self indentPrefix:indent + 1],
              cellAxisSizes);
        NSLog(@"%@ cellCrossSizes: %@",
              [self indentPrefix:indent + 1],
              cellCrossSizes);
        NSLog(@"%@ cellStretchWeights: %@",
              [self indentPrefix:indent + 1],
              cellStretchWeights);
    }

    if (YES)
    {
        // Crop or Stretch if necessary.

        BOOL cropSubviewOverflow = [self cropSubviewOverflow];
        CGFloat extraAxisSpace = maxTotalAxisSize - rawTotalAxisSize;
        BOOL hasNonEmptyGuideSize = guideSize.width * guideSize.height > 0;
        if (extraAxisSpace < 0)
        {
            if (cropSubviewOverflow && hasNonEmptyGuideSize)
            {
                [self distributeAdjustment:-extraAxisSpace
                              acrossValues:cellAxisSizes
                               withWeights:cellAxisSizes
                                  withSign:-1.f
                               withMaxZero:YES];

                for (int i=0; i < subviewCount; i++)
                {
                    UIView* subview = subviews[i];
                    CGSize maxCellSize = CGSizeMake(horizontal ? [cellAxisSizes[i] floatValue] : maxCrossSize,
                                                    horizontal ? maxCrossSize : [cellAxisSizes[i] floatValue]);
                    CGSize subviewSize = [self desiredItemSize:subview
                                                       maxSize:maxCellSize];
                    subviewSize = CGSizeMax(CGSizeZero,
                                            CGSizeMin(maxCellSize,
                                                      CGSizeCeil(subviewSize)));
                    cellCrossSizes[i] = @(horizontal ? subviewSize.height : subviewSize.width);
                }
            }
        }
        else if (extraAxisSpace > 0)
        {
            if (hasCellWithAxisStretch && hasNonEmptyGuideSize)
            {
                [self distributeAdjustment:extraAxisSpace
                              acrossValues:cellAxisSizes
                               withWeights:cellStretchWeights
                                  withSign:+1.f
                               withMaxZero:YES];

                for (int i=0; i < subviewCount; i++)
                {
                    UIView* subview = subviews[i];
                    CGSize maxCellSize = CGSizeMake(horizontal ? [cellAxisSizes[i] floatValue] : maxCrossSize,
                                                    horizontal ? maxCrossSize : [cellAxisSizes[i] floatValue]);
                    CGSize subviewSize = [self desiredItemSize:subview
                                                       maxSize:maxCellSize];
                    subviewSize = CGSizeMax(CGSizeZero,
                                            CGSizeCeil(subviewSize));

                    cellCrossSizes[i] = @(horizontal ? subviewSize.height : subviewSize.width);
                }
            }
        }

        if (cropSubviewOverflow)
        {
            for (int i=0; i < subviewCount; i++)
            {
                cellCrossSizes[i] = @(MIN([cellCrossSizes[i] floatValue], maxCrossSize));
            }
        }
    }

    for (int i=0; i < subviewCount; i++)
    {
        UIView* subview = subviews[i];
        BOOL hasCrossStretch = (horizontal
                                ? subview.vStretchWeight
                                : subview.hStretchWeight) > 0;
        if (hasCrossStretch)
        {
            cellCrossSizes[i] = @(maxCrossSize);
        }
    }

    if (debugLayout)
    {
        NSLog(@"%@ cellAxisSizes: %@",
              [self indentPrefix:indent + 1],
              cellAxisSizes);
        NSLog(@"%@ cellCrossSizes: %@",
              [self indentPrefix:indent + 1],
              cellCrossSizes);
        NSLog(@"%@ cellStretchWeights: %@",
              [self indentPrefix:indent + 1],
              cellStretchWeights);
    }

    CGFloat bodyCrossSize = [self maxFloats:cellCrossSizes];
    CGFloat totalAxisSize = [self sumFloats:cellAxisSizes];

    if (hasCellWithAxisStretch)
    {
        totalAxisSize = maxTotalAxisSize;
    }

    CGFloat axisIndex = horizontal ? contentBounds.origin.x : contentBounds.origin.y;
    CGFloat crossIndex = horizontal ? contentBounds.origin.y : contentBounds.origin.x;

    CGFloat extraAxisSpace = maxTotalAxisSize - totalAxisSize;
    CGFloat extraCrossSpace = maxCrossSize - bodyCrossSize;

    if (debugLayout)
    {
        NSLog(@"%@ bodyCrossSize: %f, totalAxisSize: %f, ",
              [self indentPrefix:indent + 1],
              bodyCrossSize,
              totalAxisSize);
        NSLog(@"%@ extraAxisSpace: %f, extraCrossSpace: %f, ",
              [self indentPrefix:indent + 1],
              extraAxisSpace,
              extraCrossSpace);
    }

    // Honor the axis alignment.
    if (horizontal)
    {
        [self hAlignIndex:&axisIndex
               extraSpace:extraAxisSpace
                     view:view];
        if (!hasCellWithCrossStretch)
        {
            [self vAlignIndex:&crossIndex
                   extraSpace:extraCrossSpace
                         view:view];
        }
    }
    else
    {
        [self vAlignIndex:&axisIndex
               extraSpace:extraAxisSpace
                     view:view];
        if (!hasCellWithCrossStretch)
        {
            [self hAlignIndex:&crossIndex
                   extraSpace:extraCrossSpace
                         view:view];
        }
    }

    if (debugLayout)
    {
        NSLog(@"%@ bodyCrossSize: %f, axisIndex: %f, crossIndex: %f",
              [self indentPrefix:indent + 1],
              bodyCrossSize,
              axisIndex,
              crossIndex);
    }

    // Calculate and apply the subviews' frames.
    CellPositioningMode cellPositioning = [self cellPositioning];
    for (int i=0; i < subviewCount; i++)
    {
        UIView* subview = subviews[i];

        CGRect cellBounds = CGRectMake(horizontal ? axisIndex : crossIndex,
                                       horizontal ? crossIndex : axisIndex,
                                       horizontal ? [cellAxisSizes[i] floatValue] : bodyCrossSize,
                                       horizontal ? bodyCrossSize : [cellAxisSizes[i] floatValue]);

        CGSize subviewSize = CGSizeMake(horizontal ? [cellAxisSizes[i] floatValue] : [cellCrossSizes[i] floatValue],
                                        horizontal ? [cellCrossSizes[i] floatValue] : [cellAxisSizes[i] floatValue]);

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

        axisIndex = (horizontal ? subview.right : subview.bottom);
        if (i < [spacings count])
        {
            NSNumber *spacing = spacings[i];
            axisIndex += [spacing intValue];
        }
    }
}

@end
