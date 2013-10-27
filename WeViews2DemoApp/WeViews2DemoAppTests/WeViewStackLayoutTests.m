//
//  WeViewStackLayoutTests.m
//  WeView v2
//
//  Copyright (c) 2013 Charles Matthew Chen. All rights reserved.
//
//  Distributed under the Apache License v2.0.
//  http://www.apache.org/licenses/LICENSE-2.0.html
//

#import "WeView.h"
#import "WeViewStackLayoutTests.h"
#import "WeViewTestView.h"

@implementation WeViewStackLayoutTests

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
    return [weView addSubviewWithCustomLayout:subview];
}

- (WeViewLayout *)addSubviews:(NSArray *)subviews
                     toWeView:(WeView *)weView
{
    return [weView addSubviewsWithStackLayout:subviews];
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

@end
