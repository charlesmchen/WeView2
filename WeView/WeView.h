//
//  WeView.h
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

// By default, layout views using a block.
- (WeViewLayout *)useBlockDefaultLayout:(BlockLayoutBlock)block;

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

// Add subviews with a horizontal layout that applies to just these subview.
- (WeViewLayout *)addSubviewsWithHorizontalLayout:(NSArray *)subviews;

// Add subviews with a vertical layout that applies to just these subview.
- (WeViewLayout *)addSubviewsWithVerticalLayout:(NSArray *)subviews;

// Add a subview with a layout that stretches the subview to fill this view's bounds.
- (WeViewLayout *)addSubviewWithFillLayout:(UIView *)subview;

// Add a subview with a layout that stretches the subview to fill this view's bounds, while
// preserving its aspect ratio.
- (WeViewLayout *)addSubviewWithFillLayoutWAspectRatio:(UIView *)subview;

// Add a subview with a layout that stretches the subview to fill this view's bounds, while
// preserving its aspect ratio.
- (WeViewLayout *)addSubviewWithFitLayoutWAspectRatio:(UIView *)subview;

- (WeViewLayout *)addSubviews:(NSArray *)subviews
              withLayoutBlock:(BlockLayoutBlock)block;
- (WeViewLayout *)addSubview:(UIView *)subview
             withLayoutBlock:(BlockLayoutBlock)block;

#pragma mark -

// Subviews added without a custom layout (ie. with [UIView addSubview:(UIView *)view] or this
// method) will use the default layout.
- (WeView *)addSubviews:(NSArray *)subviews;

- (void)removeAllSubviews;

@end
