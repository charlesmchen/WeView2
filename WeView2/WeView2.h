//
//  WeView2.h
//  Unknown Project
//
//  Copyright (c) 2013 Charles Matthew Chen. All rights reserved.
//

#pragma once

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "UIView+WeView2.h"
#import "WeView2BlockLayout.h"
#import "WeView2FitOrFillLayout.h"

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

// By default, _DO NOT_ lay out subviews.
- (WeView2 *)useNoDefaultLayout;

#pragma mark - Custom Layouts

// Add subviews with a custom layout which will only apply for these subviews.

- (WeView2 *)addSubviews:(NSArray *)subviews
              withLayout:(WeView2Layout *)layout;
- (WeView2 *)addSubview:(UIView *)subview
             withLayout:(WeView2Layout *)layout;
- (WeView2 *)addSubviews:(NSArray *)subviews
         withLayoutBlock:(BlockLayoutBlock)block;
- (WeView2 *)addSubview:(UIView *)subview
        withLayoutBlock:(BlockLayoutBlock)block;

#pragma mark -

// Subviews added without a custom layout (ie. with [UIView addSubview:(UIView *)view]) will use the
// default layout.
- (WeView2 *)addSubviews:(NSArray *)subviews;

- (void)removeAllSubviews;

@end
