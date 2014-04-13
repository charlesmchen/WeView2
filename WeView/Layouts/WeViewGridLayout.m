//
//  WeViewGridLayout.m
//  WeView v2
//
//  Copyright (c) 2014 Charles Matthew Chen. All rights reserved.
//
//  Distributed under the Apache License v2.0.
//  http://www.apache.org/licenses/LICENSE-2.0.html
//

#import <QuartzCore/QuartzCore.h>

#import "UIView+WeView.h"
#import "WeViewGridLayout.h"
#import "WeViewLayout+Subclass.h"
#import "WeViewLayoutUtils.h"
#import "WeViewMacros.h"

typedef struct
{
    int columnCount, rowCount;
} GridRowAndColumnCount;

#pragma mark -

@implementation WeViewGridSizing

+ (WeViewGridSizing *)sizingWithSize:(int)size
{
    WeViewGridSizing *result = [[WeViewGridSizing alloc] init];
    result.fixedSize = @(size);
    return result;
}

+ (WeViewGridSizing *)sizingWithStretchWeight:(CGFloat)stretchWeight
{
    WeViewGridSizing *result = [[WeViewGridSizing alloc] init];
    result.stretchWeight = stretchWeight;
    return result;
}

+ (WeViewGridSizing *)sizingWithSize:(int)size
                       stretchWeight:(CGFloat)stretchWeight
{
    WeViewGridSizing *result = [[WeViewGridSizing alloc] init];
    result.fixedSize = @(size);
    result.stretchWeight = stretchWeight;
    return result;
}

@end

#pragma mark - GridAxisLayout

@interface GridAxisLayout : NSObject

// For the horizontal axis, this is the WeViewSpacing for the left margin.
// For the vertical axis, this is the WeViewSpacing for the top margin.
@property (nonatomic) WeViewSpacing *preMargin;
// For the horizontal axis, this is the left margin.
// For the vertical axis, this is the top margin.
@property (nonatomic) int preMarginSize;

// For the horizontal axis, this is the WeViewSpacing for the right margin.
// For the vertical axis, this is the WeViewSpacing for the bottom margin.
@property (nonatomic) WeViewSpacing *postMargin;
// For the horizontal axis, this is the right margin.
// For the vertical axis, this is the bottom margin.
@property (nonatomic) int postMarginSize;

// For the horizontal axis, this is the WeViewGridSizings for each column.
// For the vertical axis, this is the the WeViewGridSizings for each row.
@property (nonatomic) NSArray *cellSizings;
// For the horizontal axis, this is the size of each column.
// For the vertical axis, this is the the size of each row.
@property (nonatomic) NSMutableArray *cellSizes;

// For the horizontal axis, this is the WeViewSpacing for each column spacing.
// For the vertical axis, this is the the WeViewSpacing for each row spacing.
@property (nonatomic) NSArray *spacings;
// For the horizontal axis, this is the size of each column spacing.
// For the vertical axis, this is the the size of each row spacing.
@property (nonatomic) NSMutableArray *spacingSizes;

@property (nonatomic) BOOL allCellSizesAreFixed;

@property (nonatomic) WeViewAxisAlignment axisAlignment;

// Zero for top or left alignment; postive otherwise.
@property (nonatomic) int axisOrigin;

@end

#pragma mark -

@implementation GridAxisLayout

+ (GridAxisLayout *)createWithPreMargin:(WeViewSpacing *)preMargin
                             postMargin:(WeViewSpacing *)postMargin
                            cellSizings:(NSArray *)cellSizings
                               spacings:(NSArray *)spacings
                          axisAlignment:(WeViewAxisAlignment)axisAlignment
{
    WeViewAssert(cellSizings);
    WeViewAssert([cellSizings count] > 0);
    WeViewAssert(spacings);
    WeViewAssert([spacings count] >= 0);
    WeViewAssert([spacings count] == [cellSizings count] - 1);

    GridAxisLayout *result = [[GridAxisLayout alloc] init];

    result.preMargin = preMargin;
    result.preMarginSize = result.preMargin.size;
    result.postMargin = postMargin;
    result.postMarginSize = result.postMargin.size;

    result.allCellSizesAreFixed = YES;
    result.cellSizings = cellSizings;
    result.cellSizes = [NSMutableArray array];
    for (WeViewGridSizing *cellSizing in cellSizings)
    {
        int cellSize = MAX(0, ceilf([cellSizing.fixedSize floatValue]));
        [result.cellSizes addObject:@(cellSize)];
        result.allCellSizesAreFixed &= cellSizing.fixedSize != nil;
    }

    result.spacings = spacings;
    result.spacingSizes = [NSMutableArray array];
    for (WeViewSpacing *spacing in spacings)
    {
        [result.spacingSizes addObject:@(MAX(0, spacing.size))];
    }

    result.axisAlignment = axisAlignment;

    WeViewAssert(result.cellSizings);
    WeViewAssert(result.cellSizes);
    WeViewAssert([result.cellSizings count] == [result.cellSizes count]);
    WeViewAssert(result.spacings);
    WeViewAssert(result.spacingSizes);
    WeViewAssert([result.spacings count] == [result.spacingSizes count]);

    return result;
}

