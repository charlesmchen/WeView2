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
#import "WeView2CenterLayout.h"

@interface WeView2 ()

@property (nonatomic) WeView2Layout *defaultLayout;
@property (nonatomic) NSMutableDictionary *subviewLayoutMap;

@end

#pragma mark -

@implementation WeView2

- (void)commonInit
{
    [self setHLinearLayout];
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

- (WeView2 *)setHLinearLayout
{
    self.defaultLayout = [WeView2LinearLayout hLinearLayout];
    return self;
}

- (WeView2 *)setVLinearLayout
{
    self.defaultLayout = [WeView2LinearLayout vLinearLayout];
    return self;
}

- (WeView2 *)setNoopLayout
{
    self.defaultLayout = [WeView2NoopLayout noopLayout];
    return self;
}

- (WeView2 *)setCenterLayout
{
    self.defaultLayout = [WeView2CenterLayout centerLayout];
    return self;
}

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
    [self addSubviews:@[subview,]
           withLayout:layout];
    return self;
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
    [self addSubviews:subviews
           withLayout:nil];
    return self;
}

- (void)removeAllSubviews
{
    for (UIView *subview in self.subviews)
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
