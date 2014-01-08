//
//  DemoViewFactory.h
//  WeView v2
//
//  Copyright (c) 2014 Charles Matthew Chen. All rights reserved.
//
//  Distributed under the Apache License v2.0.
//  http://www.apache.org/licenses/LICENSE-2.0.html
//

#pragma once

#import <Foundation/Foundation.h>

@interface DemoViewFactory : NSObject

+ (UILabel *)createLabel:(NSString *)text
                fontSize:(CGFloat)fontSize;

+ (UILabel *)createLabel:(NSString *)text
                fontSize:(CGFloat)fontSize
               textColor:(UIColor *)textColor;

+ (UIColor *)colorWithRGBHex:(UInt32)hex;

+ (UIButton *)createFlatUIButton:(NSString *)label
                       textColor:(UIColor *)textColor
                     buttonColor:(UIColor *)buttonColor
                          target:(id)target
                        selector:(SEL)selector;

@end
