//
//  WeView2Layout.h
//  Unknown Project
//
//  Copyright (c) 2013 Charles Matthew Chen. All rights reserved.
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

- (CGFloat)leftMargin:(UIView *)view;
- (WeView2Layout *)setLeftMargin:(CGFloat)value;
- (CGFloat)rightMargin:(UIView *)view;
- (WeView2Layout *)setRightMargin:(CGFloat)value;
- (CGFloat)topMargin:(UIView *)view;
- (WeView2Layout *)setTopMargin:(CGFloat)value;
- (CGFloat)bottomMargin:(UIView *)view;
- (WeView2Layout *)setBottomMargin:(CGFloat)value;

- (CGFloat)vSpacing:(UIView *)view;
- (WeView2Layout *)setVSpacing:(CGFloat)value;
- (CGFloat)hSpacing:(UIView *)view;
- (WeView2Layout *)setHSpacing:(CGFloat)value;

// The horizontal alignment of subviews within this view.
- (HAlign)hAlign:(UIView *)view;
- (WeView2Layout *)setHAlign:(HAlign)value;
// The vertical alignment of subviews within this view.
- (VAlign)vAlign:(UIView *)view;
- (WeView2Layout *)setVAlign:(VAlign)value;

- (BOOL)debugLayout:(UIView *)view;
- (WeView2Layout *)setDebugLayout:(BOOL)value;

// Convenience accessor(s) for the leftMargin and rightMargin properties.
- (WeView2Layout *)setHMargin:(CGFloat)value;

// Convenience accessor(s) for the topMargin and bottomMargin properties.
- (WeView2Layout *)setVMargin:(CGFloat)value;

// Convenience accessor(s) for the leftMargin, rightMargin, topMargin and bottomMargin properties.
- (WeView2Layout *)setMargin:(CGFloat)value;

// Convenience accessor(s) for the hSpacing and vSpacing properties.
- (WeView2Layout *)setSpacing:(CGFloat)value;

/* CODEGEN MARKER: End */

#pragma mark - Utility Methods

- (void)positionSubview:(UIView *)subview
            inSuperview:(UIView *)superview
               withSize:(CGSize)subviewSize
           inCellBounds:(CGRect)cellBounds;

- (CGPoint)insetOriginOfView:(UIView *)view;

- (CGRect)contentBoundsOfView:(UIView *)view
                      forSize:(CGSize)size;

- (CGSize)insetSizeOfView:(UIView *)view;

- (CGSize)desiredItemSize:(UIView *)subview
                  maxSize:(CGSize)maxSize;

@end
