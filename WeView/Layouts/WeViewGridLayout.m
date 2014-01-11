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

#pragma mark - LayerGridInfo

@interface GridLayoutInfo : NSObject

@property (nonatomic) int columnCount;
@property (nonatomic) int rowCount;

@property (nonatomic) int leftMarginSize;
@property (nonatomic) int rightMarginSize;
@property (nonatomic) int topMarginSize;
@property (nonatomic) int bottomMarginSize;

@property (nonatomic) NSMutableArray *rowSizings;
@property (nonatomic) NSMutableArray *rowSizes;
// TODO: Check renaming.
@property (nonatomic) NSMutableArray *rowSpacings;
@property (nonatomic) NSMutableArray *rowSpacingSizes;

@property (nonatomic) NSMutableArray *columnSizings;
@property (nonatomic) NSMutableArray *columnSizes;
// TODO: Check renaming.
@property (nonatomic) NSMutableArray *columnSpacings;
@property (nonatomic) NSMutableArray *columnSpacingSizes;

@end

#pragma mark -

@implementation GridLayoutInfo

//- (int)rowCount
//{
//    return [self.rowHeights count];
//}
//
//- (int)columnCount
//{
//    return [self.columnWidths count];
//}
//
//- (CGSize)totalSpacingSize:(UIView *)superview
//                    layout:(WeViewLayout *)layout
//{
//    CGSize result = CGSizeZero;
//    for (NSNumber *columnSpacing in self.columnSpacings)
//    {
//        result.width += [columnSpacing floatValue];
//    }
//    for (NSNumber *rowSpacing in self.rowSpacings)
//    {
//        result.height += [rowSpacing floatValue];
//    }
//    return result;
//}
//
//- (CGSize)totalCellSize:(UIView *)superview
//                 layout:(WeViewLayout *)layout
//{
//    int columnCount = self.columnCount;
//    int rowCount = self.rowCount;
//    CGSize result = CGSizeZero;
//    for (int column=0; column < columnCount; column++)
//    {
//        result.width += [self.columnWidths[column] floatValue];
//    }
//    for (int row=0; row < rowCount; row++)
//    {
//        result.height += [self.rowHeights[row] floatValue];
//    }
//    return result;
//}
//

