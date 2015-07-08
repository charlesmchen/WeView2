//
//  LinearLayoutTests.mm
//  WeView
//
//  Copyright (c) 2015 FiftyThree, Inc. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "UIView+WeView.h"
#import "WeView.h"
#import "WrappingTestView.h"

@interface LinearLayoutTests : XCTestCase

@end

#pragma mark -

@implementation LinearLayoutTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testHorizontalLayout_OneView
{
    WeView *weview = [[WeView alloc] init];

    UIView *view0 = [[UIView alloc] init];
    CGSize view0Size = CGSizeMake(100, 100);
    view0.size = view0Size;
    [weview addSubviewWithLayout:view0];

    {
        XCTAssertTrue(CGSizeEqualToSize([weview sizeThatFits:CGSizeZero], view0Size));
        XCTAssertTrue(CGSizeEqualToSize([weview sizeThatFits:CGSizeMake(10, 10)], view0Size));
        XCTAssertTrue(CGSizeEqualToSize([weview sizeThatFits:CGSizeMake(1000, 1000)], view0Size));
        [weview sizeToFit];
        [weview layoutSubviews];
        XCTAssertTrue(CGSizeEqualToSize(weview.size, view0Size));
        XCTAssertTrue(CGSizeEqualToSize(view0.size, view0Size));
        XCTAssertTrue(CGPointEqualToPoint(view0.origin, CGPointZero));
    }
}

- (void)testHorizontalLayout_TwoViews
{
    WeView *weview = [[WeView alloc] init];

    UIView *view0 = [[UIView alloc] init];
    CGSize view0Size = CGSizeMake(100, 100);
    view0.size = view0Size;
    UIView *view1 = [[UIView alloc] init];
    CGSize view1Size = CGSizeMake(200, 200);
    view1.size = view1Size;
    WeViewLayout *layout = [weview addSubviewsWithHorizontalLayout:@[ view0, view1, ]];

    {
        CGSize weviewSize = CGSizeMake(300, 200);
        XCTAssertTrue(CGSizeEqualToSize([weview sizeThatFits:CGSizeZero], weviewSize));
        XCTAssertTrue(CGSizeEqualToSize([weview sizeThatFits:CGSizeMake(10, 10)], weviewSize));
        XCTAssertTrue(CGSizeEqualToSize([weview sizeThatFits:CGSizeMake(1000, 1000)], weviewSize));
        [weview sizeToFit];
        [weview layoutSubviews];
        XCTAssertTrue(CGSizeEqualToSize(weview.size, weviewSize));
        XCTAssertTrue(CGSizeEqualToSize(view0.size, view0Size));
        XCTAssertTrue(CGSizeEqualToSize(view1.size, view1Size));
        XCTAssertTrue(CGPointEqualToPoint(view0.origin, CGPointMake(0, 50)));
        XCTAssertTrue(CGPointEqualToPoint(view1.origin, CGPointMake(100, 0)));
    }

    [layout setSpacing:10];

    {
        CGSize weviewSize = CGSizeMake(310, 200);
        XCTAssertTrue(CGSizeEqualToSize([weview sizeThatFits:CGSizeZero], weviewSize));
        XCTAssertTrue(CGSizeEqualToSize([weview sizeThatFits:CGSizeMake(10, 10)], weviewSize));
        XCTAssertTrue(CGSizeEqualToSize([weview sizeThatFits:CGSizeMake(1000, 1000)], weviewSize));
        [weview sizeToFit];
        [weview layoutSubviews];
        XCTAssertTrue(CGSizeEqualToSize(weview.size, weviewSize));
        XCTAssertTrue(CGSizeEqualToSize(view0.size, view0Size));
        XCTAssertTrue(CGSizeEqualToSize(view1.size, view1Size));
        XCTAssertTrue(CGPointEqualToPoint(view0.origin, CGPointMake(0, 50)));
        XCTAssertTrue(CGPointEqualToPoint(view1.origin, CGPointMake(110, 0)));
    }

    [layout setSpacing:0];
    [layout setMargin:10];

    {
        CGSize weviewSize = CGSizeMake(320, 220);
        XCTAssertTrue(CGSizeEqualToSize([weview sizeThatFits:CGSizeZero], weviewSize));
        XCTAssertTrue(CGSizeEqualToSize([weview sizeThatFits:CGSizeMake(10, 10)], weviewSize));
        XCTAssertTrue(CGSizeEqualToSize([weview sizeThatFits:CGSizeMake(1000, 1000)], weviewSize));
        [weview sizeToFit];
        [weview layoutSubviews];
        XCTAssertTrue(CGSizeEqualToSize(weview.size, weviewSize));
        XCTAssertTrue(CGSizeEqualToSize(view0.size, view0Size));
        XCTAssertTrue(CGSizeEqualToSize(view1.size, view1Size));
        XCTAssertTrue(CGPointEqualToPoint(view0.origin, CGPointMake(10, 60)));
        XCTAssertTrue(CGPointEqualToPoint(view1.origin, CGPointMake(110, 10)));
    }

    [layout setSpacing:20];
    [layout setMargin:10];

    {
        CGSize weviewSize = CGSizeMake(340, 220);
        XCTAssertTrue(CGSizeEqualToSize([weview sizeThatFits:CGSizeZero], weviewSize));
        XCTAssertTrue(CGSizeEqualToSize([weview sizeThatFits:CGSizeMake(10, 10)], weviewSize));
        XCTAssertTrue(CGSizeEqualToSize([weview sizeThatFits:CGSizeMake(1000, 1000)], weviewSize));
        [weview sizeToFit];
        [weview layoutSubviews];
        XCTAssertTrue(CGSizeEqualToSize(weview.size, weviewSize));
        XCTAssertTrue(CGSizeEqualToSize(view0.size, view0Size));
        XCTAssertTrue(CGSizeEqualToSize(view1.size, view1Size));
        XCTAssertTrue(CGPointEqualToPoint(view0.origin, CGPointMake(10, 60)));
        XCTAssertTrue(CGPointEqualToPoint(view1.origin, CGPointMake(130, 10)));
    }
}

