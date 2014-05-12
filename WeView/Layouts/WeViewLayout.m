//
//  WeViewLayout.m
//  WeView v2
//
//  Copyright (c) 2014 Charles Matthew Chen. All rights reserved.
//
//  Distributed under the Apache License v2.0.
//  http://www.apache.org/licenses/LICENSE-2.0.html
//

#import <QuartzCore/QuartzCore.h>

#import "UIView+WeView.h"
#import "WeView.h"
#import "WeViewLayout+Subclass.h"
#import "WeViewLayoutUtils.h"
#import "WeViewLinearLayout.h"
#import "WeViewMacros.h"

CG_INLINE CGRect CenterSizeOnRect(CGRect srcRect, CGSize srcSize)
{
    CGRect result = CGRectZero;
    result.size = srcSize;
    result.origin.x = roundf(srcRect.origin.x + (srcRect.size.width - result.size.width) * 0.5f);
    result.origin.y = roundf(srcRect.origin.y + (srcRect.size.height - result.size.height) * 0.5f);
    return result;
}

CG_INLINE CGRect FillRectWithSize(CGRect srcRect, CGSize srcSize)
{
    if (srcSize.width <= 0.f ||
        srcSize.height <= 0.f)
    {
        return srcRect;
    }

    CGFloat widthFactor = srcRect.size.width / srcSize.width;
    CGFloat heightFactor = srcRect.size.height / srcSize.height;
    CGFloat factor = MAX(widthFactor, heightFactor);
    CGSize resultSize;
    resultSize.width = roundf(srcSize.width * factor);
    resultSize.height = roundf(srcSize.height * factor);
    return CenterSizeOnRect(srcRect, resultSize);
}

CG_INLINE CGRect FitSizeInRect(CGRect srcRect, CGSize srcSize)
{
    if (srcSize.width <= 0.f ||
        srcSize.height <= 0.f)
    {
        return srcRect;
    }

    CGFloat widthFactor = srcRect.size.width / srcSize.width;
    CGFloat heightFactor = srcRect.size.height / srcSize.height;
    CGFloat factor = MIN(widthFactor, heightFactor);
    CGSize resultSize;
    resultSize.width = roundf(srcSize.width * factor);
    resultSize.height = roundf(srcSize.height * factor);
    return CenterSizeOnRect(srcRect, resultSize);
}

#pragma mark -

@interface WeViewLayout ()
{
/* CODEGEN MARKER: Members Start */

CGFloat _leftMargin;
CGFloat _rightMargin;
CGFloat _topMargin;
CGFloat _bottomMargin;

int _vSpacing;
int _hSpacing;

HAlign _hAlign;
VAlign _vAlign;

BOOL _cropSubviewOverflow;
CellPositioningMode _cellPositioning;

BOOL _debugLayout;
BOOL _debugMinSize;

/* CODEGEN MARKER: Members End */
}

@property (nonatomic, weak) WeView *_superview;

@end

#pragma mark -

@implementation WeViewLayout

