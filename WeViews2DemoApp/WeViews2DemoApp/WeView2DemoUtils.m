//
//  WeView2DemoUtils.m
//  WeViews2DemoApp
//
//  Copyright (c) 2013 Charles Matthew Chen. All rights reserved.
//
//  Distributed under the Apache License v2.0.
//  http://www.apache.org/licenses/LICENSE-2.0.html
//

#import "WeView2DemoUtils.h"

@implementation WeView2DemoUtils

//+ (NSArray*) allColors {
//    return [NSArray arrayWithObjects:
//            [UIColor redColor],
//            [UIColor greenColor],
//            [UIColor blueColor],
//            //            [UIColor colorWithWhite:0.25f alpha:1.0f],
//            [UIColor orangeColor],
//            [UIColor purpleColor],
//            [UIColor brownColor],
//            [UIColor yellowColor],
//            [UIColor cyanColor],
//            [UIColor magentaColor],
//
//            [UIColor whiteColor],
//            [UIColor colorWithWhite:0.75f alpha:1.0f],
//            [UIColor colorWithWhite:0.5f alpha:1.0f],
//            [UIColor colorWithWhite:0.25f alpha:1.0f],
//            [UIColor blackColor],
//
//            UIColorRGB(0x5f8ab7),
//            UIColorRGB(0xf3f6f9),
//            UIColorRGB(0xb9c8cf),
//            UIColorRGB(0xe7e7e7),
//            UIColorRGB(0x026db1),
//            UIColorRGB(0xa5a5a5),
//            UIColorRGB(0x0196ce),
//            UIColorRGB(0x3e5386),
//            UIColorRGB(0x314d8a),
//            UIColorRGB(0x5572b1),
//            UIColorRGB(0xf7f7f7),
//            UIColorRGB(0x303034),
//            UIColorRGB(0xE6E6E6),
//
//            [[UIColor redColor] colorWithAlphaComponent:0.5f],
//            [[UIColor greenColor] colorWithAlphaComponent:0.5f],
//            [[UIColor blueColor] colorWithAlphaComponent:0.5f],
//            [[UIColor orangeColor] colorWithAlphaComponent:0.5f],
//            [[UIColor purpleColor] colorWithAlphaComponent:0.5f],
//            [[UIColor brownColor] colorWithAlphaComponent:0.5f],
//            [[UIColor yellowColor] colorWithAlphaComponent:0.5f],
//            [[UIColor cyanColor] colorWithAlphaComponent:0.5f],
//            [[UIColor magentaColor] colorWithAlphaComponent:0.5f],
//            [[UIColor whiteColor] colorWithAlphaComponent:0.5f],
//            [[UIColor blackColor] colorWithAlphaComponent:0.5f],
//
//            [UIColor clearColor],
//            nil];
//}
//
//+ (NSArray*) foregroundColors {
//    return [self allColors];
//}
//
//+ (NSArray*) backgroundColors {
//    return [self allColors];
//}
//
//+ (NSArray*) foregroundColors {
//    return [NSArray arrayWithObjects:
//            [UIColor redColor],
//            [UIColor greenColor],
//            [UIColor blueColor],
//            //            [UIColor colorWithWhite:0.25f alpha:1.0f],
//            [UIColor colorWithWhite:0.75f alpha:1.0f],
//            [UIColor orangeColor],
//            [UIColor purpleColor],
//            [UIColor brownColor],
//            [UIColor yellowColor],
//            nil];
//}
//
//+ (NSArray*) backgroundColors {
//    return [NSArray arrayWithObjects:
//            [UIColor whiteColor],
//            [UIColor colorWithWhite:0.25f alpha:1.0f],
//            [UIColor blackColor],
//            [UIColor clearColor],
//            nil];
//}
//
//+ (NSArray*) allColors {
//    NSMutableArray* result = [NSMutableArray array];
//    [result addObjectsFromArray:[self foregroundColors]];
//    [result addObjectsFromArray:[self backgroundColors]];
//    return result;
//}
//
//+ (UIColor*) randomForegroundColor {
//    NSArray* colorOptions = [self foregroundColors];
//    UIColor* value = [colorOptions objectAtIndex:RANDOM_INT() % [colorOptions count]];
//    return value;
//}
//
//+ (UIColor*) randomBackgroundColor {
//    NSArray* colorOptions = [self backgroundColors];
//    UIColor* value = [colorOptions objectAtIndex:RANDOM_INT() % [colorOptions count]];
//    return value;
//}
//
//+ (UIButton*) makeButton:(NSString*) label
//                  target:(id) target
//                selector:(SEL) selector {
//    UIButton* button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [button setTitle:label
//            forState:UIControlStateNormal];
//    button.titleLabel.font = [UIFont systemFontOfSize:14];
//    button.titleLabel.textColor = [UIColor blackColor];
//    [button addTarget:target
//               action:selector
//     forControlEvents:UIControlEventTouchUpInside];
//    return button;
//}
//
//+ (WeLink*) makeLink:(NSString*) label {
//    WeLink* result = [WeLink create:label
//                             font:[UIFont systemFontOfSize:14]
//                          upColor:[UIColor whiteColor]
//                        downColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5f]];
//    return result;
//}
//
//+ (WeLink*) makeLink:(NSString*) label
//             target:(id) target
//           selector:(SEL) selector {
//    WeLink* result = [self makeLink:label];
//    [result addClickSelector:selector
//                      target:target];
//    return result;
//}
//
//+ (void) reLayoutParentsOfView:(UIView*) view
//                      withRoot:(UIView*) rootView {
//
//    while (view != nil) {
//        if (view == rootView) {
//            break;
//        }
//        if ([view isKindOfClass:[WePanel class]]) {
//            WePanel* panel = (WePanel*) view;
//            [panel layoutContents];
//        }
//
//        view = [view superview];
//    }
//}

+ (BOOL)ignoreChildrenOfView:(UIView *)view {
    return ([view isKindOfClass:[UIButton class]] ||
            [view isKindOfClass:[UITableView class]] ||
            [view isKindOfClass:[UITextField class]] ||
            [view isKindOfClass:[UIActivityIndicatorView class]] ||
            [view isKindOfClass:[UISlider class]] ||
            [view isKindOfClass:[UIDatePicker class]] ||
            [view isKindOfClass:[UIProgressView class]] ||
            [view isKindOfClass:[UISearchBar class]] ||
            [view isKindOfClass:[UIWebView class]]);
}

//+ (void) randomizeViewLocation:(UIView*) view {
//    UIView* parent = view.superview;
//
//    // Randomize location within parent view
//    CGRect parentFrame = parent.frame;
//    CGRect viewFrame = view.frame;
//    int rangeX = _wv_max(1, parentFrame.size.width - viewFrame.size.width);
//    int rangeY = _wv_max(1, parentFrame.size.height - viewFrame.size.height);
//    CGPoint randomOrigin = CGPointMake(RANDOM_INT() % rangeX,
//                                       RANDOM_INT() % rangeY);
//    setUIViewOrigin(view, randomOrigin);
//}

@end
