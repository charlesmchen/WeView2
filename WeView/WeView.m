//
//  WeView.m
//  WeView 2
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
#import "WeViewGridLayout.h"
#import "WeViewFlowLayout.h"

@interface WeViewLayout (WeView)

// This method is private and should only be used internally.
- (void)bindToSuperview:(WeView *)superview;

// This method is private and should only be used internally.
- (void)copyConfigurationOfLayout:(WeViewLayout *)layout;

@end

#pragma mark -

@interface WeView ()

// The default layout for subviews not associated with a specific layout.
@property (nonatomic) WeViewLayout *_defaultLayout;

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

- (WeViewLayout *)useHorizontalDefaultLayout
{
    self.defaultLayout = [WeViewLinearLayout horizontalLayout];
    return self.defaultLayout;
}

- (WeViewLayout *)useVerticalDefaultLayout
{
    self.defaultLayout = [WeViewLinearLayout verticalLayout];
    return self.defaultLayout;
}

- (WeViewLayout *)useNoDefaultLayout
{
    self.defaultLayout = [WeViewNoopLayout noopLayout];
    return self.defaultLayout;
}

- (WeViewLayout *)useStackDefaultLayout
{
    self.defaultLayout = [WeViewStackLayout stackLayout];
    return self.defaultLayout;
}

- (WeViewLayout *)useFlowDefaultLayout
{
    self.defaultLayout = [WeViewFlowLayout flowLayout];
    return self.defaultLayout;
}

- (WeViewLayout *)useBlockDefaultLayout:(WeView2LayoutBlock)layoutBlock
{
    self.defaultLayout = [WeViewBlockLayout blockLayoutWithBlock:layoutBlock];
    return self.defaultLayout;
}

- (WeViewLayout *)useBlockDefaultLayout:(WeView2LayoutBlock)layoutBlock
                       desiredSizeBlock:(WeView2DesiredSizeBlock)desiredSizeBlock
{
    self.defaultLayout = [WeViewBlockLayout blockLayoutWithBlock:layoutBlock
                                                desiredSizeBlock:desiredSizeBlock];
    return self.defaultLayout;
}

- (WeView *)setDefaultLayout:(WeViewLayout *)defaultLayout
{
    self._defaultLayout = defaultLayout;
    [self._defaultLayout bindToSuperview:self];
    [self setNeedsLayout];
    return self;
}

- (WeViewLayout *)defaultLayout
{
    return self._defaultLayout;
}

#pragma mark -

- (NSArray *)getLayouts:(BOOL)activeOnly
{
    NSMutableArray *result = [NSMutableArray array];

    // First, add the default layout if necessary.
    if (!activeOnly ||
        [[self subviewsForLayout:self._defaultLayout] count] > 0)
    {
        [result addObject:self._defaultLayout];
    }

    // Second, add the custom layouts _in subview order_.
    for (UIView *subview in self.subviews)
    {
        WeViewLayout *layout = self.subviewLayoutMap[subview];
        if (layout &&
            ![result containsObject:layout])
        {
            [result addObject:layout];
        }
    }

    return result;
}

- (NSArray *)activeLayouts
{
    return [self getLayouts:YES];
}

- (NSArray *)allLayouts
{
    return [self getLayouts:NO];
}

