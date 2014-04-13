//
//  WeViewVerticalLayoutTests.m
//  WeView v2
//
//  Copyright (c) 2014 Charles Matthew Chen. All rights reserved.
//
//  Distributed under the Apache License v2.0.
//  http://www.apache.org/licenses/LICENSE-2.0.html
//

#import "WeView.h"
#import "WeViewTestView.h"
#import "WeViewVerticalLayoutTests.h"

@implementation WeViewVerticalLayoutTests

- (void)setUp
{
    [super setUp];

    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.

    [super tearDown];
}

- (WeViewLayout *)addSubview:(UIView *)subview
                    toWeView:(WeView *)weView
{
    return [weView addSubviewsWithVerticalLayout:@[subview,]];
}

- (WeViewLayout *)addSubviews:(NSArray *)subviews
                     toWeView:(WeView *)weView
{
    return [weView addSubviewsWithVerticalLayout:subviews];
}

- (void)testBasicSizing
{
    [super baseTestBasicSizing];
}

- (void)testBasicMinAndMaxSize
{
    [super baseTestBasicMinAndMaxSize];
}

- (void)testBasicSpacing
{
    [super baseTestBasicSpacing];
}

- (void)testBasicRounding
{
    [super baseTestBasicRounding];
}

- (void)baseTestBasicSizing
{
    WeView *weView = [[WeView alloc] init];
    CGSize subviewSize = CGSizeMake(100, 100);
    WeViewTestView *subview0 = [[WeViewTestView alloc] initWithDesiredSize:subviewSize];
    WeViewTestView *subview1 = [[WeViewTestView alloc] initWithDesiredSize:subviewSize];
    WeViewTestView *subview2 = [[WeViewTestView alloc] initWithDesiredSize:subviewSize];
    WeViewLayout *layout = [self addSubviews:@[subview0, subview1, subview2]
                                    toWeView:weView];

    STAssertTrue(CGSizeEqualToSize([weView sizeThatFits:CGSizeZero], CGSizeMake(100, 300)), @"Unexpected value");

    STAssertTrue(CGSizeEqualToSize([weView sizeThatFits:CGSizeMake(1, 1)], CGSizeMake(100, 300)), @"Unexpected value");

    for (UIView *subview in weView.subviews)
    {
        [subview resetAllLayoutProperties];
    }
    [layout resetAllProperties];
    layout.topMargin = 10;

    STAssertTrue(CGSizeEqualToSize([weView sizeThatFits:CGSizeZero], CGSizeMake(100, 310)), @"Unexpected value");

    for (UIView *subview in weView.subviews)
    {
        [subview resetAllLayoutProperties];
    }
    [layout resetAllProperties];
    layout.vSpacing = 10;

    STAssertTrue(CGSizeEqualToSize([weView sizeThatFits:CGSizeZero], CGSizeMake(100, 320)), @"Unexpected value");

    for (UIView *subview in weView.subviews)
    {
        [subview resetAllLayoutProperties];
    }
    [layout resetAllProperties];
    layout.vSpacing = -10;

    STAssertTrue(CGSizeEqualToSize([weView sizeThatFits:CGSizeZero], CGSizeMake(100, 280)), @"Unexpected value");
}

@end
