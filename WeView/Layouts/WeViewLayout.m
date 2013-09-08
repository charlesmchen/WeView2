//
//  WeViewLayout.m
//  Unknown Project
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

@interface WeViewLayout ()
{
/* CODEGEN MARKER: Members Start */

NSNumber *_leftMargin;
NSNumber *_rightMargin;
NSNumber *_topMargin;
NSNumber *_bottomMargin;

NSNumber *_vSpacing;
NSNumber *_hSpacing;

NSNumber *_contentHAlign;
NSNumber *_contentVAlign;

NSNumber *_cropSubviewOverflow;
NSNumber *_cellPositioning;

NSNumber *_debugLayout;
NSNumber *_debugMinSize;

/* CODEGEN MARKER: Members End */
}

@end

#pragma mark -

@implementation WeViewLayout

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

#pragma mark - Per-Layout Properties

/* CODEGEN MARKER: Accessors Start */

- (CGFloat)leftMargin:(UIView *)view
{
    if (_leftMargin)
    {
        return [_leftMargin floatValue];
    }
    return [view leftMargin];
}

- (WeViewLayout *)setLeftMargin:(CGFloat)value
{
    _leftMargin = @(value);
    return self;
}

- (CGFloat)rightMargin:(UIView *)view
{
    if (_rightMargin)
    {
        return [_rightMargin floatValue];
    }
    return [view rightMargin];
}

- (WeViewLayout *)setRightMargin:(CGFloat)value
{
    _rightMargin = @(value);
    return self;
}

- (CGFloat)topMargin:(UIView *)view
{
    if (_topMargin)
    {
        return [_topMargin floatValue];
    }
    return [view topMargin];
}

- (WeViewLayout *)setTopMargin:(CGFloat)value
{
    _topMargin = @(value);
    return self;
}

- (CGFloat)bottomMargin:(UIView *)view
{
    if (_bottomMargin)
    {
        return [_bottomMargin floatValue];
    }
    return [view bottomMargin];
}

- (WeViewLayout *)setBottomMargin:(CGFloat)value
{
    _bottomMargin = @(value);
    return self;
}

- (CGFloat)vSpacing:(UIView *)view
{
    if (_vSpacing)
    {
        return [_vSpacing floatValue];
    }
    return [view vSpacing];
}

- (WeViewLayout *)setVSpacing:(CGFloat)value
{
    _vSpacing = @(value);
    return self;
}

- (CGFloat)hSpacing:(UIView *)view
{
    if (_hSpacing)
    {
        return [_hSpacing floatValue];
    }
    return [view hSpacing];
}

- (WeViewLayout *)setHSpacing:(CGFloat)value
{
    _hSpacing = @(value);
    return self;
}

- (HAlign)contentHAlign:(UIView *)view
{
    if (_contentHAlign)
    {
        return [_contentHAlign intValue];
    }
    return [view contentHAlign];
}

- (WeViewLayout *)setContentHAlign:(HAlign)value
{
    _contentHAlign = @(value);
    return self;
}

- (VAlign)contentVAlign:(UIView *)view
{
    if (_contentVAlign)
    {
        return [_contentVAlign intValue];
    }
    return [view contentVAlign];
}

- (WeViewLayout *)setContentVAlign:(VAlign)value
{
    _contentVAlign = @(value);
    return self;
}

- (BOOL)cropSubviewOverflow:(UIView *)view
{
    if (_cropSubviewOverflow)
    {
        return [_cropSubviewOverflow boolValue];
    }
    return [view cropSubviewOverflow];
}

- (WeViewLayout *)setCropSubviewOverflow:(BOOL)value
{
    _cropSubviewOverflow = @(value);
    return self;
}

- (CellPositioningMode)cellPositioning:(UIView *)view
{
    if (_cellPositioning)
    {
        return [_cellPositioning intValue];
    }
    return [view cellPositioning];
}

- (WeViewLayout *)setCellPositioning:(CellPositioningMode)value
{
    _cellPositioning = @(value);
    return self;
}

- (BOOL)debugLayout:(UIView *)view
{
    if (_debugLayout)
    {
        return [_debugLayout boolValue];
    }
    return [view debugLayout];
}

- (WeViewLayout *)setDebugLayout:(BOOL)value
{
    _debugLayout = @(value);
    return self;
}

