//
//  WeView2.m
//  Unknown Project
//
//  Copyright (c) 2013 Charles Matthew Chen. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "UIView+WeView2.h"
#import "WeView2.h"
#import "WeView2Layout.h"
#import "WeView2LinearLayout.h"
#import "WeView2Macros.h"
#import "WeView2NoopLayout.h"
#import "WeView2Macros.h"
#import "WeView2StackLayout.h"
#import "WeView2FitOrFillLayout.h"

@interface WeView2 ()

@property (nonatomic) WeView2Layout *defaultLayout;
@property (nonatomic) NSMutableDictionary *subviewLayoutMap;

@end

#pragma mark -

@implementation WeView2

- (void)commonInit
{
    self.subviewLayoutMap = [NSMutableDictionary dictionary];
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

- (WeView2 *)useHorizontalDefaultLayout
{
    self.defaultLayout = [WeView2LinearLayout horizontalLayout];
    return self;
}

- (WeView2 *)useVerticalDefaultLayout
{
    self.defaultLayout = [WeView2LinearLayout verticalLayout];
    return self;
}

- (WeView2 *)useNoDefaultLayout
{
    self.defaultLayout = [WeView2NoopLayout noopLayout];
    return self;
}

- (WeView2 *)useStackDefaultLayout
{
    self.defaultLayout = [WeView2StackLayout stackLayout];
    return self;
}

- (WeView2 *)useFillDefaultLayout
{
    self.defaultLayout = [WeView2FitOrFillLayout fillBoundsLayout];
    return self;
}

- (void)setDefaultLayout:(WeView2Layout *)defaultLayout
{
    _defaultLayout = defaultLayout;
    [self setNeedsLayout];
}

#pragma mark -

- (NSArray *)subviewsForLayout:(WeView2Layout *)layout
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
    WeView2Assert(self.defaultLayout);
    NSSet *layouts = [NSSet setWithArray:[self.subviewLayoutMap allValues]];
    for (WeView2Layout *layout in layouts)
    {
        NSArray *layoutSubviews = [self subviewsForLayout:layout];
        WeView2Assert(layoutSubviews);
        WeView2Assert([layoutSubviews count] > 0);
        [layout layoutContentsOfView:self
                            subviews:layoutSubviews];
    }
    [self.defaultLayout layoutContentsOfView:self
                                    subviews:[self subviewsForLayout:nil]];
}

- (CGSize)sizeThatFits:(CGSize)size
{
    WeView2Assert(self.defaultLayout);
    return [self.defaultLayout minSizeOfContentsView:self
                                            subviews:[self subviewsForLayout:nil]
                                        thatFitsSize:size];
}

- (WeView2 *)addSubview:(UIView *)subview
             withLayout:(WeView2Layout *)layout
{
    WeView2Assert(layout);
    return [self addSubviews:@[subview,]
                  withLayout:layout];
}

- (WeView2 *)addSubviews:(NSArray *)subviews
              withLayout:(WeView2Layout *)layout
{
    WeView2Assert(subviews);
    for (UIView *subview in subviews)
    {
        WeView2Assert(subview);
        WeView2Assert(![self.subviews containsObject:subview]);

        if (layout)
        {
            self.subviewLayoutMap[subview] = layout;
        }
        [self addSubview:subview];
    }
    [self setNeedsLayout];
    return self;
}

- (WeView2 *)addSubviews:(NSArray *)subviews
{
    return [self addSubviews:subviews
           withLayout:nil];
}

- (WeView2 *)addSubviews:(NSArray *)subviews
         withLayoutBlock:(BlockLayoutBlock)block
{
    return [self addSubviews:subviews
                  withLayout:[WeView2BlockLayout blockLayoutWithBlock:block]];
}

- (WeView2 *)addSubview:(UIView *)subview
        withLayoutBlock:(BlockLayoutBlock)block
{
    return [self addSubviews:@[subview,]
                  withLayout:[WeView2BlockLayout blockLayoutWithBlock:block]];
}

- (void)removeAllSubviews
{
    for (UIView *subview in [self.subviews copy])
    {
        [subview removeFromSuperview];
    }
    WeView2Assert(self.subviewLayoutMap);
    WeView2Assert([self.subviewLayoutMap count] == 0);
}

- (void)didAddSubview:(UIView *)subview
{
    WeView2Assert(subview);
}

- (void)willRemoveSubview:(UIView *)subview
{
    WeView2Assert(subview);
    if (self.subviewLayoutMap[subview])
    {
        [self.subviewLayoutMap removeObjectForKey:subview];
    }
}

@end
