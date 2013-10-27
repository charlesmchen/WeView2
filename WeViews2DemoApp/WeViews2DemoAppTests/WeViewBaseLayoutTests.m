//
//  WeViewBaseLayoutTests.m
//  WeView v2
//
//  Copyright (c) 2013 Charles Matthew Chen. All rights reserved.
//
//  Distributed under the Apache License v2.0.
//  http://www.apache.org/licenses/LICENSE-2.0.html
//

#import "WeView.h"
#import "WeViewBaseLayoutTests.h"
#import "WeViewTestView.h"

@implementation WeViewBaseLayoutTests

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
    // Subclasses should reimplement this method.
    WeViewAssert(0);
    return [weView addSubviewWithCustomLayout:subview];
}

- (WeViewLayout *)addSubviews:(NSArray *)subviews
                     toWeView:(WeView *)weView
{
    // Subclasses should reimplement this method.
    WeViewAssert(0);
    return [weView addSubviewsWithStackLayout:subviews];
}

- (void)baseTestBasicSizing
{
    WeView *weView = [[WeView alloc] init];
    CGSize subviewSize = CGSizeMake(100, 100);
    WeViewTestView *subview = [[WeViewTestView alloc] initWithDesiredSize:subviewSize];
    [self addSubview:subview
            toWeView:weView];

    STAssertTrue(CGSizeEqualToSize(subview.desiredSize, subviewSize), @"Unexpected value");

    STAssertTrue(CGSizeEqualToSize([subview sizeThatFits:CGSizeZero], subviewSize), @"Unexpected value");

    STAssertTrue(CGSizeEqualToSize([subview sizeThatFits:CGSizeMake(1, 1)], subviewSize), @"Unexpected value");

    STAssertTrue(CGSizeEqualToSize([subview sizeThatFits:CGSizeMake(1000, 1000)], subviewSize), @"Unexpected value");

    STAssertTrue(CGSizeEqualToSize([subview sizeThatFits:CGSizeMake(0, 1000)], subviewSize), @"Unexpected value");

    STAssertTrue(CGSizeEqualToSize([subview sizeThatFits:CGSizeMake(1000, 0)], subviewSize), @"Unexpected value");

    STAssertTrue(CGSizeEqualToSize([weView sizeThatFits:CGSizeZero], subviewSize), @"Unexpected value");

    STAssertTrue(CGSizeEqualToSize([weView sizeThatFits:CGSizeMake(1, 1)], subviewSize), @"Unexpected value");

    STAssertTrue(CGSizeEqualToSize([weView sizeThatFits:CGSizeMake(0, 1000)], subviewSize), @"Unexpected value");

    STAssertTrue(CGSizeEqualToSize([weView sizeThatFits:CGSizeMake(1000, 0)], subviewSize), @"Unexpected value");
}

- (void)baseTestBasicMinAndMaxSize
{
    WeView *weView = [[WeView alloc] init];
    CGSize subviewSize = CGSizeMake(100, 100);
    WeViewTestView *subview = [[WeViewTestView alloc] initWithDesiredSize:subviewSize];
    [self addSubview:subview
            toWeView:weView];

    [subview resetAllLayoutProperties];
    subview.minWidth = 200;
    STAssertTrue(CGSizeEqualToSize(subview.desiredSize, subviewSize), @"Unexpected value");
    STAssertTrue(CGSizeEqualToSize([weView sizeThatFits:CGSizeZero], CGSizeMake(200, 100)), @"Unexpected value");

    [subview resetAllLayoutProperties];

    STAssertTrue(CGSizeEqualToSize([weView sizeThatFits:CGSizeZero], subviewSize), @"Unexpected value");

    subview.maxWidth = 50;
    STAssertTrue(CGSizeEqualToSize(subview.desiredSize, subviewSize), @"Unexpected value");
    STAssertTrue(CGSizeEqualToSize([weView sizeThatFits:CGSizeZero], CGSizeMake(50, 100)), @"Unexpected value");

    [subview resetAllLayoutProperties];
    subview.minHeight = 200;
    STAssertTrue(CGSizeEqualToSize(subview.desiredSize, subviewSize), @"Unexpected value");
    STAssertTrue(CGSizeEqualToSize([weView sizeThatFits:CGSizeZero], CGSizeMake(100, 200)), @"Unexpected value");

    [subview resetAllLayoutProperties];

    STAssertTrue(CGSizeEqualToSize([weView sizeThatFits:CGSizeZero], subviewSize), @"Unexpected value");

    subview.maxHeight = 50;
    STAssertTrue(CGSizeEqualToSize(subview.desiredSize, subviewSize), @"Unexpected value");
    STAssertTrue(CGSizeEqualToSize([weView sizeThatFits:CGSizeZero], CGSizeMake(100, 50)), @"Unexpected value");
}

