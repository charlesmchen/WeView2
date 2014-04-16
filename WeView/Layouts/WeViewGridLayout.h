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

- (CGFloat)leftMarginStretchWeight;
- (WeViewGridLayout *)setLeftMarginStretchWeight:(CGFloat)value;
- (CGFloat)rightMarginStretchWeight;
- (WeViewGridLayout *)setRightMarginStretchWeight:(CGFloat)value;
- (CGFloat)topMarginStretchWeight;
- (WeViewGridLayout *)setTopMarginStretchWeight:(CGFloat)value;
- (CGFloat)bottomMarginStretchWeight;
- (WeViewGridLayout *)setBottomMarginStretchWeight:(CGFloat)value;

/* CODEGEN MARKER: Properties Start */

// Optional.
// 
// The default sizing behavior of all rows.  Only applies to rows for which no row-specific
// sizing behavior has been specified with
// rowSizings.
- (WeViewGridSizing *)defaultRowSizing;
- (WeViewGridLayout *)setDefaultRowSizing:(WeViewGridSizing *)value;

// Optional.
// 
// The default sizing behavior of all columns.  Only applies to columns for which no
// column-specific sizing behavior has been specified with
// columnSizings.
- (WeViewGridSizing *)defaultColumnSizing;
- (WeViewGridLayout *)setDefaultColumnSizing:(WeViewGridSizing *)value;

// Optional.
// 
// Row-specific sizing behavior.
// 
// All contents must be instances of WeViewGridSizing.
// 
// The first element of rowSizings applies to the first (top-most row), etc.
// 
// Does not need to exactly match the number of rows.  defaultRowSizing applies to any rows
// without a corresponding element in
// rowSizings.
- (NSArray *)rowSizings;
- (WeViewGridLayout *)setRowSizings:(NSArray *)value;

// Optional.
// 
// Column-specific sizing behavior.
// 
// All contents must be instances of WeViewGridSizing.
// 
// The first element of columnSizings applies to the first (left-most column), etc.
// 
// Does not need to exactly match the number of columns.  defaultColumnSizing applies to any
// columns without a corresponding element in
// columnSizings.
- (NSArray *)columnSizings;
- (WeViewGridLayout *)setColumnSizings:(NSArray *)value;

// Optional.
// 
// The default vertical spacing between subviews of this view.
- (WeViewSpacing *)defaultRowSpacing;
- (WeViewGridLayout *)setDefaultRowSpacing:(WeViewSpacing *)value;

// Optional.
// 
// The default horizontal spacing between subviews of this view.
- (WeViewSpacing *)defaultColumnSpacing;
- (WeViewGridLayout *)setDefaultColumnSpacing:(WeViewSpacing *)value;

// Optional.
// 
// Specifies the spacing between specific rows.
// 
// All contents must be instances of WeViewSpacing.
// 
// The first element of rowSpacings applies to the spacing between the first and second rows,
// etc.
// 
// Does not need to exactly match the number of spacings between rows.  defaultVSpacing applies
// to any spacings without a corresponding element in
// rowSpacings.
- (NSArray *)rowSpacings;
- (WeViewGridLayout *)setRowSpacings:(NSArray *)value;

// Optional.
// 
// Specifies the spacing between specific columns.
// 
// All contents must be instances of WeViewSpacing.
// 
// The first element of columnSpacings applies to the spacing between the first and second
// columns,
// etc.
// 
// Does not need to exactly match the number of spacings between columns.  defaultHSpacing
// applies to any spacings without a corresponding element in
// columnSpacings.
- (NSArray *)columnSpacings;
- (WeViewGridLayout *)setColumnSpacings:(NSArray *)value;

// If YES, all rows will have the same height - the height of the tallest row.
// 
// Default is NO.
- (BOOL)isRowHeightUniform;
- (WeViewGridLayout *)setIsRowHeightUniform:(BOOL)value;

// If YES, all columns will have the same width - the width of the widest column.
// 
// Default is NO.
- (BOOL)isColumnWidthUniform;
- (WeViewGridLayout *)setIsColumnWidthUniform:(BOOL)value;

/* CODEGEN MARKER: Properties End */

#pragma mark - Factory methods

// Factory method.
//
// maxColumnCount: The maximum number of columns in the grid.  If zero, the subviews will be
// layed out with as many columns as subviews (ie. horizontally).
+ (WeViewGridLayout *)gridLayoutWithMaxColumnCount:(int)maxColumnCount;

// Factory method.
//
// maxRowCount: The maximum number of rows in the grid.  If zero, the subviews will be
// layed out with as many rows as subviews (ie. vertically).
+ (WeViewGridLayout *)gridLayoutWithMaxRowCount:(int)maxRowCount;

#pragma mark - Convenience accessors

- (WeViewGridLayout *)setMarginStretchWeight:(CGFloat)value;
- (WeViewGridLayout *)setHMarginStretchWeight:(CGFloat)value;
- (WeViewGridLayout *)setVMarginStretchWeight:(CGFloat)value;

- (WeViewGridLayout *)setDefaultSpacing:(WeViewSpacing *)value;
- (WeViewGridLayout *)setDefaultSpacingSize:(int)value;
- (WeViewGridLayout *)setDefaultSpacingStretchWeight:(CGFloat)value;

@end
