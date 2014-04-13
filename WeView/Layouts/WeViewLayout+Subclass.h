//
//  WeViewLayout+Subclass.h
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

#import "WeViewLayout.h"

@interface WeViewLayout (Subclass)

- (void)propertyChanged;

#pragma mark - Utility Methods

- (void)positionSubview:(UIView *)subview
            inSuperview:(UIView *)superview
               withSize:(CGSize)subviewSize
           inCellBounds:(CGRect)cellBounds
        cellPositioning:(CellPositioningMode)cellPositioning;

- (CGRect)contentBoundsOfView:(UIView *)view
                      forSize:(CGSize)size;

- (CGSize)insetSizeOfView:(UIView *)view;

- (CGSize)desiredItemSize:(UIView *)subview
                  maxSize:(CGSize)maxSize;

+ (NSArray *)distributeSpace:(CGFloat)space
      acrossCellsWithWeights:(NSArray *)cellWeights;

+ (void)distributeAdjustment:(CGFloat)totalAdjustment
                acrossValues:(NSMutableArray *)values
                 withWeights:(NSArray *)weights
                    withSign:(CGFloat)sign
                 withMaxZero:(BOOL)withMaxZero;

#pragma mark - Debug Methods

- (NSString *)indentPrefix:(int)indent;

- (int)viewHierarchyDistanceToWindow:(UIView *)view;

@end
