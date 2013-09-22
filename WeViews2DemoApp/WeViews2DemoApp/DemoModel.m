//
//  DemoModel.m
//  WeView 2
//
//  Copyright (c) 2013 Charles Matthew Chen. All rights reserved.
//
//  Distributed under the Apache License v2.0.
//  http://www.apache.org/licenses/LICENSE-2.0.html
//

#import "DemoModel.h"
#import "WeViewDemoConstants.h"

@implementation DemoModel

- (id)init
{
    self = [super init];
    if (self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleSetSelectionTo:)
                                                     name:NOTIFICATION_SET_SELECTION_TO
                                                   object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)handleSetSelectionTo:(NSNotification *)notification
{
    self.selection = notification.object;
}

+ (DemoModel *)create
{
    DemoModel* result = [[DemoModel alloc] init];
    result.rootView = [[WeView alloc] init];

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

@end
