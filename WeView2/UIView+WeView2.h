//
//  UIView+WeView2.h
//  Unknown Project
//
//  Copyright (c) 2013 Charles Matthew Chen. All rights reserved.
//

#pragma once

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 * Horizontal alignment constants.
 */
typedef enum
{
    H_ALIGN_LEFT = 0,
    H_ALIGN_CENTER = 1,
    H_ALIGN_RIGHT = 2,
} HAlign;

/**
 * Vertical alignment constants.
 */
typedef enum
{
    V_ALIGN_TOP = 0,
    V_ALIGN_CENTER = 1,
    V_ALIGN_BOTTOM = 2,
} VAlign;

@interface UIView (WeView2)

#pragma mark - Associated Values

/* CODEGEN MARKER: Start */

- (CGFloat)minWidth;
- (id)setMinWidth:(CGFloat)value;
- (CGFloat)maxWidth;
- (id)setMaxWidth:(CGFloat)value;
- (CGFloat)minHeight;
- (id)setMinHeight:(CGFloat)value;
- (CGFloat)maxHeight;
- (id)setMaxHeight:(CGFloat)value;

- (CGFloat)hStretchWeight;
- (id)setHStretchWeight:(CGFloat)value;
- (CGFloat)vStretchWeight;
- (id)setVStretchWeight:(CGFloat)value;
- (BOOL)ignoreNaturalSize;
- (id)setIgnoreNaturalSize:(BOOL)value;

- (CGFloat)leftMargin;
- (id)setLeftMargin:(CGFloat)value;
- (CGFloat)rightMargin;
- (id)setRightMargin:(CGFloat)value;
- (CGFloat)topMargin;
- (id)setTopMargin:(CGFloat)value;
- (CGFloat)bottomMargin;
- (id)setBottomMargin:(CGFloat)value;

- (CGFloat)vSpacing;
- (id)setVSpacing:(CGFloat)value;
- (CGFloat)hSpacing;
- (id)setHSpacing:(CGFloat)value;

- (NSString *)debugName;
- (id)setDebugName:(NSString *)value;
- (BOOL)debugLayout;
- (id)setDebugLayout:(BOOL)value;

// Sets the minWidth and minHeight properties.
- (id)setMinSize:(CGSize)value;

// Sets the maxWidth and maxHeight properties.
- (id)setMaxSize:(CGSize)value;

// Sets the minWidth and maxWidth properties.
- (id)setFixedWidth:(CGFloat)value;

// Sets the minHeight and maxHeight properties.
- (id)setFixedHeight:(CGFloat)value;

// Sets the minWidth, minHeight, maxWidth and maxHeight properties.
- (id)setFixedSize:(CGSize)value;

// Sets the vStretchWeight and hStretchWeight properties.
- (id)setStretchWeight:(CGFloat)value;

// Sets the leftMargin and rightMargin properties.
- (id)setHMargin:(CGFloat)value;

// Sets the topMargin and bottomMargin properties.
- (id)setVMargin:(CGFloat)value;

// Sets the leftMargin, rightMargin, topMargin and bottomMargin properties.
- (id)setMargin:(CGFloat)value;

// Sets the hSpacing and vSpacing properties.
- (id)setSpacing:(CGFloat)value;

/* CODEGEN MARKER: End */

// Describes the horizontal alignment of subviews within this view.
- (HAlign)hAlign;
- (id)setHAlign:(HAlign)value;

// Describes the vertical alignment of subviews within this view.
- (VAlign)vAlign;
- (id)setVAlign:(VAlign)value;

// Layout should stretch this subview to fit any available space.
- (id)withStretch;

// Layout should stretch this subview to fit any available space, ignoring its natural size.
- (id)withPureStretch;

- (CGSize)minSize;

- (CGSize)maxSize;

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

- (CGFloat)bottom;
- (CGFloat)right;

- (void)centerHorizontallyInSuperview;
- (void)centerVerticallyInSuperview;

- (NSString *)layoutDescription;

@end
