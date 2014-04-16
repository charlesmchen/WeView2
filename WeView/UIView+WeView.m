//
//  UIView+WeView.m
//  WeView v2
//
//  Copyright (c) 2014 Charles Matthew Chen. All rights reserved.
//
//  Distributed under the Apache License v2.0.
//  http://www.apache.org/licenses/LICENSE-2.0.html
//

#import <assert.h>
#import <objc/runtime.h>

#import "UIView+WeView.h"
#import "WeViewMacros.h"

static const void *kWeViewKey_ViewInfo = &kWeViewKey_ViewInfo;

@interface WeViewViewInfo : NSObject

/* CODEGEN MARKER: View Info Properties Start */

// The minimum desired width of this view. Trumps the maxWidth.
@property (nonatomic) CGFloat minDesiredWidth;

// The maximum desired width of this view. Trumped by the minWidth.
@property (nonatomic) CGFloat maxDesiredWidth;

// The minimum desired height of this view. Trumps the maxHeight.
@property (nonatomic) CGFloat minDesiredHeight;

// The maximum desired height of this view. Trumped by the minHeight.
@property (nonatomic) CGFloat maxDesiredHeight;

// The horizontal stretch weight of this view. If non-zero, the view is willing to take available
// space or be cropped if
// necessary.
// 
// Subviews with larger relative stretch weights will be stretched more.
@property (nonatomic) CGFloat hStretchWeight;

// The vertical stretch weight of this view. If non-zero, the view is willing to take available
// space or be cropped if
// necessary.
// 
// Subviews with larger relative stretch weights will be stretched more.
@property (nonatomic) CGFloat vStretchWeight;

// An adjustment to the spacing to the left of this view, if any.
// 
// This value can be positive or negative.
// 
// Only applies to the horizontal, vertical and flow layouts.
@property (nonatomic) int leftSpacingAdjustment;

// An adjustment to the spacing above this view, if any.
// 
// This value can be positive or negative.
// 
// Only applies to the horizontal and vertical layouts.
@property (nonatomic) int topSpacingAdjustment;

// An adjustment to the spacing to the right of this view, if any.
// 
// This value can be positive or negative.
// 
// Only applies to the horizontal, vertical and flow layouts.
@property (nonatomic) int rightSpacingAdjustment;

// An adjustment to the spacing below this view, if any.
// 
// This value can be positive or negative.
// 
// Only applies to the horizontal and vertical layouts.
@property (nonatomic) int bottomSpacingAdjustment;

// This adjustment can be used to manipulate the desired width of a view.
// 
// It is added to the desired width reported by the subview.
// 
// This value can be negative.
@property (nonatomic) CGFloat desiredWidthAdjustment;

// This adjustment can be used to manipulate the desired height of a view.
// 
// It is added to the desired width reported by the subview.
// 
// This value can be negative.
@property (nonatomic) CGFloat desiredHeightAdjustment;
@property (nonatomic) BOOL ignoreDesiredSize;

// The horizontal alignment preference of this view within in its layout cell.
// 
// This value is optional.  The default value is the contentHAlign of its superview.
// 
// cellHAlign should only be used for cells whose alignment differs from its superview's.
@property (nonatomic) HAlign cellHAlign;

// The vertical alignment preference of this view within in its layout cell.
// 
// This value is optional.  The default value is the contentVAlign of its superview.
// 
// cellVAlign should only be used for cells whose alignment differs from its superview's.
@property (nonatomic) VAlign cellVAlign;
@property (nonatomic) BOOL hasCellHAlign;
@property (nonatomic) BOOL hasCellVAlign;

@property (nonatomic) NSString * debugName;

// Convenience accessor(s) for the minDesiredWidth and minDesiredHeight properties.
- (CGSize)minDesiredSize;
- (void)setMinDesiredSize:(CGSize)value;

// Convenience accessor(s) for the maxDesiredWidth and maxDesiredHeight properties.
- (CGSize)maxDesiredSize;
- (void)setMaxDesiredSize:(CGSize)value;

// Convenience accessor(s) for the desiredWidthAdjustment and desiredHeightAdjustment properties.
- (CGSize)desiredSizeAdjustment;
- (void)setDesiredSizeAdjustment:(CGSize)value;

// Convenience accessor(s) for the minDesiredWidth and maxDesiredWidth properties.
- (void)setFixedDesiredWidth:(CGFloat)value;

// Convenience accessor(s) for the minDesiredHeight and maxDesiredHeight properties.
- (void)setFixedDesiredHeight:(CGFloat)value;

// Convenience accessor(s) for the minDesiredWidth, minDesiredHeight, maxDesiredWidth and
// maxDesiredHeight
// properties.
- (void)setFixedDesiredSize:(CGSize)value;

