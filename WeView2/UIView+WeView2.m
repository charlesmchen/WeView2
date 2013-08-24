//
//  UIView+WeView2.m
//  Unknown Project
//
//  Copyright (c) 2013 Charles Matthew Chen. All rights reserved.
//

#import "UIView+WeView2.h"

//#import "NSObject+Extension.h"
#import <assert.h>
#import <objc/runtime.h>

#import "WeView2Macros.h"

/* CODEGEN MARKER: Keys Start */

static const void *kWeView2Key_MinWidth = &kWeView2Key_MinWidth;
static const void *kWeView2Key_MaxWidth = &kWeView2Key_MaxWidth;
static const void *kWeView2Key_MinHeight = &kWeView2Key_MinHeight;
static const void *kWeView2Key_MaxHeight = &kWeView2Key_MaxHeight;

static const void *kWeView2Key_HStretchWeight = &kWeView2Key_HStretchWeight;
static const void *kWeView2Key_VStretchWeight = &kWeView2Key_VStretchWeight;
static const void *kWeView2Key_IgnoreNaturalSize = &kWeView2Key_IgnoreNaturalSize;

static const void *kWeView2Key_LeftMargin = &kWeView2Key_LeftMargin;
static const void *kWeView2Key_RightMargin = &kWeView2Key_RightMargin;
static const void *kWeView2Key_TopMargin = &kWeView2Key_TopMargin;
static const void *kWeView2Key_BottomMargin = &kWeView2Key_BottomMargin;

static const void *kWeView2Key_VSpacing = &kWeView2Key_VSpacing;
static const void *kWeView2Key_HSpacing = &kWeView2Key_HSpacing;

static const void *kWeView2Key_DebugName = &kWeView2Key_DebugName;
static const void *kWeView2Key_DebugLayout = &kWeView2Key_DebugLayout;

/* CODEGEN MARKER: Keys End */

static const void *kWeView2Key_HAlign = &kWeView2Key_HAlign;
static const void *kWeView2Key_VAlign = &kWeView2Key_VAlign;

CGRect alignSizeWithinRect(CGSize size, CGRect rect, HAlign hAlign, VAlign vAlign)
{
    CGRect result;
    result.size = size;

    switch (hAlign)
    {
        case H_ALIGN_LEFT:
            result.origin.x = 0;
            break;
        case H_ALIGN_CENTER:
            result.origin.x = (rect.size.width - size.width) / 2;
            break;
        case H_ALIGN_RIGHT:
            result.origin.x = rect.size.width - size.width;
            break;
        default:
            NSLog(@"Unknown hAlign: %d", hAlign);
            assert(0);
            break;
    }
    switch (vAlign)
    {
        case V_ALIGN_TOP:
            result.origin.y = 0;
            break;
        case V_ALIGN_CENTER:
            result.origin.y = (rect.size.height - size.height) / 2;
            break;
        case V_ALIGN_BOTTOM:
            result.origin.y = rect.size.height - size.height;
            break;
        default:
            NSLog(@"Unknown vAlign: %d", vAlign);
            assert(0);
            break;
    }
    result.origin = CGPointRound(CGPointAdd(result.origin, rect.origin));
    return result;
}

@implementation UIView (WeView2)

#pragma mark - Associated Values

- (CGFloat)associatedFloat:(const void *)key
              defaultValue:(CGFloat)defaultValue
{
    NSNumber *value = objc_getAssociatedObject(self, key);
    return (value
            ? [value floatValue]
            : defaultValue);
}

- (CGFloat)associatedFloat:(const void *)key
{
    return [self associatedFloat:key
                    defaultValue:0];
}

