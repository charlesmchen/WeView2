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
#import "WeViewLayoutUtils.h"
#import "WeViewMacros.h"

typedef struct
{
    int columnCount, rowCount;
} GridRowAndColumnCount;

#pragma mark -

// TODO: Make this category public.
@interface WeViewLayout (Subclass)

- (void)propertyChanged;

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

//- (CGFloat)totalAxisStretchWeight
//{
//    return WeViewSumFloats([se]axisStretchWeights);
//}

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

- (void)stretchIfNecessary:(CGFloat)viewAxisSize
{
    NSMutableArray *axisSizes = [self axisSizes];
    NSArray *axisStretchWeights = [self axisStretchWeights];

//    //                          WeViewSumFloats(self.rowSpacingSizes));
//    CGSize contentSize = CGSizeMax(CGSizeZero, [result totalSize]);
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
        }
        else
        {
            // There IS extra space in the layout BUT the content CANNOT stretch along this axis;
            // therefore apply alignment.
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
    }
    else if (extraAxisSize < 0)
    {
        if (totalStretchWeights.x > 0)
        {
            // TODO:
        }
        else
        {
            // TODO:
        }
    }
}

//
//        return CGSizeMake(self.leftMarginSize +
//                          self.rightMarginSize +
//                          WeViewSumFloats(self.columnSizes) +
//                          WeViewSumFloats(self.columnSpacingSizes),
//                          self.topMarginSize +
//                          self.bottomMarginSize +
//                          WeViewSumFloats(self.rowSizes) +
//                          WeViewSumFloats(self.rowSpacingSizes));
//CGSize contentSize = CGSizeMax(CGSizeZero, [result totalSize]);
//int extraWidth = ceilf(CGSizeSubtract(viewSize, contentSize).width);
//CGFloat totalAxisStretchWeight = WeViewSumFloats(axisStretchWeights);
//if (extraWidth > 0)
//
//- (CGSize)totalSize
//{
//    return CGSizeMake(self.leftMarginSize +
//                      self.rightMarginSize +
//                      WeViewSumFloats(self.columnSizes) +
//                      WeViewSumFloats(self.columnSpacingSizes),
//                      self.topMarginSize +
//                      self.bottomMarginSize +
//                      WeViewSumFloats(self.rowSizes) +
//                      WeViewSumFloats(self.rowSpacingSizes));
//    //    //        NSLog(@"totalSize totalCellSize: %@", FormatCGSize([self totalCellSize:superview
//    //    //                                                                        layout:layout]));
//    //    //        NSLog(@"totalSize totalSpacingSize: %@", FormatCGSize([self totalSpacingSize:superview
//    //    //                                                                        layout:layout]));
//    //    //        NSLog(@"totalSize contentSize: %@", FormatCGSize(contentSize));
//}

@end

#pragma mark -

#pragma mark - LayerGridInfo

@interface GridLayoutInfo : NSObject

@property (nonatomic) GridAxisLayout *columnAxisLayout;
@property (nonatomic) GridAxisLayout *rowAxisLayout;

// TODO:
@property (nonatomic) int columnCount;
@property (nonatomic) int rowCount;

//@property (nonatomic) int leftMarginSize;
//@property (nonatomic) int rightMarginSize;
//@property (nonatomic) int topMarginSize;
//@property (nonatomic) int bottomMarginSize;
//
//@property (nonatomic) NSMutableArray *rowSizings;
//@property (nonatomic) NSMutableArray *rowSizes;
// TODO: Check renaming.
//@property (nonatomic) NSMutableArray *rowSpacings;
//@property (nonatomic) NSMutableArray *rowSpacingSizes;
//
//@property (nonatomic) NSMutableArray *columnSizings;
//@property (nonatomic) NSMutableArray *columnSizes;
// TODO: Check renaming.
//@property (nonatomic) NSMutableArray *columnSpacings;
//@property (nonatomic) NSMutableArray *columnSpacingSizes;

@end

#pragma mark -

@implementation GridLayoutInfo