- (NSArray *)subviewsForLayout:(WeViewLayout *)layout
{
    // Returns the subviews for a given layout _in layout order_.

    if (layout == self._defaultLayout)
    {
        // Use "nil" to find the subviews for the default layout.
        layout = nil;
    }
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
    CGSize result = CGSizeZero;
    NSSet *layouts = [NSSet setWithArray:[self.subviewLayoutMap allValues]];
    for (WeViewLayout *layout in layouts)
    {
        NSArray *layoutSubviews = [self subviewsForLayout:layout];
        WeViewAssert(layoutSubviews);
        WeViewAssert([layoutSubviews count] > 0);
        result = CGSizeMax(result,
                           [layout minSizeOfContentsView:self
                                                subviews:layoutSubviews
                                            thatFitsSize:size]);
    }
    result = CGSizeMax(result,
                       [self.defaultLayout minSizeOfContentsView:self
                                                        subviews:[self subviewsForLayout:nil]
                                                    thatFitsSize:size]);
    return result;
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
    [layout bindToSuperview:self];
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

- (WeViewLayout *)addSubviewToDefaultLayout:(UIView *)subview
{
    [self addSubviews:@[subview,]
           withLayout:nil];
    return self._defaultLayout;
}

- (WeViewLayout *)addSubviewsToDefaultLayout:(NSArray *)subviews
{
    [self addSubviews:subviews
           withLayout:nil];
    return self._defaultLayout;
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

- (WeViewLayout *)addSubviewsWithStackLayout:(NSArray *)subviews
{
    WeViewLayout *layout = [WeViewStackLayout stackLayout];
    [self addSubviews:subviews
           withLayout:layout];
    return layout;
}

- (WeViewLayout *)addSubviewsWithFlowLayout:(NSArray *)subviews
{
    WeViewLayout *layout = [WeViewFlowLayout flowLayout];
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
              withLayoutBlock:(WeView2LayoutBlock)layoutBlock
{
    WeViewBlockLayout *layout = [WeViewBlockLayout blockLayoutWithBlock:layoutBlock];
    [self addSubviews:subviews
           withLayout:layout];
    return layout;
}

- (WeViewLayout *)addSubviews:(NSArray *)subviews
              withLayoutBlock:(WeView2LayoutBlock)layoutBlock
             desiredSizeBlock:(WeView2DesiredSizeBlock)desiredSizeBlock
{
    WeViewBlockLayout *layout = [WeViewBlockLayout blockLayoutWithBlock:layoutBlock
                                                       desiredSizeBlock:desiredSizeBlock];
    [self addSubviews:subviews
           withLayout:layout];
    return layout;
}

- (WeViewLayout *)addSubview:(UIView *)subview
             withLayoutBlock:(WeView2LayoutBlock)layoutBlock
{
    WeViewBlockLayout *layout = [WeViewBlockLayout blockLayoutWithBlock:layoutBlock];
    [self addSubviews:@[subview,]
           withLayout:layout];
    return layout;
}

- (WeViewLayout *)addSubview:(UIView *)subview
             withLayoutBlock:(WeView2LayoutBlock)layoutBlock
            desiredSizeBlock:(WeView2DesiredSizeBlock)desiredSizeBlock
{
    WeViewBlockLayout *layout = [WeViewBlockLayout blockLayoutWithBlock:layoutBlock
                                                       desiredSizeBlock:desiredSizeBlock];
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

- (WeViewLayout *)replaceLayout:(WeViewLayout *)oldLayout
                     withLayout:(WeViewLayout *)newLayout
{
    // This method should only be used by the demo.

    [newLayout copyConfigurationOfLayout:oldLayout];

    if (self._defaultLayout == oldLayout)
    {
        [self setDefaultLayout:newLayout];
    }

    for (id key in self.subviewLayoutMap)
    {
        if (self.subviewLayoutMap[key] == oldLayout)
        {
            self.subviewLayoutMap[key] = newLayout;
        }
    }
    [self setNeedsDisplay];
    return newLayout;
}

- (WeViewLayout *)replaceLayoutWithHorizontalLayout:(WeViewLayout *)oldLayout
{
    // This method should only be used by the demo.
    return [self replaceLayout:oldLayout
                    withLayout:[WeViewLinearLayout horizontalLayout]];
}

- (WeViewLayout *)replaceLayoutWithVerticalLayout:(WeViewLayout *)oldLayout
{
    // This method should only be used by the demo.
    return [self replaceLayout:oldLayout
                    withLayout:[WeViewLinearLayout verticalLayout]];
}

- (WeViewLayout *)replaceLayoutWithStackLayout:(WeViewLayout *)oldLayout
{
    // This method should only be used by the demo.
    return [self replaceLayout:oldLayout
                    withLayout:[WeViewStackLayout stackLayout]];
}

- (WeViewLayout *)replaceLayoutWithFlowLayout:(WeViewLayout *)oldLayout
{
    // This method should only be used by the demo.
    return [self replaceLayout:oldLayout
                    withLayout:[WeViewFlowLayout flowLayout]];
}

- (WeViewLayout *)replaceLayoutWithGridLayout:(WeViewLayout *)oldLayout
{
    // This method should only be used by the demo.
    return [self replaceLayout:oldLayout
                    withLayout:[WeViewGridLayout gridLayoutWithColumns:2
                                                         isGridUniform:NO
                                                         stretchPolicy:GRID_STRETCH_POLICY_STRETCH_SPACING]];
}

@end
