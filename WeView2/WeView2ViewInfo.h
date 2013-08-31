//
//  WeView2ViewInfo.h
//  Unknown Project
//
//  Copyright (c) 2013 Charles Matthew Chen. All rights reserved.
//

#pragma once

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "WeView2Common.h"

@interface WeView2ViewInfo : NSObject

@property (nonatomic) HAlign hAlign;
@property (nonatomic) VAlign vAlign;

// TODO: Comment that min width trumps max width.

/* CODEGEN MARKER: View Info Start */

@property (nonatomic) CGFloat minWidth;
@property (nonatomic) CGFloat maxWidth;
@property (nonatomic) CGFloat minHeight;
@property (nonatomic) CGFloat maxHeight;

@property (nonatomic) CGFloat hStretchWeight;
@property (nonatomic) CGFloat vStretchWeight;
@property (nonatomic) BOOL ignoreDesiredSize;

@property (nonatomic) CGFloat leftMargin;
@property (nonatomic) CGFloat rightMargin;
@property (nonatomic) CGFloat topMargin;
@property (nonatomic) CGFloat bottomMargin;

@property (nonatomic) CGFloat vSpacing;
@property (nonatomic) CGFloat hSpacing;

@property (nonatomic) NSString *debugName;
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
