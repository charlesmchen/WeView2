//
//  WrappingTestView.h
//  WeView
//
//  Copyright (c) 2015 FiftyThree, Inc. All rights reserved.
//

#pragma once

#import <UIKit/UIKit.h>

/** A test view for testing text-like wrapping behavior.

 The contents of this view are specified in "blocks".  These blocks act like more predictable
 characters in text content, ie. they all have exactly the same size.

 A WrappingTestView will behave as those it is wrapping its blocks in a text-like way, ie.:

 B B B B B
 B B B B

Therefore the height of this subview depends on its height, just like a text view.
 */
@interface WrappingTestView : UIView

@property (nonatomic) CGSize blockSize;
@property (nonatomic) int blockCount;

@end
