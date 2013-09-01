//
//  CenterDemo1.m
//  WeViews2DemoApp
//
//  Copyright (c) 2013 Charles Matthew Chen. All rights reserved.
//

#import "WeView2.h"
#import "CenterDemo1.h"

@implementation CenterDemo1

- (NSString *)name
{
    return @"Horizontal Linear 1";
}

- (DemoModel *)demoModel
{
    DemoModel *result = [DemoModel create];

    [[result.rootView useHorizontalDefaultLayout]
    addSubviews:@[
     [self createLabel:@"Welcome"
              fontSize:16.f],
     [self createLabel:@"To"
              fontSize:24.f],
     [self createLabel:@"WeView2"
              fontSize:32.f],
     ]];
    [[[result.rootView setVMargin:10]
      setHMargin:20]
     setSpacing:5];

    [self assignRandomBackgroundColors:[self collectSubviews:result.rootView]];
//    result.debugLayout = YES;
    result.rootView.debugName = @"CenterDemo1";
    return result;
}

@end
