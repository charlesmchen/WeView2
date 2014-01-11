//
//  WeViewGridLayout.h
//  WeView v2
//
//  Copyright (c) 2014 Charles Matthew Chen. All rights reserved.
//
//  Distributed under the Apache License v2.0.
//  http://www.apache.org/licenses/LICENSE-2.0.html
//

#pragma once

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "WeViewLayout.h"

// Represents the sizing behavior of a row or column in a grid layout.
@interface WeViewGridSizing : NSObject

// Optional.
//
// If specified, the column or row will have the given desired size, regardless of its contents.
// If it is not specified, the desired size of the column or row is based on its contents.
@property (nonatomic) NSNumber *fixedSize;

// If the stretchWeight is non-zero, the column or grid can stretch to fill any extra space in the layout
// using that stretch weight.  It can also contract if the layout's desired size overflows the available
// space.
//
// The default value is zero.
@property (nonatomic) CGFloat stretchWeight;

+ (WeViewGridSizing *)sizingWithSize:(int)size;

+ (WeViewGridSizing *)sizingWithStretchWeight:(CGFloat)stretchWeight;

+ (WeViewGridSizing *)sizingWithSize:(int)size
                       stretchWeight:(CGFloat)stretchWeight;

@end

#pragma mark -

@interface WeViewGridLayout : WeViewLayout

// The left margin of the contents of this view.
- (WeViewSpacing *)leftMarginInfo;
- (WeViewLayout *)setLeftMarginInfo:(WeViewSpacing *)value;

// The right margin of the contents of this view.
- (WeViewSpacing *)rightMarginInfo;
- (WeViewLayout *)setRightMarginInfo:(WeViewSpacing *)value;

// The top margin of the contents of this view.
- (WeViewSpacing *)topMarginInfo;
- (WeViewLayout *)setTopMarginInfo:(WeViewSpacing *)value;

// The bottom margin of the contents of this view.
- (WeViewSpacing *)bottomMarginInfo;
- (WeViewLayout *)setBottomMarginInfo:(WeViewSpacing *)value;

// The default horizontal spacing between subviews of this view.
- (WeViewSpacing *)defaultHSpacing;
- (WeViewLayout *)setDefaultHSpacing:(WeViewSpacing *)value;

// The default vertical spacing between subviews of this view.
- (WeViewSpacing *)defaultVSpacing;
- (WeViewLayout *)setDefaultVSpacing:(WeViewSpacing *)value;

// Optional.
//
// The default sizing behavior of all rows.  Only applies to rows for which no row-specific sizing behavior
// has been specified with rowSizings.
@property (nonatomic) WeViewGridSizing *defaultRowSizing;

// The default sizing behavior of all columns.  Only applies to columns for which no column-specific sizing
// behavior has been specified with columnSizings.
@property (nonatomic) WeViewGridSizing *defaultColumnSizing;

// Optional.
//
// Row-specific sizing behavior.
//
// All contents must be instances of WeViewGridSizing.
//
// The first element of rowSizings applies to the first (top-most row), etc.
//
// Does not need to exactly match the number of rows.  defaultRowSizing applies to any rows without a
// corresponding element in rowSizings.
@property (nonatomic) NSArray *rowSizings;

// Optional.
//
// Column-specific sizing behavior.
//
// All contents must be instances of WeViewGridSizing.
//
// The first element of columnSizings applies to the first (left-most column), etc.
//
// Does not need to exactly match the number of columns.  defaultColumnSizing applies to any columns without a
// corresponding element in columnSizings.
@property (nonatomic) NSArray *columnSizings;

// Optional.
//
// Specifies the spacing between specific rows.
//
// All contents must be instances of WeViewSpacing.
//
// The first element of rowSpacings applies to the spacing between the first and second rows, etc.
//
// Does not need to exactly match the number of spacings between rows.  defaultVSpacing applies to any
// spacings without a corresponding element in rowSpacings.
@property (nonatomic) NSArray *rowSpacings;

// Optional.
//
// Specifies the spacing between specific columns.
//
// All contents must be instances of WeViewSpacing.
//
// The first element of columnSpacings applies to the spacing between the first and second columns, etc.
//
// Does not need to exactly match the number of spacings between columns.  defaultHSpacing applies to any
// spacings without a corresponding element in columnSpacings.
@property (nonatomic) NSArray *columnSpacings;

// If YES, all rows will have the same height - the height of the tallest row.
//
// Default is NO.
@property (nonatomic) BOOL isRowHeightUniform;

// If YES, all columns will have the same width - the width of the widest column.
//
// Default is NO.
@property (nonatomic) BOOL isColumnWidthUniform;

// Factory method.
//
// columnCount: The number of columns in the grid.
+ (WeViewGridLayout *)gridLayoutWithColumnCount:(int)columnCount;

@end