- (WeViewGridSizing *)cellSizingForIndex:(int)index
{
    return (WeViewGridSizing *) self.cellSizings[index];
}

- (CGFloat)cellSizeForIndex:(int)index
{
    return [self.cellSizes[index] floatValue];
}

- (void)setCellSize:(CGFloat)value forIndex:(int)index
{
    self.cellSizes[index] = @(value);
}

- (void)ensureUniformCellSize
{
    self.cellSizes = WeViewArrayOfFloatsWithValue(WeViewMaxFloats(self.cellSizes),
                                                  [self.cellSizes count]);
}

- (NSArray *)axisStretchWeights
{
    // Order of elements matters in this collection.
    NSMutableArray *result = [NSMutableArray array];
    // Ignore negative stretch weight values.
    //
    // TODO: Note this in the docs.
    [result addObject:@(MAX(0, self.preMargin.stretchWeight))];
    [result addObject:@(MAX(0, self.postMargin.stretchWeight))];
    for (WeViewGridSizing *sizing in self.cellSizings)
    {
        [result addObject:@(MAX(0, sizing.stretchWeight))];
    }
    for (WeViewSpacing *spacing in self.spacings)
    {
        [result addObject:@(MAX(0, spacing.stretchWeight))];
    }
    return result;
}

- (NSMutableArray *)axisSizes
{
    // Order of elements matters in this collection.
    NSMutableArray *result = [NSMutableArray array];
    [result addObject:@(self.preMarginSize)];
    [result addObject:@(self.postMarginSize)];
    [result addObjectsFromArray:self.cellSizes];
    [result addObjectsFromArray:self.spacingSizes];
    return result;
}

- (void)updateAxisSizes:(NSArray *)values
{
    WeViewAssert(values);
    WeViewAssert([values count] == 2 + [self.cellSizes count] + [self.spacingSizes count]);
    self.preMarginSize = ceilf([values[0] floatValue]);
    self.postMarginSize = ceilf([values[1] floatValue]);
    self.cellSizes = [[values subarrayWithRange:NSMakeRange(2,
                                                            [self.cellSizes count])] mutableCopy];
    self.spacingSizes = [[values subarrayWithRange:NSMakeRange(2 + [self.cellSizes count],
                                                               [self.spacingSizes count])] mutableCopy];
}

- (void)applyAxisAlignment:(int)extraAxisSize
{
    switch (self.axisAlignment)
    {
        case WEVIEW_ALIGNMENT_TOP_OR_LEFT:
            self.axisOrigin = 0;
            break;
        case WEVIEW_ALIGNMENT_CENTER:
            self.axisOrigin = roundf(extraAxisSize / 2.f);
            break;
        case WEVIEW_ALIGNMENT_BOTTOM_OR_RIGHT:
            self.axisOrigin = extraAxisSize;
            break;
        default:
            WeViewAssert(0);
            break;
    }
}