- (void)testHorizontalLayout_Wrapping0
{
    WeView *weview = [[WeView alloc] init];

    WrappingTestView *view0 = [[WrappingTestView alloc] init];
    view0.blockSize = CGSizeMake(10, 10);
    view0.blockCount = 100;
    [weview addSubviewWithLayout:view0];

    {
        XCTAssertTrue(CGSizeEqualToSize([weview sizeThatFits:CGSizeZero], CGSizeMake(1000, 10)));
        XCTAssertTrue(CGSizeEqualToSize([weview sizeThatFits:CGSizeMake(5, 5)], CGSizeMake(10, 1000)));
        XCTAssertTrue(CGSizeEqualToSize([weview sizeThatFits:CGSizeMake(10, 10)], CGSizeMake(10, 1000)));
        XCTAssertTrue(CGSizeEqualToSize([weview sizeThatFits:CGSizeMake(100, 10)], CGSizeMake(100, 100)));

        weview.size = [weview sizeThatFits:CGSizeZero];
        [weview sizeToFit];
        [weview layoutSubviews];
        XCTAssertTrue(CGSizeEqualToSize(weview.size, CGSizeMake(1000, 10)));
        XCTAssertTrue(CGSizeEqualToSize(view0.size, CGSizeMake(1000, 10)));
        XCTAssertTrue(CGPointEqualToPoint(view0.origin, CGPointMake(0, 0)));
    }
}

