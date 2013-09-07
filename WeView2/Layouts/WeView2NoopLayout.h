//
//  WeView2NoopLayout.h
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

#import "WeView2Layout.h"

@interface WeView2NoopLayout : WeView2Layout

// Factory method.
//
// Does _NOT_ alter the layout of subviews.
+ (WeView2NoopLayout *)noopLayout;

@end
