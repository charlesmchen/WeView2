//
//  WeViewViewInfo.m
//  Unknown Project
//
//  Copyright (c) 2013 Charles Matthew Chen. All rights reserved.
//
//  Distributed under the Apache License v2.0.
//  http://www.apache.org/licenses/LICENSE-2.0.html
//

#import <assert.h>
#import <objc/runtime.h>

#import "WeViewViewInfo.h"
#import "WeViewMacros.h"

@implementation WeViewViewInfo

- (id)init
{
    if (self = [super init])
    {
        self.maxWidth = CGFLOAT_MAX;
        self.maxHeight = CGFLOAT_MAX;
    }

    return self;
}

/* CODEGEN MARKER: View Info Start */

- (void)setCellHAlign:(HAlign)value
{
    _cellHAlign = value;
    self.hasCellHAlign = YES;
}

- (void)setCellVAlign:(VAlign)value
{
    _cellVAlign = value;
    self.hasCellVAlign = YES;
}

- (CGSize)minSize
{
    return CGSizeMake(self.minWidth, self.minHeight);
}

- (void)setMinSize:(CGSize)value
{
    [self setMinWidth:value.width];
    [self setMinHeight:value.height];
}

- (CGSize)maxSize
{
    return CGSizeMake(self.maxWidth, self.maxHeight);
}

- (void)setMaxSize:(CGSize)value
{
    [self setMaxWidth:value.width];
    [self setMaxHeight:value.height];
}

- (CGSize)desiredSizeAdjustment
{
    return CGSizeMake(self.desiredWidthAdjustment, self.desiredHeightAdjustment);
}

- (void)setDesiredSizeAdjustment:(CGSize)value
{
    [self setDesiredWidthAdjustment:value.width];
    [self setDesiredHeightAdjustment:value.height];
}

- (void)setFixedWidth:(CGFloat)value
{
    [self setMinWidth:value];
    [self setMaxWidth:value];
}

- (void)setFixedHeight:(CGFloat)value
{
    [self setMinHeight:value];
    [self setMaxHeight:value];
}

- (void)setFixedSize:(CGSize)value
{
    [self setMinWidth:value.width];
    [self setMinHeight:value.height];
    [self setMaxWidth:value.width];
    [self setMaxHeight:value.height];
}

- (void)setStretchWeight:(CGFloat)value
{
    [self setVStretchWeight:value];
    [self setHStretchWeight:value];
}

/* CODEGEN MARKER: View Info End */

- (NSString *)formatLayoutDescriptionItem:(NSString *)key
                                    value:(id)value
{
    return [NSString stringWithFormat:@"%@: %@, ", key, value];
}

- (NSString *)layoutDescription
{
    NSMutableString *result = [@"" mutableCopy];

    /* CODEGEN MARKER: Debug Start */

    [result appendString:[self formatLayoutDescriptionItem:@"minWidth" value:@(self.minWidth)]];
    [result appendString:[self formatLayoutDescriptionItem:@"maxWidth" value:@(self.maxWidth)]];
    [result appendString:[self formatLayoutDescriptionItem:@"minHeight" value:@(self.minHeight)]];
    [result appendString:[self formatLayoutDescriptionItem:@"maxHeight" value:@(self.maxHeight)]];
    [result appendString:[self formatLayoutDescriptionItem:@"hStretchWeight" value:@(self.hStretchWeight)]];
    [result appendString:[self formatLayoutDescriptionItem:@"vStretchWeight" value:@(self.vStretchWeight)]];
    [result appendString:[self formatLayoutDescriptionItem:@"desiredWidthAdjustment" value:@(self.desiredWidthAdjustment)]];
    [result appendString:[self formatLayoutDescriptionItem:@"desiredHeightAdjustment" value:@(self.desiredHeightAdjustment)]];
    [result appendString:[self formatLayoutDescriptionItem:@"ignoreDesiredSize" value:@(self.ignoreDesiredSize)]];
    [result appendString:[self formatLayoutDescriptionItem:@"cellHAlign" value:@(self.cellHAlign)]];
    [result appendString:[self formatLayoutDescriptionItem:@"cellVAlign" value:@(self.cellVAlign)]];
    [result appendString:[self formatLayoutDescriptionItem:@"hasCellHAlign" value:@(self.hasCellHAlign)]];
    [result appendString:[self formatLayoutDescriptionItem:@"hasCellVAlign" value:@(self.hasCellVAlign)]];
    [result appendString:[self formatLayoutDescriptionItem:@"debugName" value:self.debugName]];

/* CODEGEN MARKER: Debug End */

    return result;
}

@end
