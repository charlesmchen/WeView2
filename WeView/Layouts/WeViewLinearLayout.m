//
//  WeViewLinearLayout.m
//  WeView v2
//
//  Copyright (c) 2014 Charles Matthew Chen. All rights reserved.
//
//  Distributed under the Apache License v2.0.
//  http://www.apache.org/licenses/LICENSE-2.0.html
//

#import <QuartzCore/QuartzCore.h>

#import "UIView+WeView.h"
#import "WeViewLayout+Subclass.h"
#import "WeViewLayoutUtils.h"
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

- (NSMutableArray *)getSpacings:(NSArray *)subviews
                     horizontal:(BOOL)horizontal
{
    // Determine the spacing.
    int baseSpacing = ceilf(horizontal ? [self hSpacing] : [self vSpacing]);
    int totalSpacing = baseSpacing;
    NSMutableArray *spacings = [NSMutableArray array];
    {
        UIView* lastSubview = nil;
        for (UIView* subview in subviews)
        {
            if (lastSubview)
            {
                int spacing = roundf(baseSpacing +
                                     (horizontal ? lastSubview.rightSpacingAdjustment : lastSubview.bottomSpacingAdjustment) +
                                     (horizontal ? subview.leftSpacingAdjustment : subview.topSpacingAdjustment));
                totalSpacing += spacing;
                [spacings addObject:@(spacing)];
            }
            lastSubview = subview;
        }
    }
    return spacings;
}

- (void)updateSizingOfSubviews:(NSArray *)subviews
                 cellAxisSizes:(NSMutableArray *)cellAxisSizes
                cellCrossSizes:(NSMutableArray *)cellCrossSizes
                    horizontal:(BOOL)horizontal
                  maxCrossSize:(CGFloat)maxCrossSize
{
    WeViewAssert([cellAxisSizes count] == [subviews count]);
    WeViewAssert([cellCrossSizes count] == [subviews count]);
    NSUInteger subviewCount = [subviews count];
    BOOL cropSubviewOverflow = [self cropSubviewOverflow];

    for (int i=0; i < subviewCount; i++)
    {
        UIView* subview = subviews[i];
        CGSize maxCellSize = CGSizeMake(horizontal ? [cellAxisSizes[i] floatValue] : maxCrossSize,
                                        horizontal ? maxCrossSize : [cellAxisSizes[i] floatValue]);
        CGSize subviewSize = [self desiredItemSize:subview
                                           maxSize:maxCellSize];
        subviewSize = CGSizeMax(CGSizeZero,
                                CGSizeCeil(subviewSize));
        if (cropSubviewOverflow)
        {
            subviewSize = CGSizeMin(maxCellSize, subviewSize);
        }

        // We only update the cross size.
        cellCrossSizes[i] = @(horizontal ? subviewSize.height : subviewSize.width);
    }
}

