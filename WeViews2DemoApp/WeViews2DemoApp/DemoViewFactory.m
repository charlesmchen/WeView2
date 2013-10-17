//
//  DemoViewFactory.m
//  WeView v2
//
//  Copyright (c) 2013 Charles Matthew Chen. All rights reserved.
//
//  Distributed under the Apache License v2.0.
//  http://www.apache.org/licenses/LICENSE-2.0.html
//

#import <QuartzCore/QuartzCore.h>

#import "DemoViewFactory.h"

@implementation DemoViewFactory

+ (UILabel *)createLabel:(NSString *)text
                fontSize:(CGFloat)fontSize
{
    return [self createLabel:text
                    fontSize:fontSize
                   textColor:[UIColor whiteColor]];

}

+ (UILabel *)createLabel:(NSString *)text
                fontSize:(CGFloat)fontSize
               textColor:(UIColor *)textColor
{
    UILabel *result = [[UILabel alloc] init];
    result.opaque = NO;
    result.backgroundColor = [UIColor clearColor];
    result.textColor = textColor;
    //    result.font = [UIFont systemFontOfSize:fontSize];
    result.font = [UIFont fontWithName:@"AvenirNext-DemiBold"
                                  size:fontSize];
    result.text = text;
    [result sizeToFit];
    return result;
}

+ (UIColor *)colorWithRGBHex:(UInt32)hex
{
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;

    return [UIColor colorWithRed:r / 255.0f
                           green:g / 255.0f
                            blue:b / 255.0f
                           alpha:1.0f];
}

+ (UIButton *)createFlatUIButton:(NSString *)label
                       textColor:(UIColor *)textColor
                     buttonColor:(UIColor *)buttonColor
                          target:(id)target
                        selector:(SEL)selector
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.opaque = NO;
    button.backgroundColor = buttonColor;
    button.layer.cornerRadius = 5.f;
    button.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    [button setTitle:label
            forState:UIControlStateNormal];
    [button setTitleColor:textColor
                 forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont fontWithName:@"AvenirNext-DemiBold"
                                                   size:14];
    [button addTarget:target
                     action:selector
     forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.backgroundColor = [UIColor clearColor];
    button.titleLabel.opaque = NO;
    [button sizeToFit];

    return button;
}

@end
