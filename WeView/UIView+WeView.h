//
//  UIView+WeView.h
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

@interface UIView (WeView) <NSCopying>

/* CODEGEN MARKER: Properties Start */

// The minimum desired width of this view. Trumps the maxWidth.
- (CGFloat)minDesiredWidth;
- (UIView *)setMinDesiredWidth:(CGFloat)value;

// The maximum desired width of this view. Trumped by the minWidth.
- (CGFloat)maxDesiredWidth;
- (UIView *)setMaxDesiredWidth:(CGFloat)value;

// The minimum desired height of this view. Trumps the maxHeight.
- (CGFloat)minDesiredHeight;
- (UIView *)setMinDesiredHeight:(CGFloat)value;

// The maximum desired height of this view. Trumped by the minHeight.
- (CGFloat)maxDesiredHeight;
- (UIView *)setMaxDesiredHeight:(CGFloat)value;

// The horizontal stretch weight of this view. If non-zero, the view is willing to take available
// space or be cropped if
// necessary.
// 
// Subviews with larger relative stretch weights will be stretched more.
- (CGFloat)hStretchWeight;
- (UIView *)setHStretchWeight:(CGFloat)value;

// The vertical stretch weight of this view. If non-zero, the view is willing to take available
// space or be cropped if
// necessary.
// 
// Subviews with larger relative stretch weights will be stretched more.
- (CGFloat)vStretchWeight;
- (UIView *)setVStretchWeight:(CGFloat)value;

// An adjustment to the spacing to the left of this view, if any.
// 
// This value can be positive or negative.
// 
// Only applies to the horizontal, vertical and flow layouts.
- (int)leftSpacingAdjustment;
- (UIView *)setLeftSpacingAdjustment:(int)value;

// An adjustment to the spacing above this view, if any.
// 
// This value can be positive or negative.
// 
// Only applies to the horizontal and vertical layouts.
- (int)topSpacingAdjustment;
- (UIView *)setTopSpacingAdjustment:(int)value;

// An adjustment to the spacing to the right of this view, if any.
// 
// This value can be positive or negative.
// 
// Only applies to the horizontal, vertical and flow layouts.
- (int)rightSpacingAdjustment;
- (UIView *)setRightSpacingAdjustment:(int)value;

// An adjustment to the spacing below this view, if any.
// 
// This value can be positive or negative.
// 
// Only applies to the horizontal and vertical layouts.
- (int)bottomSpacingAdjustment;
- (UIView *)setBottomSpacingAdjustment:(int)value;

// This adjustment can be used to manipulate the desired width of a view.
// 
// It is added to the desired width reported by the subview.
// 
// This value can be negative.
- (CGFloat)desiredWidthAdjustment;
- (UIView *)setDesiredWidthAdjustment:(CGFloat)value;

// This adjustment can be used to manipulate the desired height of a view.
// 
// It is added to the desired width reported by the subview.
// 
// This value can be negative.
- (CGFloat)desiredHeightAdjustment;
- (UIView *)setDesiredHeightAdjustment:(CGFloat)value;
- (BOOL)ignoreDesiredSize;
- (UIView *)setIgnoreDesiredSize:(BOOL)value;

// The horizontal alignment preference of this view within in its layout cell.
// 
// This value is optional.  The default value is the contentHAlign of its superview.
// 
// cellHAlign should only be used for cells whose alignment differs from its superview's.
- (HAlign)cellHAlign;
- (UIView *)setCellHAlign:(HAlign)value;

// The vertical alignment preference of this view within in its layout cell.
// 
// This value is optional.  The default value is the contentVAlign of its superview.
// 
// cellVAlign should only be used for cells whose alignment differs from its superview's.
- (VAlign)cellVAlign;
- (UIView *)setCellVAlign:(VAlign)value;
- (BOOL)hasCellHAlign;
- (UIView *)setHasCellHAlign:(BOOL)value;
- (BOOL)hasCellVAlign;
- (UIView *)setHasCellVAlign:(BOOL)value;

- (NSString *)debugName;
- (UIView *)setDebugName:(NSString *)value;

// Convenience accessor(s) for the minDesiredWidth and minDesiredHeight properties.
- (CGSize)minDesiredSize;
- (UIView *)setMinDesiredSize:(CGSize)value;

// Convenience accessor(s) for the maxDesiredWidth and maxDesiredHeight properties.
- (CGSize)maxDesiredSize;
- (UIView *)setMaxDesiredSize:(CGSize)value;

// Convenience accessor(s) for the desiredWidthAdjustment and desiredHeightAdjustment properties.
- (CGSize)desiredSizeAdjustment;
- (UIView *)setDesiredSizeAdjustment:(CGSize)value;

// Convenience accessor(s) for the minDesiredWidth and maxDesiredWidth properties.
- (UIView *)setFixedDesiredWidth:(CGFloat)value;

// Convenience accessor(s) for the minDesiredHeight and maxDesiredHeight properties.
- (UIView *)setFixedDesiredHeight:(CGFloat)value;

// Convenience accessor(s) for the minDesiredWidth, minDesiredHeight, maxDesiredWidth and
// maxDesiredHeight
// properties.
- (UIView *)setFixedDesiredSize:(CGSize)value;

// Convenience accessor(s) for the vStretchWeight and hStretchWeight properties.
- (UIView *)setStretchWeight:(CGFloat)value;

/* CODEGEN MARKER: Properties End */

// The layout should stretch this subview horizontally to fit any available space.
- (UIView *)setHStretches;

// The layout should stretch this subview vertically to fit any available space.
- (UIView *)setVStretches;

// The layout should stretch this subview horizontally and vertically to fit any available space.
- (UIView *)setStretches;

// The layout should ignore this view's desired size.
- (UIView *)setIgnoreDesiredSize;

// The layout should stretch this subview to fit any available space, ignoring its desired size.
- (UIView *)setStretchesIgnoringDesiredSize;

#pragma mark - Convenience Accessors

// Origin Accessors
//
// Setters affect the frame.
- (CGPoint)origin;
- (void)setOrigin:(CGPoint)origin;
- (CGFloat)x;
- (void)setX:(CGFloat)value;
- (CGFloat)y;
- (void)setY:(CGFloat)value;

// Size Accessors
//
// Setters affect the bounds and the frame.
- (CGSize)size;
- (void)setSize:(CGSize)size;
- (CGFloat)width;
- (void)setWidth:(CGFloat)value;
- (CGFloat)height;
- (void)setHeight:(CGFloat)value;

// Right and Bottom Accessors
- (CGFloat)right;
- (void)setRight:(CGFloat)value;
- (CGFloat)bottom;
- (void)setBottom:(CGFloat)value;

// Center Accessors
- (CGFloat)hCenter;
- (void)setHCenter:(CGFloat)value;
- (CGFloat)vCenter;
- (void)setVCenter:(CGFloat)value;

#pragma mark - Manual alignment

- (void)centerAlignHorizontallyWithView:(UIView *)view;
- (void)centerAlignVerticallyWithView:(UIView *)view;

- (void)centerHorizontallyInSuperview;
- (void)centerVerticallyInSuperview;

#pragma mark - Misc.

- (NSString *)layoutDescription;

- (void)resetAllLayoutProperties;

@end