- (void)setAssociatedFloat:(CGFloat)value
                       key:(const void *)key
{
    objc_setAssociatedObject(self, key, @(value), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)associatedBoolean:(const void *)key
{
    return [objc_getAssociatedObject(self, key) boolValue];
}

- (void)setAssociatedBoolean:(BOOL)value
                         key:(const void *)key
{
    objc_setAssociatedObject(self, key, @(value), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (int)associatedInt:(const void *)key
        defaultValue:(int)defaultValue
{
    NSNumber *value = objc_getAssociatedObject(self, key);
    return (value
            ? [value intValue]
            : defaultValue);
}

- (void)setAssociatedInt:(int)value
                     key:(const void *)key
{
    objc_setAssociatedObject(self, key, @(value), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)associatedString:(const void *)key
                  defaultValue:(NSString *)defaultValue
{
    NSString *value = objc_getAssociatedObject(self, key);
    return (value
            ? value
            : defaultValue);
}

- (void)setAssociatedString:(NSString *)value
                        key:(const void *)key
{
    objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

/* CODEGEN MARKER: Accessors Start */

- (CGFloat)minWidth
{
    return [self associatedFloat:kWeView2Key_MinWidth];
}

- (id)setMinWidth:(CGFloat)value
{
    WeView2Assert(value >= 0);
    [self setAssociatedFloat:value key:kWeView2Key_MinWidth];
    return self;
}

- (CGFloat)maxWidth
{
    return [self associatedFloat:kWeView2Key_MaxWidth defaultValue:CGFLOAT_MAX];
}

- (id)setMaxWidth:(CGFloat)value
{
    WeView2Assert(value >= 0);
    [self setAssociatedFloat:value key:kWeView2Key_MaxWidth];
    return self;
}

- (CGFloat)minHeight
{
    return [self associatedFloat:kWeView2Key_MinHeight];
}

- (id)setMinHeight:(CGFloat)value
{
    WeView2Assert(value >= 0);
    [self setAssociatedFloat:value key:kWeView2Key_MinHeight];
    return self;
}

- (CGFloat)maxHeight
{
    return [self associatedFloat:kWeView2Key_MaxHeight defaultValue:CGFLOAT_MAX];
}

- (id)setMaxHeight:(CGFloat)value
{
    WeView2Assert(value >= 0);
    [self setAssociatedFloat:value key:kWeView2Key_MaxHeight];
    return self;
}

- (CGFloat)hStretchWeight
{
    return [self associatedFloat:kWeView2Key_HStretchWeight];
}

- (id)setHStretchWeight:(CGFloat)value
{
    WeView2Assert(value >= 0);
    [self setAssociatedFloat:value key:kWeView2Key_HStretchWeight];
    return self;
}

- (CGFloat)vStretchWeight
{
    return [self associatedFloat:kWeView2Key_VStretchWeight];
}

- (id)setVStretchWeight:(CGFloat)value
{
    WeView2Assert(value >= 0);
    [self setAssociatedFloat:value key:kWeView2Key_VStretchWeight];
    return self;
}

- (BOOL)ignoreNaturalSize
{
    return [self associatedBoolean:kWeView2Key_IgnoreNaturalSize];
}

- (id)setIgnoreNaturalSize:(BOOL)value
{
    [self setAssociatedBoolean:value key:kWeView2Key_IgnoreNaturalSize];
    return self;
}

- (CGFloat)leftMargin
{
    return [self associatedFloat:kWeView2Key_LeftMargin];
}

- (id)setLeftMargin:(CGFloat)value
{
    [self setAssociatedFloat:value key:kWeView2Key_LeftMargin];
    return self;
}

- (CGFloat)rightMargin
{
    return [self associatedFloat:kWeView2Key_RightMargin];
}

- (id)setRightMargin:(CGFloat)value
{
    [self setAssociatedFloat:value key:kWeView2Key_RightMargin];
    return self;
}

- (CGFloat)topMargin
{
    return [self associatedFloat:kWeView2Key_TopMargin];
}

- (id)setTopMargin:(CGFloat)value
{
    [self setAssociatedFloat:value key:kWeView2Key_TopMargin];
    return self;
}

- (CGFloat)bottomMargin
{
    return [self associatedFloat:kWeView2Key_BottomMargin];
}

- (id)setBottomMargin:(CGFloat)value
{
    [self setAssociatedFloat:value key:kWeView2Key_BottomMargin];
    return self;
}

- (CGFloat)vSpacing
{
    return [self associatedFloat:kWeView2Key_VSpacing];
}

- (id)setVSpacing:(CGFloat)value
{
    [self setAssociatedFloat:value key:kWeView2Key_VSpacing];
    return self;
}

- (CGFloat)hSpacing
{
    return [self associatedFloat:kWeView2Key_HSpacing];
}

- (id)setHSpacing:(CGFloat)value
{
    [self setAssociatedFloat:value key:kWeView2Key_HSpacing];
    return self;
}

- (NSString *)debugName
{
    return [self associatedString:kWeView2Key_DebugName defaultValue:@"?"];
}

- (id)setDebugName:(NSString *)value
{
    [self setAssociatedString:value key:kWeView2Key_DebugName];
    return self;
}

- (BOOL)debugLayout
{
    return [self associatedBoolean:kWeView2Key_DebugLayout];
}

- (id)setDebugLayout:(BOOL)value
{
    [self setAssociatedBoolean:value key:kWeView2Key_DebugLayout];
    return self;
}

- (id)setMinSize:(CGSize)value
{
    [self setMinWidth:value.width];
    [self setMinHeight:value.height];
    return self;
}

- (id)setMaxSize:(CGSize)value
{
    [self setMaxWidth:value.width];
    [self setMaxHeight:value.height];
    return self;
}

- (id)setFixedWidth:(CGFloat)value
{
    [self setMinWidth:value];
    [self setMaxWidth:value];
    return self;
}

- (id)setFixedHeight:(CGFloat)value
{
    [self setMinHeight:value];
    [self setMaxHeight:value];
    return self;
}

- (id)setFixedSize:(CGSize)value
{
    [self setMinWidth:value.width];
    [self setMinHeight:value.height];
    [self setMaxWidth:value.width];
    [self setMaxHeight:value.height];
    return self;
}

- (id)setStretchWeight:(CGFloat)value
{
    [self setVStretchWeight:value];
    [self setHStretchWeight:value];
    return self;
}

- (id)setHMargin:(CGFloat)value
{
    [self setLeftMargin:value];
    [self setRightMargin:value];
    return self;
}

- (id)setVMargin:(CGFloat)value
{
    [self setTopMargin:value];
    [self setBottomMargin:value];
    return self;
}

- (id)setMargin:(CGFloat)value
{
    [self setLeftMargin:value];
    [self setRightMargin:value];
    [self setTopMargin:value];
    [self setBottomMargin:value];
    return self;
}

- (id)setSpacing:(CGFloat)value
{
    [self setHSpacing:value];
    [self setVSpacing:value];
    return self;
}

/* CODEGEN MARKER: Accessors End */

- (HAlign)hAlign
{
    return [self associatedInt:kWeView2Key_HAlign
                  defaultValue:H_ALIGN_CENTER];
}

- (id)setHAlign:(HAlign)value
{
    [self setAssociatedInt:value key:kWeView2Key_HAlign];
    return self;
}

- (VAlign)vAlign
{
    return [self associatedInt:kWeView2Key_VAlign
                  defaultValue:V_ALIGN_CENTER];
}

- (id)setVAlign:(VAlign)value
{
    [self setAssociatedInt:value key:kWeView2Key_VAlign];
    return self;
}

- (id)withStretch
{
    // Layout should stretch this subview to fit any available space.
    [self setStretchWeight:1.f];
    return self;
}

- (id)withPureStretch
{
    // Layout should stretch this subview to fit any available space, ignoring its natural
    // size.
    [self setStretchWeight:1.f];
    self.ignoreNaturalSize = YES;
    return self;
}

- (CGSize)minSize
{
    return CGSizeMake(self.minWidth, self.minHeight);
}

- (CGSize)maxSize
{
    return CGSizeMake(self.maxWidth, self.maxHeight);
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

- (CGFloat)bottom
{
    return self.y + self.height;
}

- (CGFloat)right
{
    return self.x + self.width;
}

- (NSString *)formatLayoutDescriptionItem:(NSString *)key
                                    value:(id)value
{
    return [NSString stringWithFormat:@"%@: %@, ", key, value];
}

- (NSString *)layoutDescription
{
    NSMutableString *result = [@"" mutableCopy];

/* CODEGEN MARKER: Debug Start */

    if (objc_getAssociatedObject(self, kWeView2Key_MinWidth))
    {
        [result appendString:[self formatLayoutDescriptionItem:@"minWidth"
                                                         value:objc_getAssociatedObject(self, kWeView2Key_MinWidth)]];
    }

    if (objc_getAssociatedObject(self, kWeView2Key_MaxWidth))
    {
        [result appendString:[self formatLayoutDescriptionItem:@"maxWidth"
                                                         value:objc_getAssociatedObject(self, kWeView2Key_MaxWidth)]];
    }

    if (objc_getAssociatedObject(self, kWeView2Key_MinHeight))
    {
        [result appendString:[self formatLayoutDescriptionItem:@"minHeight"
                                                         value:objc_getAssociatedObject(self, kWeView2Key_MinHeight)]];
    }

    if (objc_getAssociatedObject(self, kWeView2Key_MaxHeight))
    {
        [result appendString:[self formatLayoutDescriptionItem:@"maxHeight"
                                                         value:objc_getAssociatedObject(self, kWeView2Key_MaxHeight)]];
    }

    if (objc_getAssociatedObject(self, kWeView2Key_HStretchWeight))
    {
        [result appendString:[self formatLayoutDescriptionItem:@"hStretchWeight"
                                                         value:objc_getAssociatedObject(self, kWeView2Key_HStretchWeight)]];
    }

    if (objc_getAssociatedObject(self, kWeView2Key_VStretchWeight))
    {
        [result appendString:[self formatLayoutDescriptionItem:@"vStretchWeight"
                                                         value:objc_getAssociatedObject(self, kWeView2Key_VStretchWeight)]];
    }

    if (objc_getAssociatedObject(self, kWeView2Key_IgnoreNaturalSize))
    {
        [result appendString:[self formatLayoutDescriptionItem:@"ignoreNaturalSize"
                                                         value:objc_getAssociatedObject(self, kWeView2Key_IgnoreNaturalSize)]];
    }

    if (objc_getAssociatedObject(self, kWeView2Key_LeftMargin))
    {
        [result appendString:[self formatLayoutDescriptionItem:@"leftMargin"
                                                         value:objc_getAssociatedObject(self, kWeView2Key_LeftMargin)]];
    }

    if (objc_getAssociatedObject(self, kWeView2Key_RightMargin))
    {
        [result appendString:[self formatLayoutDescriptionItem:@"rightMargin"
                                                         value:objc_getAssociatedObject(self, kWeView2Key_RightMargin)]];
    }

    if (objc_getAssociatedObject(self, kWeView2Key_TopMargin))
    {
        [result appendString:[self formatLayoutDescriptionItem:@"topMargin"
                                                         value:objc_getAssociatedObject(self, kWeView2Key_TopMargin)]];
    }

    if (objc_getAssociatedObject(self, kWeView2Key_BottomMargin))
    {
        [result appendString:[self formatLayoutDescriptionItem:@"bottomMargin"
                                                         value:objc_getAssociatedObject(self, kWeView2Key_BottomMargin)]];
    }

    if (objc_getAssociatedObject(self, kWeView2Key_VSpacing))
    {
        [result appendString:[self formatLayoutDescriptionItem:@"vSpacing"
                                                         value:objc_getAssociatedObject(self, kWeView2Key_VSpacing)]];
    }

    if (objc_getAssociatedObject(self, kWeView2Key_HSpacing))
    {
        [result appendString:[self formatLayoutDescriptionItem:@"hSpacing"
                                                         value:objc_getAssociatedObject(self, kWeView2Key_HSpacing)]];
    }

    if (objc_getAssociatedObject(self, kWeView2Key_DebugName))
    {
        [result appendString:[self formatLayoutDescriptionItem:@"debugName"
                                                         value:objc_getAssociatedObject(self, kWeView2Key_DebugName)]];
    }

    if (objc_getAssociatedObject(self, kWeView2Key_DebugLayout))
    {
        [result appendString:[self formatLayoutDescriptionItem:@"debugLayout"
                                                         value:objc_getAssociatedObject(self, kWeView2Key_DebugLayout)]];
    }

/* CODEGEN MARKER: Debug End */

    return result;
}

@end
