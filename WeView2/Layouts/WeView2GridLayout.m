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

@property (nonatomic) NSArray *columnWidths;
@property (nonatomic) NSArray *rowHeights;
@property (nonatomic) int maxColumnWidth;
@property (nonatomic) int maxRowHeight;
@property (nonatomic) CGSize contentSize;
@property (nonatomic) CGSize totalSize;

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

@end

#pragma mark -

//@interface WeView2GridLayout ()
//
//@property (nonatomic) int columnCount;
//@property (nonatomic) BOOL isGridUniform;
//
//@property (nonatomic) BOOL hasFixedCellSize;
//@property (nonatomic) CGSize fixedCellSize;
//
//@end
//
//#pragma mark -
//
//@implementation WeView2GridLayout
//
//- (id)init
//{
//    self = [super init];
//    if (self)
//    {
//    }
//    return self;
//}
//
//- (void)dealloc
//{
//}
//
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
//
//- (GridRowAndColumnCount)rowAndColumnCount:(NSArray *)subviews
//{
//    GridRowAndColumnCount result;
//    if (self.columnCount > 0) {
//        result.columnCount = self.columnCount;
//        result.rowCount = ceilf([subviews count] / (CGFloat) result.columnCount);
//    } else {
//        result.columnCount = [subviews count];
//        result.rowCount = 1;
//    }
//    return result;
//}
//
//- (NSArray *)toNSFloatArray:(CGFloat *)values
//                      count:(int)count
//{
//    NSMutableArray *result = [NSMutableArray array];
//    for (int i=0; i < count; i++) {
//        [result addObject:@(values[i])];
//    }
//    return result;
//}
//
//- (GridLayoutInfo *)getGridLayoutInfo:(UIView *)view
//                             subviews:(NSArray *)subviews
// debug:(BOOL)debug
//{
//    BOOL debugMinSize = [self debugMinSize:view];
//    BOOL debugLayout = [self debugLayout:view];
//
//    GridLayoutInfo *result = [[GridLayoutInfo alloc] init];
//
//    GridRowAndColumnCount rowAndColumnCount = [self rowAndColumnCount:subviews];
//    int rowCount = rowAndColumnCount.rowCount;
//    int columnCount = rowAndColumnCount.columnCount;
//
//    // TODO: Use a two-pass approach where subview size calculation is based first on "guide size",
//    // then on attempt to trim if necessary.
//    CGRect contentBounds = [self contentBoundsOfView:view
//                                             forSize:CGSizeZero];
//    CGSize maxSubviewSize = contentBounds.size;
//    maxSubviewSize.width = MAX(0, maxSubviewSize.width - [self hSpacing:view] * (columnCount - 1));
//    maxSubviewSize.height = MAX(0, maxSubviewSize.height - [self vSpacing:view] * (rowCount - 1));
//    if (self.isGridUniform) {
//        if (columnCount > 0)
//        {
//            maxSubviewSize.width = floorf(maxSubviewSize.width * (1.f / columnCount));
//        }
//        if (rowCount > 0)
//        {
//            maxSubviewSize.height = floorf(maxSubviewSize.height * (1.f / rowCount));
//        }
//    }
//    else
//    {
//        // TODO: The "non-uniform" case is quite complicated due to subview flow.
//        maxSubviewSize = CGSizeZero;
//    }
//
//    CGFloat columnWidths[columnCount];
//    CGFloat rowHeights[rowCount];
//    for (int column=0; column < columnCount; column++) {
//        columnWidths[column] = 0;
//    }
//    for (int row=0; row < rowCount; row++) {
//        rowHeights[row] = 0;
//    }
//    result.maxColumnWidth = 0;
//    result.maxRowHeight = 0;
//
//    if (self.hasFixedCellSize)
//    {
//        for (int i=0; i < columnCount; i++) {
//            columnWidths[i] = self.fixedCellSize.width;
//        }
//        for (int i=0; i < rowCount; i++) {
//            rowHeights[i] = self.fixedCellSize.height;
//        }
//    }
//    else if (!view.ignoreDesiredSize)
//    {
//        int index = 0;
//        for (UIView* subview in subviews) {
//            int row = index / columnCount;
//            int column = index % columnCount;
//            index++;
//
//            CGSize subviewSize = [self desiredItemSize:subview
//                                               maxSize:maxSubviewSize];
//
//            //        if (layer.debugLayout) {
//            //            NSLog(@"%@[%d][%d] desired size: %@",
//            //                  [item class],
//            //                  column,
//            //                  row,
//            //                  FormatSize(itemSize));
//            //        }
//
//            columnWidths[column] = MAX(columnWidths[column], subviewSize.width);
//            result.maxColumnWidth = MAX(result.maxColumnWidth, subviewSize.width);
//            rowHeights[row] = MAX(rowHeights[row], subviewSize.height);
//            result.maxRowHeight = MAX(result.maxRowHeight, subviewSize.height);
//        }
//
//        if (self.isGridUniform) {
//            for (int i=0; i < columnCount; i++) {
//                columnWidths[i] = result.maxColumnWidth;
//            }
//            for (int i=0; i < rowCount; i++) {
//                rowHeights[i] = result.maxRowHeight;
//            }
//        }
//    }
//
//    result.columnWidths = [self toNSFloatArray:&(columnWidths[0])
//                                         count:columnCount];
//    result.rowHeights = [self toNSFloatArray:&(rowHeights[0])
//                                       count:rowCount];
//
//    CGSize contentSize = CGSizeZero;
//    for (int column=0; column < columnCount; column++) {
//        contentSize.width += columnWidths[column];
//    }
//    for (int row=0; row < rowCount; row++) {
//        contentSize.height += rowHeights[row];
//    }
//    contentSize.width += [self hSpacing:view] * (columnCount - 1);
//    contentSize.height += [self vSpacing:view] * (rowCount - 1);
//    result.contentSize = contentSize;
//
//    result.totalSize = CGSizeAdd(contentSize,
//                                 [self insetSizeOfView:view]);
//
//    //    if (layer.debugLayout) {
//    //        NSLog(@"result.columnCount: %d",
//    //              columnCount);
//    //        NSLog(@"result.rowCount: %d",
//    //              rowCount);
//    //        for (int i=0; i < result.columnCount; i++) {
//    //            NSLog(@"result.columnWidths[%d]: %d",
//    //                  i, result.columnWidths[i]);
//    //        }
//    //        for (int i=0; i < result.rowCount; i++) {
//    //            NSLog(@"result.rowHeights[%d]: %d",
//    //                  i, result.rowHeights[i]);
//    //        }
//    //        NSLog(@"result.maxColumnWidth: %d",
//    //              result.maxColumnWidth);
//    //        NSLog(@"result.maxRowHeight: %d",
//    //              result.maxRowHeight);
//    //        NSLog(@"result.contentSize: %@",
//    //              FormatSize(result.contentSize));
//    //        NSLog(@"result.totalSize: %@",
//    //              FormatSize(result.totalSize));
//    //    }
//
//    return result;
//}
//
//- (IntSize)sumContentSize:(CGSize *)subviewSizes
//             subviewCount:(int)subviewCount
//               horizontal:(BOOL)horizontal
//{
//    // Sum the "content size" ie. the minimum desired size of the subviews.
//    // This doesn't include the margins, border, spacing, etc.
//    IntSize result = IntSizeZero();
//    for (int i=0; i < subviewCount; i++)
//    {
//        if (horizontal)
//        {
//            result.width += subviewSizes[i].width;
//            result.height = MAX(result.height, subviewSizes[i].height);
//        }
//        else
//        {
//            result.width = MAX(result.width, subviewSizes[i].width);
//            result.height += subviewSizes[i].height;
//        }
//    }
//    return result;
//}
//
//- (void)getStretchWeightsForSubviews:(NSArray *)subviews
//                        subviewCount:(int)subviewCount
//                      stretchWeights:(CGFloat *)stretchWeights
//                  totalStretchWeight:(CGFloat *)totalStretchWeight
//                        stretchCount:(int *)stretchCount
//{
//    WeView2Assert([subviews count] == subviewCount);
//
//    // Total stretch weight of subviews along the axis of layout.
//    *totalStretchWeight = 0;
//    // The number of subviews with flexible size along the axis of layout.
//    *stretchCount = 0;
//
//    for (int i=0; i < subviewCount; i++)
//    {
//        UIView* subview = subviews[i];
//        stretchWeights[i] = (self.isHorizontal
//                             ? subview.hStretchWeight
//                             : subview.vStretchWeight);
//
//        WeView2Assert(stretchWeights[i] >= 0);
//        // TODO: Should not be necessary.
//        stretchWeights[i] = fabsf(stretchWeights[i]);
//
//        if (stretchWeights[i] > 0)
//        {
//            *totalStretchWeight += stretchWeights[i];
//            *stretchCount = *stretchCount + 1;
//        }
//    }
//}
//
// TODO: Do we need to honor other params as well?
//- (CGSize)minSizeOfContentsView:(UIView *)view
//                       subviews:(NSArray *)subviews
//                   thatFitsSize:(CGSize)guideSize
//{
//    GridLayoutInfo *gridLayoutInfo = [self getGridLayoutInfo:view
//                                                    subviews:subviews];
//    if (view.debugLayout)
//    {
//        NSLog(@"- minSizeOfContentsView: %@ thatFitsSize:%@ = %@",
//              [view class],
//              NSStringFromCGSize(guideSize),
//              NSStringFromCGSize(gridLayoutInfo.totalSize));
//    }
//    return gridLayoutInfo.totalSize;
//}
//
//- (void)dumpItemSizes:(NSString *)label
//             subviews:(NSArray *)subviews
//         subviewSizes:(CGSize *)subviewSizes
//       stretchWeights:(CGFloat *)stretchWeights
//{
//    for (int i=0; i < [subviews count]; i++)
//    {
//        UIView* subview = subviews[i];
//
//        NSLog(@"\t%@[%d] %@ size: %@, stretchWeight: %f",
//              label,
//              i,
//              [subview class],
//              FormatSize(subviewSizes[i]),
//              stretchWeights[i]);
//    }
//}
//
//- (void)layoutContentsOfView:(UIView *)view
//                    subviews:(NSArray *)subviews
//{
//    BOOL debugLayout = [self debugLayout:view];
//
//    if (debugLayout)
//    {
//        NSLog(@"layoutContentsOfView: %@ (%@) %@",
//              [view class], view.debugName, NSStringFromCGSize(view.size));
//    }
//
//    GridLayoutInfo *gridLayoutInfo = [self getGridLayoutInfo:view
//                                                    subviews:subviews];
//
//    if (self.hasFixedCellSize)
//    {
//        for (int i=0; i < columnCount; i++) {
//            columnWidths[i] = self.fixedCellSize.width;
//        }
//        for (int i=0; i < rowCount; i++) {
//            rowHeights[i] = self.fixedCellSize.height;
//        }
//    }
//
//    if (self.isGridUniform)
//    {
//
//    }
//
//    BOOL horizontal = self.isHorizontal;
//    int subviewCount = [subviews count];
//
//    CGFloat totalStretchWeight;
//    int stretchCount;
//    CGFloat stretchWeights[subviewCount];
//    [self getStretchWeightsForSubviews:subviews
//                          subviewCount:subviewCount
//                        stretchWeights:&(stretchWeights[0])
//                    totalStretchWeight:&totalStretchWeight
//                          stretchCount:&stretchCount];
//
//    CGSize guideSize = view.size;
//    CGFloat spacing = ceilf(horizontal ? [self hSpacing:view] : [self vSpacing:view]);
//    CGRect contentBounds = [self contentBoundsOfView:view
//                                             forSize:guideSize];
//    CGSize maxSubviewSize = contentBounds.size;
//    if (horizontal)
//    {
//        maxSubviewSize.width = MAX(0, maxSubviewSize.width - spacing * (subviewCount - 1));
//    }
//    else
//    {
//        maxSubviewSize.height = MAX(0, maxSubviewSize.height - spacing * (subviewCount - 1));
//    }
//
//    if (debugLayout)
//    {
//        NSLog(@"minSizeOfContentsView: contentBounds: %@, guideSize: %@, insetSizeOfView: %@",
//              FormatRect(contentBounds),
//              FormatSize(guideSize),
//              FormatSize([self insetSizeOfView:view]));
//    }
//
//    CGSize subviewSizes[subviewCount];
//    for (int i=0; i < subviewCount; i++)
//    {
//        UIView* subview = subviews[i];
//
//        subviewSizes[i] = [self desiredItemSize:subview
//                                        maxSize:maxSubviewSize];
//    }
//
//    if (debugLayout)
//    {
//        NSLog(@"layoutContentsOfView (%@ %@) maxSubviewSize: %@, guideSize: %@, insetSizeOfView: %@",
//              [view class], view.debugName,
//              FormatSize(maxSubviewSize),
//              FormatSize(view.size),
//              FormatSize([self insetSizeOfView:view]));
//    }
//
//    IntSize contentSize = [self sumContentSize:&subviewSizes[0]
//                                  subviewCount:subviewCount
//                                    horizontal:horizontal];
//
//    if (debugLayout)
//    {
//        [self dumpItemSizes:@"layoutContentsOfView: (ideal)"
//                   subviews:subviews
//               subviewSizes:subviewSizes
//             stretchWeights:stretchWeights];
//    }
//
//    // Check to see if we need to crop our content.
//    if (YES)
//    {
//        int extraAxisSpaceRaw;
//        int axisSize;
//        if (horizontal)
//        {
//            axisSize = contentSize.width;
//            extraAxisSpaceRaw = maxSubviewSize.width - contentSize.width;
//        }
//        else
//        {
//            axisSize = contentSize.height;
//            extraAxisSpaceRaw = maxSubviewSize.height - contentSize.height;
//        }
//
//        if (debugLayout)
//        {
//            NSLog(@"\t axisSize: %d, extraAxisSpaceRaw: %d, contentSize: %@, maxSubviewSize: %@",
//                  axisSize,
//                  extraAxisSpaceRaw,
//                  FormatIntSize(contentSize),
//                  FormatSize(maxSubviewSize)
//                  );
//        }
//
//        if (extraAxisSpaceRaw < 0)
//        {
//            // Can't fit everything; we need to crop.
//            int totalCropAmount = -extraAxisSpaceRaw;
//            int remainingCropAmount = totalCropAmount;
//            // We want to crop proportionally, so that we crop more
//            // from larger subviews.
//            CGFloat cropFactor = clamp01(remainingCropAmount / (CGFloat) axisSize);
//            for (int i=0; i < subviewCount; i++)
//            {
//                int cropAmount;
//                // round up the amount to crop.
//                if (horizontal)
//                {
//                    cropAmount = ceilf(subviewSizes[i].width * cropFactor);
//                }
//                else
//                {
//                    cropAmount = ceilf(subviewSizes[i].height * cropFactor);
//                }
//                // Don't crop more than enough to exactly fit non-stretch subviews in panel.
//                cropAmount = MIN(remainingCropAmount, cropAmount);
//                remainingCropAmount -= cropAmount;
//                if (horizontal)
//                {
//                    subviewSizes[i].width -= cropAmount;
//
//                    // For "wrapping" subviews, reducing the width can increase
//                    // the height.
//                    UIView* subview = subviews[i];
//                    subviewSizes[i].height = [subview sizeThatFits:CGSizeMake(subviewSizes[i].width,
//                                                                              maxSubviewSize.height)].height;
//                }
//                else
//                {
//                    subviewSizes[i].height -= cropAmount;
//                }
//            }
//
//            // Update content size
//            contentSize = [self sumContentSize:&subviewSizes[0]
//                                  subviewCount:subviewCount
//                                    horizontal:horizontal];
//
//            if (debugLayout)
//            {
//                [self dumpItemSizes:@"layoutContentsOfView: (after crop)"
//                           subviews:subviews
//                       subviewSizes:subviewSizes
//                     stretchWeights:stretchWeights];
//            }
//        }
//    }
//
//    // If layer stretches, we want to do a second pass that calculates the
//    // size of stretching subviews.
//    if (YES)
//    {
//        int stretchCountRemainder = stretchCount;
//        int stretchTotal;
//        if (horizontal)
//        {
//            stretchTotal = maxSubviewSize.width - contentSize.width;
//        }
//        else
//        {
//            stretchTotal = maxSubviewSize.height - contentSize.height;
//        }
//        int stretchRemainder = stretchTotal;
//
//        if (debugLayout)
//        {
//            NSLog(@"contentSize.width: %d, contentSize.height: %d, stretchCountRemainder: %d, stretchTotal: %d, stretchRemainder: %d, totalStretchWeight: %f",
//                  contentSize.width,
//                  contentSize.height,
//                  stretchCountRemainder,
//                  stretchTotal,
//                  stretchRemainder,
//                  totalStretchWeight);
//        }
//
//        if (stretchRemainder > 0 && stretchCountRemainder > 0)
//        {
//            // This is actually a series of passes.
//            // With each "stretch" pass, we evenly divide the remainder of the available
//            // space between the remaining stretch subviews based on their stretch weight.
//            //
//            // More than one pass is necessary, since subviews may have a maximum stretch
//            // size.
//            while (stretchRemainder > 0 && stretchCountRemainder > 0)
//            {
//                for (int i=0; i < subviewCount; i++)
//                {
//                    // ignore non-stretching subviews.
//                    if (!(stretchWeights[i] > 0))
//                    {
//                        continue;
//                    }
//
//                    // Divide the remaining stretch space evenly between the stretching
//                    // subviews in this layer.
//                    int subviewStretch;
//                    if (stretchCountRemainder == 1)
//                    {
//                        subviewStretch = stretchRemainder;
//                    }
//                    else
//                    {
//                        subviewStretch = floorf(stretchTotal * stretchWeights[i] / totalStretchWeight);
//                    }
//                    stretchCountRemainder--;
//                    stretchRemainder -= subviewStretch;
//
//                    CGSize subviewSize = subviewSizes[i];
//                    if (horizontal)
//                    {
//                        subviewSize.width += subviewStretch;
//                    }
//                    else
//                    {
//                        subviewSize.height += subviewStretch;
//                    }
//                    subviewSizes[i] = subviewSize;
//                }
//            }
//
//            // Update content size
//            contentSize = [self sumContentSize:&subviewSizes[0]
//                                  subviewCount:subviewCount
//                                    horizontal:horizontal];
//
//            if (debugLayout)
//            {
//                [self dumpItemSizes:@"layoutContentsOfView: (after stretch)"
//                           subviews:subviews
//                       subviewSizes:subviewSizes
//                     stretchWeights:stretchWeights];
//
//                NSLog(@"contentSize: %@",
//                      FormatIntSize(contentSize));
//            }
//        }
//    }
//
//    int crossSize = horizontal ? maxSubviewSize.height : maxSubviewSize.width;
//    int axisIndex = horizontal ? contentBounds.origin.x : contentBounds.origin.y;
//
//    // Honor the axis alignment.
//    if (horizontal)
//    {
//        int extraAxisSpace = maxSubviewSize.width - contentSize.width;
//        switch ([self hAlign:view])
//        {
//            case H_ALIGN_LEFT:
//                break;
//            case H_ALIGN_CENTER:
//                axisIndex += extraAxisSpace / 2;
//                break;
//            case H_ALIGN_RIGHT:
//                axisIndex += extraAxisSpace;
//                break;
//            default:
//                WeView2Assert(0);
//                break;
//        }
//    }
//    else
//    {
//        int extraAxisSpace = maxSubviewSize.height - contentSize.height;
//        switch ([self vAlign:view])
//        {
//            case V_ALIGN_BOTTOM:
//                axisIndex += extraAxisSpace;
//                break;
//            case V_ALIGN_CENTER:
//                axisIndex += extraAxisSpace / 2;
//                break;
//            case V_ALIGN_TOP:
//                break;
//            default:
//                WeView2Assert(0);
//                break;
//        }
//    }
//
//    // Calculate and apply the subviews' frames.
//    for (int i=0; i < subviewCount; i++)
//    {
//        UIView* subview = subviews[i];
//        CGSize subviewSize = subviewSizes[i];
//
//        int crossIndex = horizontal ? contentBounds.origin.y : contentBounds.origin.x;
//        CGRect cellBounds = CGRectMake(horizontal ? axisIndex : crossIndex,
//                                       horizontal ? crossIndex : axisIndex,
//                                       horizontal ? subviewSize.width : crossSize,
//                                       horizontal ? crossSize : subviewSize.height);
//
//        [self positionSubview:subview
//                  inSuperview:view
//                     withSize:subviewSize
//                 inCellBounds:cellBounds];
//
//        if (debugLayout)
//        {
//            NSLog(@"layoutContentsOfView (%@ %@) final subview(%@): %@, raw subviewSize: %@",
//                  [view class], view.debugName,
//                  [subview class], FormatRect(subview.frame), FormatCGSize(subviewSize));
//        }
//
//        axisIndex = (horizontal ? subview.right : subview.bottom) + spacing;
//    }
//}
//
//@end
