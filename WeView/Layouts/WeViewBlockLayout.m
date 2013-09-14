//
//  WeViewBlockLayout.m
//  Unknown Project
//
//  Copyright (c) 2013 Charles Matthew Chen. All rights reserved.
//
//  Distributed under the Apache License v2.0.
//  http://www.apache.org/licenses/LICENSE-2.0.html
//

#import <QuartzCore/QuartzCore.h>

#import "WeViewBlockLayout.h"
#import "UIView+WeView.h"
#import "WeViewMacros.h"

@interface WeViewBlockLayout ()

@property (copy, nonatomic) BlockLayoutBlock block;

@end

#pragma mark -

@implementation WeViewBlockLayout

+ (WeViewBlockLayout *)blockLayoutWithBlock:(BlockLayoutBlock)block
{
    WeViewAssert(block);
    WeViewBlockLayout *layout = [[WeViewBlockLayout alloc] init];
    layout.block = block;
    return layout;
}

- (CGSize)minSizeOfContentsView:(UIView *)view
                       subviews:(NSArray *)subviews
                   thatFitsSize:(CGSize)guideSize
{
    return CGSizeZero;
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

    WeViewAssert(self.block);
    int subviewCount = [subviews count];
    for (int i=0; i < subviewCount; i++)
    {
        UIView* subview = subviews[i];
        self.block(view, subview);

        if (debugLayout)
        {
            NSLog(@"%@ - final layout[%d] %@: %@",
                  [self indentPrefix:indent + 2],
                  i,
                  [subview class],
                  FormatRect(subview.frame));
        }
    }
}

@end
