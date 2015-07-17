//
//  WeViewProxyView.m
//  WeView v2
//
//  Copyright (c) 2015 Charles Matthew Chen. All rights reserved.
//
//  Distributed under the Apache License v2.0.
//  http://www.apache.org/licenses/LICENSE-2.0.html
//

#import "WeViewProxyView.h"
#import "UIView+WeView.h"

@interface WeViewProxyView ()

@property (nonatomic) BOOL isWeakReference;
@property (nonatomic) UIView *strongView;
@property (nonatomic, weak) UIView *weakView;

@end

#pragma mark -

@implementation WeViewProxyView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.opaque = NO;
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.opaque = NO;
    }
    return self;
}

- (CGSize)sizeThatFits:(CGSize)size
{
    UIView *view = self.isWeakReference ? self.weakView : self.strongView;
    return [view sizeThatFits:size];
}

/* CODEGEN MARKER: Accessors Start */

- (CGFloat)minDesiredWidth
{
    UIView *view = self.isWeakReference ? self.weakView : self.strongView;
    return [view minDesiredWidth];
}

- (CGFloat)maxDesiredWidth
{
    UIView *view = self.isWeakReference ? self.weakView : self.strongView;
    return [view maxDesiredWidth];
}

- (CGFloat)minDesiredHeight
{
    UIView *view = self.isWeakReference ? self.weakView : self.strongView;
    return [view minDesiredHeight];
}

- (CGFloat)maxDesiredHeight
{
    UIView *view = self.isWeakReference ? self.weakView : self.strongView;
    return [view maxDesiredHeight];
}

- (CGFloat)hStretchWeight
{
    UIView *view = self.isWeakReference ? self.weakView : self.strongView;
    return [view hStretchWeight];
}

- (CGFloat)vStretchWeight
{
    UIView *view = self.isWeakReference ? self.weakView : self.strongView;
    return [view vStretchWeight];
}

- (int)leftSpacingAdjustment
{
    UIView *view = self.isWeakReference ? self.weakView : self.strongView;
    return [view leftSpacingAdjustment];
}

- (int)topSpacingAdjustment
{
    UIView *view = self.isWeakReference ? self.weakView : self.strongView;
    return [view topSpacingAdjustment];
}

- (int)rightSpacingAdjustment
{
    UIView *view = self.isWeakReference ? self.weakView : self.strongView;
    return [view rightSpacingAdjustment];
}

- (int)bottomSpacingAdjustment
{
    UIView *view = self.isWeakReference ? self.weakView : self.strongView;
    return [view bottomSpacingAdjustment];
}

- (CGFloat)desiredWidthAdjustment
{
    UIView *view = self.isWeakReference ? self.weakView : self.strongView;
    return [view desiredWidthAdjustment];
}

- (CGFloat)desiredHeightAdjustment
{
    UIView *view = self.isWeakReference ? self.weakView : self.strongView;
    return [view desiredHeightAdjustment];
}

- (BOOL)ignoreDesiredWidth
{
    UIView *view = self.isWeakReference ? self.weakView : self.strongView;
    return [view ignoreDesiredWidth];
}

- (BOOL)ignoreDesiredHeight
{
    UIView *view = self.isWeakReference ? self.weakView : self.strongView;
    return [view ignoreDesiredHeight];
}

- (int)xPositionOffset
{
    UIView *view = self.isWeakReference ? self.weakView : self.strongView;
    return [view xPositionOffset];
}

- (int)yPositionOffset
{
    UIView *view = self.isWeakReference ? self.weakView : self.strongView;
    return [view yPositionOffset];
}

- (HAlign)cellHAlign
{
    UIView *view = self.isWeakReference ? self.weakView : self.strongView;
    return [view cellHAlign];
}

- (VAlign)cellVAlign
{
    UIView *view = self.isWeakReference ? self.weakView : self.strongView;
    return [view cellVAlign];
}

- (BOOL)hasCellHAlign
{
    UIView *view = self.isWeakReference ? self.weakView : self.strongView;
    return [view hasCellHAlign];
}

- (BOOL)hasCellVAlign
{
    UIView *view = self.isWeakReference ? self.weakView : self.strongView;
    return [view hasCellVAlign];
}

- (BOOL)skipLayout
{
    UIView *view = self.isWeakReference ? self.weakView : self.strongView;
    return [view skipLayout];
}

- (NSString *)debugName
{
    UIView *view = self.isWeakReference ? self.weakView : self.strongView;
    return [view debugName];
}

/* CODEGEN MARKER: Accessors End */

+ (WeViewProxyView *)proxyWithView:(UIView *)view
{
    WeViewProxyView *proxy = [[WeViewProxyView alloc] init];
    proxy.strongView = view;
    proxy.isWeakReference = NO;
    return proxy;
}

+ (WeViewProxyView *)proxyWithWeakReferenceToView:(UIView *)view
{
    WeViewProxyView *proxy = [[WeViewProxyView alloc] init];
    proxy.weakView = view;
    proxy.isWeakReference = YES;
    return proxy;
}

@end
