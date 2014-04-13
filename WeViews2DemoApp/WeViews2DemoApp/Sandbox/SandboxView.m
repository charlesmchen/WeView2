//
//  SandboxView.m
//  WeView v2
//
//  Copyright (c) 2014 Charles Matthew Chen. All rights reserved.
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

- (CGSize)maxViewSize
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

    // Smoothly animate layout of the entire view hierarchy.
    NSMutableDictionary *beforeFrames = [NSMutableDictionary dictionary];
    NSMutableDictionary *afterFrames = [NSMutableDictionary dictionary];
    for (UIView *view in collectedViews)
    {
        beforeFrames[view] = [NSValue valueWithCGRect:view.frame];
    }
    for (UIView *view in collectedViews)
    {
        [view layoutSubviews];
    }
    for (UIView *view in collectedViews)
    {
        afterFrames[view] = [NSValue valueWithCGRect:view.frame];
    }
    for (UIView *view in collectedViews)
    {
        view.frame = [((NSValue *) beforeFrames[view]) CGRectValue];
    }

    [UIView animateWithDuration:0.35f
                          delay:0.f
                        options:(UIViewAnimationOptionLayoutSubviews
                                 | UIViewAnimationOptionBeginFromCurrentState)
                     animations:^{
                         for (UIView *view in collectedViews)
                         {
                             view.frame = [((NSValue *) afterFrames[view]) CGRectValue];
                         }
                     }
                     completion:^(BOOL finished) {
                         for (UIView *view in collectedViews)
                         {
                             [view setNeedsLayout];
                         }
                     }];
}

@end
