//
//  WeView2LinearLayout.h
//  Unknown Project
//
//  Copyright (c) 2013 Charles Matthew Chen. All rights reserved.
//

#pragma once

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "WeView2Layout.h"

// TODO: Discuss semantics of [UIView sizeThatFits:(CGSize)size].
// Functions like a "minimum size" in some sense - if the view wants to insist upon a minimum
// size, the return value can exceed the size parameter.
// Functions like a "maximum size" in some sense - the return value can be smaller than the
// size parameter.
// Also allows a view to describe how large it will be in a given context, ie. with a wrapping
// UILabel whose height depends on its width.
//
// TODO: Discuss pixel-, subpixel-, and point- alignment.
//
// TODO: Discuss container alignment vs. subview alignment.
//
// TODO: Discuss what happens when subviews insist upon exceeding axis or cross size of container.
@interface WeView2LinearLayout : WeView2Layout

@property (nonatomic) BOOL isHorizontal;

+ (WeView2LinearLayout *)hLinearLayout;

+ (WeView2LinearLayout *)vLinearLayout;

@end
