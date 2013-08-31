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

typedef void(^BlockLayoutBlock)(UIView *superview, UIView *subview);

@interface WeView2BlockLayout : WeView2Layout

+ (WeView2BlockLayout *)create:(BlockLayoutBlock)block;

@end
