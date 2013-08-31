//
//  DemoViewFactory.h
//  WeViews2DemoApp
//
//  Copyright (c) 2013 Charles Matthew Chen. All rights reserved.
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

@end
