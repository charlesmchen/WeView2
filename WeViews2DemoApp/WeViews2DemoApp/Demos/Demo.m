//
//  Demo.m
//  WeViews2DemoApp
//
//  Copyright (c) 2013 Charles Matthew Chen. All rights reserved.
//

#import "Demo.h"

@implementation Demo

- (NSString *)name
{
    return nil;
}

- (DemoModel *)demoModel
{
    return nil;
}

- (UILabel *)createLabel:(NSString *)text
                fontSize:(CGFloat)fontSize
{
    return [self createLabel:text
                    fontSize:fontSize
                   textColor:[UIColor whiteColor]];

}
- (UILabel *)createLabel:(NSString *)text
                fontSize:(CGFloat)fontSize
               textColor:(UIColor *)textColor
{
    UILabel *result = [[UILabel alloc] init];
    result.opaque = NO;
    result.backgroundColor = [UIColor clearColor];
    result.textColor = textColor;
    result.font = [UIFont systemFontOfSize:fontSize];
    result.text = text;
    return result;
}

- (UIColor *)colorWithRGBHex:(UInt32)hex
{
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;

    return [UIColor colorWithRed:r / 255.0f
                           green:g / 255.0f
                            blue:b / 255.0f
                           alpha:1.0f];
}

- (void)assignRandomBackgroundColors:(NSArray *)views
{
    static NSArray *colors = nil;
    if (!colors)
    {
        colors = @[
                   [self colorWithRGBHex:0x5271cb],
                   [self colorWithRGBHex:0xfd9345],
                   [self colorWithRGBHex:0xb74d4d],
                   [self colorWithRGBHex:0x94c365],
                   [self colorWithRGBHex:0xffcd6a],
                   [self colorWithRGBHex:0x7fcedd],
                   [self colorWithRGBHex:0xc49a50],
                   [self colorWithRGBHex:0x658a57],
                   [self colorWithRGBHex:0xff8a8a],
                   [self colorWithRGBHex:0x363636],
                   [self colorWithRGBHex:0xb1b1b1],
                   ];
    }
    static int colorIndexCounter = 0;
    for (UIView *view in views)
    {
        int colorIndex = colorIndexCounter;
        colorIndexCounter = (colorIndexCounter + 1) % [colors count];
        view.backgroundColor = colors[colorIndex];
        view.opaque = YES;
    }
}

- (NSArray *)collectSubviews:(UIView *)view
{
    NSMutableArray *result = [NSMutableArray array];
    [result addObject:view];
    for (UIView *subview in view.subviews)
    {
        [result addObjectsFromArray:[self collectSubviews:subview]];
    }
    return result;
}

@end