// Convenience accessor(s) for the vStretchWeight and hStretchWeight properties.
- (void)setStretchWeight:(CGFloat)value;

/* CODEGEN MARKER: View Info Properties End */

@end

#pragma mark -

@implementation WeViewViewInfo

- (id)init
{
    if (self = [super init])
    {
        self.maxDesiredWidth = CGFLOAT_MAX;
        self.maxDesiredHeight = CGFLOAT_MAX;
    }

    return self;
}

/* CODEGEN MARKER: View Info M Start */

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

- (CGSize)minDesiredSize
{
    return CGSizeMake(self.minDesiredWidth, self.minDesiredHeight);
}

- (void)setMinDesiredSize:(CGSize)value
{
    [self setMinDesiredWidth:value.width];
    [self setMinDesiredHeight:value.height];
}

- (CGSize)maxDesiredSize
{
    return CGSizeMake(self.maxDesiredWidth, self.maxDesiredHeight);
}

- (void)setMaxDesiredSize:(CGSize)value
{
    [self setMaxDesiredWidth:value.width];
    [self setMaxDesiredHeight:value.height];
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

- (void)setFixedDesiredWidth:(CGFloat)value
{
    [self setMinDesiredWidth:value];
    [self setMaxDesiredWidth:value];
}

- (void)setFixedDesiredHeight:(CGFloat)value
{
    [self setMinDesiredHeight:value];
    [self setMaxDesiredHeight:value];
}

- (void)setFixedDesiredSize:(CGSize)value
{
    [self setMinDesiredWidth:value.width];
    [self setMinDesiredHeight:value.height];
    [self setMaxDesiredWidth:value.width];
    [self setMaxDesiredHeight:value.height];
}

- (void)setStretchWeight:(CGFloat)value
{
    [self setVStretchWeight:value];
    [self setHStretchWeight:value];
}

/* CODEGEN MARKER: View Info M End */

- (NSString *)formatLayoutDescriptionItem:(NSString *)key
                                    value:(id)value
{
    return [NSString stringWithFormat:@"%@: %@, ", key, value];
}

- (NSString *)layoutDescription
{
    NSMutableString *result = [@"" mutableCopy];

    /* CODEGEN MARKER: View Info Debug Start */

    [result appendString:[self formatLayoutDescriptionItem:@"minDesiredWidth" value:@(self.minDesiredWidth)]];
    [result appendString:[self formatLayoutDescriptionItem:@"maxDesiredWidth" value:@(self.maxDesiredWidth)]];
    [result appendString:[self formatLayoutDescriptionItem:@"minDesiredHeight" value:@(self.minDesiredHeight)]];
    [result appendString:[self formatLayoutDescriptionItem:@"maxDesiredHeight" value:@(self.maxDesiredHeight)]];
    [result appendString:[self formatLayoutDescriptionItem:@"hStretchWeight" value:@(self.hStretchWeight)]];
    [result appendString:[self formatLayoutDescriptionItem:@"vStretchWeight" value:@(self.vStretchWeight)]];
    [result appendString:[self formatLayoutDescriptionItem:@"leftSpacingAdjustment" value:@(self.leftSpacingAdjustment)]];
    [result appendString:[self formatLayoutDescriptionItem:@"topSpacingAdjustment" value:@(self.topSpacingAdjustment)]];
    [result appendString:[self formatLayoutDescriptionItem:@"rightSpacingAdjustment" value:@(self.rightSpacingAdjustment)]];
    [result appendString:[self formatLayoutDescriptionItem:@"bottomSpacingAdjustment" value:@(self.bottomSpacingAdjustment)]];
    [result appendString:[self formatLayoutDescriptionItem:@"desiredWidthAdjustment" value:@(self.desiredWidthAdjustment)]];
    [result appendString:[self formatLayoutDescriptionItem:@"desiredHeightAdjustment" value:@(self.desiredHeightAdjustment)]];
    [result appendString:[self formatLayoutDescriptionItem:@"ignoreDesiredSize" value:@(self.ignoreDesiredSize)]];
    [result appendString:[self formatLayoutDescriptionItem:@"cellHAlign" value:@(self.cellHAlign)]];
    [result appendString:[self formatLayoutDescriptionItem:@"cellVAlign" value:@(self.cellVAlign)]];
    [result appendString:[self formatLayoutDescriptionItem:@"hasCellHAlign" value:@(self.hasCellHAlign)]];
    [result appendString:[self formatLayoutDescriptionItem:@"hasCellVAlign" value:@(self.hasCellVAlign)]];
    [result appendString:[self formatLayoutDescriptionItem:@"debugName" value:self.debugName]];

/* CODEGEN MARKER: View Info Debug End */

    return result;
}

@end

#pragma mark -

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

- (CGFloat)minDesiredWidth
{
    return [self.viewInfo minDesiredWidth];
}

- (UIView *)setMinDesiredWidth:(CGFloat)value
{
    [self.viewInfo setMinDesiredWidth:value];
    [self.superview setNeedsLayout];
    return self;
}

- (CGFloat)maxDesiredWidth
{
    return [self.viewInfo maxDesiredWidth];
}

- (UIView *)setMaxDesiredWidth:(CGFloat)value
{
    [self.viewInfo setMaxDesiredWidth:value];
    [self.superview setNeedsLayout];
    return self;
}

- (CGFloat)minDesiredHeight
{
    return [self.viewInfo minDesiredHeight];
}

- (UIView *)setMinDesiredHeight:(CGFloat)value
{
    [self.viewInfo setMinDesiredHeight:value];
    [self.superview setNeedsLayout];
    return self;
}

- (CGFloat)maxDesiredHeight
{
    return [self.viewInfo maxDesiredHeight];
}

- (UIView *)setMaxDesiredHeight:(CGFloat)value
{
    [self.viewInfo setMaxDesiredHeight:value];
    [self.superview setNeedsLayout];
    return self;
}

- (CGFloat)hStretchWeight
{
    return [self.viewInfo hStretchWeight];
}

- (UIView *)setHStretchWeight:(CGFloat)value
{
    [self.viewInfo setHStretchWeight:value];
    [self.superview setNeedsLayout];
    return self;
}

- (CGFloat)vStretchWeight
{
    return [self.viewInfo vStretchWeight];
}

- (UIView *)setVStretchWeight:(CGFloat)value
{
    [self.viewInfo setVStretchWeight:value];
    [self.superview setNeedsLayout];
    return self;
}

- (int)leftSpacingAdjustment
{
    return [self.viewInfo leftSpacingAdjustment];
}

- (UIView *)setLeftSpacingAdjustment:(int)value
{
    [self.viewInfo setLeftSpacingAdjustment:value];
    [self.superview setNeedsLayout];
    return self;
}

- (int)topSpacingAdjustment
{
    return [self.viewInfo topSpacingAdjustment];
}

- (UIView *)setTopSpacingAdjustment:(int)value
{
    [self.viewInfo setTopSpacingAdjustment:value];
    [self.superview setNeedsLayout];
    return self;
}

- (int)rightSpacingAdjustment
{
    return [self.viewInfo rightSpacingAdjustment];
}

- (UIView *)setRightSpacingAdjustment:(int)value
{
    [self.viewInfo setRightSpacingAdjustment:value];
    [self.superview setNeedsLayout];
    return self;
}

- (int)bottomSpacingAdjustment
{
    return [self.viewInfo bottomSpacingAdjustment];
}

- (UIView *)setBottomSpacingAdjustment:(int)value
{
    [self.viewInfo setBottomSpacingAdjustment:value];
    [self.superview setNeedsLayout];
    return self;
}

- (CGFloat)desiredWidthAdjustment
{
    return [self.viewInfo desiredWidthAdjustment];
}

- (UIView *)setDesiredWidthAdjustment:(CGFloat)value
{
    [self.viewInfo setDesiredWidthAdjustment:value];
    [self.superview setNeedsLayout];
    return self;
}

- (CGFloat)desiredHeightAdjustment
{
    return [self.viewInfo desiredHeightAdjustment];
}

- (UIView *)setDesiredHeightAdjustment:(CGFloat)value
{
    [self.viewInfo setDesiredHeightAdjustment:value];
    [self.superview setNeedsLayout];
    return self;
}

- (BOOL)ignoreDesiredSize
{
    return [self.viewInfo ignoreDesiredSize];
}

- (UIView *)setIgnoreDesiredSize:(BOOL)value
{
    [self.viewInfo setIgnoreDesiredSize:value];
    [self.superview setNeedsLayout];
    return self;
}

- (HAlign)cellHAlign
{
    return [self.viewInfo cellHAlign];
}

- (UIView *)setCellHAlign:(HAlign)value
{
    [self.viewInfo setCellHAlign:value];
    [self.superview setNeedsLayout];
    return self;
}

- (VAlign)cellVAlign
{
    return [self.viewInfo cellVAlign];
}

- (UIView *)setCellVAlign:(VAlign)value
{
    [self.viewInfo setCellVAlign:value];
    [self.superview setNeedsLayout];
    return self;
}

- (BOOL)hasCellHAlign
{
    return [self.viewInfo hasCellHAlign];
}

- (UIView *)setHasCellHAlign:(BOOL)value
{
    [self.viewInfo setHasCellHAlign:value];
    [self.superview setNeedsLayout];
    return self;
}

- (BOOL)hasCellVAlign
{
    return [self.viewInfo hasCellVAlign];
}

- (UIView *)setHasCellVAlign:(BOOL)value
{
    [self.viewInfo setHasCellVAlign:value];
    [self.superview setNeedsLayout];
    return self;
}

- (NSString *)debugName
{
    return [self.viewInfo debugName];
}

- (UIView *)setDebugName:(NSString *)value
{
    [self.viewInfo setDebugName:value];
    [self.superview setNeedsLayout];
    return self;
}

- (CGSize)minDesiredSize
{
    return [self.viewInfo minDesiredSize];
}

- (UIView *)setMinDesiredSize:(CGSize)value
{
    [self setMinDesiredWidth:value.width];
    [self setMinDesiredHeight:value.height];
    [self.superview setNeedsLayout];
    return self;
}

- (CGSize)maxDesiredSize
{
    return [self.viewInfo maxDesiredSize];
}

- (UIView *)setMaxDesiredSize:(CGSize)value
{
    [self setMaxDesiredWidth:value.width];
    [self setMaxDesiredHeight:value.height];
    [self.superview setNeedsLayout];
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
    [self.superview setNeedsLayout];
    return self;
}

- (UIView *)setFixedDesiredWidth:(CGFloat)value
{
    [self setMinDesiredWidth:value];
    [self setMaxDesiredWidth:value];
    [self.superview setNeedsLayout];
    return self;
}

- (UIView *)setFixedDesiredHeight:(CGFloat)value
{
    [self setMinDesiredHeight:value];
    [self setMaxDesiredHeight:value];
    [self.superview setNeedsLayout];
    return self;
}

- (UIView *)setFixedDesiredSize:(CGSize)value
{
    [self setMinDesiredWidth:value.width];
    [self setMinDesiredHeight:value.height];
    [self setMaxDesiredWidth:value.width];
    [self setMaxDesiredHeight:value.height];
    [self.superview setNeedsLayout];
    return self;
}

- (UIView *)setStretchWeight:(CGFloat)value
{
    [self setVStretchWeight:value];
    [self setHStretchWeight:value];
    [self.superview setNeedsLayout];
    return self;
}

/* CODEGEN MARKER: Accessors End */

- (UIView *)setHStretches
{
    [self setHStretchWeight:1.f];
    return self;
}

- (UIView *)setVStretches
{
    [self setVStretchWeight:1.f];
    return self;
}

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
    r.origin = CGPointRound(origin);
    self.frame = r;
}

