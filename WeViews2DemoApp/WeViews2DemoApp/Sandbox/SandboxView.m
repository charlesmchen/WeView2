//
//  SandboxView.m
//  WeViews2DemoApp
//
//  Copyright (c) 2013 Charles Matthew Chen. All rights reserved.
//
//  Distributed under the Apache License v2.0.
//  http://www.apache.org/licenses/LICENSE-2.0.html
//

#import "SandboxView.h"
#import "WeViewMacros.h"

@implementation SandboxView

- (void)displayDemoModel:(DemoModel *)demoModel
{
    // Subclasses should implement this method.
    WeViewAssert(0);
}

- (CGSize)rootViewSize
{
    // Subclasses should implement this method.
    WeViewAssert(0);
    return CGSizeZero;
}

- (void)setControlsHidden:(BOOL)value
{
    // Subclasses should implement this method.
    WeViewAssert(0);
}

@end
