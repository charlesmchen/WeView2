//
//  WeViewDemoUtils.m
//  WeView v2
//
//  Copyright (c) 2013 Charles Matthew Chen. All rights reserved.
//
//  Distributed under the Apache License v2.0.
//  http://www.apache.org/licenses/LICENSE-2.0.html
//

#import "WeViewDemoUtils.h"

@implementation WeViewDemoUtils

+ (BOOL)ignoreChildrenOfView:(UIView *)view
{
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

@end
