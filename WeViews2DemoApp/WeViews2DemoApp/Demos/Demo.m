//
//  Demo.m
//  WeViews2DemoApp
//
//  Copyright (c) 2013 Charles Matthew Chen. All rights reserved.
//
//  Distributed under the Apache License v2.0.
//  http://www.apache.org/licenses/LICENSE-2.0.html
//

#import "Demo.h"
#import "DemoViewFactory.h"

@implementation Demo

//- (NSString *)name
//{
//    return nil;
//}
//
//- (DemoModel *)demoModel
//{
//    return nil;
//}
//
//- (UILabel *)createLabel:(NSString *)text
//                fontSize:(CGFloat)fontSize
//{
//    return [DemoViewFactory createLabel:text
//                               fontSize:fontSize
//                              textColor:[UIColor whiteColor]];
//
//}
//- (UILabel *)createLabel:(NSString *)text
//                fontSize:(CGFloat)fontSize
//               textColor:(UIColor *)textColor
//{
//    return [DemoViewFactory createLabel:text
//                               fontSize:fontSize
//                              textColor:textColor];
//}
//
//- (UIColor *)colorWithRGBHex:(UInt32)hex
//{
//    return [DemoViewFactory colorWithRGBHex:hex];
//}
//
//- (void)assignRandomBackgroundColors:(NSArray *)views
//{
//    static NSArray *colors = nil;
//    if (!colors)
//    {
//        colors = @[
//                   [self colorWithRGBHex:0x5271cb],
//                   [self colorWithRGBHex:0xfd9345],
//                   [self colorWithRGBHex:0xb74d4d],
//                   [self colorWithRGBHex:0x94c365],
//                   [self colorWithRGBHex:0xffcd6a],
//                   [self colorWithRGBHex:0x7fcedd],
//                   [self colorWithRGBHex:0xc49a50],
//                   [self colorWithRGBHex:0x658a57],
//                   [self colorWithRGBHex:0xff8a8a],
//                   [self colorWithRGBHex:0x363636],
//                   [self colorWithRGBHex:0xb1b1b1],
//                   ];
//    }
//    static int colorIndexCounter = 0;
//    for (UIView *view in views)
//    {
//        int colorIndex = colorIndexCounter;
//        colorIndexCounter = (colorIndexCounter + 1) % [colors count];
//        view.backgroundColor = colors[colorIndex];
//        view.opaque = YES;
//    }
//}
//
//- (NSArray *)collectSubviews:(UIView *)view
//{
//    NSMutableArray *result = [NSMutableArray array];
//    [result addObject:view];
//    for (UIView *subview in view.subviews)
//    {
//        [result addObjectsFromArray:[self collectSubviews:subview]];
//    }
//    return result;
//}

@end
