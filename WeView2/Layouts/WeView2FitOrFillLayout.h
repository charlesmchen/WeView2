//
//  WeView2FitOrFillLayout.h
//  Unknown Project
//
//  Copyright (c) 2013 Charles Matthew Chen. All rights reserved.
//

#pragma once

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "WeView2Layout.h"

@interface WeView2FitOrFillLayout : WeView2Layout

// Factory method.
//
// Lays out subviews of a view so that they fill the entire bounds of their superview.
+ (WeView2FitOrFillLayout *)fillBoundsLayout;

// Factory method.
//
// Lays out subviews of a view so that they fill the content bounds (ie. the bounds minus the border
// and margins) of their superview.
+ (WeView2FitOrFillLayout *)fillContentBoundsLayout;

// Factory method.
//
// Lays out subviews of a view so that they fill the entire bounds of their superview, preserving
// their natural aspect ratio.
//
// For example, this can be used to display an image (in a UIImageView) so that it entirely fills
// the bounds of its superview without distorting the image.  In this scenario you will probably
// want to set the "clipsToBounds" property to YES on the superview;
+ (WeView2FitOrFillLayout *)fillBoundsWithAspectRatioLayout;

// Factory method.
//
// Lays out subviews of a view so that they fill the content bounds (ie. the bounds minus the border
// and margins) of their superview, preserving their natural aspect ratio.
//
// For example, this can be used to display an image (in a UIImageView) so that it entirely fills
// the content bounds of its superview without distorting the image.  In this scenario you will
// probably want to set the "clipsToBounds" property to YES on the superview;
+ (WeView2FitOrFillLayout *)fillContentBoundsWithAspectRatioLayout;

// Factory method.
//
// Lays out subviews of a view so that they fit inside the entire bounds of their superview,
// preserving their natural aspect ratio.
//
// For example, this can be used to display an image (in a UIImageView), at the maximum size that
// fits inside its superview without clipping or distorting the image.
+ (WeView2FitOrFillLayout *)fitBoundsWithAspectRatioLayout;

// Factory method.
//
// Lays out subviews of a view so that they fit inside the content bounds (ie. the bounds minus the
// border and margins) of their superview, preserving their natural aspect ratio.
//
// For example, this can be used to display an image (in a UIImageView), at the maximum size that
// fits inside its superview without clipping or distorting the image.
+ (WeView2FitOrFillLayout *)fitContentBoundsWithAspectRatioLayout;

@end