- (id)init
{
    if (self = [super init])
    {
        [self resetAllProperties];
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

- (CGFloat)leftMargin
{
    return _leftMargin;
}

- (WeViewLayout *)setLeftMargin:(CGFloat)value
{
    _leftMargin = value;
    [self propertyChanged];
    return self;
}

- (CGFloat)rightMargin
{
    return _rightMargin;
}

- (WeViewLayout *)setRightMargin:(CGFloat)value
{
    _rightMargin = value;
    [self propertyChanged];
    return self;
}

- (CGFloat)topMargin
{
    return _topMargin;
}

- (WeViewLayout *)setTopMargin:(CGFloat)value
{
    _topMargin = value;
    [self propertyChanged];
    return self;
}

- (CGFloat)bottomMargin
{
    return _bottomMargin;
}

- (WeViewLayout *)setBottomMargin:(CGFloat)value
{
    _bottomMargin = value;
    [self propertyChanged];
    return self;
}

- (int)vSpacing
{
    return _vSpacing;
}

- (WeViewLayout *)setVSpacing:(int)value
{
    _vSpacing = value;
    [self propertyChanged];
    return self;
}

- (int)hSpacing
{
    return _hSpacing;
}

- (WeViewLayout *)setHSpacing:(int)value
{
    _hSpacing = value;
    [self propertyChanged];
    return self;
}

- (HAlign)hAlign
{
    return _hAlign;
}

- (WeViewLayout *)setHAlign:(HAlign)value
{
    _hAlign = value;
    [self propertyChanged];
    return self;
}

- (VAlign)vAlign
{
    return _vAlign;
}

- (WeViewLayout *)setVAlign:(VAlign)value
{
    _vAlign = value;
    [self propertyChanged];
    return self;
}

- (BOOL)cropSubviewOverflow
{
    return _cropSubviewOverflow;
}

- (WeViewLayout *)setCropSubviewOverflow:(BOOL)value
{
    _cropSubviewOverflow = value;
    [self propertyChanged];
    return self;
}

- (CellPositioningMode)cellPositioning
{
    return _cellPositioning;
}

- (WeViewLayout *)setCellPositioning:(CellPositioningMode)value
{
    _cellPositioning = value;
    [self propertyChanged];
    return self;
}

- (BOOL)debugLayout
{
    return _debugLayout;
}

- (WeViewLayout *)setDebugLayout:(BOOL)value
{
    _debugLayout = value;
    [self propertyChanged];
    return self;
}

- (BOOL)debugMinSize
{
    return _debugMinSize;
}

- (WeViewLayout *)setDebugMinSize:(BOOL)value
{
    _debugMinSize = value;
    [self propertyChanged];
    return self;
}

- (WeViewLayout *)setHMargin:(CGFloat)value
{
    [self setLeftMargin:value];
    [self setRightMargin:value];
    [self propertyChanged];
    return self;
}

- (WeViewLayout *)setVMargin:(CGFloat)value
{
    [self setTopMargin:value];
    [self setBottomMargin:value];
    [self propertyChanged];
    return self;
}

- (WeViewLayout *)setMargin:(CGFloat)value
{
    [self setLeftMargin:value];
    [self setRightMargin:value];
    [self setTopMargin:value];
    [self setBottomMargin:value];
    [self propertyChanged];
    return self;
}

- (WeViewLayout *)setSpacing:(int)value
{
    [self setHSpacing:value];
    [self setVSpacing:value];
    [self propertyChanged];
    return self;
}

/* CODEGEN MARKER: Accessors End */

- (void)propertyChanged
{
    [self._superview setNeedsLayout];
}

- (void)resetAllProperties
{
    /* CODEGEN MARKER: Reset Start */

    self.leftMargin = 0.f;
    self.rightMargin = 0.f;
    self.topMargin = 0.f;
    self.bottomMargin = 0.f;
    self.vSpacing = 0;
    self.hSpacing = 0;
    self.hAlign = H_ALIGN_CENTER;
    self.vAlign = V_ALIGN_CENTER;
    self.cropSubviewOverflow = NO;
    self.cellPositioning = CELL_POSITIONING_NORMAL;
    self.debugLayout = NO;
    self.debugMinSize = NO;

/* CODEGEN MARKER: Reset End */

    _cropSubviewOverflow = YES;
}

#pragma mark - Utility Methods

- (void)bindToSuperview:(WeView *)superview
{
    // Layouts should not be shared or re-used.
    WeViewAssert(superview);
    WeViewAssert(!self._superview);
    self._superview = superview;
}

- (WeView *)superview
{
    WeViewAssert(self._superview != nil);
    return self._superview;
}

- (HAlign)subviewCellHAlign:(UIView *)superview
                    subview:(UIView *)subview
{
    if (subview.hasCellHAlign)
    {
        return subview.cellHAlign;
    }
    return _hAlign;
}

- (VAlign)subviewCellVAlign:(UIView *)view
                    subview:(UIView *)subview
{
    if (subview.hasCellVAlign)
    {
        return subview.cellVAlign;
    }
    return _vAlign;
}

- (CGRect)alignSize:(CGSize)size
         withinRect:(CGRect)rect
             hAlign:(HAlign)hAlign
             vAlign:(VAlign)vAlign
{
    CGRect result;
    result.size = size;

    switch (hAlign)
    {
        case H_ALIGN_LEFT:
            result.origin.x = 0;
            break;
        case H_ALIGN_CENTER:
            result.origin.x = (rect.size.width - size.width) / 2;
            break;
        case H_ALIGN_RIGHT:
            result.origin.x = rect.size.width - size.width;
            break;
        default:
            NSLog(@"Unknown hAlign: %d", hAlign);
            assert(0);
            break;
    }
    switch (vAlign)
    {
        case V_ALIGN_TOP:
            result.origin.y = 0;
            break;
        case V_ALIGN_CENTER:
            result.origin.y = (rect.size.height - size.height) / 2;
            break;
        case V_ALIGN_BOTTOM:
            result.origin.y = rect.size.height - size.height;
            break;
        default:
            NSLog(@"Unknown vAlign: %d", vAlign);
            assert(0);
            break;
    }
    result.origin = CGPointRound(CGPointAdd(result.origin, rect.origin));
    return result;
}

- (void)positionSubview:(UIView *)subview
            inSuperview:(UIView *)superview
               withSize:(CGSize)subviewSize
           inCellBounds:(CGRect)cellBounds
        cellPositioning:(CellPositioningMode)cellPositioning
{
    switch (cellPositioning)
    {
        case CELL_POSITIONING_NORMAL:
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
            subview.frame = [self alignSize:subviewSize
                                 withinRect:cellBounds
                                     hAlign:[self subviewCellHAlign:superview
                                                            subview:subview]
                                     vAlign:[self subviewCellVAlign:superview
                                                            subview:subview]];
            break;
        }
        case CELL_POSITIONING_FILL:
        {
            CGRect subviewFrame = cellBounds;
            subviewFrame.origin = CGPointRound(subviewFrame.origin);
            subviewFrame.size = CGSizeMax(CGSizeZero, CGSizeFloor(subviewFrame.size));
            subview.frame = subviewFrame;
            break;
        }
        case CELL_POSITIONING_FILL_W_ASPECT_RATIO:
        case CELL_POSITIONING_FIT_W_ASPECT_RATIO:
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
                if (cellPositioning == CELL_POSITIONING_FILL_W_ASPECT_RATIO)
                {
                    subviewSize = FillRectWithSize(cellBounds, desiredSize).size;
                }
                else
                {
                    subviewSize = FitSizeInRect(cellBounds, desiredSize).size;
                }
                subviewSize = CGSizeMax(CGSizeZero, CGSizeFloor(subviewSize));
                subview.frame = [self alignSize:subviewSize
                                     withinRect:cellBounds
                                         hAlign:[self subviewCellHAlign:superview
                                                                subview:subview]
                                         vAlign:[self subviewCellVAlign:superview
                                                                subview:subview]];
            }
        }
        default:
            break;
    }
}

