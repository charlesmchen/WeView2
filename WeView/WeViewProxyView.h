//
//  WeViewProxyView.h
//  WeView v2
//
//  Copyright (c) 2015 Charles Matthew Chen. All rights reserved.
//
//  Distributed under the Apache License v2.0.
//  http://www.apache.org/licenses/LICENSE-2.0.html
//

#pragma once

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// An invisible view whose desired size is based on another view.  The other view IS NOT a subview
// of the proxy.
//
// This proxy is useful for balancing layouts, ie. by having an invisible view that counterbalances
// the space used in the layout by another view.
@interface WeViewProxyView : UIView

// A factory method that returns an instance of WeViewProxyView that maintains a strong reference to
// the other view.
+ (WeViewProxyView *)proxyWithView:(UIView *)view;

// A factory method that returns an instance of WeViewProxyView that maintains a weak reference to
// the other view.
+ (WeViewProxyView *)proxyWithWeakReferenceToView:(UIView *)view;

@end
