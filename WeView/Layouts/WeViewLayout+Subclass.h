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

#pragma mark - Cell Positioning

// By default, cellPositioning has a value of CELL_POSITIONING_NORMAL and cell size is based on
// their desired size and they are aligned within their layout
// cell.
//
// If cellPositioning is set to CELL_POSITIONING_FILL, subviews fill the entire bounds of their
// layout cell, regardless of their desired
// size.
//
// If cellPositioning is set to CELL_POSITIONING_FILL_W_ASPECT_RATIO, subviews fill the entire
// bounds of their layout cell but retain the aspect ratio of their desired
// size.
//
// If cellPositioning is set to CELL_POSITIONING_FIT_W_ASPECT_RATIO, subviews are "fit" inside
// the bounds of their layout cell and retain the aspect ratio of their desired
// size.
- (CellPositioningMode)cellPositioning;
- (WeViewLayout *)setCellPositioning:(CellPositioningMode)value;

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