- (void)stretchOrCropContents:(NSArray *)subviews
                cellAxisSizes:(NSMutableArray *)cellAxisSizes
               cellCrossSizes:(NSMutableArray *)cellCrossSizes
           cellStretchWeights:(NSArray *)cellStretchWeights
                     spacings:(NSMutableArray *)spacings
                   horizontal:(BOOL)horizontal
       hasCellWithAxisStretch:(BOOL)hasCellWithAxisStretch
                contentBounds:(CGRect)contentBounds
                  isLayingOut:(BOOL)isLayingOut
{
    BOOL cropSubviewOverflow = [self cropSubviewOverflow] && isLayingOut;
    NSUInteger subviewCount = [subviews count];
    CGSize maxTotalSubviewsSize = [self maxTotalSubviewsSize:contentBounds.size
                                                    spacings:spacings
                                                  horizontal:horizontal];
    CGFloat maxCrossSize = horizontal ? maxTotalSubviewsSize.height : maxTotalSubviewsSize.width;
    CGFloat maxTotalAxisSize = horizontal ? maxTotalSubviewsSize.width : maxTotalSubviewsSize.height;
    CGFloat totalAxisSize = WeViewSumFloats(cellAxisSizes);
    CGFloat extraAxisSpace = maxTotalAxisSize - totalAxisSize;

    if (extraAxisSpace < 0 && cropSubviewOverflow)
    {
        // Crop from subviews with axis stretch first.
        if (hasCellWithAxisStretch)
        {
            [WeViewLayout distributeAdjustment:-extraAxisSpace
                                  acrossValues:cellAxisSizes
                                   withWeights:cellStretchWeights
                                      withSign:-1.f
                                   withMaxZero:YES];

            if (horizontal)
            {
                [self updateSizingOfSubviews:subviews
                               cellAxisSizes:cellAxisSizes
                              cellCrossSizes:cellCrossSizes
                                  horizontal:horizontal
                                maxCrossSize:maxCrossSize];
            }

            totalAxisSize = WeViewSumFloats(cellAxisSizes);
            extraAxisSpace = maxTotalAxisSize - totalAxisSize;
        }

        if (extraAxisSpace < 0)
        {
            // If we still have underflow, crop all subviews.
            [WeViewLayout distributeAdjustment:-extraAxisSpace
                                  acrossValues:cellAxisSizes
                                   withWeights:cellAxisSizes
                                      withSign:-1.f
                                   withMaxZero:YES];

            if (horizontal)
            {
                [self updateSizingOfSubviews:subviews
                               cellAxisSizes:cellAxisSizes
                              cellCrossSizes:cellCrossSizes
                                  horizontal:horizontal
                                maxCrossSize:maxCrossSize];
            }
        }
    }
    else if (extraAxisSpace > 0)
    {
        if (hasCellWithAxisStretch)
        {
            [WeViewLayout distributeAdjustment:extraAxisSpace
                                  acrossValues:cellAxisSizes
                                   withWeights:cellStretchWeights
                                      withSign:+1.f
                                   withMaxZero:YES];

            if (horizontal)
            {
                [self updateSizingOfSubviews:subviews
                               cellAxisSizes:cellAxisSizes
                              cellCrossSizes:cellCrossSizes
                                  horizontal:horizontal
                                maxCrossSize:maxCrossSize];
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

- (CGSize)maxTotalSubviewsSize:(CGSize)contentSize
                      spacings:(NSArray *)spacings
                    horizontal:(BOOL)horizontal
{
    int totalSpacing = WeViewSumInts(spacings);
    CGSize totalSpacingSize = CGSizeMake(horizontal ? totalSpacing : 0.f,
                                         horizontal ? 0.f : totalSpacing);
    return CGSizeSubtract(contentSize,
                          totalSpacingSize);
}

- (CGSize)minSizeOfContentsView:(UIView *)view
                       subviews:(NSArray *)subviews
                   thatFitsSize:(CGSize)guideSize
{
    if ([subviews count] < 1)
    {
        return [self insetSizeOfView:view];
    }

    guideSize = CGSizeMax(guideSize, CGSizeZero);
    BOOL hasNonEmptyGuideSize = (MAX(0, guideSize.width) * MAX(guideSize.height, 0)) > 0;
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
    NSUInteger subviewCount = [subviews count];

    NSMutableArray *spacings = [self getSpacings:subviews
                                      horizontal:horizontal];

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

    NSMutableArray *cellAxisSizes = [NSMutableArray array];
    NSMutableArray *cellCrossSizes = [NSMutableArray array];
    NSMutableArray *cellStretchWeights = [NSMutableArray array];
    BOOL hasCellWithAxisStretch = NO;
    BOOL hasCellWithCrossStretch = NO;
    {
        CGSize maxTotalSubviewsSize = [self maxTotalSubviewsSize:contentBounds.size
                                                        spacings:spacings
                                                      horizontal:horizontal];

        for (int i=0; i < subviewCount; i++)
        {
            UIView* subview = subviews[i];
            CGSize subviewSize = [self desiredItemSize:subview
                                               maxSize:hasNonEmptyGuideSize ? maxTotalSubviewsSize : CGSizeZero];
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
    }

    if (debugMinSize)
    {
        [self dumpItemSizes:@"subview desired sizes"
                   subviews:subviews
              cellAxisSizes:cellAxisSizes
             cellCrossSizes:cellCrossSizes
         cellStretchWeights:cellStretchWeights
                     indent:indent+2];
    }

    if (hasNonEmptyGuideSize)
    {
        [self stretchOrCropContents:subviews
                      cellAxisSizes:cellAxisSizes
                     cellCrossSizes:cellCrossSizes
                 cellStretchWeights:cellStretchWeights
                           spacings:spacings
                         horizontal:horizontal
             hasCellWithAxisStretch:hasCellWithAxisStretch
                      contentBounds:contentBounds
                        isLayingOut:NO];
    }

    if (debugMinSize)
    {
        [self dumpItemSizes:@"subview cropped/stretched sizes"
                   subviews:subviews
              cellAxisSizes:cellAxisSizes
             cellCrossSizes:cellCrossSizes
         cellStretchWeights:cellStretchWeights
                     indent:indent+2];
    }

    CGFloat largestCrossSize = WeViewMaxFloats(cellCrossSizes);
    CGFloat totalAxisSize = WeViewSumFloats(cellAxisSizes);
    int totalSpacing = WeViewSumInts(spacings);
    CGSize totalSpacingSize = CGSizeMake(horizontal ? totalSpacing : 0.f,
                                         horizontal ? 0.f : totalSpacing);

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
        cellAxisSizes:(NSMutableArray *)cellAxisSizes
       cellCrossSizes:(NSMutableArray *)cellCrossSizes
   cellStretchWeights:(NSArray *)cellStretchWeights
               indent:(int)indent
{
    for (int i=0; i < [subviews count]; i++)
    {
        UIView* subview = subviews[i];

        NSLog(@"%@ %@[%d] %@ axis: %f, cross: %f, stretchWeight: %0.1f",
              [self indentPrefix:indent],
              label,
              i,
              [subview class],
              [cellAxisSizes[i] floatValue],
              [cellCrossSizes[i] floatValue],
              [cellStretchWeights[i] floatValue]);
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
    guideSize = CGSizeMax(guideSize, CGSizeZero);
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
    NSUInteger subviewCount = [subviews count];

    NSMutableArray *spacings = [self getSpacings:subviews
                                      horizontal:horizontal];

    CGRect contentBounds = [self contentBoundsOfView:view
                                             forSize:guideSize];

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
    {
        CGSize maxTotalSubviewsSize = [self maxTotalSubviewsSize:contentBounds.size
                                                        spacings:spacings
                                                      horizontal:horizontal];
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

            CGFloat cellAxisStretchWeight = MAX(0, (horizontal
                                                    ? subview.hStretchWeight
                                                    : subview.vStretchWeight));
            CGFloat cellCrossStretchWeight = MAX(0, (horizontal
                                                     ? subview.vStretchWeight
                                                     : subview.hStretchWeight));
            [cellStretchWeights addObject:@(cellAxisStretchWeight)];
            hasCellWithAxisStretch |= cellAxisStretchWeight > 0.f;
            hasCellWithCrossStretch |= cellCrossStretchWeight > 0.f;

            if (debugLayout)
            {
                NSLog(@"%@ subviewSize[%d]: %@ = %@ axisStretchWeight: %f, crossStretchWeight: %f",
                      [self indentPrefix:indent + 1],
                      i,
                      [subview class],
                      FormatCGSize(subviewSize),
                      cellAxisStretchWeight,
                      cellCrossStretchWeight);
            }
        }

        if (debugLayout)
        {
            NSLog(@"%@ maxTotalSubviewsSize: %@",
                  [self indentPrefix:indent + 1],
                  FormatCGSize(maxTotalSubviewsSize));

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
    }

    [self stretchOrCropContents:subviews
                  cellAxisSizes:cellAxisSizes
                 cellCrossSizes:cellCrossSizes
             cellStretchWeights:cellStretchWeights
                       spacings:spacings
                     horizontal:horizontal
         hasCellWithAxisStretch:hasCellWithAxisStretch
                  contentBounds:contentBounds
                    isLayingOut:YES];

    CGSize maxTotalSubviewsSize = [self maxTotalSubviewsSize:contentBounds.size
                                                    spacings:spacings
                                                  horizontal:horizontal];
    CGFloat maxCrossSize = horizontal ? maxTotalSubviewsSize.height : maxTotalSubviewsSize.width;
    CGFloat maxTotalAxisSize = horizontal ? maxTotalSubviewsSize.width : maxTotalSubviewsSize.height;

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
        NSLog(@"%@ spacings: %@",
              [self indentPrefix:indent + 1],
              spacings);
    }

    CGFloat bodyCrossSize = WeViewMaxFloats(cellCrossSizes);
    CGFloat totalAxisSize = WeViewSumFloats(cellAxisSizes);

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
