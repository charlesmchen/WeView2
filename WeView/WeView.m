//
//  WeView.m
//  WeView v2
//
//  Copyright (c) 2013 Charles Matthew Chen. All rights reserved.
//
//  Distributed under the Apache License v2.0.
//  http://www.apache.org/licenses/LICENSE-2.0.html
//

#import <QuartzCore/QuartzCore.h>

#import "UIView+WeView.h"
#import "WeView.h"
#import "WeViewFlowLayout.h"
#import "WeViewGridLayout.h"
#import "WeViewLayout.h"
#import "WeViewLinearLayout.h"
#import "WeViewMacros.h"
#import "WeViewStackLayout.h"

@interface WeViewLayout (WeView)

// This method is private and should only be used internally.
- (void)bindToSuperview:(WeView *)superview;

// This method is private and should only be used internally.
- (void)copyConfigurationOfLayout:(WeViewLayout *)layout;

@end

#pragma mark -

@interface WeView ()

// A map of subview-to-layout of subviews associated with specific layouts.
@property (nonatomic) NSMutableDictionary *subviewLayoutMap;

@end

#pragma mark -

@implementation WeView

- (void)commonInit
{
    self.subviewLayoutMap = [NSMutableDictionary dictionary];
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

#pragma mark -

- (NSArray *)layouts
{
    NSMutableArray *result = [NSMutableArray array];

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

- (NSArray *)subviewsForLayout:(WeViewLayout *)layout
{
    // Returns the subviews for a given layout _in layout order_.

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
    NSSet *layouts = [NSSet setWithArray:[self.subviewLayoutMap allValues]];
    for (WeViewLayout *layout in layouts)
    {
        NSArray *layoutSubviews = [self subviewsForLayout:layout];
        WeViewAssert(layoutSubviews);
        WeViewAssert([layoutSubviews count] > 0);
        [layout layoutContentsOfView:self
                            subviews:layoutSubviews];
    }
}

- (CGSize)sizeThatFits:(CGSize)size
{
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

// TODO: Remove this method.
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

// TODO: Remove this method.
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

// TODO: Remove this method.
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
              withLayoutBlock:(WeViewLayoutBlock)layoutBlock
{
    WeViewBlockLayout *layout = [WeViewBlockLayout blockLayoutWithBlock:layoutBlock];
    [self addSubviews:subviews
           withLayout:layout];
    return layout;
}

- (WeViewLayout *)addSubviews:(NSArray *)subviews
              withLayoutBlock:(WeViewLayoutBlock)layoutBlock
             desiredSizeBlock:(WeViewDesiredSizeBlock)desiredSizeBlock
{
    WeViewBlockLayout *layout = [WeViewBlockLayout blockLayoutWithBlock:layoutBlock
                                                       desiredSizeBlock:desiredSizeBlock];
    [self addSubviews:subviews
           withLayout:layout];
    return layout;
}

- (WeViewLayout *)addSubview:(UIView *)subview
             withLayoutBlock:(WeViewLayoutBlock)layoutBlock
{
    WeViewBlockLayout *layout = [WeViewBlockLayout blockLayoutWithBlock:layoutBlock];
    [self addSubviews:@[subview,]
           withLayout:layout];
    return layout;
}

- (WeViewLayout *)addSubview:(UIView *)subview
             withLayoutBlock:(WeViewLayoutBlock)layoutBlock
            desiredSizeBlock:(WeViewDesiredSizeBlock)desiredSizeBlock
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

- (void)setDebugLayoutOflayouts:(BOOL)value
{
    for (WeViewLayout *layout in [self layouts])
    {
        layout.debugLayout = value;
    }
}

- (void)setDebugMinSizeOflayouts:(BOOL)value
{
    for (WeViewLayout *layout in [self layouts])
    {
        layout.debugMinSize = value;
    }
}

@end
