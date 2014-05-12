//
//  WeViewBlockLayout.m
//  WeView v2
//
//  Copyright (c) 2014 Charles Matthew Chen. All rights reserved.
//
//  Distributed under the Apache License v2.0.
//  http://www.apache.org/licenses/LICENSE-2.0.html
//

#import <QuartzCore/QuartzCore.h>

#import "UIView+WeView.h"
#import "WeViewBlockLayout.h"
#import "WeViewLayout+Subclass.h"
#import "WeViewMacros.h"

@interface WeViewBlockLayout ()

@property (copy, nonatomic) WeViewLayoutBlock layoutBlock;
@property (copy, nonatomic) WeViewDesiredSizeBlock desiredSizeBlock;

@end

#pragma mark -

@implementation WeViewBlockLayout

+ (WeViewBlockLayout *)blockLayoutWithBlock:(WeViewLayoutBlock)layoutBlock
                           desiredSizeBlock:(WeViewDesiredSizeBlock)desiredSizeBlock
{
    WeViewAssert(layoutBlock);
    WeViewAssert(desiredSizeBlock);
    WeViewBlockLayout *layout = [[WeViewBlockLayout alloc] init];
    layout.layoutBlock = layoutBlock;
    layout.desiredSizeBlock = desiredSizeBlock;
    return layout;
}

+ (WeViewBlockLayout *)blockLayoutWithBlock:(WeViewLayoutBlock)layoutBlock
{
    WeViewAssert(layoutBlock);
    WeViewBlockLayout *layout = [[WeViewBlockLayout alloc] init];
    layout.layoutBlock = layoutBlock;
    return layout;
}

- (void)resetAllProperties
{
    self.layoutBlock = nil;
    self.desiredSizeBlock = nil;

    [super resetAllProperties];
}

- (CGSize)minSizeOfContentsView:(UIView *)view
                       subviews:(NSArray *)subviews
                   thatFitsSize:(CGSize)guideSize
{
    CGSize result = CGSizeZero;
    if (self.desiredSizeBlock)
    {
        NSUInteger subviewCount = [subviews count];
        for (int i=0; i < subviewCount; i++)
        {
            UIView* subview = subviews[i];
            result = CGSizeMax(result, self.desiredSizeBlock(view, subview));
        }
    }
    return result;
}

- (void)layoutContentsOfView:(UIView *)view
                    subviews:(NSArray *)subviews
{
    if ([subviews count] < 1)
    {
        return;
    }

    BOOL debugLayout = [self debugLayout];
    int indent = 0;
    CGSize guideSize = view.size;
    if (debugLayout)
    {
        indent = [self viewHierarchyDistanceToWindow:view];
        NSLog(@"%@+ [%@ (%@) layoutContentsOfView: %@] : %@",
              [self indentPrefix:indent],
              [self class],
              view.debugName,
              [view class],
              NSStringFromCGSize(guideSize));
    }

    WeViewAssert(self.layoutBlock);
    NSUInteger subviewCount = [subviews count];
    for (int i=0; i < subviewCount; i++)
    {
        UIView* subview = subviews[i];
        self.layoutBlock(view, subview);

        if (debugLayout)
        {
            NSLog(@"%@ - final layout[%d] %@: %@",
                  [self indentPrefix:indent + 2],
                  i,
                  [subview class],
                  FormatCGRect(subview.frame));
        }
    }
}

@end
