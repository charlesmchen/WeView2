//
//  WeScrollView.h
//  WeView v2
//
//  Copyright (c) 2015 Charles Matthew Chen. All rights reserved.
//
//  Distributed under the Apache License v2.0.
//  http://www.apache.org/licenses/LICENSE-2.0.html
//

#pragma once

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WeScrollView : UIScrollView

@property (nonatomic) UIView *contentView;

@property (nonatomic) HAlign hAlign;
@property (nonatomic) VAlign vAlign;

+ (WeScrollView *)createVerticalScrollView;
+ (WeScrollView *)createVerticalScrollViewForContentView:(UIView *)contentView;

+ (WeScrollView *)createHorizontalScrollView;
+ (WeScrollView *)createHorizontalScrollViewForContentView:(UIView *)contentView;

+ (WeScrollView *)createHorizontalAndVerticalScrollView;
+ (WeScrollView *)createHorizontalAndVerticalScrollViewForContentView:(UIView *)contentView;

@end
