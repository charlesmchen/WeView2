//
//  Demo.h
//  WeViews2DemoApp
//
//  Copyright (c) 2013 Charles Matthew Chen. All rights reserved.
//

#pragma once

#import <Foundation/Foundation.h>

@interface Demo : NSObject

- (NSString *)name;

- (UIView *)demoView;

- (UILabel *)createLabel:(NSString *)text
                fontSize:(CGFloat)fontSize;
- (UILabel *)createLabel:(NSString *)text
                fontSize:(CGFloat)fontSize
               textColor:(UIColor *)textColor;

- (void)assignRandomBackgroundColors:(NSArray *)views;
- (NSArray *)collectSubviews:(UIView *)view;

@end