- (void)baseTestBasicSpacing
{
    WeView *weView = [[WeView alloc] init];
    CGSize subviewSize = CGSizeMake(100, 100);
    WeViewTestView *subview = [[WeViewTestView alloc] initWithDesiredSize:subviewSize];
    WeViewLayout *layout = [self addSubview:subview
                                   toWeView:weView];

    STAssertTrue(CGSizeEqualToSize([weView sizeThatFits:CGSizeZero], CGSizeMake(100, 100)), @"Unexpected value");

    [layout resetAllProperties];
    layout.topMargin = 50;

    STAssertTrue(CGSizeEqualToSize([weView sizeThatFits:CGSizeZero], CGSizeMake(100, 150)), @"Unexpected value");

    [layout resetAllProperties];
    layout.bottomMargin = 50;

    STAssertTrue(CGSizeEqualToSize([weView sizeThatFits:CGSizeZero], CGSizeMake(100, 150)), @"Unexpected value");

    [layout resetAllProperties];
    layout.vMargin = 50;

    STAssertTrue(CGSizeEqualToSize([weView sizeThatFits:CGSizeZero], CGSizeMake(100, 200)), @"Unexpected value");

    [layout resetAllProperties];
    layout.leftMargin = 50;

    STAssertTrue(CGSizeEqualToSize([weView sizeThatFits:CGSizeZero], CGSizeMake(150, 100)), @"Unexpected value");

    [layout resetAllProperties];
    layout.rightMargin = 50;

    STAssertTrue(CGSizeEqualToSize([weView sizeThatFits:CGSizeZero], CGSizeMake(150, 100)), @"Unexpected value");

    [layout resetAllProperties];
    layout.hMargin = 50;

    STAssertTrue(CGSizeEqualToSize([weView sizeThatFits:CGSizeZero], CGSizeMake(200, 100)), @"Unexpected value");

    [layout resetAllProperties];
    layout.margin = 50;

    STAssertTrue(CGSizeEqualToSize([weView sizeThatFits:CGSizeZero], CGSizeMake(200, 200)), @"Unexpected value");
}

- (void)baseTestBasicRounding
{
    WeView *weView = [[WeView alloc] init];
    CGSize subviewSize = CGSizeMake(100, 100);
    WeViewTestView *subview = [[WeViewTestView alloc] initWithDesiredSize:subviewSize];
    WeViewLayout *layout = [self addSubview:subview
                                   toWeView:weView];

    STAssertTrue(CGSizeEqualToSize([weView sizeThatFits:CGSizeZero], CGSizeMake(100, 100)), @"Unexpected value");

    [subview resetAllLayoutProperties];
    [layout resetAllProperties];
    subview.desiredSize = CGSizeMake(50.1, 50);

    STAssertTrue(CGSizeEqualToSize([weView sizeThatFits:CGSizeZero], CGSizeMake(51, 50)), @"Unexpected value");

    [subview resetAllLayoutProperties];
    [layout resetAllProperties];
    subview.desiredSize = CGSizeMake(50.9, 50);

    STAssertTrue(CGSizeEqualToSize([weView sizeThatFits:CGSizeZero], CGSizeMake(51, 50)), @"Unexpected value");

    [subview resetAllLayoutProperties];
    [layout resetAllProperties];
    subview.desiredSize = CGSizeMake(50, 50);
    subview.minWidth = 50.9;

    STAssertTrue(CGSizeEqualToSize([weView sizeThatFits:CGSizeZero], CGSizeMake(51, 50)), @"Unexpected value");

    [subview resetAllLayoutProperties];
    [layout resetAllProperties];
    subview.desiredSize = CGSizeMake(50, 50);
    layout.leftMargin = 0.1;

    STAssertTrue(CGSizeEqualToSize([weView sizeThatFits:CGSizeZero], CGSizeMake(51, 50)), @"Unexpected value");

    [subview resetAllLayoutProperties];
    [layout resetAllProperties];
    subview.desiredSize = CGSizeMake(50, 50);
    layout.hMargin = 0.4;

    STAssertTrue(CGSizeEqualToSize([weView sizeThatFits:CGSizeZero], CGSizeMake(52, 50)), @"Unexpected value");

    [subview resetAllLayoutProperties];
    [layout resetAllProperties];
    subview.desiredSize = CGSizeMake(50.4, 50);
    layout.leftMargin = 0.4;

    STAssertTrue(CGSizeEqualToSize([weView sizeThatFits:CGSizeZero], CGSizeMake(52, 50)), @"Unexpected value");
}

@end
