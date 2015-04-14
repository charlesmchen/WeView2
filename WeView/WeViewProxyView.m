//
//  WeView.m
//  WeView v2
//
//  Copyright (c) 2014 Charles Matthew Chen. All rights reserved.
//
//  Distributed under the Apache License v2.0.
//  http://www.apache.org/licenses/LICENSE-2.0.html
//

#import "WeViewProxyView.h"

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

+ (WeViewProxyView*)proxyWithView:(UIView *)view
{
    WeViewProxyView *proxy = [[WeViewProxyView alloc] init];
    proxy.strongView = view;
    proxy.isWeakReference = NO;
    return proxy;
}

+ (WeViewProxyView*)proxyWithWeakReferenceToView:(UIView *)view
{
    WeViewProxyView *proxy = [[WeViewProxyView alloc] init];
    proxy.weakView = view;
    proxy.isWeakReference = YES;
    return proxy;
}

@end
