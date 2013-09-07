//
//  WeView2.h
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

#import "UIView+WeView2.h"
#import "WeView2BlockLayout.h"

@class WeView2Layout;

@interface WeView2 : UIView

#pragma mark - Default Layout

// Set the default layout for subviews of this view.

// By default, lay out subviews horiztonally, left-to-right.
- (WeView2 *)useHorizontalDefaultLayout;

// By default, lay out subviews vertically, top-to-bottom.
- (WeView2 *)useVerticalDefaultLayout;

// By default, lay out subviews on top of each other.
- (WeView2 *)useStackDefaultLayout;

// By default, layout views using a block.
- (WeView2 *)useBlockDefaultLayout:(BlockLayoutBlock)block;

// By default, _DO NOT_ lay out subviews.
- (WeView2 *)useNoDefaultLayout;

// Use a specific layout as the default layout.
- (void)setDefaultLayout:(WeView2Layout *)defaultLayout;

#pragma mark - Custom Layouts

// Add subviews with a custom layout which will only apply for these subviews.

- (WeView2 *)addSubviews:(NSArray *)subviews
              withLayout:(WeView2Layout *)layout;
- (WeView2 *)addSubview:(UIView *)subview
             withLayout:(WeView2Layout *)layout;

// Add a subview with a custom layout that applies to just that subview.
- (WeView2Layout *)addSubviewWithCustomLayout:(UIView *)subview;

// Add subviews with a horizontal layout that applies to just these subview.
- (WeView2Layout *)addSubviewsWithHorizontalLayout:(NSArray *)subviews;

// Add subviews with a vertical layout that applies to just these subview.
- (WeView2Layout *)addSubviewsWithVerticalLayout:(NSArray *)subviews;

// Add a subview with a layout that stretches the subview to fill this view's bounds.
- (WeView2Layout *)addSubviewWithFillLayout:(UIView *)subview;

// Add a subview with a layout that stretches the subview to fill this view's bounds, while
// preserving its aspect ratio.
- (WeView2Layout *)addSubviewWithFillLayoutWAspectRatio:(UIView *)subview;

// Add a subview with a layout that stretches the subview to fill this view's bounds, while
// preserving its aspect ratio.
- (WeView2Layout *)addSubviewWithFitLayoutWAspectRatio:(UIView *)subview;

- (WeView2Layout *)addSubviews:(NSArray *)subviews
               withLayoutBlock:(BlockLayoutBlock)block;
- (WeView2Layout *)addSubview:(UIView *)subview
              withLayoutBlock:(BlockLayoutBlock)block;

#pragma mark -

// Subviews added without a custom layout (ie. with [UIView addSubview:(UIView *)view] or this
// method) will use the default layout.
- (WeView2 *)addSubviews:(NSArray *)subviews;

- (void)removeAllSubviews;

@end
