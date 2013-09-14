//
//  UIView+WeView.m
//  Unknown Project
//
//  Copyright (c) 2013 Charles Matthew Chen. All rights reserved.
//
//  Distributed under the Apache License v2.0.
//  http://www.apache.org/licenses/LICENSE-2.0.html
//

#import <assert.h>
#import <objc/runtime.h>

#import "UIView+WeView.h"
#import "WeViewMacros.h"

static const void *kWeViewKey_ViewInfo = &kWeViewKey_ViewInfo;

@implementation UIView (WeView)

#pragma mark - Associated Values

- (WeViewViewInfo *)viewInfo
{
    WeViewViewInfo *value = objc_getAssociatedObject(self, kWeViewKey_ViewInfo);
    if (!value)
    {
        value = [[WeViewViewInfo alloc] init];
        objc_setAssociatedObject(self, kWeViewKey_ViewInfo, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return value;
}

- (void)resetAllLayoutProperties
{
    objc_setAssociatedObject(self, kWeViewKey_ViewInfo, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

/* CODEGEN MARKER: Accessors Start */

- (CGFloat)minWidth
{
    return [self.viewInfo minWidth];
}

- (UIView *)setMinWidth:(CGFloat)value
{
    [self.viewInfo setMinWidth:value];
    return self;
}

- (CGFloat)maxWidth
{
    return [self.viewInfo maxWidth];
}

- (UIView *)setMaxWidth:(CGFloat)value
{
    [self.viewInfo setMaxWidth:value];
    return self;
}

- (CGFloat)minHeight
{
    return [self.viewInfo minHeight];
}

- (UIView *)setMinHeight:(CGFloat)value
{
    [self.viewInfo setMinHeight:value];
    return self;
}

- (CGFloat)maxHeight
{
    return [self.viewInfo maxHeight];
}

- (UIView *)setMaxHeight:(CGFloat)value
{
    [self.viewInfo setMaxHeight:value];
    return self;
}

- (CGFloat)hStretchWeight
{
    return [self.viewInfo hStretchWeight];
}

- (UIView *)setHStretchWeight:(CGFloat)value
{
    [self.viewInfo setHStretchWeight:value];
    return self;
}

- (CGFloat)vStretchWeight
{
    return [self.viewInfo vStretchWeight];
}

- (UIView *)setVStretchWeight:(CGFloat)value
{
    [self.viewInfo setVStretchWeight:value];
    return self;
}

- (CGFloat)desiredWidthAdjustment
{
    return [self.viewInfo desiredWidthAdjustment];
}

- (UIView *)setDesiredWidthAdjustment:(CGFloat)value
{
    [self.viewInfo setDesiredWidthAdjustment:value];
    return self;
}

- (CGFloat)desiredHeightAdjustment
{
    return [self.viewInfo desiredHeightAdjustment];
}

- (UIView *)setDesiredHeightAdjustment:(CGFloat)value
{
    [self.viewInfo setDesiredHeightAdjustment:value];
    return self;
}

- (BOOL)ignoreDesiredSize
{
    return [self.viewInfo ignoreDesiredSize];
}

- (UIView *)setIgnoreDesiredSize:(BOOL)value
{
    [self.viewInfo setIgnoreDesiredSize:value];
    return self;
}

- (HAlign)cellHAlign
{
    return [self.viewInfo cellHAlign];
}

- (UIView *)setCellHAlign:(HAlign)value
{
    [self.viewInfo setCellHAlign:value];
    return self;
}

- (VAlign)cellVAlign
{
    return [self.viewInfo cellVAlign];
}

- (UIView *)setCellVAlign:(VAlign)value
{
    [self.viewInfo setCellVAlign:value];
    return self;
}

- (BOOL)hasCellHAlign
{
    return [self.viewInfo hasCellHAlign];
}

- (UIView *)setHasCellHAlign:(BOOL)value
{
    [self.viewInfo setHasCellHAlign:value];
    return self;
}

- (BOOL)hasCellVAlign
{
    return [self.viewInfo hasCellVAlign];
}

- (UIView *)setHasCellVAlign:(BOOL)value
{
    [self.viewInfo setHasCellVAlign:value];
    return self;
}

- (NSString *)debugName
{
    return [self.viewInfo debugName];
}

- (UIView *)setDebugName:(NSString *)value
{
    [self.viewInfo setDebugName:value];
    return self;
}

- (CGSize)minSize
{
    return [self.viewInfo minSize];
}

- (UIView *)setMinSize:(CGSize)value
{
    [self setMinWidth:value.width];
    [self setMinHeight:value.height];
    return self;
}

- (CGSize)maxSize
{
    return [self.viewInfo maxSize];
}

- (UIView *)setMaxSize:(CGSize)value
{
    [self setMaxWidth:value.width];
    [self setMaxHeight:value.height];
    return self;
}

- (CGSize)desiredSizeAdjustment
{
    return [self.viewInfo desiredSizeAdjustment];
}

- (UIView *)setDesiredSizeAdjustment:(CGSize)value
{
    [self setDesiredWidthAdjustment:value.width];
    [self setDesiredHeightAdjustment:value.height];
    return self;
}

- (UIView *)setFixedWidth:(CGFloat)value
{
    [self setMinWidth:value];
    [self setMaxWidth:value];
    return self;
}

- (UIView *)setFixedHeight:(CGFloat)value
{
    [self setMinHeight:value];
    [self setMaxHeight:value];
    return self;
}

- (UIView *)setFixedSize:(CGSize)value
{
    [self setMinWidth:value.width];
    [self setMinHeight:value.height];
    [self setMaxWidth:value.width];
    [self setMaxHeight:value.height];
    return self;
}

- (UIView *)setStretchWeight:(CGFloat)value
{
    [self setVStretchWeight:value];
    [self setHStretchWeight:value];
    return self;
}

/* CODEGEN MARKER: Accessors End */

- (UIView *)setStretches
{
    [self setStretchWeight:1.f];
    return self;
}

- (UIView *)setIgnoreDesiredSize
{
    self.ignoreDesiredSize = YES;
    return self;
}

- (UIView *)setStretchesIgnoringDesiredSize
{
    [self setStretchWeight:1.f];
    self.ignoreDesiredSize = YES;
    return self;
}

#pragma mark - Convenience Accessors

- (CGPoint)origin
{
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin
{
    CGRect r = self.frame;
    r.origin = origin;
    self.frame = r;
}

- (CGSize)size
{
    return self.frame.size;
}

- (void)setSize:(CGSize)size
{
    CGRect r = self.frame;
    r.size = size;
    self.frame = r;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (void)setX:(CGFloat)value
{
    CGRect r = self.frame;
    r.origin.x = value;
    self.frame = r;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)setY:(CGFloat)value
{
    CGRect r = self.frame;
    r.origin.y = value;
    self.frame = r;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)value
{
    CGRect r = self.frame;
    r.size.width = value;
    self.frame = r;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)value
{
    CGRect r = self.frame;
    r.size.height = value;
    self.frame = r;
}

- (CGFloat)right
{
    return self.x + self.width;
}

- (void)setRight:(CGFloat)value
{
    self.x = value - self.width;
}

- (CGFloat)bottom
{
    return self.y + self.height;
}

- (void)setBottom:(CGFloat)value
{
    self.y = value - self.height;
}

- (void)centerAlignHorizontallyWithView:(UIView *)view
{
    WeViewAssert(view);
    WeViewAssert(self.superview);
    WeViewAssert(view.superview);
    CGPoint otherCenter = [view.superview convertPoint:view.center
                                                toView:self.superview];
    self.x = roundf(otherCenter.x - self.width * 0.5f);
}

- (void)centerAlignVerticallyWithView:(UIView *)view
{
    WeViewAssert(view);
    WeViewAssert(self.superview);
    WeViewAssert(view.superview);
    CGPoint otherCenter = [view.superview convertPoint:view.center
                                                toView:self.superview];
    self.y = roundf(otherCenter.y - self.height * 0.5f);
}

- (void)centerHorizontallyInSuperview
{
    WeViewAssert(self.superview);
    self.x = roundf((self.superview.width - self.width) * 0.5f);
}

- (void)centerVerticallyInSuperview
{
    WeViewAssert(self.superview);
    self.y = roundf((self.superview.height - self.height) * 0.5f);
}

#pragma mark - Debug

- (NSString *)layoutDescription
{
    return [self.viewInfo layoutDescription];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

@end