- (CGSize)size
{
    return self.frame.size;
}

- (void)setSize:(CGSize)size
{
    CGRect r = self.frame;
    r.size = CGSizeRound(size);
    self.frame = r;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (void)setX:(CGFloat)value
{
    CGRect r = self.frame;
    r.origin.x = roundf(value);
    self.frame = r;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)setY:(CGFloat)value
{
    CGRect r = self.frame;
    r.origin.y = roundf(value);
    self.frame = r;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)value
{
    CGRect r = self.frame;
    r.size.width = roundf(value);
    self.frame = r;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)value
{
    CGRect r = self.frame;
    r.size.height = roundf(value);
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

- (CGFloat)hCenter
{
    return self.x + self.width * 0.5f;
}

- (void)setHCenter:(CGFloat)value
{
    self.x = value - self.width * 0.5f;
}

- (CGFloat)vCenter
{
    return self.y + self.height * 0.5f;
}

- (void)setVCenter:(CGFloat)value
{
    self.y = value - self.height * 0.5f;
}

- (void)centerAlignHorizontallyWithView:(UIView *)view
{
    WeViewAssert(view);
    WeViewAssert(self.superview);
    WeViewAssert(view.superview);
    CGPoint otherCenter = [view.superview convertPoint:view.center
                                                toView:self.superview];
    self.x = otherCenter.x - self.width * 0.5f;
}

- (void)centerAlignVerticallyWithView:(UIView *)view
{
    WeViewAssert(view);
    WeViewAssert(self.superview);
    WeViewAssert(view.superview);
    CGPoint otherCenter = [view.superview convertPoint:view.center
                                                toView:self.superview];
    self.y = otherCenter.y - self.height * 0.5f;
}

- (void)centerHorizontallyInSuperview
{
    WeViewAssert(self.superview);
    self.x = (self.superview.width - self.width) * 0.5f;
}

- (void)centerVerticallyInSuperview
{
    WeViewAssert(self.superview);
    self.y = (self.superview.height - self.height) * 0.5f;
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