- (BOOL)stretchIfNecessary:(CGFloat)viewAxisSize
{
    // Returns YES IFF cell, margin or spacing sizes are changed.

    NSMutableArray *axisSizes = [self axisSizes];
    NSArray *axisStretchWeights = [self axisStretchWeights];

    int extraAxisSize = ceilf(viewAxisSize) - WeViewSumFloats(axisSizes);
    CGFloat totalAxisStretchWeight = WeViewSumFloats(axisStretchWeights);
    if (extraAxisSize > 0)
    {
        if (totalAxisStretchWeight > 0)
        {
            // There IS extra space in the layout AND the content CAN stretch along this axis;
            // therefore stretch.
            [WeViewLayout distributeAdjustment:extraAxisSize
                                  acrossValues:axisSizes
                                   withWeights:axisStretchWeights
                                      withSign:+1.f
                                   withMaxZero:YES];
            [self updateAxisSizes:axisSizes];
            return YES;
        }
        else
        {
            // There IS extra space in the layout BUT the content CANNOT stretch along this axis;
            // therefore apply alignment.
            [self applyAxisAlignment:extraAxisSize];
        }
    }
    else if (extraAxisSize < 0)
    {
        if (totalAxisStretchWeight > 0)
        {
            // There IS a shortfall in the layout AND the content CAN stretch along this axis;
            // therefore stretch.
            [WeViewLayout distributeAdjustment:-extraAxisSize
                                  acrossValues:axisSizes
                                   withWeights:axisStretchWeights
                                      withSign:-1.f
                                   withMaxZero:YES];
            [self updateAxisSizes:axisSizes];
            return YES;
        }
        else
        {
            // There IS a shortfall of space in the layout BUT the content CANNOT stretch along this axis;
            // therefore apply alignment.
            [self applyAxisAlignment:extraAxisSize];
        }
    }

    return NO;
}

- (CGFloat)totalAxisSize {
    return WeViewSumFloats([self axisSizes]);
}

@end

#pragma mark -

#pragma mark - LayerGridInfo

@interface GridLayoutInfo : NSObject

@property (nonatomic) GridAxisLayout *columnAxisLayout;
@property (nonatomic) GridAxisLayout *rowAxisLayout;

@property (nonatomic) int columnCount;
@property (nonatomic) int rowCount;

@end

#pragma mark -

@implementation GridLayoutInfo

@end

#pragma mark -

@interface WeViewGridLayout ()
{
    /* CODEGEN MARKER: Members Start */

WeViewSpacing *_leftMarginInfo;
WeViewSpacing *_rightMarginInfo;
WeViewSpacing *_topMarginInfo;
WeViewSpacing *_bottomMarginInfo;

WeViewGridSizing *_defaultRowSizing;
WeViewGridSizing *_defaultColumnSizing;

NSArray *_rowSizings;
NSArray *_columnSizings;

WeViewSpacing *_defaultHSpacing;
WeViewSpacing *_defaultVSpacing;

NSArray *_rowSpacings;
NSArray *_columnSpacings;

BOOL _isRowHeightUniform;
BOOL _isColumnWidthUniform;

/* CODEGEN MARKER: Members End */
}

// One but only one of the following two properties should be set.
@property (nonatomic) NSNumber *maxColumnCount;
@property (nonatomic) NSNumber *maxRowCount;

@end

#pragma mark -

@implementation WeViewGridLayout

+ (WeViewGridLayout *)gridLayoutWithMaxColumnCount:(int)maxColumnCount
{
    WeViewAssert(maxColumnCount >= 0);
    WeViewGridLayout *layout = [[WeViewGridLayout alloc] init];
    layout.maxColumnCount = @(maxColumnCount);
    return layout;
}

+ (WeViewGridLayout *)gridLayoutWithMaxRowCount:(int)maxRowCount
{
    WeViewAssert(maxRowCount >= 0);
    WeViewGridLayout *layout = [[WeViewGridLayout alloc] init];
    layout.maxRowCount = @(maxRowCount);
    return layout;
}

- (void)resetAllProperties
{
    // Do not reset maxColumnCount or maxRowCount.

    self.defaultRowSizing = nil;
    self.defaultColumnSizing = nil;
    self.rowSizings = nil;
    self.columnSizings = nil;
    self.rowSpacings = nil;
    self.columnSpacings = nil;
    self.isRowHeightUniform = NO;
    self.isColumnWidthUniform = NO;

    [super resetAllProperties];
}

/* CODEGEN MARKER: Accessors Start */

- (WeViewSpacing *)leftMarginInfo
{
    return _leftMarginInfo;
}

- (WeViewLayout *)setLeftMarginInfo:(WeViewSpacing *)value
{
    _leftMarginInfo = value;
    [self propertyChanged];
    return self;
}

- (WeViewSpacing *)rightMarginInfo
{
    return _rightMarginInfo;
}

- (WeViewLayout *)setRightMarginInfo:(WeViewSpacing *)value
{
    _rightMarginInfo = value;
    [self propertyChanged];
    return self;
}

- (WeViewSpacing *)topMarginInfo
{
    return _topMarginInfo;
}