- (CGSize)totalStretchWeights:(WeViewLayout *)layout
{
    CGSize result = CGSizeMake(self, <#CGFloat height#>)
    return CGSizeMake(self.leftMargin +
                      self.rightMargin +
                      WeViewSumFloats(self.columnSizes) +
                      WeViewSumFloats(self.columnSpacingSizes),
                      self.topMargin +
                      self.bottomMargin +
                      WeViewSumFloats(self.rowSizes) +
                      WeViewSumFloats(self.rowSpacingSizes));

    //                      , <#CGFloat height#>)
    //    CGFloat WeViewSumFloats(NSArray *values)
    //
    //
    //    CGSize contentSize = CGSizeAdd([self totalCellSize:superview
    //                                                layout:layout],
    //                                   [self totalSpacingSize:superview
    //                                                   layout:layout]);
    //
    //    //    {
    //    //        NSLog(@"totalSize totalCellSize: %@", FormatCGSize([self totalCellSize:superview
    //    //                                                                        layout:layout]));
    //    //        NSLog(@"totalSize totalSpacingSize: %@", FormatCGSize([self totalSpacingSize:superview
    //    //                                                                        layout:layout]));
    //    //        NSLog(@"totalSize contentSize: %@", FormatCGSize(contentSize));
    //    //    }
    //
    //    return CGSizeMax(CGSizeZero,
    //                     CGSizeCeil(CGSizeAdd(contentSize,
    //                                          [layout insetSizeOfView:superview])));
}

- (CGSize)totalSize
{
    return CGSizeMake(self.leftMargin +
                      self.rightMargin +
                      WeViewSumFloats(self.columnSizes) +
                      WeViewSumFloats(self.columnSpacingSizes),
                      self.topMargin +
                      self.bottomMargin +
                      WeViewSumFloats(self.rowSizes) +
                      WeViewSumFloats(self.rowSpacingSizes));
    //
    //
    //                      , <#CGFloat height#>)
    //    CGFloat WeViewSumFloats(NSArray *values)
    //
    //
    //    CGSize contentSize = CGSizeAdd([self totalCellSize:superview
    //                                                layout:layout],
    //                                   [self totalSpacingSize:superview
    //                                                   layout:layout]);
    //
    //    //    {
    //    //        NSLog(@"totalSize totalCellSize: %@", FormatCGSize([self totalCellSize:superview
    //    //                                                                        layout:layout]));
    //    //        NSLog(@"totalSize totalSpacingSize: %@", FormatCGSize([self totalSpacingSize:superview
    //    //                                                                        layout:layout]));
    //    //        NSLog(@"totalSize contentSize: %@", FormatCGSize(contentSize));
    //    //    }
    //
    //    return CGSizeMax(CGSizeZero,
    //                     CGSizeCeil(CGSizeAdd(contentSize,
    //                                          [layout insetSizeOfView:superview])));
}

@end

#pragma mark -

@interface WeViewGridLayout ()

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

    result.leftMargin = self.leftMarginInfo.size;
    result.topMargin = self.topMarginInfo.size;
    result.rightMargin = self.rightMarginInfo.size;
    result.bottomMargin = self.bottomMarginInfo.size;

    BOOL allRowAndColumnsSizesAreFixed = YES;

    result.rowSizings = [NSMutableArray array];
    result.rowSizes = [NSMutableArray array];
    result.rowSpacings = [NSMutableArray array];
    result.rowSpacingSizes = [NSMutableArray array];
    for (int rowIdx=0; rowIdx < rowCount; rowIdx++)
    {
        WeViewGridSizing *rowSizing = [self sizingForIndex:rowIdx
                                                   sizings:self.rowSizings
                                             defaultSizing:self.defaultRowSizing];
        [result.rowSizings addObject:rowSizing];
        int rowSize = ceilf([rowSizing.fixedSize floatValue]);
        [result.rowSizes addObject:@(rowSize)];
        allRowAndColumnsSizesAreFixed &= rowSizing.fixedSize != nil;
        if (rowIdx > 0)
        {
            WeViewSpacing *rowSpacing = [self spacingForIndex:rowIdx - 1
                                                     spacings:self.rowSpacings
                                               defaultSpacing:self.defaultVSpacing];
            [result.rowSpacings addObject:rowSpacing];
            [result.rowSpacingSizes addObject:@(rowSpacing.size)];
        }
    }

    result.columnSizings = [NSMutableArray array];
    result.columnSizes = [NSMutableArray array];
    result.columnSpacings = [NSMutableArray array];
    result.columnSpacingSizes = [NSMutableArray array];
    for (int columnIdx=0; columnIdx < columnCount; columnIdx++)
    {
        WeViewGridSizing *columnSizing = [self sizingForIndex:columnIdx
                                                   sizings:self.columnSizings
                                             defaultSizing:self.defaultColumnSizing];
        [result.columnSizings addObject:columnSizing];
        int columnSize = ceilf([columnSizing.fixedSize floatValue]);
        [result.columnSizes addObject:@(columnSize)];
        allRowAndColumnsSizesAreFixed &= columnSizing.fixedSize != nil;
        if (columnIdx > 0)
        {
            WeViewSpacing *columnSpacing = [self spacingForIndex:columnIdx - 1
                                                     spacings:self.columnSpacings
                                               defaultSpacing:self.defaultVSpacing];
            [result.columnSpacings addObject:columnSpacing];
            [result.columnSpacingSizes addObject:@(columnSpacing.size)];
        }
    }

    WeViewAssert([result.rowSizings count] == rowCount);
    WeViewAssert([result.rowSizes count] == rowCount);
    WeViewAssert([result.rowSpacings count] == rowCount - 1);
    WeViewAssert([result.rowSpacingSizes count] == rowCount - 1);
    WeViewAssert([result.columnSizings count] == columnCount);
    WeViewAssert([result.columnSizes count] == columnCount);
    WeViewAssert([result.columnSpacings count] == columnCount - 1);
    WeViewAssert([result.columnSpacingSizes count] == columnCount - 1);

    if (!allRowAndColumnsSizesAreFixed)
    {
        // If not all row and columns sizes are fixed, we calculate the desired size of all subviews.

        CGSize maxContentSize = CGSizeZero;
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
                if (((WeViewGridSizing *) result.rowSizings[row]).fixedSize &&
                    ((WeViewGridSizing *) result.columnSizings[column]).fixedSize)
                {
                    // Do nothing; this cell has a fixed desired size.
                }
                else
                {
                    CGSize maxCellSize = maxContentSize;
                    if (((WeViewGridSizing *) result.rowSizings[row]).fixedSize)
                    {
                        maxCellSize.height = ((WeViewGridSizing *) result.rowSizings[row]).fixedSize.floatValue;
                    }
                    else if (((WeViewGridSizing *) result.columnSizings[column]).fixedSize)
                    {
                        maxCellSize.width = ((WeViewGridSizing *) result.columnSizings[column]).fixedSize.floatValue;
                    }
                    CGSize subviewSize = [self desiredItemSize:subview
                                                       maxSize:isAbstractSizeQuery ? CGSizeZero : maxCellSize];
                    result.rowSizes[row] = @(MAX([result.rowSizes[row] floatValue],
                                                 subviewSize.height));
                    result.columnSizes[column] = @(MAX([result.columnSizes[column] floatValue],
                                                       subviewSize.width));
                }
            }
        }
    }

    if (self.isRowHeightUniform)
    {
        // Ensure all rows have the height of the tallest row.
        result.rowSizes = WeViewArrayOfFloatsWithValue(WeViewMaxFloats(result.rowSizes),
                                                       [result.rowSizes count]);
    }
    if (self.isColumnWidthUniform)
    {
        // Ensure all columns have the width of the widest column.
        result.columnSizes = WeViewArrayOfFloatsWithValue(WeViewMaxFloats(result.columnSizes),
                                                          [result.columnSizes count]);
    }

    if (isAbstractSizeQuery)
    {
        // No need to stretch in an abstract size query.
        return result;
    }

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
