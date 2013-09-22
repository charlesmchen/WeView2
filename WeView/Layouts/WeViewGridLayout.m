//
//  WeViewGridLayout.m
//  WeView 2
//
//  Copyright (c) 2013 Charles Matthew Chen. All rights reserved.
//
//  Distributed under the Apache License v2.0.
//  http://www.apache.org/licenses/LICENSE-2.0.html
//

#import <QuartzCore/QuartzCore.h>

#import "UIView+WeView.h"
#import "WeViewGridLayout.h"
#import "WeViewMacros.h"

typedef struct
{
    int columnCount, rowCount;
} GridRowAndColumnCount;

#pragma mark - LayerGridInfo

@interface GridLayoutInfo : NSObject

@property (nonatomic) NSMutableArray *columnWidths;
@property (nonatomic) NSMutableArray *rowHeights;
@property (nonatomic) NSMutableArray *columnSpacings;
@property (nonatomic) NSMutableArray *rowSpacings;
@property (nonatomic) int maxColumnWidth;
@property (nonatomic) int maxRowHeight;

@end

#pragma mark -

@implementation GridLayoutInfo

- (int)rowCount
{
    return [self.rowHeights count];
}

- (int)columnCount
{
    return [self.columnWidths count];
}

- (CGSize)totalSpacingSize:(UIView *)superview
                    layout:(WeViewLayout *)layout
{
    CGSize result = CGSizeZero;
    for (NSNumber *columnSpacing in self.columnSpacings)
    {
        result.width += [columnSpacing floatValue];
    }
    for (NSNumber *rowSpacing in self.rowSpacings)
    {
        result.width += [rowSpacing floatValue];
    }
    return result;
}

- (CGSize)totalCellSize:(UIView *)superview
                 layout:(WeViewLayout *)layout
{
    int columnCount = self.columnCount;
    int rowCount = self.rowCount;
    CGSize result = CGSizeZero;
    for (int column=0; column < columnCount; column++)
    {
        result.width += [self.columnWidths[column] floatValue];
    }
    for (int row=0; row < rowCount; row++)
    {
        result.height += [self.rowHeights[row] floatValue];
    }
    return result;
}

- (CGSize)totalSize:(UIView *)superview
             layout:(WeViewLayout *)layout
{
    CGSize contentSize = CGSizeAdd([self totalCellSize:superview
                                       layout:layout],
                                   [self totalSpacingSize:superview
                                                   layout:layout]);
    return CGSizeMax(CGSizeZero,
                     CGSizeCeil(CGSizeAdd(contentSize,
                                          [layout insetSizeOfView:superview])));
}

@end

#pragma mark -

@interface WeViewGridLayout ()

@property (nonatomic) int columnCount;
@property (nonatomic) BOOL isGridUniform;
@property (nonatomic) GridStretchPolicy stretchPolicy;

@property (nonatomic) BOOL hasCellSizeHint;
@property (nonatomic) CGSize cellSizeHint;

@end

#pragma mark -

@implementation WeViewGridLayout

+ (WeViewGridLayout *)gridLayoutWithColumns:(int)columnCount
                              isGridUniform:(BOOL)isGridUniform
                              stretchPolicy:(GridStretchPolicy)stretchPolicy
                               cellSizeHint:(CGSize)cellSizeHint
{
    WeViewGridLayout *layout = [[WeViewGridLayout alloc] init];
    layout.columnCount = columnCount;
    layout.isGridUniform = isGridUniform;
    layout.stretchPolicy = stretchPolicy;
    layout.hasCellSizeHint = YES;
    layout.cellSizeHint = cellSizeHint;
    return layout;
}

+ (WeViewGridLayout *)gridLayoutWithColumns:(int)columnCount
                              isGridUniform:(BOOL)isGridUniform
                              stretchPolicy:(GridStretchPolicy)stretchPolicy
{
    WeViewGridLayout *layout = [[WeViewGridLayout alloc] init];
    layout.columnCount = columnCount;
    layout.isGridUniform = isGridUniform;
    layout.stretchPolicy = stretchPolicy;
    return layout;
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

- (GridLayoutInfo *)getGridLayoutInfo:(UIView *)view
                             subviews:(NSArray *)subviews
                                debug:(BOOL)debug
{
    GridLayoutInfo *result = [[GridLayoutInfo alloc] init];

    GridRowAndColumnCount rowAndColumnCount = [self rowAndColumnCount:subviews];
    int rowCount = rowAndColumnCount.rowCount;
    int columnCount = rowAndColumnCount.columnCount;

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
    result.maxColumnWidth = 0;
    result.maxRowHeight = 0;

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
                                               maxSize:maxSubviewSize];

            columnWidths[column] = MAX(columnWidths[column], subviewSize.width);
            result.maxColumnWidth = MAX(result.maxColumnWidth, subviewSize.width);
            rowHeights[row] = MAX(rowHeights[row], subviewSize.height);
            result.maxRowHeight = MAX(result.maxRowHeight, subviewSize.height);
        }

        if (self.isGridUniform)
        {
            for (int i=0; i < columnCount; i++)
            {
                columnWidths[i] = result.maxColumnWidth;
            }
            for (int i=0; i < rowCount; i++)
            {
                rowHeights[i] = result.maxRowHeight;
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
    //        NSLog(@"result.maxColumnWidth: %d",
    //              result.maxColumnWidth);
    //        NSLog(@"result.maxRowHeight: %d",
    //              result.maxRowHeight);
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
                                                       debug:debugMinSize];

    CGSize totalSize = [gridLayoutInfo totalSize:view
                                          layout:self];

    if (self.debugLayout)
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
                                                       debug:debugLayout];
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