- (void)testHorizontalLayout_Wrapping1
{
    WeView *weview = [[WeView alloc] init];
    
    WrappingTestView *view0 = [[WrappingTestView alloc] init];
    view0.blockSize = CGSizeMake(10, 10);
    view0.blockCount = 100;
    [view0 setHStretches];
    [view0 setIgnoreDesiredWidth:YES];
    [weview addSubviewsWithHorizontalLayout:@[view0,]];
    
    {
        XCTAssertTrue(CGSizeEqualToSize([weview sizeThatFits:CGSizeZero], CGSizeMake(0, 10)));
        XCTAssertTrue(CGSizeEqualToSize([weview sizeThatFits:CGSizeMake(5, 5)], CGSizeMake(5, 1000)));
        XCTAssertTrue(CGSizeEqualToSize([weview sizeThatFits:CGSizeMake(10, 10)], CGSizeMake(10, 1000)));
        XCTAssertTrue(CGSizeEqualToSize([weview sizeThatFits:CGSizeMake(100, 10)], CGSizeMake(100, 100)));
    }
    
    // CGSizeZero, sizeToFit
    {
        weview.size = CGSizeZero;
        [weview sizeToFit];
        [weview layoutSubviews];
        XCTAssertTrue(CGSizeEqualToSize(weview.size, CGSizeMake(0, 10)));
        XCTAssertTrue(CGSizeEqualToSize(view0.size, CGSizeMake(0, 10)));
        XCTAssertTrue(CGPointEqualToPoint(view0.origin, CGPointMake(0, 0)));
    }
    
    // CGSizeMake(50, 50), sizeToFit
    {
        weview.size = CGSizeMake(50, 50);
        [weview sizeToFit];
        [weview layoutSubviews];
        XCTAssertTrue(CGSizeEqualToSize(weview.size, CGSizeMake(0, 10)));
        XCTAssertTrue(CGSizeEqualToSize(view0.size, CGSizeMake(0, 10)));
        XCTAssertTrue(CGPointEqualToPoint(view0.origin, CGPointMake(0, 0)));
    }
    
    // CGSizeMake(5, 5)
    {
        weview.size = CGSizeMake(5, 5);
        [weview layoutSubviews];
        XCTAssertTrue(CGSizeEqualToSize(weview.size, CGSizeMake(5, 5)));
        XCTAssertTrue(CGSizeEqualToSize(view0.size, CGSizeMake(5, 1000)));
        XCTAssertTrue(CGPointEqualToPoint(view0.origin, CGPointMake(0, -498)));
    }
    
    // CGSizeMake(10, 10)
    {
        weview.size = CGSizeMake(10, 10);
        [weview layoutSubviews];
        XCTAssertTrue(CGSizeEqualToSize(weview.size, CGSizeMake(10, 10)));
        XCTAssertTrue(CGSizeEqualToSize(view0.size, CGSizeMake(10, 1000)));
        XCTAssertTrue(CGPointEqualToPoint(view0.origin, CGPointMake(0, -495)));
    }
    
    // CGSizeMake(30, 30)
    {
        weview.size = CGSizeMake(30, 30);
        [weview layoutSubviews];
        XCTAssertTrue(CGSizeEqualToSize(weview.size, CGSizeMake(30, 30)));
        XCTAssertTrue(CGSizeEqualToSize(view0.size, CGSizeMake(30, 330)));
        XCTAssertTrue(CGPointEqualToPoint(view0.origin, CGPointMake(0, -150)));
    }
    
    // CGSizeMake(100, 100)
    {
        weview.size = CGSizeMake(100, 100);
        [weview layoutSubviews];
        XCTAssertTrue(CGSizeEqualToSize(weview.size, CGSizeMake(100, 100)));
        XCTAssertTrue(CGSizeEqualToSize(view0.size, CGSizeMake(100, 100)));
        XCTAssertTrue(CGPointEqualToPoint(view0.origin, CGPointMake(0, 0)));
    }
    
    // sizeThatFits:CGSizeMake(100, 0)
    {
        weview.size = [weview sizeThatFits:CGSizeMake(100, 0)];
        [weview layoutSubviews];
        XCTAssertTrue(CGSizeEqualToSize(weview.size, CGSizeMake(100, 100)));
        XCTAssertTrue(CGSizeEqualToSize(view0.size, CGSizeMake(100, 100)));
        XCTAssertTrue(CGPointEqualToPoint(view0.origin, CGPointMake(0, 0)));
    }
}

