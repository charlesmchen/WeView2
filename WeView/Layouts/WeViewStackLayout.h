//
//  WeViewStackLayout.h
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

@interface WeViewStackLayout : WeViewLayout

// Factory method.
//
// Lays out all views stacked on top of each other.
+ (WeViewStackLayout *)stackLayout;

@end