- (WeViewLayout *)setTopMarginInfo:(WeViewSpacing *)value
{
    _topMarginInfo = value;
    [self propertyChanged];
    return self;
}

- (WeViewSpacing *)bottomMarginInfo
{
    return _bottomMarginInfo;
}

- (WeViewLayout *)setBottomMarginInfo:(WeViewSpacing *)value
{
    _bottomMarginInfo = value;
    [self propertyChanged];
    return self;
}

- (WeViewGridSizing *)defaultRowSizing
{
    return _defaultRowSizing;
}

- (WeViewLayout *)setDefaultRowSizing:(WeViewGridSizing *)value
{
    _defaultRowSizing = value;
    [self propertyChanged];
    return self;
}

- (WeViewGridSizing *)defaultColumnSizing
{
    return _defaultColumnSizing;
}

- (WeViewLayout *)setDefaultColumnSizing:(WeViewGridSizing *)value
{
    _defaultColumnSizing = value;
    [self propertyChanged];
    return self;
}

- (NSArray *)rowSizings
{
    return _rowSizings;
}

- (WeViewLayout *)setRowSizings:(NSArray *)value
{
    _rowSizings = value;
    [self propertyChanged];
    return self;
}

- (NSArray *)columnSizings
{
    return _columnSizings;
}

- (WeViewLayout *)setColumnSizings:(NSArray *)value
{
    _columnSizings = value;
    [self propertyChanged];
    return self;
}

- (WeViewSpacing *)defaultHSpacing
{
    return _defaultHSpacing;
}

- (WeViewLayout *)setDefaultHSpacing:(WeViewSpacing *)value
{
    _defaultHSpacing = value;
    [self propertyChanged];
    return self;
}

- (WeViewSpacing *)defaultVSpacing
{
    return _defaultVSpacing;
}

- (WeViewLayout *)setDefaultVSpacing:(WeViewSpacing *)value
{
    _defaultVSpacing = value;
    [self propertyChanged];
    return self;
}

- (NSArray *)rowSpacings
{
    return _rowSpacings;
}

- (WeViewLayout *)setRowSpacings:(NSArray *)value
{
    _rowSpacings = value;
    [self propertyChanged];
    return self;
}

- (NSArray *)columnSpacings
{
    return _columnSpacings;
}

- (WeViewLayout *)setColumnSpacings:(NSArray *)value
{
    _columnSpacings = value;
    [self propertyChanged];
    return self;
}

- (BOOL)isRowHeightUniform
{
    return _isRowHeightUniform;
}

- (WeViewLayout *)setIsRowHeightUniform:(BOOL)value
{
    _isRowHeightUniform = value;
    [self propertyChanged];
    return self;
}

- (BOOL)isColumnWidthUniform
{
    return _isColumnWidthUniform;
}

- (WeViewLayout *)setIsColumnWidthUniform:(BOOL)value
{
    _isColumnWidthUniform = value;
    [self propertyChanged];
    return self;
}

/* CODEGEN MARKER: Accessors End */

- (GridRowAndColumnCount)rowAndColumnCount:(NSArray *)subviews
{
    GridRowAndColumnCount result;
    if (self.maxRowCount)
    {
        if ([self.maxRowCount intValue] > 0)
        {
            result.rowCount = MIN([self.maxRowCount intValue],
                                  [subviews count]);
            result.columnCount = ceilf([subviews count] / (CGFloat) MAX(1, result.rowCount));
        }
        else
        {
            result.columnCount = 1;
            result.rowCount = [subviews count];
        }
    }
    else
    {
        if ([self.maxColumnCount intValue] > 0)
        {
            result.columnCount = MIN([self.maxColumnCount intValue],
                                     [subviews count]);
            result.rowCount = ceilf([subviews count] / (CGFloat) MAX(1, result.columnCount));
        }
        else
        {
            result.columnCount = [subviews count];
            result.rowCount = 1;
        }
    }
    return result;
}

- (NSMutableArray *)toNSFloatArray:(CGFloat *)values
                             count:(int)count
{
    NSMutableArray *result = [NSMutableArray array];
    for (int i=0; i < count; i++)
    {
        [result addObject:@(values[i])];
    }
    return result;
}

