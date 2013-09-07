//
//  Demo.h
//  WeViews2DemoApp
//
//  Copyright (c) 2013 Charles Matthew Chen. All rights reserved.
//
//  Distributed under the Apache License v2.0.
//  http://www.apache.org/licenses/LICENSE-2.0.html
//

#pragma once

#import <Foundation/Foundation.h>
#import "DemoModel.h"

typedef DemoModel *(^CreateDemoModelBlock)();

@interface Demo : NSObject

@property (nonatomic) NSString *name;
@property (copy, nonatomic) CreateDemoModelBlock createDemoModelBlock;

//- (NSString *)name;
//
//- (DemoModel *)demoModel;
//
//- (UILabel *)createLabel:(NSString *)text
//                fontSize:(CGFloat)fontSize;
//- (UILabel *)createLabel:(NSString *)text
//                fontSize:(CGFloat)fontSize
//               textColor:(UIColor *)textColor;
//
//- (void)assignRandomBackgroundColors:(NSArray *)views;
//- (NSArray *)collectSubviews:(UIView *)view;

@end
