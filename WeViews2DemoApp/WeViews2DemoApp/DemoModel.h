//
//  DemoModel.h
//  WeViews2DemoApp
//
//  Copyright (c) 2013 Charles Matthew Chen. All rights reserved.
//
//  Distributed under the Apache License v2.0.
//  http://www.apache.org/licenses/LICENSE-2.0.html
//

#pragma once

#import "WeView.h"

@protocol DemoModelDelegate <NSObject>

- (void)selectionChanged:(id)selection;

@end

@interface DemoModel : NSObject

@property (nonatomic, weak) id<DemoModelDelegate> delegate;
@property (nonatomic) id selection;
@property (nonatomic) WeView *rootView;
@property (nonatomic) BOOL useIPhoneSandboxByDefault;

+ (DemoModel *)create;

- (NSArray *)collectSubviews:(UIView *)view;

@end
