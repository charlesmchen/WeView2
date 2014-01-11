//
//  WeViewSpacing.h
//  WeView v2
//
//  Copyright (c) 2014 Charles Matthew Chen. All rights reserved.
//
//  Distributed under the Apache License v2.0.
//  http://www.apache.org/licenses/LICENSE-2.0.html
//

#pragma once

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// Represents the desired size of a margin or the spacing between views in a layout.
//
// The default behavior is to have a fixed, non-stretching size of zero.
@interface WeViewSpacing : NSObject

// The desired size of the margin or spacing.
//
// The size specifies the desired size of the margin or spacing.
@property (nonatomic) int size;

// If the stretchWeight is non-zero, the margin or spacing can stretch to fill any extra space in the layout
// using that stretch weight or collapses if necessary.  It can also contract if the layout's desired size
// overflows the available space.
//
// The default value is zero.
@property (nonatomic) CGFloat stretchWeight;

+ (WeViewSpacing *)spacingWithSize:(int)size;

+ (WeViewSpacing *)spacingWithStretchWeight:(CGFloat)stretchWeight;

+ (WeViewSpacing *)spacingWithSize:(int)size
                     stretchWeight:(CGFloat)stretchWeight;

@end
