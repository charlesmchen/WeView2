//
//  WeView2FitOrFillLayout.m
//  Unknown Project
//
//  Copyright (c) 2013 Charles Matthew Chen. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "WeView2FitOrFillLayout.h"
#import "UIView+WeView2.h"
#import "WeView2Macros.h"

@interface WeView2FitOrFillLayout ()

@property (nonatomic) BOOL isFill;

@end

#pragma mark -

@implementation WeView2FitOrFillLayout

+ (WeView2FitOrFillLayout *)fitLayout
{
    WeView2FitOrFillLayout *layout = [[WeView2FitOrFillLayout alloc] init];
    layout.isFill = NO;
    return layout;
}

+ (WeView2FitOrFillLayout *)fillLayout
{
    WeView2FitOrFillLayout *layout = [[WeView2FitOrFillLayout alloc] init];
    layout.isFill = YES;
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
    CGRect contentBounds = [self contentBoundsOfView:view
                                             forSize:view.size];

    for (int i=0; i < [subviews count]; i++)
    {
        UIView* subview = subviews[i];

        CGSize desiredSize = [subview sizeThatFits:CGSizeZero];
        if (desiredSize.width > 0 &&
            desiredSize.height > 0 &&
            contentBounds.size.width > 0 &&
            contentBounds.size.height > 0)
        {
            subview.frame = (self.isFill
                             ? FillRectWithSize(contentBounds, desiredSize)
                             : FitSizeInRect(contentBounds, desiredSize));
        }
        else
        {
            subview.frame = contentBounds;
        }
    }
}

@end
