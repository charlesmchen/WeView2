//
//  WeView.h
//  WeView 2
//
//  Copyright (c) 2013 Charles Matthew Chen. All rights reserved.
//
//  Distributed under the Apache License v2.0.
//  http://www.apache.org/licenses/LICENSE-2.0.html
//

#pragma once

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "UIView+WeView.h"
#import "WeViewBlockLayout.h"

@class WeViewLayout;

@interface WeView : UIView

#pragma mark - Default Layout

// Set the default layout for subviews of this view.

// By default, lay out subviews horiztonally, left-to-right.
- (WeViewLayout *)useHorizontalDefaultLayout;

// By default, lay out subviews vertically, top-to-bottom.
- (WeViewLayout *)useVerticalDefaultLayout;

// By default, lay out subviews on top of each other.
- (WeViewLayout *)useStackDefaultLayout;

// By default, lay out subviews in a "flow" layout that wraps subviews like text, left-to-right,
// top-to-bottom.
- (WeViewLayout *)useFlowDefaultLayout;

// By default, layout views using a "layout" block that positions and sizes the subviews.  This
// layout will not affect the desired size of this WeView.
- (WeViewLayout *)useBlockDefaultLayout:(WeView2LayoutBlock)layoutBlock;

// By default, layout views using a "layout" block that positions and sizes the subviews and a
// "desired size" block that determines the desired size of the subviews of this WeView.
- (WeViewLayout *)useBlockDefaultLayout:(WeView2LayoutBlock)layoutBlock
                       desiredSizeBlock:(WeView2DesiredSizeBlock)desiredSizeBlock;

// By default, _DO NOT_ lay out subviews.
- (WeViewLayout *)useNoDefaultLayout;

// Use a specific layout as the default layout.
- (WeView *)setDefaultLayout:(WeViewLayout *)defaultLayout;

#pragma mark - Custom Layouts

// Add subviews with a custom layout which will only apply for these subviews.

- (WeView *)addSubviews:(NSArray *)subviews
             withLayout:(WeViewLayout *)layout;
- (WeView *)addSubview:(UIView *)subview
            withLayout:(WeViewLayout *)layout;

// Add a subview with a custom layout that applies to just that subview.
- (WeViewLayout *)addSubviewWithCustomLayout:(UIView *)subview;

// Add subviews with a horizontal layout that applies to just these subviews.
- (WeViewLayout *)addSubviewsWithHorizontalLayout:(NSArray *)subviews;

// Add subviews with a vertical layout that applies to just these subviews.
- (WeViewLayout *)addSubviewsWithVerticalLayout:(NSArray *)subviews;

// Add subviews with a stack layout that applies to just these subviews.
- (WeViewLayout *)addSubviewsWithStackLayout:(NSArray *)subviews;

// Add subviews with a flow layout that applies to just these subviews.
- (WeViewLayout *)addSubviewsWithFlowLayout:(NSArray *)subviews;

// Add a subview with a layout that stretches the subview to fill this view's bounds.
- (WeViewLayout *)addSubviewWithFillLayout:(UIView *)subview;

// Add a subview with a layout that stretches the subview to fill this view's bounds, while
// preserving its aspect ratio.
- (WeViewLayout *)addSubviewWithFillLayoutWAspectRatio:(UIView *)subview;

// Add a subview with a layout that stretches the subview to fill this view's bounds, while
// preserving its aspect ratio.
- (WeViewLayout *)addSubviewWithFitLayoutWAspectRatio:(UIView *)subview;

// Add subviews with a block-based layout that applies to just these subviews.
//
// The "layout" block positions and sizes these subviews.
- (WeViewLayout *)addSubviews:(NSArray *)subviews
              withLayoutBlock:(WeView2LayoutBlock)layoutBlock;

// Add subviews with a block-based layout that applies to just these subviews.
//
// The "layout" block positions and sizes these subviews and the "desired size" block determines
// the desired size of these subviews.
- (WeViewLayout *)addSubviews:(NSArray *)subviews
              withLayoutBlock:(WeView2LayoutBlock)layoutBlock
             desiredSizeBlock:(WeView2DesiredSizeBlock)desiredSizeBlock;

// Add a subview with a block-based layout that applies to just that subview.
//
// The "layout" block positions and sizes this subview.
- (WeViewLayout *)addSubview:(UIView *)subview
             withLayoutBlock:(WeView2LayoutBlock)layoutBlock
            desiredSizeBlock:(WeView2DesiredSizeBlock)desiredSizeBlock;

// Add a subview with a block-based layout that applies to just that subview.
//
// The "layout" block positions and sizes this subview and the "desired size" block determines the
// desired size of this subview.
- (WeViewLayout *)addSubview:(UIView *)subview
             withLayoutBlock:(WeView2LayoutBlock)layoutBlock;

#pragma mark -

// Add subview to default layout.
//
// Functionally equivalent to [UIView addSubview], but can be chained.
- (WeViewLayout *)addSubviewToDefaultLayout:(UIView *)subview;

// Add subviews to default layout.
- (WeViewLayout *)addSubviewsToDefaultLayout:(NSArray *)subviews;

- (void)removeAllSubviews;

@end
