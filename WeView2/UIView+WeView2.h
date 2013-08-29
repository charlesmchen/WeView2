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

NSString* FormatVAlign(VAlign value);
NSString* FormatHAlign(HAlign value);

CGRect alignSizeWithinRect(CGSize size, CGRect rect, HAlign hAlign, VAlign vAlign);

#pragma mark -

@interface WeView2ViewInfo : NSObject

@property (nonatomic) HAlign hAlign;
@property (nonatomic) VAlign vAlign;

/* CODEGEN MARKER: View Info Start */

@property (nonatomic) CGFloat minWidth;
@property (nonatomic) CGFloat maxWidth;
@property (nonatomic) CGFloat minHeight;
@property (nonatomic) CGFloat maxHeight;

@property (nonatomic) CGFloat hStretchWeight;
@property (nonatomic) CGFloat vStretchWeight;
@property (nonatomic) BOOL ignoreNaturalSize;

@property (nonatomic) CGFloat leftMargin;
@property (nonatomic) CGFloat rightMargin;
@property (nonatomic) CGFloat topMargin;
@property (nonatomic) CGFloat bottomMargin;

@property (nonatomic) CGFloat vSpacing;
@property (nonatomic) CGFloat hSpacing;

@property (nonatomic) NSString * debugName;
@property (nonatomic) BOOL debugLayout;

// Convenience accessor(s) for the minWidth and minHeight properties.
- (CGSize)minSize;
- (void)setMinSize:(CGSize)value;

// Convenience accessor(s) for the maxWidth and maxHeight properties.
- (CGSize)maxSize;
- (void)setMaxSize:(CGSize)value;

// Convenience accessor(s) for the minWidth and maxWidth properties.
- (void)setFixedWidth:(CGFloat)value;

// Convenience accessor(s) for the minHeight and maxHeight properties.
- (void)setFixedHeight:(CGFloat)value;

// Convenience accessor(s) for the minWidth, minHeight, maxWidth and maxHeight properties.
- (void)setFixedSize:(CGSize)value;

// Convenience accessor(s) for the vStretchWeight and hStretchWeight properties.
- (void)setStretchWeight:(CGFloat)value;

// Convenience accessor(s) for the leftMargin and rightMargin properties.
- (void)setHMargin:(CGFloat)value;

// Convenience accessor(s) for the topMargin and bottomMargin properties.
- (void)setVMargin:(CGFloat)value;

// Convenience accessor(s) for the leftMargin, rightMargin, topMargin and bottomMargin properties.
- (void)setMargin:(CGFloat)value;

// Convenience accessor(s) for the hSpacing and vSpacing properties.
- (void)setSpacing:(CGFloat)value;

/* CODEGEN MARKER: View Info End */

- (NSString *)layoutDescription;

@end

#pragma mark -

@interface UIView (WeView2)

/* CODEGEN MARKER: Start */

- (CGFloat)minWidth;
- (UIView *)setMinWidth:(CGFloat)value;
- (CGFloat)maxWidth;
- (UIView *)setMaxWidth:(CGFloat)value;
- (CGFloat)minHeight;
- (UIView *)setMinHeight:(CGFloat)value;
- (CGFloat)maxHeight;
- (UIView *)setMaxHeight:(CGFloat)value;

- (CGFloat)hStretchWeight;
- (UIView *)setHStretchWeight:(CGFloat)value;
- (CGFloat)vStretchWeight;
- (UIView *)setVStretchWeight:(CGFloat)value;
- (BOOL)ignoreNaturalSize;
- (UIView *)setIgnoreNaturalSize:(BOOL)value;

- (CGFloat)leftMargin;
- (UIView *)setLeftMargin:(CGFloat)value;
- (CGFloat)rightMargin;
- (UIView *)setRightMargin:(CGFloat)value;
- (CGFloat)topMargin;
- (UIView *)setTopMargin:(CGFloat)value;
- (CGFloat)bottomMargin;
- (UIView *)setBottomMargin:(CGFloat)value;

- (CGFloat)vSpacing;
- (UIView *)setVSpacing:(CGFloat)value;
- (CGFloat)hSpacing;
- (UIView *)setHSpacing:(CGFloat)value;

- (NSString *)debugName;
- (UIView *)setDebugName:(NSString *)value;
- (BOOL)debugLayout;
- (UIView *)setDebugLayout:(BOOL)value;

// Convenience accessor(s) for the minWidth and minHeight properties.
- (CGSize)minSize;
- (UIView *)setMinSize:(CGSize)value;

// Convenience accessor(s) for the maxWidth and maxHeight properties.
- (CGSize)maxSize;
- (UIView *)setMaxSize:(CGSize)value;

// Convenience accessor(s) for the minWidth and maxWidth properties.
- (UIView *)setFixedWidth:(CGFloat)value;

// Convenience accessor(s) for the minHeight and maxHeight properties.
- (UIView *)setFixedHeight:(CGFloat)value;

// Convenience accessor(s) for the minWidth, minHeight, maxWidth and maxHeight properties.
- (UIView *)setFixedSize:(CGSize)value;

// Convenience accessor(s) for the vStretchWeight and hStretchWeight properties.
- (UIView *)setStretchWeight:(CGFloat)value;

// Convenience accessor(s) for the leftMargin and rightMargin properties.
- (UIView *)setHMargin:(CGFloat)value;

// Convenience accessor(s) for the topMargin and bottomMargin properties.
- (UIView *)setVMargin:(CGFloat)value;

// Convenience accessor(s) for the leftMargin, rightMargin, topMargin and bottomMargin properties.
- (UIView *)setMargin:(CGFloat)value;

// Convenience accessor(s) for the hSpacing and vSpacing properties.
- (UIView *)setSpacing:(CGFloat)value;

/* CODEGEN MARKER: End */

// Describes the horizontal alignment of subviews within this view.
- (HAlign)hAlign;
- (UIView *)setHAlign:(HAlign)value;

// Describes the vertical alignment of subviews within this view.
- (VAlign)vAlign;
- (UIView *)setVAlign:(VAlign)value;

// Layout should stretch this subview to fit any available space.
- (UIView *)withStretch;

// Layout should stretch this subview to fit any available space, ignoring its natural size.
- (UIView *)withPureStretch;

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

- (void)centerHorizontallyInSuperview;
- (void)centerVerticallyInSuperview;

- (NSString *)layoutDescription;

@end
