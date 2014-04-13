//
//  WeViewBlockLayout.h
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

#import "WeViewLayout.h"

// Block used for custom positioning of subviews.  Called once for each subview of the superview.
typedef void(^WeViewLayoutBlock)(UIView *superview, UIView *subview);

// Block used for determining the desired size of subviews.  Called once for each subview of the
// superview.
typedef CGSize(^WeViewDesiredSizeBlock)(UIView *superview, UIView *subview);

@interface WeViewBlockLayout : WeViewLayout

// Factory method.
+ (WeViewBlockLayout *)blockLayoutWithBlock:(WeViewLayoutBlock)layoutBlock
                           desiredSizeBlock:(WeViewDesiredSizeBlock)desiredSizeBlock;

// Factory method.
+ (WeViewBlockLayout *)blockLayoutWithBlock:(WeViewLayoutBlock)layoutBlock;

@end
