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
#import "WeViewSpacing.h"

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

/* CODEGEN MARKER: Properties Start */

// The left margin of the contents of this view.
- (CGFloat)leftMargin;
- (WeViewLayout *)setLeftMargin:(CGFloat)value;

// The right margin of the contents of this view.
- (CGFloat)rightMargin;
- (WeViewLayout *)setRightMargin:(CGFloat)value;

// The top margin of the contents of this view.
- (CGFloat)topMargin;
- (WeViewLayout *)setTopMargin:(CGFloat)value;

// The bottom margin of the contents of this view.
- (CGFloat)bottomMargin;
- (WeViewLayout *)setBottomMargin:(CGFloat)value;

// The vertical spacing between subviews of this view.
- (int)vSpacing;
- (WeViewLayout *)setVSpacing:(int)value;

// The horizontal spacing between subviews of this view.
- (int)hSpacing;
- (WeViewLayout *)setHSpacing:(int)value;

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

- (BOOL)debugLayout;
- (WeViewLayout *)setDebugLayout:(BOOL)value;
- (BOOL)debugMinSize;
- (WeViewLayout *)setDebugMinSize:(BOOL)value;

// Convenience accessor(s) for the leftMargin and rightMargin properties.
- (WeViewLayout *)setHMargin:(CGFloat)value;

// Convenience accessor(s) for the topMargin and bottomMargin properties.
- (WeViewLayout *)setVMargin:(CGFloat)value;

// Convenience accessor(s) for the leftMargin, rightMargin, topMargin and bottomMargin
// properties.
- (WeViewLayout *)setMargin:(CGFloat)value;

// Convenience accessor(s) for the hSpacing and vSpacing properties.
- (WeViewLayout *)setSpacing:(int)value;

/* CODEGEN MARKER: Properties End */

- (void)resetAllProperties;

@end
