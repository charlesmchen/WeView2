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

//- (LoadableList::Ptr)createLoadableList:(int)size
//{
//    ModelList::Ptr modelList = ModelList::New();
//    for (int i = 0; i < size; i++) {
//        modelList->AddItem(Journal::New(ModelId(std::to_string(i))));
//    }
//    return LoadableList::New(modelList, make_shared<LoadableCache>());
//}
//
//- (void)testWithListSize:(int)size
//                maxItemsToLoad:(int)maxItemsToLoad
//                  itemsPerPage:(int)itemsPerPage
//              baseLoadPriority:(optional<LoadablePriority>)baseLoadPriority
//             selectedItemIndex:(optional<int>)selectedItemIndex
//    expectedDistanceComponents:(vector<optional<float>>)expectedDistanceComponents
//{
//    LoadRequester::Ptr loadRequestor = LoadRequester::New();
//    LoadableList::Ptr loadableList = [self createLoadableList:size];
//    loadableList->SelectItemAtIndex(selectedItemIndex ? *selectedItemIndex : -1,
//                                    ModelListIsAtRest::Yes);
//
//    GridLoadableLoadPolicy::Ptr loadPolicy = GridLoadableLoadPolicy::New(maxItemsToLoad, itemsPerPage);
//    loadPolicy->SetBasePriority(baseLoadPriority);
//    loadPolicy->UpdatePriorities(loadableList, loadRequestor);
//
//    // Print the observed and expected and distance
//    for (int i = 0; i < size; i++) {
//        optional<LoadablePriority> loadPriority = loadableList->GetLoadable(i)->LoadPriority();
//        printf("%s ", (loadPriority ? std::to_string(loadPriority->DistanceComponent()).c_str() : "none"));
//        printf("[%s], ", (expectedDistanceComponents[i] ? std::to_string(expectedDistanceComponents[i].get()).c_str() : "none"));
//    }
//    for (int i = 0; i < size; i++) {
//        optional<LoadablePriority> loadPriority = loadableList->GetLoadable(i)->LoadPriority();
//        XCTAssertEqual((loadPriority
//                            ? optional<float>(loadPriority->DistanceComponent())
//                            : none),
//                       expectedDistanceComponents[i],
//                       @"");
//        if (loadPriority) {
//            XCTAssertEqual(loadPriority->RelevanceComponent(),
//                           0.f,
//                           @"");
//        }
//    }
//    printf("\n");
//}

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
        //        NSLog(@"weview.frame: %@", NSStringFromCGRect(weview.frame));
        [weview sizeToFit];
        [weview layoutSubviews];
        //        NSLog(@"weview.frame: %@", NSStringFromCGRect(weview.frame));
        XCTAssertTrue(CGSizeEqualToSize(weview.size, weviewSize));
        //        NSLog(@"view0.origin: %@", NSStringFromCGPoint(view0.origin));
        //        NSLog(@"view0.origin: %@", NSStringFromCGPoint(view1.origin));
        XCTAssertTrue(CGSizeEqualToSize(view0.size, view0Size));
        XCTAssertTrue(CGSizeEqualToSize(view1.size, view1Size));
        //        NSLog(@"view0.origin: %@", NSStringFromCGPoint(view0.origin));
        //        NSLog(@"view0.origin: %@", NSStringFromCGPoint(view1.origin));
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
    [view0 setIgnoreDesiredSize];
    [weview addSubviewWithLayout:view0];

    {
        NSLog(@"x: %@", NSStringFromCGSize([weview sizeThatFits:CGSizeZero]));
        XCTAssertTrue(CGSizeEqualToSize([weview sizeThatFits:CGSizeZero], CGSizeMake(1000, 10)));
        XCTAssertTrue(CGSizeEqualToSize([weview sizeThatFits:CGSizeMake(5, 5)], CGSizeMake(10, 1000)));
        XCTAssertTrue(CGSizeEqualToSize([weview sizeThatFits:CGSizeMake(10, 10)], CGSizeMake(10, 1000)));
        XCTAssertTrue(CGSizeEqualToSize([weview sizeThatFits:CGSizeMake(100, 10)], CGSizeMake(100, 100)));
    }

    // sizeThatFits:CGSizeZero
    {
        weview.size = [weview sizeThatFits:CGSizeZero];
        [weview sizeToFit];
        [weview layoutSubviews];
        NSLog(@"weview.frame: %@", NSStringFromCGRect(weview.frame));
        NSLog(@"view0: %@", NSStringFromCGRect(view0.frame));
        XCTAssertTrue(CGSizeEqualToSize(weview.size, CGSizeMake(1000, 10)));
        XCTAssertTrue(CGSizeEqualToSize(view0.size, CGSizeMake(1000, 10)));
        XCTAssertTrue(CGPointEqualToPoint(view0.origin, CGPointMake(0, 0)));
    }
}

@end
