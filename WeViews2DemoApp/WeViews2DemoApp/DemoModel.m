//
//  DemoModel.m
//  WeViews2DemoApp
//
//  Copyright (c) 2013 Charles Matthew Chen. All rights reserved.
//

#import "DemoModel.h"
#import "WeView2DemoConstants.h"
//#import "WeMacros.h"
//#import "WePanel.h"
//#import "MockIPhone.h"
//#import "WeViewsDemoUtils.h"
//#import "WeScrollView.h"

//
//@interface CanvasPanel : WePanel
//
//@end
//
//
//#pragma mark
//
//
//@implementation CanvasPanel
//
//@end
//
//
//#pragma mark

@implementation DemoModel

+ (DemoModel *)create {
    DemoModel* result = [[DemoModel alloc] init];
    result.rootView = [[WeView2 alloc] init];

    return result;
}

- (void)setSelection:(id)value
{
    if (_selection == value)
    {
        return;
    }
    _selection = value;

    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SELECTION_CHANGED
                                                        object:_selection];
    [self.delegate selectionChanged:self.selection];
}

//- (void) setNewItem:(id) value
//          andSelect:(BOOL) andSelect {
//    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_ITEM_ADDED
//                                                        object:value];
//    if (andSelect) {
//        id toSelect = value;
//        if (value !=  nil && [value isKindOfClass:[MockIPhone class]]) {
//            MockIPhone* mockIPhone = (MockIPhone*) value;
//            toSelect = mockIPhone.screen;
//        }
//        [self setSelection:toSelect];
//    } else {
//        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SELECTION_CHANGED
//                                                            object:_selection];
//    }
//}

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

//- (NSArray*) getAllCanvasViews:(UIView*) view {
//    NSMutableArray* result = [NSMutableArray array];
//
//    [result addObject:view];
//
//    if ([WeViewsDemoUtils ignoreChildrenOfView:view]) {
//        // Ignore children of certain UIView subclasses.
//    } else if ([view respondsToSelector:@selector(mockSubviews)]) {
//        NSArray* mockSubviews = [view performSelector:@selector(mockSubviews)];
//        for (UIView* subview in mockSubviews) {
//            [result addObjectsFromArray:[self getAllCanvasViews:subview]];
//        }
//    } else {
//        for (UIView* subview in view.subviews) {
//            [result addObjectsFromArray:[self getAllCanvasViews:subview]];
//        }
//    }
//
//    return result;
//}

//- (NSArray*) getAllCanvasViews {
//    return [self getAllCanvasViews:rootView];
//}
//
//- (void) addToSelection:(UIView*) view
//              andSelect:(BOOL) andSelect {
//    UIView* parentView;
//    if ([selection isKindOfClass:[WePanel class]]) {
//        WePanel* panel = (WePanel*) selection;
//        [panel addSubview:view];
//        parentView = panel;
//    } else if ([selection isKindOfClass:[WeScrollView class]]) {
//        WeScrollView* scrollView = (WeScrollView*) selection;
//        scrollView.content = view;
//        parentView = scrollView;
//    } else if ([selection isKindOfClass:[WePanelLayer class]]) {
//        WePanelLayer* layer = (WePanelLayer*) selection;
//        [layer addView:view];
//        parentView = layer.panel;
//    }
//
//    // Randomize location within parent view
//    CGRect parentFrame = parentView.frame;
//    CGRect viewFrame = view.frame;
//    int rangeX = _wv_max(1, parentFrame.size.width - viewFrame.size.width);
//    int rangeY = _wv_max(1, parentFrame.size.height - viewFrame.size.height);
//    CGPoint randomOrigin = CGPointMake(RANDOM_INT() % rangeX,
//                                       RANDOM_INT() % rangeY);
//    setUIViewOrigin(view, randomOrigin);
//
//    // re-layout
//    [WeViewsDemoUtils reLayoutParentsOfView:parentView
//                                   withRoot:rootView.superview];
//
//    //    DemoModel.selection = view;
//    [self setNewItem:view
//                  andSelect:andSelect];
//}

@end
