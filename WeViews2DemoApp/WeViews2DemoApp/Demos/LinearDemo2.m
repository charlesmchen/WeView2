//
//  LinearDemo2.m
//  WeViews2DemoApp
//
//  Copyright (c) 2013 Charles Matthew Chen. All rights reserved.
//

#import "WeView2.h"
#import "LinearDemo2.h"

@implementation LinearDemo2

- (NSString *)name
{
    return @"Horizontal Linear 1";
}

- (DemoModel *)demoModel
{
    DemoModel *result = [DemoModel create];
    
    WeView2 *topPanel = [[WeView2 alloc] init];
    [[topPanel useHorizontalDefaultLayout]
     addSubviews:@[
     [self createLabel:@"Welcome"
              fontSize:16.f],
     [self createLabel:@"To"
              fontSize:24.f],
     [self createLabel:@"WeView2"
              fontSize:32.f],
     ]];
    [[[topPanel setVMargin:10]
      setHMargin:20]
     setSpacing:5];
    
    WeView2 *bottomPanel = [[WeView2 alloc] init];
    [[bottomPanel useHorizontalDefaultLayout]
     addSubviews:@[
     [self createLabel:@"Welcome"
              fontSize:16.f],
     [self createLabel:@"To"
              fontSize:24.f],
     [self createLabel:@"WeView2"
              fontSize:32.f],
     ]];
    [[[bottomPanel setVMargin:10]
      setHMargin:20]
     setSpacing:5];
    
    [[result.rootView useVerticalDefaultLayout]
     addSubviews:@[
     topPanel,
     bottomPanel,
     ]];
    [[result.rootView setMargin:10]
     setSpacing:10];

//    topPanel.debugLayout = YES;
//    result.rootView.debugLayout = YES;
//    topPanel.debugMinSize = YES;
//    topPanel.debugLayout = YES;
    
    [self assignRandomBackgroundColors:[self collectSubviews:result.rootView]];
//    result.debugLayout = YES;
    result.rootView.debugName = @"LinearDemo2";
    topPanel.debugName = @"topPanel";
    bottomPanel.debugName = @"bottomPanel";
    return result;
}

@end
