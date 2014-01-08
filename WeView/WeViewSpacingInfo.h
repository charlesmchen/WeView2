//
//  WeViewSpacingInfo.h
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
// If no WeViewSpacingInfo is specified OR if neither of the properties are set, the default behavior is to
// have a fixed, non-stretching size of zero.
//
// If only fixedSize is specified, the margin or spacing has that desired size.
//
// If only stretchWeight is specified, the margin or spacing has a desired size of zero but stretches to
// fill any extra space in the layout using that stretch weight.
//
// If both fixedSize and stretchWeight are specified, fixedSize determines the base size of the margin or
// spacing but the stretchWeight also applies.
@interface WeViewSpacingInfo : NSObject

// Optional.
//
// If specified, the base desired size of the margin or spacing.
//
// The default value is zero.
@property (nonatomic) NSNumber *fixedSize;

// Optional.
//
// If specified, in addition to the "base desired size" of the margin or spacing, it stretches to fill any
// extra space in the layout using that stretch weight.
//
// The default value is zero.
@property (nonatomic) NSNumber *stretchWeight;

+ (WeViewSpacingInfo *)spacingWithFixedSize:(int)fixedSize;

+ (WeViewSpacingInfo *)spacingWithStretchWeight:(CGFloat)stretchWeight;

+ (WeViewSpacingInfo *)spacingWithFixedSize:(int)fixedSize
                              stretchWeight:(CGFloat)stretchWeight;

@end
