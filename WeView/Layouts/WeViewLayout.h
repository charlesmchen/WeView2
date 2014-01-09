//
//  WeViewLayout.h
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

#import "WeViewEnums.h"
#import "WeViewSpacingInfo.h"

@class WeView;

@interface WeViewLayout : NSObject <NSCopying>

// Subclasses only need to implement two methods, [layoutContentsOfView: subviews:] and
// [minSizeOfContentsView: subviews: thatFitsSize:].
//
// This method returns the minimum size for _view_ such that it can lay out the given list of
// _subviews_ given the suggested _guideSize_.
//
// If the guideSize is equal to CGSizeZero, this method should return the "ideal" desired size,
// ie. without any wrapping, etc.
- (CGSize)minSizeOfContentsView:(UIView *)view
                       subviews:(NSArray *)subviews
                   thatFitsSize:(CGSize)guideSize;

// Subclasses only need to implement two methods, [layoutContentsOfView: subviews:] and
// [minSizeOfContentsView: subviews: thatFitsSize:].
//
// This method positions and resizes each of the _subviews_ within the bounds of _view_, ie. by
// setting each subview's frame.
- (void)layoutContentsOfView:(UIView *)view
                    subviews:(NSArray *)subviews;

#pragma mark - Per-Layout Properties

// Layouts default to use the superview's properties (See: UIView+WeView.h).  However, any values
// set on the layout itself with supercede values from the superview.

/* CODEGEN MARKER: Start */

// The left margin of the contents of this view.
- (WeViewSpacingInfo *)leftMarginInfo;
- (WeViewLayout *)setLeftMarginInfo:(WeViewSpacingInfo *)value;

// The right margin of the contents of this view.
- (WeViewSpacingInfo *)rightMarginInfo;
- (WeViewLayout *)setRightMarginInfo:(WeViewSpacingInfo *)value;

// The top margin of the contents of this view.
- (WeViewSpacingInfo *)topMarginInfo;
- (WeViewLayout *)setTopMarginInfo:(WeViewSpacingInfo *)value;

// The bottom margin of the contents of this view.
- (WeViewSpacingInfo *)bottomMarginInfo;
- (WeViewLayout *)setBottomMarginInfo:(WeViewSpacingInfo *)value;

// The default horizontal spacing between subviews of this view.
- (WeViewSpacingInfo *)defaultHSpacingInfo;
- (WeViewLayout *)setDefaultHSpacingInfo:(WeViewSpacingInfo *)value;

// The default vertical spacing between subviews of this view.
- (WeViewSpacingInfo *)defaultVSpacingInfo;
- (WeViewLayout *)setDefaultVSpacingInfo:(WeViewSpacingInfo *)value;

// The horizontal alignment of this layout.
- (HAlign)hAlign;
- (WeViewLayout *)setHAlign:(HAlign)value;

// The vertical alignment of this layout.
- (VAlign)vAlign;
- (WeViewLayout *)setVAlign:(VAlign)value;

// By default, if the content size (ie. the total subview size plus margins and spacing) of a
// WeView overflows its bounds, subviews are cropped to fit inside the available
// space.
//
// If cropSubviewOverflow is NO, no cropping occurs and subviews may overflow the bounds of their
// superview.
- (BOOL)cropSubviewOverflow;
- (WeViewLayout *)setCropSubviewOverflow:(BOOL)value;

// By default, cellPositioning has a value of CELL_POSITIONING_NORMAL and cell size is based on
// their desired size and they are aligned within their layout
// cell.
//
// If cellPositioning is set to CELL_POSITIONING_FILL, subviews fill the entire bounds of their
// layout cell, regardless of their desired
// size.
//
// If cellPositioning is set to CELL_POSITIONING_FILL_W_ASPECT_RATIO, subviews fill the entire
// bounds of their layout cell but retain the aspect ratio of their desired
// size.
//
// If cellPositioning is set to CELL_POSITIONING_FIT_W_ASPECT_RATIO, subviews are "fit" inside
// the bounds of their layout cell and retain the aspect ratio of their desired
// size.
- (CellPositioningMode)cellPositioning;
- (WeViewLayout *)setCellPositioning:(CellPositioningMode)value;

- (BOOL)debugLayout;
- (WeViewLayout *)setDebugLayout:(BOOL)value;
- (BOOL)debugMinSize;
- (WeViewLayout *)setDebugMinSize:(BOOL)value;

// Convenience accessor(s) for the leftMarginInfo property.
- (int)leftMargin;
- (WeViewLayout *)setLeftMargin:(int)value;

// Convenience accessor(s) for the rightMarginInfo property.
- (int)rightMargin;
- (WeViewLayout *)setRightMargin:(int)value;

// Convenience accessor(s) for the topMarginInfo property.
- (int)topMargin;
- (WeViewLayout *)setTopMargin:(int)value;

// Convenience accessor(s) for the bottomMarginInfo property.
- (int)bottomMargin;
- (WeViewLayout *)setBottomMargin:(int)value;

// Convenience accessor(s) for the leftMarginInfo property.
- (CGFloat)leftMarginStretchWeight;
- (WeViewLayout *)setLeftMarginStretchWeight:(CGFloat)value;

// Convenience accessor(s) for the rightMarginInfo property.
- (CGFloat)rightMarginStretchWeight;
- (WeViewLayout *)setRightMarginStretchWeight:(CGFloat)value;

// Convenience accessor(s) for the topMarginInfo property.
- (CGFloat)topMarginStretchWeight;
- (WeViewLayout *)setTopMarginStretchWeight:(CGFloat)value;

// Convenience accessor(s) for the bottomMarginInfo property.
- (CGFloat)bottomMarginStretchWeight;
- (WeViewLayout *)setBottomMarginStretchWeight:(CGFloat)value;

// Convenience accessor(s) for the leftMargin and rightMargin properties.
- (WeViewLayout *)setHMargin:(CGFloat)value;

// Convenience accessor(s) for the topMargin and bottomMargin properties.
- (WeViewLayout *)setVMargin:(CGFloat)value;

// Convenience accessor(s) for the leftMargin, rightMargin, topMargin and bottomMargin
// properties.
- (WeViewLayout *)setMargin:(CGFloat)value;

// Convenience accessor(s) for the defaultHSpacingInfo and defaultVSpacingInfo properties.
- (WeViewLayout *)setDefaultSpacingInfo:(WeViewSpacingInfo *)value;

// Convenience accessor(s) for the defaultHSpacingInfo property.
- (int)hSpacing;
- (WeViewLayout *)setHSpacing:(int)value;

// Convenience accessor(s) for the defaultVSpacingInfo property.
- (int)vSpacing;
- (WeViewLayout *)setVSpacing:(int)value;

// Convenience accessor(s) for the hSpacing and vSpacing properties.
- (WeViewLayout *)setSpacing:(int)value;

/* CODEGEN MARKER: End */

- (void)resetAllProperties;

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
