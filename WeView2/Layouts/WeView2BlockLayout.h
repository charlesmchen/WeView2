//
//  WeView2BlockLayout.h
//  Unknown Project
//
//  Copyright (c) 2013 Charles Matthew Chen. All rights reserved.
//

#pragma once

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "WeView2Layout.h"

// Block used for custom positioning of subviews.  Called once for each subview of the superview.
//
// Like HTML "absolute" positioning, subviews layed out by a WeView2BlockLayout do not effect the
// size of their superview.
typedef void(^BlockLayoutBlock)(UIView *superview, UIView *subview);

@interface WeView2BlockLayout : WeView2Layout

// Factory method.
+ (WeView2BlockLayout *)blockLayoutWithBlock:(BlockLayoutBlock)block;

@end
