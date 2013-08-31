//
//  WeView2BlockLayout.m
//  Unknown Project
//
//  Copyright (c) 2013 Charles Matthew Chen. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "WeView2BlockLayout.h"
#import "UIView+WeView2.h"
#import "WeView2Macros.h"

@interface WeView2BlockLayout ()

@property (copy, nonatomic) BlockLayoutBlock block;

@end

#pragma mark -

@implementation WeView2BlockLayout

+ (WeView2BlockLayout *)create:(BlockLayoutBlock)block
{
    WeView2Assert(block);
    WeView2BlockLayout *layout = [[WeView2BlockLayout alloc] init];
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
    WeView2Assert(self.block);
    for (UIView *subview in subviews)
    {
        self.block(view, subview);
    }
}

@end
