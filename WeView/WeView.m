//
//  WeView.m
//  Unknown Project
//
//  Copyright (c) 2013 Charles Matthew Chen. All rights reserved.
//
//  Distributed under the Apache License v2.0.
//  http://www.apache.org/licenses/LICENSE-2.0.html
//

#import <QuartzCore/QuartzCore.h>

#import "UIView+WeView.h"
#import "WeView.h"
#import "WeViewLayout.h"
#import "WeViewLinearLayout.h"
#import "WeViewMacros.h"
#import "WeViewNoopLayout.h"
#import "WeViewMacros.h"
#import "WeViewStackLayout.h"

@interface WeView ()

// The default layout for subviews not associated with a specific layout.
@property (nonatomic) WeViewLayout *defaultLayout;

// A map of subview-to-layout of subviews associated with specific layouts.
@property (nonatomic) NSMutableDictionary *subviewLayoutMap;

@end

#pragma mark -

@implementation WeView

- (void)commonInit
{
    self.subviewLayoutMap = [NSMutableDictionary dictionary];
    // Default to using a horizontal layout.
    [self useHorizontalDefaultLayout];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self commonInit];
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        [self commonInit];
    }
    return self;
}

- (void)dealloc
{
}

#pragma mark - Default Layout

- (WeView *)useHorizontalDefaultLayout
{
    self.defaultLayout = [WeViewLinearLayout horizontalLayout];
    return self;
}

- (WeView *)useVerticalDefaultLayout
{
    self.defaultLayout = [WeViewLinearLayout verticalLayout];
    return self;
}

- (WeView *)useNoDefaultLayout
{
    self.defaultLayout = [WeViewNoopLayout noopLayout];
    return self;
}

- (WeView *)useStackDefaultLayout
{
    self.defaultLayout = [WeViewStackLayout stackLayout];
    return self;
}

- (WeView *)useBlockDefaultLayout:(BlockLayoutBlock)block
{
    self.defaultLayout = [WeViewBlockLayout blockLayoutWithBlock:block];
    return self;
}

- (void)setDefaultLayout:(WeViewLayout *)defaultLayout
{
    _defaultLayout = defaultLayout;
    [self setNeedsLayout];
}

#pragma mark -

- (NSArray *)subviewsForLayout:(WeViewLayout *)layout
{
    NSMutableArray *result = [NSMutableArray array];
    for (UIView *subview in self.subviews)
    {
        if (self.subviewLayoutMap[subview] == layout)
        {
            [result addObject:subview];
        }
    }

    return result;
}

- (void)layoutSubviews
{
    WeViewAssert(self.defaultLayout);
    NSSet *layouts = [NSSet setWithArray:[self.subviewLayoutMap allValues]];
    for (WeViewLayout *layout in layouts)
    {
        NSArray *layoutSubviews = [self subviewsForLayout:layout];
        WeViewAssert(layoutSubviews);
        WeViewAssert([layoutSubviews count] > 0);
        [layout layoutContentsOfView:self
                            subviews:layoutSubviews];
    }
    [self.defaultLayout layoutContentsOfView:self
                                    subviews:[self subviewsForLayout:nil]];
}

- (CGSize)sizeThatFits:(CGSize)size
{
    WeViewAssert(self.defaultLayout);
    return [self.defaultLayout minSizeOfContentsView:self
                                            subviews:[self subviewsForLayout:nil]
                                        thatFitsSize:size];
}

- (WeView *)addSubview:(UIView *)subview
            withLayout:(WeViewLayout *)layout
{
    WeViewAssert(layout);
    return [self addSubviews:@[subview,]
                  withLayout:layout];
}

- (WeView *)addSubviews:(NSArray *)subviews
             withLayout:(WeViewLayout *)layout
{
    WeViewAssert(subviews);
    for (UIView *subview in subviews)
    {
        WeViewAssert(subview);
        WeViewAssert(![self.subviews containsObject:subview]);

        if (layout)
        {
            self.subviewLayoutMap[subview] = layout;
        }
        [self addSubview:subview];
    }
    [self setNeedsLayout];
    return self;
}

- (WeView *)addSubviews:(NSArray *)subviews
{
    return [self addSubviews:subviews
           withLayout:nil];
}

#pragma mark - Custom Layouts

- (WeViewLayout *)addSubviewWithCustomLayout:(UIView *)subview
{
    WeViewLayout *layout = [WeViewStackLayout stackLayout];
    [self addSubviews:@[subview,]
           withLayout:layout];
    return layout;
}

- (WeViewLayout *)addSubviewsWithHorizontalLayout:(NSArray *)subviews
{
    WeViewLayout *layout = [WeViewLinearLayout horizontalLayout];
    [self addSubviews:subviews
           withLayout:layout];
    return layout;
}

- (WeViewLayout *)addSubviewsWithVerticalLayout:(NSArray *)subviews
{
    WeViewLayout *layout = [WeViewLinearLayout verticalLayout];
    [self addSubviews:subviews
           withLayout:layout];
    return layout;
}

- (WeViewLayout *)addSubviewWithFillLayout:(UIView *)subview
{
    // Fit and Fill layouts default to ignoring the superview's margins.
    WeViewLayout *layout = [[[WeViewStackLayout stackLayout]
                              setMargin:0]
                             setCellPositioning:CELL_POSITION_FILL];
    [self addSubviews:@[subview,]
           withLayout:layout];
    return layout;
}

- (WeViewLayout *)addSubviewWithFillLayoutWAspectRatio:(UIView *)subview
{
    // Fit and Fill layouts default to ignoring the superview's margins.
    WeViewLayout *layout = [[[WeViewStackLayout stackLayout]
                              setMargin:0]
                             setCellPositioning:CELL_POSITION_FILL_W_ASPECT_RATIO];
    [self addSubviews:@[subview,]
           withLayout:layout];
    return layout;
}

- (WeViewLayout *)addSubviewWithFitLayoutWAspectRatio:(UIView *)subview
{
    // Fit and Fill layouts default to ignoring the superview's margins.
    WeViewLayout *layout = [[[WeViewStackLayout stackLayout]
                              setMargin:0]
                             setCellPositioning:CELL_POSITION_FIT_W_ASPECT_RATIO];
    [self addSubviews:@[subview,]
           withLayout:layout];
    return layout;
}

- (WeViewLayout *)addSubviews:(NSArray *)subviews
              withLayoutBlock:(BlockLayoutBlock)block
{
    WeViewBlockLayout *layout = [WeViewBlockLayout blockLayoutWithBlock:block];
    [self addSubviews:subviews
           withLayout:layout];
    return layout;
}

- (WeViewLayout *)addSubview:(UIView *)subview
             withLayoutBlock:(BlockLayoutBlock)block
{
    WeViewBlockLayout *layout = [WeViewBlockLayout blockLayoutWithBlock:block];
    [self addSubviews:@[subview,]
           withLayout:layout];
    return layout;
}

#pragma mark -

- (void)removeAllSubviews
{
    for (UIView *subview in [self.subviews copy])
    {
        [subview removeFromSuperview];
    }
    WeViewAssert(self.subviewLayoutMap);
    WeViewAssert([self.subviewLayoutMap count] == 0);
}

- (void)didAddSubview:(UIView *)subview
{
    WeViewAssert(subview);
}

- (void)willRemoveSubview:(UIView *)subview
{
    WeViewAssert(subview);
    if (self.subviewLayoutMap[subview])
    {
        [self.subviewLayoutMap removeObjectForKey:subview];
    }
}

@end