- (WeViewGridSizing *)sizingForIndex:(int)index
                             sizings:(NSArray *)sizings
                       defaultSizing:(WeViewGridSizing *)defaultSizing
{
    WeViewAssert(index >= 0);
    if (index < [sizings count])
    {
        WeViewGridSizing *sizing = sizings[index];
        WeViewAssert([sizing isKindOfClass:[WeViewGridSizing class]]);
        return sizing;
    }
    if (defaultSizing)
    {
        return defaultSizing;
    }
    return [[WeViewGridSizing alloc] init];
}

- (WeViewSpacing *)spacingForIndex:(int)index
                          spacings:(NSArray *)spacings
                    defaultSpacing:(WeViewSpacing *)defaultSpacing
{
    WeViewAssert(index >= 0);
    if (index < [spacings count])
    {
        WeViewSpacing *spacing = spacings[index];
        WeViewAssert([spacing isKindOfClass:[WeViewSpacing class]]);
        return spacing;
    }
    if (defaultSpacing)
    {
        return defaultSpacing;
    }
    return [[WeViewSpacing alloc] init];
}

// TODO: Apply "isAbstractSizeQuery" in other layouts.
- (GridLayoutInfo *)getGridLayoutInfo:(UIView *)view
                             subviews:(NSArray *)subviews
                  isAbstractSizeQuery:(BOOL)isAbstractSizeQuery
                                debug:(BOOL)debug
                          debugIndent:(int)indent
{
    GridLayoutInfo *result = [[GridLayoutInfo alloc] init];

    GridRowAndColumnCount rowAndColumnCount = [self rowAndColumnCount:subviews];
    int rowCount = result.rowCount = rowAndColumnCount.rowCount;
    int columnCount = result.columnCount = rowAndColumnCount.columnCount;

    WeViewAssert(rowCount > 0);
    WeViewAssert(columnCount > 0);

    NSMutableArray *rowSizings = [NSMutableArray array];
    NSMutableArray *rowSpacings = [NSMutableArray array];
    for (int rowIdx=0; rowIdx < rowCount; rowIdx++)
    {
        [rowSizings addObject:[self sizingForIndex:rowIdx
                                           sizings:self.rowSizings
                                     defaultSizing:self.defaultRowSizing]];
        if (rowIdx > 0)
        {
            [rowSpacings addObject:[self spacingForIndex:rowIdx - 1
                                                spacings:self.rowSpacings
                                          defaultSpacing:self.defaultVSpacing]];
        }
    }
    result.rowAxisLayout = [GridAxisLayout createWithPreMargin:self.topMarginInfo
                                                    postMargin:self.bottomMarginInfo
                                                   cellSizings:rowSizings
                                                      spacings:rowSpacings
                                                 axisAlignment:(WeViewAxisAlignment) self.vAlign];

    NSMutableArray *columnSizings = [NSMutableArray array];
    NSMutableArray *columnSpacings = [NSMutableArray array];
    for (int columnIdx=0; columnIdx < columnCount; columnIdx++)
    {
        [columnSizings addObject:[self sizingForIndex:columnIdx
                                              sizings:self.columnSizings
                                        defaultSizing:self.defaultColumnSizing]];
        if (columnIdx > 0)
        {
            [columnSpacings addObject:[self spacingForIndex:columnIdx - 1
                                                   spacings:self.columnSpacings
                                             defaultSpacing:self.defaultVSpacing]];
        }
    }
    result.columnAxisLayout = [GridAxisLayout createWithPreMargin:self.leftMarginInfo
                                                       postMargin:self.rightMarginInfo
                                                      cellSizings:columnSizings
                                                         spacings:columnSpacings
                                                    axisAlignment:(WeViewAxisAlignment) self.hAlign];

    BOOL allRowAndColumnsSizesAreFixed = (result.rowAxisLayout.allCellSizesAreFixed &&
                                          result.columnAxisLayout.allCellSizesAreFixed);

    // Update the row and column sizes based on actual cell content, if necessary.

    if (!allRowAndColumnsSizesAreFixed)
    {
        // If not all row and columns sizes are fixed, we calculate the desired size of all subviews.

        //        CGSize maxContentSize = CGSizeZero;
        // TODO: No, always use CGSizeZero as the guide size for subviews.
        //        if (!isAbstractSizeQuery)
        //        {
        //            maxContentSize = CGSizeMake(MAX(0, floorf(view.size.width) - (result.leftMargin +
        //                                                                          result.rightMargin +
        //                                                                          WeViewSumInts(result.columnSizes) +
        //                                                                          WeViewSumInts(result.columnSpacingSizes))),
        //                                        MAX(0, floorf(view.size.height) - (result.topMargin +
        //                                                                           result.bottomMargin +
        //                                                                           WeViewSumInts(result.rowSizes) +
        //                                                                           WeViewSumInts(result.rowSpacingSizes))));
        //        }

        // TODO: The "non-uniform" case is quite complicated due to subview flow.
        int subviewIdx = 0;
        for (UIView *subview in subviews)
        {
            int row = subviewIdx / columnCount;
            int column = subviewIdx % columnCount;
            subviewIdx++;

            if (!subview.ignoreDesiredSize)
            {
                //                CGSize cellSize = CGSizeMake([result.rowSizes[row] floatValue],
                //                                             [result.columnSizes[column] floatValue]);
                if ([result.rowAxisLayout cellSizingForIndex:row].fixedSize &&
                    [result.columnAxisLayout cellSizingForIndex:column].fixedSize)
                {
                    // Do nothing; this cell has a fixed desired size.
                }
                else
                {
                    NSNumber *fixedColumnWidth = [result.columnAxisLayout cellSizingForIndex:column].fixedSize;
                    NSNumber *fixedRowHeight = [result.rowAxisLayout cellSizingForIndex:row].fixedSize;

                    CGSize maxCellSize = CGSizeZero;
                    if (fixedRowHeight)
                    {
                        maxCellSize.width = CGFLOAT_MAX;
                        maxCellSize.height = fixedRowHeight.floatValue;
                    }
                    else if (fixedColumnWidth)
                    {
                        maxCellSize.width = fixedColumnWidth.floatValue;
                        maxCellSize.height = CGFLOAT_MAX;
                    }
                    CGSize subviewSize = [self desiredItemSize:subview
                                                       maxSize:isAbstractSizeQuery ? CGSizeZero : maxCellSize];
                    if (fixedRowHeight)
                    {
                        subviewSize.height = fixedRowHeight.floatValue;
                    }
                    else if (fixedColumnWidth)
                    {
                        subviewSize.width = fixedColumnWidth.floatValue;
                    }

                    [result.rowAxisLayout setCellSize:MAX([result.rowAxisLayout cellSizeForIndex:row],
                                                          subviewSize.height)
                                             forIndex:row];
                    [result.columnAxisLayout setCellSize:MAX([result.columnAxisLayout cellSizeForIndex:column],
                                                             subviewSize.width)
                                                forIndex:column];

                    //                    CGSize maxCellSize = maxContentSize;
                    //                    if (((WeViewGridSizing *) result.rowSizings[row]).fixedSize)
                    //                    {
                    //                        maxCellSize.height = ((WeViewGridSizing *) result.rowSizings[row]).fixedSize.floatValue;
                    //                    }
                    //                    else if (((WeViewGridSizing *) result.columnSizings[column]).fixedSize)
                    //                    {
                    //                        maxCellSize.width = ((WeViewGridSizing *) result.columnSizings[column]).fixedSize.floatValue;
                    //                    }
                    //                    CGSize subviewSize = [self desiredItemSize:subview
                    //                                                       maxSize:isAbstractSizeQuery ? CGSizeZero : maxCellSize];
                    //                    result.rowSizes[row] = @(MAX([result.rowSizes[row] floatValue],
                    //                                                 subviewSize.height));
                    //                    result.columnSizes[column] = @(MAX([result.columnSizes[column] floatValue],
                    //                                                       subviewSize.width));
                }
            }
        }
    }

    // If rows and/or columns are of uniform size, ensure now.

    if (self.isRowHeightUniform)
    {
        [result.rowAxisLayout ensureUniformCellSize];
    }
    if (self.isColumnWidthUniform)
    {
        [result.columnAxisLayout ensureUniformCellSize];
    }

    // First pass is complete.

    if (isAbstractSizeQuery)
    {
        // No need to stretch in an abstract size query.
        return result;
    }

    CGSize viewSize = CGSizeMax(CGSizeZero, view.size);
    {
        if ([result.columnAxisLayout stretchIfNecessary:viewSize.width])
        {
            // TODO:
        }
        [result.rowAxisLayout stretchIfNecessary:viewSize.height];
    }

    if (debug)
    {
        NSLog(@"%@ left margin: %d", [self indentPrefix:indent + 1], result.columnAxisLayout.preMarginSize);
        NSLog(@"%@ right margin: %d", [self indentPrefix:indent + 1], result.columnAxisLayout.postMarginSize);
        NSLog(@"%@ top margin: %d", [self indentPrefix:indent + 1], result.rowAxisLayout.preMarginSize);
        NSLog(@"%@ bottom margin: %d", [self indentPrefix:indent + 1], result.rowAxisLayout.postMarginSize);

        NSLog(@"%@ columnWidths: %@", [self indentPrefix:indent + 1], result.columnAxisLayout.cellSizes);
        NSLog(@"%@ rowHeights: %@", [self indentPrefix:indent + 1], result.rowAxisLayout.cellSizes);
        NSLog(@"%@ columnSpacings: %@", [self indentPrefix:indent + 1], result.columnAxisLayout.spacingSizes);
        NSLog(@"%@ rowSpacings: %@", [self indentPrefix:indent + 1], result.rowAxisLayout.spacingSizes);

        NSLog(@"%@ column axis origin: %d", [self indentPrefix:indent + 1], result.columnAxisLayout.axisOrigin);
        NSLog(@"%@ row axis origin: %d", [self indentPrefix:indent + 1], result.rowAxisLayout.axisOrigin);
    }

    return result;
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
    // TODO: Apply hasNonEmptyGuideSize in grid layout to ensure proper handling of the zero
    // case.
    BOOL hasNonEmptyGuideSize = !CGSizeEqualToSize(guideSize, CGSizeZero);
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

    GridLayoutInfo *gridLayoutInfo = [self getGridLayoutInfo:view
                                                    subviews:subviews
                                         isAbstractSizeQuery:!hasNonEmptyGuideSize
                                                       debug:debugMinSize
                                                 debugIndent:indent];

    // Return size, ignoring alignment.
    CGSize totalSize = CGSizeMake([gridLayoutInfo.columnAxisLayout totalAxisSize],
                                  [gridLayoutInfo.rowAxisLayout totalAxisSize]);

    if (debugMinSize)
    {
        NSLog(@"%@ result: %@",
              [self indentPrefix:indent + 1],
              NSStringFromCGSize(totalSize));
    }
    return totalSize;
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

    GridLayoutInfo *gridLayoutInfo = [self getGridLayoutInfo:view
                                                    subviews:subviews
                                         isAbstractSizeQuery:NO
                                                       debug:debugLayout
                                                 debugIndent:indent];
    int columnCount = gridLayoutInfo.columnCount;

    // Calculate and apply the subviews' frames.
    CellPositioningMode cellPositioning = [self cellPositioning];
    BOOL cropSubviewOverflow = [self cropSubviewOverflow];
    int x = gridLayoutInfo.columnAxisLayout.axisOrigin + gridLayoutInfo.columnAxisLayout.preMarginSize;
    int y = gridLayoutInfo.rowAxisLayout.axisOrigin + gridLayoutInfo.rowAxisLayout.preMarginSize;
    int subviewIdx = 0;
    for (UIView *subview in subviews)
    {
        int row = subviewIdx / columnCount;
        int column = subviewIdx % columnCount;
        subviewIdx++;

        if (column == 0)
        {
            // Newline.
            x = gridLayoutInfo.columnAxisLayout.axisOrigin + gridLayoutInfo.columnAxisLayout.preMarginSize;
            if (row > 0)
            {
                y += roundf([gridLayoutInfo.rowAxisLayout.cellSizes[row - 1] floatValue]);
                // Apply row spacing.
                y += roundf([gridLayoutInfo.rowAxisLayout.spacingSizes[row - 1] floatValue]);
            }
        }
        else
        {
            // Apply column spacing.
            x += roundf([gridLayoutInfo.columnAxisLayout.spacingSizes[column - 1] floatValue]);
        }

        CGRect cellFrame = CGRectMake(x, y,
                                       roundf([gridLayoutInfo.columnAxisLayout.cellSizes[column] floatValue]),
                                       roundf([gridLayoutInfo.rowAxisLayout.cellSizes[row] floatValue]));

        CGSize subviewSize = [self desiredItemSize:subview
                                           maxSize:cellFrame.size];

        if (cropSubviewOverflow)
        {
            subviewSize = CGSizeMin(cellFrame.size, subviewSize);
        }
        subviewSize = CGSizeMax(CGSizeZero,
                                CGSizeCeil(subviewSize));

        [self positionSubview:subview
                  inSuperview:view
                     withSize:subviewSize
                 inCellBounds:cellFrame
              cellPositioning:cellPositioning];

        if (debugLayout)
        {
            NSLog(@"%@ subview(%@).frame = %@, subviewSize: %@",
                  [self indentPrefix:indent + 1],
                  [subview class],
                  FormatCGRect(subview.frame),
                  FormatCGSize(subviewSize));
        }

        x += roundf(cellFrame.size.width);
    }
}