//- (CGPoint)totalStretchWeights:(WeViewGridLayout *)layout
//{
//    // Ignore negative stretch weight values.
//    //
//    // TODO: Note this in the docs.
//    CGPoint result = CGPointMake(MAX(0, layout.leftMarginInfo.stretchWeight) +
//                                 MAX(0, layout.rightMarginInfo.stretchWeight),
//                                 MAX(0, layout.topMarginInfo.stretchWeight) +
//                                 MAX(0, layout.bottomMarginInfo.stretchWeight));
//    for (WeViewGridSizing *sizing in self.columnSizings)
//    {
//        result.x += MAX(0, sizing.stretchWeight);
//    }
//    for (WeViewGridSizing *sizing in self.rowSizings)
//    {
//        result.y += MAX(0, sizing.stretchWeight);
//    }
//    for (WeViewSpacing *spacing in self.columnSpacings)
//    {
//        result.x += MAX(0, spacing.stretchWeight);
//    }
//    for (WeViewSpacing *spacing in self.rowSpacings)
//    {
//        result.y += MAX(0, spacing.stretchWeight);
//    }
//    return result;
//}

//- (CGSize)totalSize
//{
//    return CGSizeMake(self.leftMarginSize +
//                      self.rightMarginSize +
//                      WeViewSumFloats(self.columnSizes) +
//                      WeViewSumFloats(self.columnSpacingSizes),
//                      self.topMarginSize +
//                      self.bottomMarginSize +
//                      WeViewSumFloats(self.rowSizes) +
//                      WeViewSumFloats(self.rowSpacingSizes));
//    //    //        NSLog(@"totalSize totalCellSize: %@", FormatCGSize([self totalCellSize:superview
//    //    //                                                                        layout:layout]));
//    //    //        NSLog(@"totalSize totalSpacingSize: %@", FormatCGSize([self totalSpacingSize:superview
//    //    //                                                                        layout:layout]));
//    //    //        NSLog(@"totalSize contentSize: %@", FormatCGSize(contentSize));
//}

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

@property (nonatomic) int columnCount;

@end

#pragma mark -

@implementation WeViewGridLayout

+ (WeViewGridLayout *)gridLayoutWithColumnCount:(int)columnCount
{
    WeViewGridLayout *layout = [[WeViewGridLayout alloc] init];
    layout.columnCount = columnCount;
    return layout;
}

