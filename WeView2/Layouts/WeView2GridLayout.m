//
//  WeView2GridLayout.m
//  Unknown Project
//
//  Copyright (c) 2013 Charles Matthew Chen. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "UIView+WeView2.h"
#import "WeView2GridLayout.h"
#import "WeView2Macros.h"

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
                    layout:(WeView2Layout *)layout
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
                 layout:(WeView2Layout *)layout
{
    int columnCount = self.columnCount;
    int rowCount = self.rowCount;
    CGSize result = CGSizeZero;
    for (int column=0; column < columnCount; column++) {
        result.width += [self.columnWidths[column] floatValue];
    }
    for (int row=0; row < rowCount; row++) {
        result.height += [self.rowHeights[row] floatValue];
    }
    return result;
}

- (CGSize)totalSize:(UIView *)superview
             layout:(WeView2Layout *)layout
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

@interface WeView2GridLayout ()

@property (nonatomic) int columnCount;
@property (nonatomic) BOOL isGridUniform;

// TODO: Rename?
@property (nonatomic) BOOL hasFixedCellSize;
@property (nonatomic) CGSize fixedCellSize;

@property (nonatomic) GridStretchPolicy stretchPolicy;

@end

#pragma mark -

@implementation WeView2GridLayout

//+ (WeView2GridLayout *)horizontalLayout
//{
//    WeView2GridLayout *layout = [[WeView2GridLayout alloc] init];
//    layout.isHorizontal = YES;
//    return layout;
//}
//
//+ (WeView2GridLayout *)verticalLayout
//{
//    WeView2GridLayout *layout = [[WeView2GridLayout alloc] init];
//    layout.isHorizontal = NO;
//    return layout;
//}

- (GridRowAndColumnCount)rowAndColumnCount:(NSArray *)subviews
{
    GridRowAndColumnCount result;
    if (self.columnCount > 0) {
        result.columnCount = self.columnCount;
        result.rowCount = ceilf([subviews count] / (CGFloat) result.columnCount);
    } else {
        result.columnCount = [subviews count];
        result.rowCount = 1;
    }
    return result;
}

