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

typedef enum
{
    FILL_BOUNDS,
    FILL_CONTENT_BOUNDS,
    FILL_BOUNDS_ASPECT_RATIO,
    FILL_CONTENT_BOUNDS_ASPECT_RATIO,
    FIT_BOUNDS_ASPECT_RATIO,
    FIT_CONTENT_BOUNDS_ASPECT_RATIO,
} WeView2FitOrFillMode;

@interface WeView2FitOrFillLayout ()

@property (nonatomic) WeView2FitOrFillMode mode;

@end

#pragma mark -

@implementation WeView2FitOrFillLayout

+ (WeView2FitOrFillLayout *)fillBoundsLayout
{
    WeView2FitOrFillLayout *layout = [[WeView2FitOrFillLayout alloc] init];
    layout.mode = FILL_BOUNDS;
    return layout;
}

+ (WeView2FitOrFillLayout *)fillContentBoundsLayout
{
    WeView2FitOrFillLayout *layout = [[WeView2FitOrFillLayout alloc] init];
    layout.mode = FILL_CONTENT_BOUNDS;
    return layout;
}

+ (WeView2FitOrFillLayout *)fillBoundsWithAspectRatioLayout
{
    WeView2FitOrFillLayout *layout = [[WeView2FitOrFillLayout alloc] init];
    layout.mode = FILL_BOUNDS_ASPECT_RATIO;
    return layout;
}

+ (WeView2FitOrFillLayout *)fillContentBoundsWithAspectRatioLayout
{
    WeView2FitOrFillLayout *layout = [[WeView2FitOrFillLayout alloc] init];
    layout.mode = FILL_CONTENT_BOUNDS_ASPECT_RATIO;
    return layout;
}

+ (WeView2FitOrFillLayout *)fitBoundsWithAspectRatioLayout
{
    WeView2FitOrFillLayout *layout = [[WeView2FitOrFillLayout alloc] init];
    layout.mode = FIT_BOUNDS_ASPECT_RATIO;
    return layout;
}

+ (WeView2FitOrFillLayout *)fitContentBoundsWithAspectRatioLayout
{
    WeView2FitOrFillLayout *layout = [[WeView2FitOrFillLayout alloc] init];
    layout.mode = FIT_CONTENT_BOUNDS_ASPECT_RATIO;
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

        switch (self.mode)
        {
            case FILL_BOUNDS:
                subview.frame = view.bounds;
                break;
            case FILL_CONTENT_BOUNDS:
                subview.frame = contentBounds;
                break;
            case FILL_BOUNDS_ASPECT_RATIO:
            case FILL_CONTENT_BOUNDS_ASPECT_RATIO:
            case FIT_BOUNDS_ASPECT_RATIO:
            case FIT_CONTENT_BOUNDS_ASPECT_RATIO:
            {
                CGSize desiredSize = [subview sizeThatFits:CGSizeZero];
                BOOL isValid = (desiredSize.width > 0 &&
                                desiredSize.height > 0 &&
                                contentBounds.size.width > 0 &&
                                contentBounds.size.height > 0);
                if (!isValid)
                {
                    subview.frame = contentBounds;
                }
                else
                {
                    switch (self.mode)
                    {
                        case FILL_BOUNDS_ASPECT_RATIO:
                            subview.frame = FillRectWithSize(view.bounds, desiredSize);
                            break;
                        case FILL_CONTENT_BOUNDS_ASPECT_RATIO:
                            subview.frame = FillRectWithSize(view.bounds, desiredSize);
                            break;
                        case FIT_BOUNDS_ASPECT_RATIO:
                            subview.frame = FitSizeInRect(contentBounds, desiredSize);
                            break;
                        case FIT_CONTENT_BOUNDS_ASPECT_RATIO:
                            subview.frame = FitSizeInRect(contentBounds, desiredSize);
                            break;
                        default:
                            WeView2Assert(0);
                            break;
                    }
                }
                break;
            }

            default:
                WeView2Assert(0);
                break;
        }
    }
}

@end