- (void)testStackLayout_Wrapping1
{
    WeView *weview = [[WeView alloc] init];
    
    WrappingTestView *view0 = [[WrappingTestView alloc] init];
    view0.blockSize = CGSizeMake(10, 10);
    view0.blockCount = 100;
    [view0 setHStretches];
    [view0 setIgnoreDesiredWidth:YES];
    [weview addSubviewWithLayout:view0];
    
    {
        XCTAssertTrue(CGSizeEqualToSize([weview sizeThatFits:CGSizeZero], CGSizeMake(0, 10)));
        XCTAssertTrue(CGSizeEqualToSize([weview sizeThatFits:CGSizeMake(5, 5)], CGSizeMake(0, 1000)));
        XCTAssertTrue(CGSizeEqualToSize([weview sizeThatFits:CGSizeMake(10, 10)], CGSizeMake(0, 1000)));
        XCTAssertTrue(CGSizeEqualToSize([weview sizeThatFits:CGSizeMake(100, 10)], CGSizeMake(0, 100)));
    }
    
    // CGSizeZero, sizeToFit
    {
        weview.size = CGSizeZero;
        [weview sizeToFit];
        [weview layoutSubviews];
        XCTAssertTrue(CGSizeEqualToSize(weview.size, CGSizeMake(0, 10)));
        XCTAssertTrue(CGSizeEqualToSize(view0.size, CGSizeMake(0, 10)));
        XCTAssertTrue(CGPointEqualToPoint(view0.origin, CGPointMake(0, 0)));
    }
    
    // CGSizeMake(50, 50), sizeToFit
    {
        weview.size = CGSizeMake(50, 50);
        [weview sizeToFit];
        [weview layoutSubviews];
        XCTAssertTrue(CGSizeEqualToSize(weview.size, CGSizeMake(0, 10)));
        XCTAssertTrue(CGSizeEqualToSize(view0.size, CGSizeMake(0, 10)));
        XCTAssertTrue(CGPointEqualToPoint(view0.origin, CGPointMake(0, 0)));
    }
    
    // CGSizeMake(5, 5)
    {
        weview.size = CGSizeMake(5, 5);
        [weview layoutSubviews];
        XCTAssertTrue(CGSizeEqualToSize(weview.size, CGSizeMake(5, 5)));
        XCTAssertTrue(CGSizeEqualToSize(view0.size, CGSizeMake(5, 1000)));
        XCTAssertTrue(CGPointEqualToPoint(view0.origin, CGPointMake(0, -498)));
    }
    
    // CGSizeMake(10, 10)
    {
        weview.size = CGSizeMake(10, 10);
        [weview layoutSubviews];
        XCTAssertTrue(CGSizeEqualToSize(weview.size, CGSizeMake(10, 10)));
        XCTAssertTrue(CGSizeEqualToSize(view0.size, CGSizeMake(10, 1000)));
        XCTAssertTrue(CGPointEqualToPoint(view0.origin, CGPointMake(0, -495)));
    }
    
    // CGSizeMake(30, 30)
    {
        weview.size = CGSizeMake(30, 30);
        [weview layoutSubviews];
        XCTAssertTrue(CGSizeEqualToSize(weview.size, CGSizeMake(30, 30)));
        XCTAssertTrue(CGSizeEqualToSize(view0.size, CGSizeMake(30, 330)));
        XCTAssertTrue(CGPointEqualToPoint(view0.origin, CGPointMake(0, -150)));
    }
    
    // CGSizeMake(100, 100)
    {
        weview.size = CGSizeMake(100, 100);
        [weview layoutSubviews];
        XCTAssertTrue(CGSizeEqualToSize(weview.size, CGSizeMake(100, 100)));
        XCTAssertTrue(CGSizeEqualToSize(view0.size, CGSizeMake(100, 100)));
        XCTAssertTrue(CGPointEqualToPoint(view0.origin, CGPointMake(0, 0)));
    }
    
    // sizeThatFits:CGSizeMake(100, 0)
    {
        weview.size = [weview sizeThatFits:CGSizeMake(100, 0)];
        [weview layoutSubviews];
        XCTAssertTrue(CGSizeEqualToSize(weview.size, CGSizeMake(0, 100)));
        XCTAssertTrue(CGSizeEqualToSize(view0.size, CGSizeMake(0, 10)));
        XCTAssertTrue(CGPointEqualToPoint(view0.origin, CGPointMake(0, 45)));
    }
}

@end