- (NSMutableArray *)toNSFloatArray:(CGFloat *)values
                             count:(int)count
{
    NSMutableArray *result = [NSMutableArray array];
    for (int i=0; i < count; i++) {
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
    CGFloat hSpacing = ceilf([self hSpacing:view]);
    CGFloat vSpacing = ceilf([self vSpacing:view]);
    maxSubviewSize.width = MAX(0, maxSubviewSize.width - hSpacing * (columnCount - 1));
    maxSubviewSize.height = MAX(0, maxSubviewSize.height - vSpacing * (rowCount - 1));
    if (self.isGridUniform) {
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
    for (int column=0; column < columnCount; column++) {
        columnWidths[column] = 0;
    }
    for (int row=0; row < rowCount; row++) {
        rowHeights[row] = 0;
    }
    result.maxColumnWidth = 0;
    result.maxRowHeight = 0;

    if (self.hasFixedCellSize)
    {
        for (int i=0; i < columnCount; i++) {
            columnWidths[i] = self.fixedCellSize.width;
        }
        for (int i=0; i < rowCount; i++) {
            rowHeights[i] = self.fixedCellSize.height;
        }
    }
    else if (!view.ignoreDesiredSize)
    {
        int index = 0;
        for (UIView* subview in subviews) {
            int row = index / columnCount;
            int column = index % columnCount;
            index++;

            CGSize subviewSize = [self desiredItemSize:subview
                                               maxSize:maxSubviewSize];

            //        if (layer.debugLayout) {
            //            NSLog(@"%@[%d][%d] desired size: %@",
            //                  [item class],
            //                  column,
            //                  row,
            //                  FormatSize(itemSize));
            //        }

            columnWidths[column] = MAX(columnWidths[column], subviewSize.width);
            result.maxColumnWidth = MAX(result.maxColumnWidth, subviewSize.width);
            rowHeights[row] = MAX(rowHeights[row], subviewSize.height);
            result.maxRowHeight = MAX(result.maxRowHeight, subviewSize.height);
        }

        if (self.isGridUniform) {
            for (int i=0; i < columnCount; i++) {
                columnWidths[i] = result.maxColumnWidth;
            }
            for (int i=0; i < rowCount; i++) {
                rowHeights[i] = result.maxRowHeight;
            }
        }
    }

    // Normalize the column and row sizes.
    for (int i=0; i < columnCount; i++) {
        columnWidths[i] = MAX(0, ceilf(columnWidths[i]));
    }
    for (int i=0; i < rowCount; i++) {
        rowHeights[i] = MAX(0, ceilf(rowHeights[i]));
    }

    result.columnWidths = [self toNSFloatArray:&(columnWidths[0])
                                         count:columnCount];
    result.rowHeights = [self toNSFloatArray:&(rowHeights[0])
                                       count:rowCount];

    result.columnSpacings = [NSMutableArray array];
    for (int i=0; i < columnCount - 1; i++) {
        [result.columnSpacings addObject:@(hSpacing)];
    }
    result.rowSpacings = [NSMutableArray array];
    for (int i=0; i < rowCount - 1; i++) {
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
    //              FormatSize(result.contentSize));
    //        NSLog(@"result.totalSize: %@",
    //              FormatSize(result.totalSize));
    //    }

    return result;
}

// TODO: Do we need to honor other params as well?
- (CGSize)minSizeOfContentsView:(UIView *)view
                       subviews:(NSArray *)subviews
                   thatFitsSize:(CGSize)guideSize
{
    if ([subviews count] < 1)
    {
        return [self insetSizeOfView:view];
    }

    BOOL debugMinSize = [self debugMinSize:view];
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

    if (view.debugLayout)
    {
        NSLog(@"%@ result: %@",
              [self indentPrefix:indent + 1],
              NSStringFromCGSize(totalSize));
    }
    return totalSize;
}

- (void)distributeAdjustment:(CGFloat)totalAdjustment
                acrossValues:(NSMutableArray *)values
                 withWeights:(NSArray *)weights
                 withMaxZero:(BOOL)withMaxZero
{
    WeView2Assert([values count] == [weights count]);
    NSArray *adjustments = [self distributeSpace:roundf(totalAdjustment)
                          acrossCellsWithWeights:weights];
    WeView2Assert([values count] == [adjustments count]);
    int count = [values count];
    for (int i=0; i < count; i++)
    {
        CGFloat newValue = roundf([values[i] floatValue] - [adjustments[i] floatValue]);
        if (withMaxZero)
        {
            newValue = MAX(0.f, newValue);
        }
        values[i] = @(newValue);
    }
}

- (void)layoutContentsOfView:(UIView *)view
                    subviews:(NSArray *)subviews
{
    if ([subviews count] < 1)
    {
        return;
    }
    BOOL debugLayout = [self debugLayout:view];
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
        switch (self.stretchPolicy) {
            case GRID_STRETCH_POLICY_STRETCH_CELLS:
            {
                // Stretch the cells, distributing the extra space evenly between them.
                [self distributeAdjustment:extraCellSpace.width
                              acrossValues:gridLayoutInfo.columnWidths
                               withWeights:gridLayoutInfo.columnWidths
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
                               withMaxZero:YES];
                break;
            }
            case GRID_STRETCH_POLICY_NO_STRETCH:
            {
                // Don't stretch cells or spacing; instead align grid body within the extra space.
                switch ([self contentHAlign:view])
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
                        WeView2Assert(0);
                        break;
                }
                break;
            }
            default:
                WeView2Assert(0);
                break;
        }
    }
    else if (extraCellSpace.width < 0)
    {
        if (view.cropSubviewOverflow)
        {
            // Crop the width of cells based on their existing width - ie. crop wider columns more.
            [self distributeAdjustment:-extraCellSpace.width
                          acrossValues:gridLayoutInfo.columnWidths
                           withWeights:gridLayoutInfo.columnWidths
                           withMaxZero:YES];
        }
    }
    if (extraCellSpace.height > 0)
    {
        switch (self.stretchPolicy) {
            case GRID_STRETCH_POLICY_STRETCH_CELLS:
            {
                // Stretch the cells, distributing the extra space evenly between them.
                [self distributeAdjustment:extraCellSpace.height
                              acrossValues:gridLayoutInfo.rowHeights
                               withWeights:gridLayoutInfo.rowHeights
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
                               withMaxZero:YES];
                break;
            }
            case GRID_STRETCH_POLICY_NO_STRETCH:
            {
                // Don't stretch cells or spacing; instead align grid body within the extra space.
                switch ([self contentVAlign:view])
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
                        WeView2Assert(0);
                        break;
                }
                break;
            }
            default:
                WeView2Assert(0);
                break;
        }
    }
    else if (extraCellSpace.height < 0)
    {
        if (view.cropSubviewOverflow)
        {
            // Crop the height of cells based on their existing height - ie. crop taller rows more.
            [self distributeAdjustment:-extraCellSpace.height
                          acrossValues:gridLayoutInfo.rowHeights
                           withWeights:gridLayoutInfo.rowHeights
                           withMaxZero:YES];
        }
    }

    // Calculate and apply the subviews' frames.
    CellPositioningMode cellPositioning = [self cellPositioning:view];
    CGPoint cellOrigin = cellsOrigin;
    int subviewCount = [subviews count];
    for (int i=0; i < subviewCount; i++)
    {
        UIView* subview = subviews[i];
        int row = i / columnCount;
        int column = i % columnCount;
        WeView2Assert(column < gridLayoutInfo.columnCount);
        WeView2Assert(row < gridLayoutInfo.rowCount);
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
                  FormatRect(subview.frame),
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
