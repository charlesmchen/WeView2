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
// The "layout" block positions and sizes these subviews and the "desired size" block
// determines the desired size of these subviews.
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
// The "layout" block positions and sizes this subview and the "desired size" block determines
// the desired size of this subview.
- (WeViewLayout *)addSubview:(UIView *)subview
             withLayoutBlock:(WeView2LayoutBlock)layoutBlock;

#pragma mark -

- (void)removeAllSubviews;

- (void)setDebugLayoutOflayouts:(BOOL)value;
- (void)setDebugMinSizeOflayouts:(BOOL)value;

@end
