//
//  UIView+WeView.h
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

@interface UIView (WeView) <NSCopying>

/* CODEGEN MARKER: Start */

// The minimum desired width of this view. Trumps the maxWidth.
- (CGFloat)minWidth;
- (UIView *)setMinWidth:(CGFloat)value;

// The maximum desired width of this view. Trumped by the minWidth.
- (CGFloat)maxWidth;
- (UIView *)setMaxWidth:(CGFloat)value;

// The minimum desired height of this view. Trumps the maxHeight.
- (CGFloat)minHeight;
- (UIView *)setMinHeight:(CGFloat)value;

// The maximum desired height of this view. Trumped by the minHeight.
- (CGFloat)maxHeight;
- (UIView *)setMaxHeight:(CGFloat)value;

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

// This adjustment can be used to manipulate the desired width of a view.
- (CGFloat)desiredWidthAdjustment;
- (UIView *)setDesiredWidthAdjustment:(CGFloat)value;

// This adjustment can be used to manipulate the desired height of a view.
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

// Convenience accessor(s) for the minWidth and minHeight properties.
- (CGSize)minSize;
- (UIView *)setMinSize:(CGSize)value;

// Convenience accessor(s) for the maxWidth and maxHeight properties.
- (CGSize)maxSize;
- (UIView *)setMaxSize:(CGSize)value;

// Convenience accessor(s) for the desiredWidthAdjustment and desiredHeightAdjustment properties.
- (CGSize)desiredSizeAdjustment;
- (UIView *)setDesiredSizeAdjustment:(CGSize)value;

// Convenience accessor(s) for the minWidth and maxWidth properties.
- (UIView *)setFixedWidth:(CGFloat)value;

// Convenience accessor(s) for the minHeight and maxHeight properties.
- (UIView *)setFixedHeight:(CGFloat)value;

// Convenience accessor(s) for the minWidth, minHeight, maxWidth and maxHeight properties.
- (UIView *)setFixedSize:(CGSize)value;

// Convenience accessor(s) for the vStretchWeight and hStretchWeight properties.
- (UIView *)setStretchWeight:(CGFloat)value;

/* CODEGEN MARKER: End */

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

- (CGPoint)origin;
- (void)setOrigin:(CGPoint)origin;
- (CGFloat)x;
- (void)setX:(CGFloat)value;
- (CGFloat)y;
- (void)setY:(CGFloat)value;

// The width, height and size have the same effect on the bounds and frame.
- (CGSize)size;
- (void)setSize:(CGSize)size;
- (CGFloat)width;
- (void)setWidth:(CGFloat)value;
- (CGFloat)height;
- (void)setHeight:(CGFloat)value;

- (CGFloat)right;
- (void)setRight:(CGFloat)value;
- (CGFloat)bottom;
- (void)setBottom:(CGFloat)value;

- (void)centerAlignHorizontallyWithView:(UIView *)view;
- (void)centerAlignVerticallyWithView:(UIView *)view;

- (void)centerHorizontallyInSuperview;
- (void)centerVerticallyInSuperview;

- (NSString *)layoutDescription;

- (void)resetAllLayoutProperties;

@end
