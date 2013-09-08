//
//  WeViewViewInfo.h
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

#import "WeViewCommon.h"

@interface WeViewViewInfo : NSObject

/* CODEGEN MARKER: View Info Start */

// The minimum desired width of this view. Trumps the maxWidth.
@property (nonatomic) CGFloat minWidth;
// The maximum desired width of this view. Trumped by the minWidth.
@property (nonatomic) CGFloat maxWidth;
// The minimum desired height of this view. Trumps the maxHeight.
@property (nonatomic) CGFloat minHeight;
// The maximum desired height of this view. Trumped by the minHeight.
@property (nonatomic) CGFloat maxHeight;

// The left margin of the contents of this view.
@property (nonatomic) CGFloat leftMargin;
// The right margin of the contents of this view.
@property (nonatomic) CGFloat rightMargin;
// The top margin of the contents of this view.
@property (nonatomic) CGFloat topMargin;
// The bottom margin of the contents of this view.
@property (nonatomic) CGFloat bottomMargin;

// The vertical spacing between subviews of this view.
@property (nonatomic) CGFloat vSpacing;
// The horizontal spacing between subviews of this view.
@property (nonatomic) CGFloat hSpacing;

// The horizontal stretch weight of this view. If non-zero, the view is willing to take available space or be cropped if
// necessary.
//
// Subviews with larger relative stretch weights will be stretched more.
@property (nonatomic) CGFloat hStretchWeight;
// The vertical stretch weight of this view. If non-zero, the view is willing to take available space or be cropped if
// necessary.
//
// Subviews with larger relative stretch weights will be stretched more.
@property (nonatomic) CGFloat vStretchWeight;

// This adjustment can be used to manipulate the desired width of a view.
@property (nonatomic) CGFloat desiredWidthAdjustment;
// This adjustment can be used to manipulate the desired height of a view.
@property (nonatomic) CGFloat desiredHeightAdjustment;
@property (nonatomic) BOOL ignoreDesiredSize;

// The horizontal alignment of subviews of this view within their layout cells.
@property (nonatomic) HAlign contentHAlign;
// The vertical alignment of subviews within this view.
@property (nonatomic) VAlign contentVAlign;
// The horizontal alignment preference of this view within in its layout cell.
//
// This value is optional.  The default value is the contentHAlign of its superview.
//
// cellHAlign should only be used for cells whose alignment differs from its superview's.
@property (nonatomic) HAlign cellHAlign;
// The vertical alignment preference of this view within in its layout cell.
//
// This value is optional.  The default value is the contentVAlign of its superview.
//
// cellVAlign should only be used for cells whose alignment differs from its superview's.
@property (nonatomic) VAlign cellVAlign;
@property (nonatomic) BOOL hasCellHAlign;
@property (nonatomic) BOOL hasCellVAlign;

// By default, if the content size (ie. the total subview size plus margins and spacing) of a WeView overflows its bounds, subviews are cropped to fit inside the available
// space.
//
// If cropSubviewOverflow is NO, no cropping occurs and subviews may overflow the bounds of their
// superview.
@property (nonatomic) BOOL cropSubviewOverflow;
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
@property (nonatomic) CellPositioningMode cellPositioning;

@property (nonatomic) NSString *debugName;
@property (nonatomic) BOOL debugLayout;
@property (nonatomic) BOOL debugMinSize;

// ['// Convenience accessor(s) for the minWidth and minHeight properties.']
- (CGSize)minSize;
- (void)setMinSize:(CGSize)value;

// ['// Convenience accessor(s) for the maxWidth and maxHeight properties.']
- (CGSize)maxSize;
- (void)setMaxSize:(CGSize)value;

// ['// Convenience accessor(s) for the desiredWidthAdjustment and desiredHeightAdjustment properties.']
- (CGSize)desiredSizeAdjustment;
- (void)setDesiredSizeAdjustment:(CGSize)value;

// ['// Convenience accessor(s) for the minWidth and maxWidth properties.']
- (void)setFixedWidth:(CGFloat)value;

// ['// Convenience accessor(s) for the minHeight and maxHeight properties.']
- (void)setFixedHeight:(CGFloat)value;

// ['// Convenience accessor(s) for the minWidth, minHeight, maxWidth and maxHeight properties.']
- (void)setFixedSize:(CGSize)value;

// ['// Convenience accessor(s) for the vStretchWeight and hStretchWeight properties.']
- (void)setStretchWeight:(CGFloat)value;

// ['// Convenience accessor(s) for the leftMargin and rightMargin properties.']
- (void)setHMargin:(CGFloat)value;

// ['// Convenience accessor(s) for the topMargin and bottomMargin properties.']
- (void)setVMargin:(CGFloat)value;

// ['// Convenience accessor(s) for the leftMargin, rightMargin, topMargin and bottomMargin', '// properties.']
- (void)setMargin:(CGFloat)value;

// ['// Convenience accessor(s) for the hSpacing and vSpacing properties.']
- (void)setSpacing:(CGFloat)value;

/* CODEGEN MARKER: View Info End */

- (NSString *)layoutDescription;

@end
