//
//  WeViewBlockLayout.h
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

#import "WeViewLayout.h"

// Block used for custom positioning of subviews.  Called once for each subview of the superview.
//
// Like HTML "absolute" positioning, subviews layed out by a WeViewBlockLayout do not effect the
// size of their superview.
typedef void(^BlockLayoutBlock)(UIView *superview, UIView *subview);

@interface WeViewBlockLayout : WeViewLayout

// Factory method.
+ (WeViewBlockLayout *)blockLayoutWithBlock:(BlockLayoutBlock)block;

@end
