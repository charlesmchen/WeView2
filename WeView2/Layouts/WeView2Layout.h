//
//  WeView2Layout.h
//  Unknown Project
//
//  Copyright (c) 2013 Charles Matthew Chen. All rights reserved.
//

#pragma once

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WeView2Layout : NSObject

- (void)layoutContentsOfView:(UIView *)view;

- (CGSize)minSizeOfContentsView:(UIView *)view
                   thatFitsSize:(CGSize)size;

- (void)setSubviewFrame:(CGRect)frame
                subview:(UIView *)subview;

@end
