//
//  SandboxView.m
//  WeViews2DemoApp
//
//  Copyright (c) 2013 Charles Matthew Chen. All rights reserved.
//
//  Distributed under the Apache License v2.0.
//  http://www.apache.org/licenses/LICENSE-2.0.html
//

#import <QuartzCore/QuartzCore.h>

#import "SandboxView.h"
#import "WeViewMacros.h"

@implementation SandboxView

- (void)displayDemoModel:(DemoModel *)demoModel
{
    // Subclasses should implement this method.
    WeViewAssert(0);
}

- (CGSize)rootViewSize
{
    // Subclasses should implement this method.
    WeViewAssert(0);
    return CGSizeZero;
}

- (void)setControlsHidden:(BOOL)value
{
    // Subclasses should implement this method.
    WeViewAssert(0);
}

- (NSArray *)collectViewAndSubviews:(UIView *)view
{
    NSMutableArray *result = [NSMutableArray array];
    [result addObject:view];

    for (UIView *subview in view.subviews)
    {
        [result addObjectsFromArray:[self collectViewAndSubviews:subview]];
    }

    return result;
}

- (void)animateRelayout
{
    NSArray *collectedViews = [self collectViewAndSubviews:self];
    for (UIView *view in collectedViews)
    {
        [view.layer removeAllAnimations];
    }

    [UIView animateWithDuration:0.35f
                          delay:0.f
                        options:(UIViewAnimationOptionLayoutSubviews
                                 | UIViewAnimationOptionBeginFromCurrentState)
                     animations:^{
                         for (UIView *view in collectedViews)
                         {
                             [view layoutSubviews];
                         }
                     }
                     completion:^(BOOL finished) {
                         [self setNeedsLayout];
                     }];

    for (UIView *view in [self collectViewAndSubviews:self])
    {
        [view setNeedsLayout];
    }
}

@end