#pragma mark - Reappropriate base class properties.

- (CGFloat)leftMargin
{
    return self.leftMarginInfo.size;
}

- (WeViewLayout *)setLeftMargin:(CGFloat)value;
{
    if (!self.leftMarginInfo)
    {
        self.leftMarginInfo = [[WeViewSpacing alloc] init];
    }
    self.leftMarginInfo.size = ceilf(value);
    return self;
}

- (CGFloat)rightMargin
{
    return self.rightMarginInfo.size;
}

- (WeViewLayout *)setRightMargin:(CGFloat)value
{
    if (!self.rightMarginInfo)
    {
        self.rightMarginInfo = [[WeViewSpacing alloc] init];
    }
    self.rightMarginInfo.size = ceilf(value);
    return self;
}

- (CGFloat)topMargin
{
    return self.topMarginInfo.size;
}

- (WeViewLayout *)setTopMargin:(CGFloat)value
{
    if (!self.topMarginInfo)
    {
        self.topMarginInfo = [[WeViewSpacing alloc] init];
    }
    self.topMarginInfo.size = ceilf(value);
    return self;
}

- (CGFloat)bottomMargin
{
    return self.bottomMarginInfo.size;
}

- (WeViewLayout *)setBottomMargin:(CGFloat)value
{
    if (!self.bottomMarginInfo)
    {
        self.bottomMarginInfo = [[WeViewSpacing alloc] init];
    }
    self.bottomMarginInfo.size = ceilf(value);
    return self;
}

