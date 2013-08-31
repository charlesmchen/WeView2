//
//  DemoModel.h
//  WeViews2DemoApp
//
//  Copyright (c) 2013 Charles Matthew Chen. All rights reserved.
//

#pragma once

#import "WeView2.h"

@protocol DemoModelDelegate <NSObject>

- (void)selectionChanged:(id)selection;

@end

@interface DemoModel : NSObject

@property (nonatomic, weak) id<DemoModelDelegate> delegate;
@property (nonatomic) id selection;
@property (nonatomic) WeView2 *rootView;

+ (DemoModel *)create;

- (NSArray *)collectSubviews:(UIView *)view;

@end