- (void)resetAllProperties
{
    self.columnCount = 1;
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
    if (self.columnCount > 0)
    {
        result.columnCount = self.columnCount;
        result.rowCount = ceilf([subviews count] / (CGFloat) result.columnCount);
    }
    else
    {
        result.columnCount = [subviews count];
        result.rowCount = 1;
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
    WeViewAssert(index > 0);
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
    WeViewAssert(index > 0);
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

//    NSMutableArray *vStretchWeights = [NSMutableArray array];
//    {
//        // Ignore negative stretch weight values.
//        //
//        // TODO: Note this in the docs.
//        [vStretchWeights addObject:@(MAX(0, self.topMarginInfo.stretchWeight))];
//        [vStretchWeights addObject:@(MAX(0, self.bottomMarginInfo.stretchWeight))];
//        for (WeViewGridSizing *sizing in self.rowSizings)
//        {
//            [vStretchWeights addObject:@(MAX(0, sizing.stretchWeight))];
//        }
//        for (WeViewSpacing *spacing in self.rowSpacings)
//        {
//            [vStretchWeights addObject:@(MAX(0, spacing.stretchWeight))];
//        }
//    }

    CGSize viewSize = CGSizeMax(CGSizeZero, view.size);
//    CGPoint totalStretchWeights = [result totalStretchWeights:self];
    // Stretch/crop horizontal content if necessary.
    {
//        // Order of elements matters in this collection.
//        NSMutableArray *axisStretchWeights = [NSMutableArray array];
//        // Ignore negative stretch weight values.
//        //
//        // TODO: Note this in the docs.
//        [axisStretchWeights addObject:@(MAX(0, self.leftMarginInfo.stretchWeight))];
//        [axisStretchWeights addObject:@(MAX(0, self.rightMarginInfo.stretchWeight))];
//        for (WeViewGridSizing *sizing in self.columnSizings)
//        {
//            [axisStretchWeights addObject:@(MAX(0, sizing.stretchWeight))];
//        }
//        for (WeViewSpacing *spacing in self.columnSpacings)
//        {
//            [axisStretchWeights addObject:@(MAX(0, spacing.stretchWeight))];
//        }
//
//        // Order of elements matters in this collection.
//        NSMutableArray *axisSizes = [NSMutableArray array];
//        [axisSizes addObject:@(result.leftMarginSize)];
//        [axisSizes addObject:@(result.rightMarginSize)];
//        [axisSizes addObjectsFromArray:result.columnSizings];
//        [axisSizes addObjectsFromArray:result.columnSpacingSizes];

//        return CGSizeMake(self.leftMarginSize +
//                          self.rightMarginSize +
//                          WeViewSumFloats(self.columnSizes) +
//                          WeViewSumFloats(self.columnSpacingSizes),
//                          self.topMarginSize +
//                          self.bottomMarginSize +
//                          WeViewSumFloats(self.rowSizes) +
//                          WeViewSumFloats(self.rowSpacingSizes));
        CGSize contentSize = CGSizeMax(CGSizeZero, [result totalSize]);
        int extraWidth = ceilf(CGSizeSubtract(viewSize, contentSize).width);
        CGFloat totalAxisStretchWeight = WeViewSumFloats(axisStretchWeights);
        if (extraWidth > 0)
        {
            if (totalAxisStretchWeight > 0)
            {
                // There is extra horizontal space in the layout AND the content can stretch.

                - (NSArray *)distributeSpace:(CGFloat)space
            acrossCellsWithWeights:(NSArray *)cellWeights;

                - (void)distributeAdjustment:(CGFloat)totalAdjustment
            acrossValues:(NSMutableArray *)values
            withWeights:(NSArray *)weights
            withSign:(CGFloat)sign
            withMaxZero:(BOOL)withMaxZero;
            }
            else
            {
                // TODO:
            }
        }
        else
        {
            if (totalStretchWeights.x > 0)
            {
                // TODO:
            }
            else
            {
                // TODO:
            }
        }
    }

    - (CGSize)totalSize
    - (CGPoint)totalStretchWeights:(WeViewGridLayout *)layout

    // TODO: Use a two-pass approach where subview size calculation is based first on "guide size",
    // then on attempt to trim if necessary.
    CGRect contentBounds = [self contentBoundsOfView:view
                                             forSize:CGSizeZero];
    CGSize maxSubviewSize = contentBounds.size;
    CGFloat hSpacing = ceilf([self hSpacing]);
    CGFloat vSpacing = ceilf([self vSpacing]);
    maxSubviewSize.width = MAX(0, maxSubviewSize.width - hSpacing * (columnCount - 1));
    maxSubviewSize.height = MAX(0, maxSubviewSize.height - vSpacing * (rowCount - 1));
    if (self.isGridUniform)
    {
        if (columnCount > 0)
        {
            maxSubviewSize.width = floorf(maxSubviewSize.width * (1.f / columnCount));
        }
        if (rowCount > 0)
        {
            maxSubviewSize.height = floorf(maxSubviewSize.height * (1.f / rowCount));
        }
    }
    else
    {
        // TODO: The "non-uniform" case is quite complicated due to subview flow.
        maxSubviewSize = CGSizeZero;
    }

    CGFloat columnWidths[columnCount];
    CGFloat rowHeights[rowCount];
    for (int column=0; column < columnCount; column++)
    {
        columnWidths[column] = 0;
    }
    for (int row=0; row < rowCount; row++)
    {
        rowHeights[row] = 0;
    }
//    result.maxColumnSize = 0;
//    result.maxRowSize = 0;

    if (self.hasCellSizeHint)
    {
        for (int i=0; i < columnCount; i++)
        {
            columnWidths[i] = self.cellSizeHint.width;
        }
        for (int i=0; i < rowCount; i++)
        {
            rowHeights[i] = self.cellSizeHint.height;
        }
    }
    else if (!view.ignoreDesiredSize)
    {
        int index = 0;
        for (UIView* subview in subviews)
        {
            int row = index / columnCount;
            int column = index % columnCount;
            index++;

            CGSize subviewSize = [self desiredItemSize:subview
                                               maxSize:useEmptyGuideSize ? CGSizeZero : maxSubviewSize];

            columnWidths[column] = MAX(columnWidths[column], subviewSize.width);
            result.maxColumnSize = MAX(result.maxColumnSize, subviewSize.width);
            rowHeights[row] = MAX(rowHeights[row], subviewSize.height);
            result.maxRowSize = MAX(result.maxRowSize, subviewSize.height);
        }

        if (self.isGridUniform)
        {
            for (int i=0; i < columnCount; i++)
            {
                columnWidths[i] = result.maxColumnSize;
            }
            for (int i=0; i < rowCount; i++)
            {
                rowHeights[i] = result.maxRowSize;
            }
        }
    }

    // Normalize the column and row sizes.
    for (int i=0; i < columnCount; i++)
    {
        columnWidths[i] = MAX(0, ceilf(columnWidths[i]));
    }
    for (int i=0; i < rowCount; i++)
    {
        rowHeights[i] = MAX(0, ceilf(rowHeights[i]));
    }

    result.columnWidths = [self toNSFloatArray:&(columnWidths[0])
                                         count:columnCount];
    result.rowHeights = [self toNSFloatArray:&(rowHeights[0])
                                       count:rowCount];

    result.columnSpacings = [NSMutableArray array];
    for (int i=0; i < columnCount - 1; i++)
    {
        [result.columnSpacings addObject:@(hSpacing)];
    }
    result.rowSpacings = [NSMutableArray array];
    for (int i=0; i < rowCount - 1; i++)
    {
        [result.rowSpacings addObject:@(vSpacing)];
    }

    if (debug)
    {
        NSLog(@"%@ columnWidths: %@", [self indentPrefix:indent + 1], result.columnWidths);
        NSLog(@"%@ rowHeights: %@", [self indentPrefix:indent + 1], result.rowHeights);
        NSLog(@"%@ columnSpacings: %@", [self indentPrefix:indent + 1], result.columnSpacings);
        NSLog(@"%@ rowSpacings: %@", [self indentPrefix:indent + 1], result.rowSpacings);
    }

    //    if (layer.debugLayout) {
    //        NSLog(@"result.columnCount: %d",
    //              columnCount);
    //        NSLog(@"result.rowCount: %d",
    //              rowCount);
    //        for (int i=0; i < result.columnCount; i++) {
    //            NSLog(@"result.columnWidths[%d]: %d",
    //                  i, result.columnWidths[i]);
    //        }
    //        for (int i=0; i < result.rowCount; i++) {
    //            NSLog(@"result.rowHeights[%d]: %d",
    //                  i, result.rowHeights[i]);
    //        }
    //        NSLog(@"result.maxColumnSize: %d",
    //              result.maxColumnSize);
    //        NSLog(@"result.maxRowSize: %d",
    //              result.maxRowSize);
    //        NSLog(@"result.contentSize: %@",
    //              FormatCGSize(result.contentSize));
    //        NSLog(@"result.totalSize: %@",
    //              FormatCGSize(result.totalSize));
    //    }

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

    CGSize totalSize = [gridLayoutInfo totalSize:view
                                          layout:self];

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
    CGRect contentBounds = [self contentBoundsOfView:view
                                             forSize:guideSize];
    CGSize totalSpacingSize = [gridLayoutInfo totalSpacingSize:view
                                                        layout:self];
    CGSize maxTotalCellSize = CGSizeMax(CGSizeZero,
                                        CGSizeFloor(CGSizeSubtract(contentBounds.size,
                                                                   totalSpacingSize)));
    CGSize rawTotalCellSize = [gridLayoutInfo totalCellSize:view
                                                     layout:self];
    // If extraCellSpace is positive, there's extra space in the layout.
    // If extraCellSpace is negative, we may need to crop the cells.
    CGSize extraCellSpace = CGSizeSubtract(maxTotalCellSize, rawTotalCellSize);
    CGPoint cellsOrigin = contentBounds.origin;
    if (extraCellSpace.width > 0)
    {
        switch (self.stretchPolicy)
        {
            case GRID_STRETCH_POLICY_STRETCH_CELLS:
            {
                // Stretch the cells, distributing the extra space evenly between them.
                [self distributeAdjustment:extraCellSpace.width
                              acrossValues:gridLayoutInfo.columnWidths
                               withWeights:gridLayoutInfo.columnWidths
                                  withSign:+1.f
                               withMaxZero:YES];
                break;
            }
            case GRID_STRETCH_POLICY_STRETCH_SPACING:
            {
                // Stretch the spacing between cells, distributing the extra space evenly between
                // them.
                [self distributeAdjustment:extraCellSpace.width
                              acrossValues:gridLayoutInfo.columnSpacings
                               withWeights:gridLayoutInfo.columnSpacings
                                  withSign:+1.f
                               withMaxZero:YES];
                break;
            }
            case GRID_STRETCH_POLICY_NO_STRETCH:
            {
                // Don't stretch cells or spacing; instead align grid body within the extra space.
                switch ([self hAlign])
                {
                    case H_ALIGN_LEFT:
                        break;
                    case H_ALIGN_CENTER:
                        cellsOrigin.x += roundf(extraCellSpace.width / 2);
                        break;
                    case H_ALIGN_RIGHT:
                        cellsOrigin.x += extraCellSpace.width;
                        break;
                    default:
                        WeViewAssert(0);
                        break;
                }
                break;
            }
            default:
                WeViewAssert(0);
                break;
        }
    }
    else if (extraCellSpace.width < 0)
    {
        if (self.cropSubviewOverflow)
        {
            // Crop the width of cells based on their existing width - ie. crop wider columns more.
            [self distributeAdjustment:-extraCellSpace.width
                          acrossValues:gridLayoutInfo.columnWidths
                           withWeights:gridLayoutInfo.columnWidths
                              withSign:-1.f
                           withMaxZero:YES];
        }
    }
    if (extraCellSpace.height > 0)
    {
        switch (self.stretchPolicy)
        {
            case GRID_STRETCH_POLICY_STRETCH_CELLS:
            {
                // Stretch the cells, distributing the extra space evenly between them.
                [self distributeAdjustment:extraCellSpace.height
                              acrossValues:gridLayoutInfo.rowHeights
                               withWeights:gridLayoutInfo.rowHeights
                                  withSign:+1.f
                               withMaxZero:YES];
                break;
            }
            case GRID_STRETCH_POLICY_STRETCH_SPACING:
            {
                // Stretch the spacing between cells, distributing the extra space evenly between
                // them.
                [self distributeAdjustment:extraCellSpace.height
                              acrossValues:gridLayoutInfo.rowSpacings
                               withWeights:gridLayoutInfo.rowSpacings
                                  withSign:+1.f
                               withMaxZero:YES];
                break;
            }
            case GRID_STRETCH_POLICY_NO_STRETCH:
            {
                // Don't stretch cells or spacing; instead align grid body within the extra space.
                switch ([self vAlign])
                {
                    case V_ALIGN_BOTTOM:
                        cellsOrigin.y += extraCellSpace.height;
                        break;
                    case V_ALIGN_CENTER:
                        cellsOrigin.y += roundf(extraCellSpace.height / 2);
                        break;
                    case V_ALIGN_TOP:
                        break;
                    default:
                        WeViewAssert(0);
                        break;
                }
                break;
            }
            default:
                WeViewAssert(0);
                break;
        }
    }
    else if (extraCellSpace.height < 0)
    {
        if (self.cropSubviewOverflow)
        {
            // Crop the height of cells based on their existing height - ie. crop taller rows more.
            [self distributeAdjustment:-extraCellSpace.height
                          acrossValues:gridLayoutInfo.rowHeights
                           withWeights:gridLayoutInfo.rowHeights
                              withSign:-1.f
                           withMaxZero:YES];
        }
    }

    // Calculate and apply the subviews' frames.
    CellPositioningMode cellPositioning = [self cellPositioning];
    CGPoint cellOrigin = cellsOrigin;
    int subviewCount = [subviews count];
    for (int i=0; i < subviewCount; i++)
    {
        UIView* subview = subviews[i];
        int row = i / columnCount;
        int column = i % columnCount;
        WeViewAssert(column < gridLayoutInfo.columnCount);
        WeViewAssert(row < gridLayoutInfo.rowCount);
        CGRect cellBounds = CGRectMake(cellOrigin.x,
                                       cellOrigin.y,
                                       [gridLayoutInfo.columnWidths[column] floatValue],
                                       [gridLayoutInfo.rowHeights[row] floatValue]);

        CGSize subviewSize = [self desiredItemSize:subview
                                           maxSize:cellBounds.size];

        [self positionSubview:subview
                  inSuperview:view
                     withSize:subviewSize
                 inCellBounds:cellBounds
              cellPositioning:cellPositioning];

        if (debugLayout)
        {
            NSLog(@"%@ subview(%@).frame = %@, subviewSize: %@",
                  [self indentPrefix:indent + 1],
                  [subview class],
                  FormatCGRect(subview.frame),
                  FormatCGSize(subviewSize));
        }

        cellOrigin.x += cellBounds.size.width;
        if (column < [gridLayoutInfo.columnSpacings count])
        {
            cellOrigin.x += [gridLayoutInfo.columnSpacings[column] floatValue];
        }
        if (column + 1 == columnCount)
        {
            // Start new row.
            cellOrigin.x = cellsOrigin.x;
            cellOrigin.y += cellBounds.size.height;
            if (row < [gridLayoutInfo.rowSpacings count])
            {
                cellOrigin.y += [gridLayoutInfo.rowSpacings[row] floatValue];
            }
        }
    }
}

@end
