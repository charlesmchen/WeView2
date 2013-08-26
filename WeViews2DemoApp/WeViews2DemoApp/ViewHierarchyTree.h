//
//  ViewHierarchyTree.h
//  WeViews2DemoApp
//
//  Copyright (c) 2013 Charles Matthew Chen. All rights reserved.
//

#pragma once

#import "WeView2.h"

@class DemoModel;

@interface ViewHierarchyTree : WeView2

+ (ViewHierarchyTree *)create:(DemoModel *)demoModel;

@end