- (int)vSpacing
{
    return self.defaultVSpacing.size;
}

- (WeViewLayout *)setVSpacing:(int)value
{
    if (!self.defaultVSpacing)
    {
        self.defaultVSpacing = [[WeViewSpacing alloc] init];
    }
    self.defaultVSpacing.size = ceilf(value);
    return self;
}

- (int)hSpacing
{
    return self.defaultHSpacing.size;
}

- (WeViewLayout *)setHSpacing:(int)value
{
    if (!self.defaultHSpacing)
    {
        self.defaultHSpacing = [[WeViewSpacing alloc] init];
    }
    self.defaultHSpacing.size = ceilf(value);
    return self;
}

#pragma mark - Convenience accessors

- (WeViewGridLayout *)setMarginStretchWeight:(CGFloat)value
{
    if (!self.leftMarginInfo)
    {
        self.leftMarginInfo = [[WeViewSpacing alloc] init];
    }
    if (!self.rightMarginInfo)
    {
        self.rightMarginInfo = [[WeViewSpacing alloc] init];
    }
    if (!self.topMarginInfo)
    {
        self.topMarginInfo = [[WeViewSpacing alloc] init];
    }
    if (!self.bottomMarginInfo)
    {
        self.bottomMarginInfo = [[WeViewSpacing alloc] init];
    }
    self.leftMarginInfo.stretchWeight = value;
    self.rightMarginInfo.stretchWeight = value;
    self.topMarginInfo.stretchWeight = value;
    self.bottomMarginInfo.stretchWeight = value;
    return self;
}

- (WeViewGridLayout *)setDefaultSpacing:(WeViewSpacing *)value
{
    [self setDefaultHSpacing:[WeViewSpacing spacingWithSize:value.size
                                              stretchWeight:value.stretchWeight]];
    [self setDefaultVSpacing:[WeViewSpacing spacingWithSize:value.size
                                              stretchWeight:value.stretchWeight]];
    return self;
}

- (WeViewGridLayout *)setDefaultSpacingStretchWeight:(CGFloat)value
{
    if (!self.defaultHSpacing)
    {
        self.defaultHSpacing = [[WeViewSpacing alloc] init];
    }
    if (!self.defaultVSpacing)
    {
        self.defaultVSpacing = [[WeViewSpacing alloc] init];
    }
    self.defaultHSpacing.stretchWeight = value;
    self.defaultVSpacing.stretchWeight = value;
    return self;
}

@end