- (BOOL)debugMinSize:(UIView *)view
{
    if (_debugMinSize)
    {
        return [_debugMinSize boolValue];
    }
    return [view debugMinSize];
}

- (WeViewLayout *)setDebugMinSize:(BOOL)value
{
    _debugMinSize = @(value);
    return self;
}

- (WeViewLayout *)setHMargin:(CGFloat)value
{
    [self setLeftMargin:value];
    [self setRightMargin:value];
    return self;
}

- (WeViewLayout *)setVMargin:(CGFloat)value
{
    [self setTopMargin:value];
    [self setBottomMargin:value];
    return self;
}

- (WeViewLayout *)setMargin:(CGFloat)value
{
    [self setLeftMargin:value];
    [self setRightMargin:value];
    [self setTopMargin:value];
    [self setBottomMargin:value];
    return self;
}

- (WeViewLayout *)setSpacing:(CGFloat)value
{
    [self setHSpacing:value];
    [self setVSpacing:value];
    return self;
}

/* CODEGEN MARKER: Accessors End */

#pragma mark - Utility Methods

- (HAlign)subviewCellHAlign:(UIView *)superview
                    subview:(UIView *)subview
{
    if (subview.hasCellHAlign)
    {
        return subview.cellHAlign;
    }
    return superview.contentHAlign;
}

- (VAlign)subviewCellVAlign:(UIView *)view
                    subview:(UIView *)subview
{
    if (subview.hasCellVAlign)
    {
        return subview.cellVAlign;
    }
    return view.contentVAlign;
}

- (void)positionSubview:(UIView *)subview
            inSuperview:(UIView *)superview
               withSize:(CGSize)subviewSize
           inCellBounds:(CGRect)cellBounds
        cellPositioning:(CellPositioningMode)cellPositioning
{
    switch (cellPositioning)
    {
        case CELL_POSITION_NORMAL:
        {
            if (subview.hStretchWeight > 0)
            {
                subviewSize.width = cellBounds.size.width;
            }
            if (subview.vStretchWeight > 0)
            {
                subviewSize.height = cellBounds.size.height;
            }

            subviewSize = CGSizeMax(CGSizeZero, CGSizeFloor(subviewSize));
            subview.frame = alignSizeWithinRect(subviewSize,
                                                cellBounds,
                                                [self subviewCellHAlign:superview
                                                                subview:subview],
                                                [self subviewCellVAlign:superview
                                                                subview:subview]);
            break;
        }
        case CELL_POSITION_FILL:
        {
            CGRect subviewFrame = cellBounds;
            subviewFrame.origin = CGPointRound(subviewFrame.origin);
            subviewFrame.size = CGSizeMax(CGSizeZero, CGSizeFloor(subviewFrame.size));
            subview.frame = subviewFrame;
            break;
        }
        case CELL_POSITION_FILL_W_ASPECT_RATIO:
        case CELL_POSITION_FIT_W_ASPECT_RATIO:
        {
            CGSize desiredSize = [subview sizeThatFits:CGSizeZero];
            BOOL isValid = (desiredSize.width > 0 &&
                            desiredSize.height > 0 &&
                            cellBounds.size.width > 0 &&
                            cellBounds.size.height > 0);
            if (!isValid)
            {
                subview.frame = cellBounds;
            }
            else
            {
                if (cellPositioning == CELL_POSITION_FILL_W_ASPECT_RATIO)
                {
                    subview.frame = FillRectWithSize(cellBounds, desiredSize);
                }
                else
                {
                    subviewSize = FitSizeInRect(cellBounds, desiredSize).size;
                    subviewSize = CGSizeMax(CGSizeZero, CGSizeFloor(subviewSize));
                    subview.frame = alignSizeWithinRect(subviewSize,
                                                        cellBounds,
                                                        [self subviewCellHAlign:superview
                                                                        subview:subview],
                                                        [self subviewCellVAlign:superview
                                                                        subview:subview]);
                }
            }
        }
        default:
            break;
    }
}

