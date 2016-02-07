//
//  WeScrollView.m
//  WeView v2
//
//  Copyright (c) 2015 Charles Matthew Chen. All rights reserved.
//
//  Distributed under the Apache License v2.0.
//  http://www.apache.org/licenses/LICENSE-2.0.html
//

#import "UIView+WeView.h"
#import "WeScrollView.h"

typedef enum {
    SCROLL_MODE_HORIZONTAL,
    SCROLL_MODE_VERTICAL,
    SCROLL_MODE_BOTH,
} WeScrollViewMode;

#pragma mark -

@interface WeScrollView ()

@property (nonatomic) WeScrollViewMode mode;

@end

#pragma mark -

@implementation WeScrollView

- (id) init {
    if (self = [super init])
    {
        self.mode = SCROLL_MODE_BOTH;
        self.hAlign = H_ALIGN_CENTER;
        self.vAlign = V_ALIGN_CENTER;
    }
    return self;
}

+ (WeScrollView *)createVerticalScrollView
{
    WeScrollView *result = [[WeScrollView alloc] init];
    result.mode = SCROLL_MODE_VERTICAL;
    return result;
}

+ (WeScrollView *)createVerticalScrollViewForContentView:(UIView *)contentView
{
    WeScrollView *result = [self createVerticalScrollView];
    result.contentView = contentView;
    return result;
}

+ (WeScrollView *)createHorizontalScrollView
{
    WeScrollView *result = [[WeScrollView alloc] init];
    result.mode = SCROLL_MODE_HORIZONTAL;
    return result;
}

+ (WeScrollView *)createHorizontalScrollViewForContentView:(UIView *)contentView
{
    WeScrollView *result = [self createHorizontalScrollView];
    result.contentView = contentView;
    return result;
}

+ (WeScrollView *)createHorizontalAndVerticalScrollView
{
    WeScrollView *result = [[WeScrollView alloc] init];
    result.mode = SCROLL_MODE_BOTH;
    return result;
}

+ (WeScrollView *)createHorizontalAndVerticalScrollViewForContentView:(UIView *)contentView
{
    WeScrollView *result = [self createHorizontalAndVerticalScrollView];
    result.contentView = contentView;
    return result;
}

- (void)setContentView:(UIView *)contentView
{
    [_contentView removeFromSuperview];
    
    _contentView = contentView;
    
    [self addSubview:contentView];
    
    [self setNeedsLayout];
    [self.superview setNeedsLayout];
}

- (CGSize) sizeThatFits:(CGSize) value {
    if (!_contentView)
    {
        return CGSizeZero;
    }
    
    CGSize size;
    switch (_mode) {
        case SCROLL_MODE_HORIZONTAL: {
            CGSize maxSize = CGSizeMake(0, self.frame.size.height);
            size = [_contentView sizeThatFits:maxSize];
            size.height = self.bounds.size.height;
            break;
        }
        case SCROLL_MODE_VERTICAL: {
            CGSize maxSize = CGSizeMake(self.frame.size.width, 0);
            size = [_contentView sizeThatFits:maxSize];
            size.width = self.bounds.size.width;
            break;
        }
        case SCROLL_MODE_BOTH: {
            size = [_contentView sizeThatFits:CGSizeZero];
            break;
        }
        default:
            return CGSizeZero;
    }
    
    return size;
}

- (void)layoutSubviews
{
    // Clear the "needsLayout" flag.
    [super layoutSubviews];
    
    if (_contentView == nil) {
        self.contentSize = CGSizeZero;
        self.scrollEnabled = NO;
        return;
    }
    
    CGSize size;
    switch (_mode) {
        case SCROLL_MODE_HORIZONTAL: {
            CGSize maxSize = CGSizeMake(0, self.frame.size.height);
            size = [_contentView sizeThatFits:maxSize];
            size.height = self.bounds.size.height;
            break;
        }
        case SCROLL_MODE_VERTICAL: {
            CGSize maxSize = CGSizeMake(self.frame.size.width, 0);
            size = [_contentView sizeThatFits:maxSize];
            size.width = self.bounds.size.width;
            break;
        }
        case SCROLL_MODE_BOTH:
            size = [_contentView sizeThatFits:CGSizeZero];
            break;
        default:
            return;
    }

    self.contentSize = size;
    CGRect contentFrame = CGRectZero;

    // TODO: round/ceil/floor these sizes before doing this math.
    if (size.width < self.width) {
        if (self.contentView.hStretchWeight > 0.f) {
            size.width = self.width;
        } else {
            if (self.hAlign == H_ALIGN_CENTER) {
                contentFrame.origin.x = roundf((self.width - size.width) * 0.5f);
            } else if (self.hAlign == H_ALIGN_RIGHT) {
                contentFrame.origin.x = self.width - size.width;
            }
        }
    }
    if (size.height < self.height) {
        if (self.contentView.vStretchWeight > 0.f) {
            size.height = self.height;
        } else {
            if (self.vAlign == V_ALIGN_CENTER) {
                contentFrame.origin.y = roundf((self.height - size.height) * 0.5f);
            } else if (self.vAlign == V_ALIGN_BOTTOM) {
                contentFrame.origin.y = self.height - size.height;
            }
        }
    }

    contentFrame.size = size;
    _contentView.frame = contentFrame;
    
    // TODO: clip scrollOffset.
    self.scrollEnabled = ((self.contentSize.width > self.width) ||
                          (self.contentSize.height > self.height));
    
    [self setNeedsDisplay];
}

- (void)setBounds:(CGRect) value {
    [super setBounds:value];
    [self setNeedsLayout];
}

- (void)setFrame:(CGRect) value {
    [super setFrame:value];
    [self setNeedsLayout];
}

@end
