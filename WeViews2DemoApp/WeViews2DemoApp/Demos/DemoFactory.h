//
//  DemoFactory.h
//  WeViews2DemoApp
//
//  Copyright (c) 2013 Charles Matthew Chen. All rights reserved.
//

#pragma once

#import <Foundation/Foundation.h>

#import "Demo.h"

@interface DemoFactory : NSObject

+ (NSArray *)allDemos;
+ (Demo *)defaultDemo;

@end
