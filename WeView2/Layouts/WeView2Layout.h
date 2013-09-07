//
//  WeView2Layout.h
//  Unknown Project
//
//  Copyright (c) 2013 Charles Matthew Chen. All rights reserved.
//
//  Distributed under the Apache License v2.0.
//  http://www.apache.org/licenses/LICENSE-2.0.html
//

#pragma once

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "WeView2Common.h"

@interface WeView2Layout : NSObject

- (void)layoutContentsOfView:(UIView *)view
                    subviews:(NSArray *)subviews;

- (CGSize)minSizeOfContentsView:(UIView *)view
                       subviews:(NSArray *)subviews
                   thatFitsSize:(CGSize)size;

#pragma mark - Per-Layout Properties

// Layouts default to use the superview's properties (See: UIView+WeView2.h).  However, any values
// set on the layout itself with supercede values from the superview.

/* CODEGEN MARKER: Start */

// The left margin of the contents of this view.
- (CGFloat)leftMargin:(UIView *)view;
- (WeView2Layout *)setLeftMargin:(CGFloat)value;
// The right margin of the contents of this view.
- (CGFloat)rightMargin:(UIView *)view;
- (WeView2Layout *)setRightMargin:(CGFloat)value;
// The top margin of the contents of this view.
- (CGFloat)topMargin:(UIView *)view;
- (WeView2Layout *)setTopMargin:(CGFloat)value;
// The bottom margin of the contents of this view.
- (CGFloat)bottomMargin:(UIView *)view;
- (WeView2Layout *)setBottomMargin:(CGFloat)value;

// The vertical spacing between subviews of this view.
- (CGFloat)vSpacing:(UIView *)view;
- (WeView2Layout *)setVSpacing:(CGFloat)value;
// The horizontal spacing between subviews of this view.
- (CGFloat)hSpacing:(UIView *)view;
- (WeView2Layout *)setHSpacing:(CGFloat)value;

// The horizontal alignment of subviews of this view within their layout cells.
- (HAlign)contentHAlign:(UIView *)view;
- (WeView2Layout *)setContentHAlign:(HAlign)value;
// The vertical alignment of subviews within this view.
- (VAlign)contentVAlign:(UIView *)view;
- (WeView2Layout *)setContentVAlign:(VAlign)value;

// By default, if the content size (ie. the total subview size plus margins and spacing) of a WeView2 overflows its bounds, subviews are cropped to fit inside the available
// space.
//
// If cropSubviewOverflow is NO, no cropping occurs and subviews may overflow the bounds of their
// superview.
- (BOOL)cropSubviewOverflow:(UIView *)view;
- (WeView2Layout *)setCropSubviewOverflow:(BOOL)value;
// By default, cellPositioning has a value of CELL_POSITION_NORMAL and cell size is based on their desired size and they are aligned within their layout
// cell.
//
// If cellPositioning is set to CELL_POSITION_FILL, subviews fill the entire bounds of their layout cell, regardless of their desired
// size.
//
// If cellPositioning is set to CELL_POSITION_FILL_W_ASPECT_RATIO, subviews fill the entire bounds of their layout cell but retain the aspect ratio of their desired
// size.
//
// If cellPositioning is set to CELL_POSITION_FIT_W_ASPECT_RATIO, subviews are "fit" inside the bounds of their layout cell and retain the aspect ratio of their desired
// size.
- (CellPositioningMode)cellPositioning:(UIView *)view;
- (WeView2Layout *)setCellPositioning:(CellPositioningMode)value;

- (BOOL)debugLayout:(UIView *)view;
- (WeView2Layout *)setDebugLayout:(BOOL)value;
- (BOOL)debugMinSize:(UIView *)view;
- (WeView2Layout *)setDebugMinSize:(BOOL)value;

// ['// Convenience accessor(s) for the leftMargin and rightMargin properties.']
- (WeView2Layout *)setHMargin:(CGFloat)value;

// ['// Convenience accessor(s) for the topMargin and bottomMargin properties.']
- (WeView2Layout *)setVMargin:(CGFloat)value;

// ['// Convenience accessor(s) for the leftMargin, rightMargin, topMargin and bottomMargin', '// properties.']
- (WeView2Layout *)setMargin:(CGFloat)value;

// ['// Convenience accessor(s) for the hSpacing and vSpacing properties.']
- (WeView2Layout *)setSpacing:(CGFloat)value;

/* CODEGEN MARKER: End */

#pragma mark - Utility Methods

- (void)positionSubview:(UIView *)subview
            inSuperview:(UIView *)superview
               withSize:(CGSize)subviewSize
           inCellBounds:(CGRect)cellBounds
        cellPositioning:(CellPositioningMode)cellPositioning;

- (CGRect)contentBoundsOfView:(UIView *)view
                      forSize:(CGSize)size;

- (CGSize)insetSizeOfView:(UIView *)view;

- (CGSize)desiredItemSize:(UIView *)subview
                  maxSize:(CGSize)maxSize;

- (NSArray *)distributeSpace:(CGFloat)space
      acrossCellsWithWeights:(NSArray *)cellWeights;

- (void)distributeAdjustment:(CGFloat)totalAdjustment
                acrossValues:(NSMutableArray *)values
                 withWeights:(NSArray *)weights
                    withSign:(CGFloat)sign
                 withMaxZero:(BOOL)withMaxZero;

#pragma mark - Debug Methods

- (NSString *)indentPrefix:(int)indent;

- (int)viewHierarchyDistanceToWindow:(UIView *)view;

@end
