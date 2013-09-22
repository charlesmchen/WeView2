//
//  WeViewNoopLayout.h
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

#import "WeViewLayout.h"

@interface WeViewNoopLayout : WeViewLayout

// Factory method.
//
// Does _NOT_ alter the layout of subviews.
+ (WeViewNoopLayout *)noopLayout;

@end