- (CGRect)contentBoundsOfView:(UIView *)view
                      forSize:(CGSize)size
{
    CGFloat borderWidth = view.layer.borderWidth;

    int left = ceilf([self leftMargin:view] + borderWidth);
    int top = ceilf([self topMargin:view] + borderWidth);
    int right = floorf(size.width - ceilf([self rightMargin:view] + borderWidth));
    int bottom = floorf(size.height - ceilf([self bottomMargin:view] + borderWidth));

    return CGRectMake(left,
                      top,
                      MAX(0, right - left),
                      MAX(0, bottom - top));
}

- (CGSize)insetSizeOfView:(UIView *)view
{
    CGFloat borderWidth = view.layer.borderWidth;

    int left = ceilf([self leftMargin:view] + borderWidth);
    int top = ceilf([self topMargin:view] + borderWidth);
    int right = ceilf([self rightMargin:view] + borderWidth);
    int bottom = ceilf([self bottomMargin:view] + borderWidth);

    return CGSizeMake(left + right, top + bottom);
}

- (CGSize)desiredItemSize:(UIView *)subview
                  maxSize:(CGSize)maxSize
{
    if (subview.ignoreDesiredSize)
    {
        return CGSizeZero;
    }

    CGSize desiredSize = CGSizeAdd([subview sizeThatFits:maxSize],
                                   [subview desiredSizeAdjustment]);

    return CGSizeCeil(CGSizeMax(CGSizeMax(CGSizeZero,
                                          subview.minSize),
                                CGSizeMin(subview.maxSize,
                                          desiredSize)));
}

- (NSArray *)distributeSpace:(CGFloat)space
      acrossCellsWithWeights:(NSArray *)cellWeights
{
    // Weighted distribution of space between cells.

    WeViewAssert([cellWeights count] > 0);

    CGFloat totalCellWeight = 0.f;
    int cellCountWithWeight = 0;
    for (int i=0; i < [cellWeights count]; i++)
    {
        CGFloat cellWeight = MAX(0.f, [cellWeights[i] floatValue]);
        if (cellWeight > 0)
        {
            totalCellWeight += cellWeight;
            cellCountWithWeight++;
        }
    }

    WeViewAssert(cellCountWithWeight > 0);

    CGFloat spaceRemainder = space;
    int cellRemainder = cellCountWithWeight;
    CGFloat weightRemainder = totalCellWeight;

    NSMutableArray *result = [NSMutableArray array];
    for (int i=0; i < [cellWeights count]; i++)
    {
        CGFloat cellWeight = MAX(0.f, [cellWeights[i] floatValue]);
        int cellDistribution = 0;

        if (cellWeight > 0 && cellRemainder > 0)
        {
            if (cellRemainder == 1)
            {
                // Ensure that the total space distributed is exactly
                cellDistribution = spaceRemainder;
            }
            else
            {
                cellDistribution = floorf(spaceRemainder * cellWeight / weightRemainder);
            }

            cellRemainder--;
            spaceRemainder -= cellDistribution;
            weightRemainder -= cellWeight;
            WeViewAssert(spaceRemainder >= 0);
        }
        [result addObject:@(cellDistribution)];
    }

    return result;
}

- (void)distributeAdjustment:(CGFloat)totalAdjustment
                acrossValues:(NSMutableArray *)values
                 withWeights:(NSArray *)weights
                    withSign:(CGFloat)sign
                 withMaxZero:(BOOL)withMaxZero
{
    WeViewAssert([values count] == [weights count]);
    NSArray *adjustments = [self distributeSpace:roundf(totalAdjustment)
                          acrossCellsWithWeights:weights];
    WeViewAssert([values count] == [adjustments count]);
    int count = [values count];
    for (int i=0; i < count; i++)
    {
        CGFloat newValue = roundf([values[i] floatValue] + [adjustments[i] floatValue] * sign);
        if (withMaxZero)
        {
            newValue = MAX(0.f, newValue);
        }
        values[i] = @(newValue);
    }
}

#pragma mark - Debug Methods

- (NSString *)indentPrefix:(int)indent
{
    NSMutableString *result = [NSMutableString string];
    for (int i=0; i < indent; i++)
    {
        [result appendString:@"  "];
    }
    return result;
}

- (int)viewHierarchyDistanceToWindow:(UIView *)view
{
    UIResponder *responder = view;
    int result = 0;
    while (YES)
    {
        if (!responder ||
            [responder isKindOfClass:[UIWindow class]])
        {
            return result;
        }
        responder = [responder nextResponder];
        result += 2;
    }
}

@end
