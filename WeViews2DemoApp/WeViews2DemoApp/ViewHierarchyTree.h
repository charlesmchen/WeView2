//
//  ViewHierarchyTree.h
//  WeView 2
//
//  Copyright (c) 2013 Charles Matthew Chen. All rights reserved.
//
//  Distributed under the Apache License v2.0.
//  http://www.apache.org/licenses/LICENSE-2.0.html
//

#pragma once

#import "WeView.h"

@class DemoModel;

@interface ViewHierarchyTree : WeView

+ (ViewHierarchyTree *)create:(DemoModel *)demoModel;

- (NSArray *)getSubviewsForLayout:(WeViewLayout *)layout;

@end
