//
//  UIView+WeView2.m
//  Unknown Project
//
//  Copyright (c) 2013 Charles Matthew Chen. All rights reserved.
//

#import <assert.h>
#import <objc/runtime.h>

#import "UIView+WeView2.h"
#import "WeView2Macros.h"

static const void *kWeView2Key_ViewInfo = &kWeView2Key_ViewInfo;

NSString* FormatHAlign(HAlign value) {
    switch (value) {
        case H_ALIGN_LEFT:
            return @"Left";
        case H_ALIGN_CENTER:
            return @"Center";
        case H_ALIGN_RIGHT:
            return @"Right";
        default:
            WeView2Assert(0);
            return nil;
    }
}

NSString* FormatVAlign(VAlign value) {
    switch (value) {
        case V_ALIGN_TOP:
            return @"Top";
        case H_ALIGN_CENTER:
            return @"Center";
        case V_ALIGN_BOTTOM:
            return @"Bottom";
        default:
            WeView2Assert(0);
            return nil;
    }
}

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

#pragma mark -

@implementation WeView2ViewInfo

- (void)dealloc {
}

- (id)init {
    if (self = [super init]) {
        self.hAlign = H_ALIGN_CENTER;
        self.vAlign = V_ALIGN_CENTER;

        self.maxWidth = CGFLOAT_MAX;
        self.maxHeight = CGFLOAT_MAX;
    }
    
    return self;
}

// TODO: Add asserts in the setters.

/* CODEGEN MARKER: View Info Start */

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

- (void)setHMargin:(CGFloat)value
{
    [self setLeftMargin:value];
    [self setRightMargin:value];
}

- (void)setVMargin:(CGFloat)value
{
    [self setTopMargin:value];
    [self setBottomMargin:value];
}

- (void)setMargin:(CGFloat)value
{
    [self setLeftMargin:value];
    [self setRightMargin:value];
    [self setTopMargin:value];
    [self setBottomMargin:value];
}

- (void)setSpacing:(CGFloat)value
{
    [self setHSpacing:value];
    [self setVSpacing:value];
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
    [result appendString:[self formatLayoutDescriptionItem:@"ignoreNaturalSize" value:@(self.ignoreNaturalSize)]];
    [result appendString:[self formatLayoutDescriptionItem:@"leftMargin" value:@(self.leftMargin)]];
    [result appendString:[self formatLayoutDescriptionItem:@"rightMargin" value:@(self.rightMargin)]];
    [result appendString:[self formatLayoutDescriptionItem:@"topMargin" value:@(self.topMargin)]];
    [result appendString:[self formatLayoutDescriptionItem:@"bottomMargin" value:@(self.bottomMargin)]];
    [result appendString:[self formatLayoutDescriptionItem:@"vSpacing" value:@(self.vSpacing)]];
    [result appendString:[self formatLayoutDescriptionItem:@"hSpacing" value:@(self.hSpacing)]];
    [result appendString:[self formatLayoutDescriptionItem:@"debugName" value:self.debugName]];
    [result appendString:[self formatLayoutDescriptionItem:@"debugLayout" value:@(self.debugLayout)]];

/* CODEGEN MARKER: Debug End */

    [result appendString:[self formatLayoutDescriptionItem:@"hAlign" value:FormatHAlign(self.hAlign)]];
    [result appendString:[self formatLayoutDescriptionItem:@"vAlign" value:FormatVAlign(self.vAlign)]];

    return result;
}

@end

#pragma mark -

@implementation UIView (WeView2)

#pragma mark - Associated Values

- (WeView2ViewInfo *)viewInfo
{
    WeView2ViewInfo *value = objc_getAssociatedObject(self, kWeView2Key_ViewInfo);
    if (!value)
    {
        value = [[WeView2ViewInfo alloc] init];
        objc_setAssociatedObject(self, kWeView2Key_ViewInfo, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return value;
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

- (BOOL)ignoreNaturalSize
{
    return [self.viewInfo ignoreNaturalSize];
}

- (UIView *)setIgnoreNaturalSize:(BOOL)value
{
    [self.viewInfo setIgnoreNaturalSize:value];
    return self;
}

- (CGFloat)leftMargin
{
    return [self.viewInfo leftMargin];
}

- (UIView *)setLeftMargin:(CGFloat)value
{
    [self.viewInfo setLeftMargin:value];
    return self;
}

- (CGFloat)rightMargin
{
    return [self.viewInfo rightMargin];
}

- (UIView *)setRightMargin:(CGFloat)value
{
    [self.viewInfo setRightMargin:value];
    return self;
}

- (CGFloat)topMargin
{
    return [self.viewInfo topMargin];
}

- (UIView *)setTopMargin:(CGFloat)value
{
    [self.viewInfo setTopMargin:value];
    return self;
}

- (CGFloat)bottomMargin
{
    return [self.viewInfo bottomMargin];
}

- (UIView *)setBottomMargin:(CGFloat)value
{
    [self.viewInfo setBottomMargin:value];
    return self;
}

- (CGFloat)vSpacing
{
    return [self.viewInfo vSpacing];
}

- (UIView *)setVSpacing:(CGFloat)value
{
    [self.viewInfo setVSpacing:value];
    return self;
}

- (CGFloat)hSpacing
{
    return [self.viewInfo hSpacing];
}

- (UIView *)setHSpacing:(CGFloat)value
{
    [self.viewInfo setHSpacing:value];
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

- (BOOL)debugLayout
{
    return [self.viewInfo debugLayout];
}

- (UIView *)setDebugLayout:(BOOL)value
{
    [self.viewInfo setDebugLayout:value];
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

- (UIView *)setHMargin:(CGFloat)value
{
    [self setLeftMargin:value];
    [self setRightMargin:value];
    return self;
}

- (UIView *)setVMargin:(CGFloat)value
{
    [self setTopMargin:value];
    [self setBottomMargin:value];
    return self;
}

- (UIView *)setMargin:(CGFloat)value
{
    [self setLeftMargin:value];
    [self setRightMargin:value];
    [self setTopMargin:value];
    [self setBottomMargin:value];
    return self;
}

- (UIView *)setSpacing:(CGFloat)value
{
    [self setHSpacing:value];
    [self setVSpacing:value];
    return self;
}

/* CODEGEN MARKER: Accessors End */

- (HAlign)hAlign
{
    return [self.viewInfo hAlign];
}

- (id)setHAlign:(HAlign)value
{
    [self.viewInfo setHAlign:value];
    return self;
}

- (VAlign)vAlign
{
    return [self.viewInfo vAlign];
}

- (id)setVAlign:(VAlign)value
{
    [self.viewInfo setVAlign:value];
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

- (void)centerHorizontallyInSuperview
{
    WeView2Assert(self.superview);
    self.x = roundf((self.superview.width - self.width) * 0.5f);
}

- (void)centerVerticallyInSuperview
{
    WeView2Assert(self.superview);
    self.y = roundf((self.superview.height - self.height) * 0.5f);
}

#pragma mark - Debug

- (NSString *)layoutDescription
{
    return [self.viewInfo layoutDescription];
}

@end