// TODO: Remove
- (CGRect)contentBoundsOfView:(UIView *)view
                      forSize:(CGSize)size
{
    int left = ceilf([self leftMargin]);
    int top = ceilf([self topMargin]);
    int right = floorf(size.width - ceilf([self rightMargin]));
    int bottom = floorf(size.height - ceilf([self bottomMargin]));

    return CGRectMake(left,
                      top,
                      MAX(0, right - left),
                      MAX(0, bottom - top));
}

// TODO: Remove
- (CGSize)insetSizeOfView:(UIView *)view
{
    int left = ceilf([self leftMargin]);
    int top = ceilf([self topMargin]);
    int right = ceilf([self rightMargin]);
    int bottom = ceilf([self bottomMargin]);

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
                                          subview.minDesiredSize),
                                CGSizeMin(subview.maxDesiredSize,
                                          desiredSize)));
}

+ (NSArray *)distributeSpace:(CGFloat)space
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

+ (void)distributeAdjustment:(CGFloat)totalAdjustment
                acrossValues:(NSMutableArray *)values
                 withWeights:(NSArray *)weights
                    withSign:(CGFloat)sign
                 withMaxZero:(BOOL)withMaxZero
{
    WeViewAssert([values count] == [weights count]);
    NSArray *adjustments = [self distributeSpace:roundf(totalAdjustment)
                          acrossCellsWithWeights:weights];
    WeViewAssert([values count] == [adjustments count]);
    NSUInteger count = [values count];
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

#pragma mark - Copy Configuration

- (void)copyConfigurationOfLayout:(WeViewLayout *)layout
{
    /* CODEGEN MARKER: Copy Configuration Start */

    self.leftMargin = layout.leftMargin;
    self.rightMargin = layout.rightMargin;
    self.topMargin = layout.topMargin;
    self.bottomMargin = layout.bottomMargin;
    self.vSpacing = layout.vSpacing;
    self.hSpacing = layout.hSpacing;
    self.hAlign = layout.hAlign;
    self.vAlign = layout.vAlign;
    self.cropSubviewOverflow = layout.cropSubviewOverflow;
    self.cellPositioning = layout.cellPositioning;
    self.debugLayout = layout.debugLayout;
    self.debugMinSize = layout.debugMinSize;

/* CODEGEN MARKER: Copy Configuration End */
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

@end
