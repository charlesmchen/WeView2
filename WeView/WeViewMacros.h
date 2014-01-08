//
//  WeViewMacros.h
//  WeView v2
//
//  Copyright (c) 2014 Charles Matthew Chen. All rights reserved.
//
//  Distributed under the Apache License v2.0.
//  http://www.apache.org/licenses/LICENSE-2.0.html
//

#pragma once

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#if defined(DEBUG)
#define WeViewAssert(Condition) assert(Condition)
#else
#define WeViewAssert(Condition)
#endif

#ifndef FormatCGSize
#define FormatCGSize(__value) NSStringFromCGSize(__value)
#endif
#ifndef FormatCGPoint
#define FormatCGPoint(__value) NSStringFromCGPoint(__value)
#endif
#ifndef FormatCGRect
#define FormatCGRect(__value) NSStringFromCGRect(__value)
#endif

#ifndef DebugCGSize
#define DebugCGSize(__name, __value) NSLog(@"%@: %@", __name, NSStringFromCGSize(__value))
#endif
#ifndef DebugCGPoint
#define DebugCGPoint(__name, __value) NSLog(@"%@: %@", __name, NSStringFromCGPoint(__value))
#endif
#ifndef DebugCGRect
#define DebugCGRect(__name, __value) NSLog(@"%@: %@", __name, NSStringFromCGRect(__value))
#endif

#define sqr(a) ((a) * (a))
#define clamp01(a) (MAX(0, MIN(1, a)))

#pragma mark - CGPoint

CG_INLINE CGPoint
CGPointAdd(const CGPoint p1, const CGPoint p2)
{
    return CGPointMake(p1.x + p2.x, p1.y + p2.y);
}

CG_INLINE CGPoint
CGPointAdd3(const CGPoint p1, const CGPoint p2, const CGPoint p3)
{
    return CGPointMake(p1.x + p2.x + p3.x, p1.y + p2.y + p3.y);
}

CG_INLINE CGPoint
CGPointSubtract(const CGPoint p0, const CGPoint p1)
{
    return CGPointMake(p0.x - p1.x,
                       p0.y - p1.y);
}

CG_INLINE CGPoint
CGPointMin(CGPoint p1, CGPoint p2)
{
    return CGPointMake(MIN(p1.x, p2.x),
                       MIN(p1.y, p2.y));
}

CG_INLINE CGPoint
CGPointMax(CGPoint p1, CGPoint p2)
{
    return CGPointMake(MAX(p1.x, p2.x),
                       MAX(p1.y, p2.y));
}

CG_INLINE CGPoint
CGPointRound(const CGPoint p1)
{
    return CGPointMake(roundf(p1.x),
                       roundf(p1.y));
}

CG_INLINE CGPoint
CGPointCeil(const CGPoint p1)
{
    return CGPointMake(ceilf(p1.x),
                       ceilf(p1.y));
}

CG_INLINE CGPoint
CGPointFloor(const CGPoint p1)
{
    return CGPointMake(floorf(p1.x),
                       floorf(p1.y));
}

CG_INLINE CGPoint
CGPointAbs(const CGPoint p1)
{
    return CGPointMake(fabsf(p1.x),
                       fabsf(p1.y));
}

CG_INLINE CGFloat
CGPointDistance(CGPoint p0, CGPoint p1)
{
    CGFloat result = sqrtf(sqr(p0.x - p1.x) + sqr(p0.y - p1.y));
    return result;
}

CG_INLINE CGFloat
CGPointLength(CGPoint p1)
{
    return sqrtf(sqr(p1.x) + sqr(p1.y));

}

CG_INLINE CGPoint
CGPointScale(const CGPoint p0, const CGFloat factor)
{
    return CGPointMake(p0.x * factor,
                       p0.y * factor);
}

CG_INLINE CGPoint
CGPointInvert(const CGPoint p0)
{
    return CGPointMake(-p0.x,
                       -p0.y);
}

CG_INLINE CGFloat
CGPointDotProduct(const CGPoint p1, const CGPoint p2)
{
    return (p1.x * p2.x) + (p1.y * p2.y);
}

CG_INLINE CGPoint
CGPointNormalize(const CGPoint p0)
{
    return CGPointScale(p0, 1.0f / CGPointLength(p0));
}

CG_INLINE CGPoint
CGPointBlendFast(const CGPoint p1, const CGPoint p2, const CGFloat factor, const CGFloat nfactor)
{
    CGPoint p =
    {
        p1.x * nfactor + p2.x * factor,
        p1.y * nfactor + p2.y * factor,
    };
    return p;
}

CG_INLINE CGPoint
CGPointBlend(const CGPoint p1, const CGPoint p2, const CGFloat value)
{
    CGFloat factor = clamp01(value);
    CGFloat nfactor = 1.0f - factor;
    return CGPointBlendFast(p1, p2, factor, nfactor);
}

#pragma mark - CGSize

CG_INLINE CGSize
CGSizeAdd(const CGSize p1, const CGSize p2)
{
    return CGSizeMake(p1.width + p2.width,
                      p1.height + p2.height);
}

CG_INLINE CGSize
CGSizeSubtract(const CGSize p1, const CGSize p2)
{
    return CGSizeMake(p1.width - p2.width,
                      p1.height - p2.height);
}

CG_INLINE CGSize
CGSizeScale(const CGSize p1, const CGFloat value)
{
    return CGSizeMake(p1.width * value,
                      p1.height * value);
}

CG_INLINE CGSize
CGSizeMax(const CGSize p1, const CGSize p2)
{
    return CGSizeMake(MAX(p1.width, p2.width),
                      MAX(p1.height, p2.height));
}

CG_INLINE CGSize
CGSizeMin(const CGSize p1, const CGSize p2)
{
    return CGSizeMake(MIN(p1.width, p2.width),
                      MIN(p1.height, p2.height));
}

CG_INLINE CGSize
CGSizeRound(const CGSize p1)
{
    return CGSizeMake(roundf(p1.width),
                      roundf(p1.height));
}

CG_INLINE CGSize
CGSizeCeil(const CGSize p1)
{
    return CGSizeMake(ceilf(p1.width),
                      ceilf(p1.height));
}

CG_INLINE CGSize
CGSizeFloor(const CGSize p1)
{
    return CGSizeMake(floorf(p1.width),
                      floorf(p1.height));
}

CG_INLINE CGSize
CGSizeFitInSize(CGSize r0, CGSize r1)
{
    if (r0.width <= r1.width && r0.height <= r1.height)
    {
        return r0;
    }
    CGFloat widthFactor = r1.width / r0.width;
    CGFloat heightFactor = r1.height / r0.height;
    CGFloat factor = MIN(widthFactor, heightFactor);
    CGSize result;
    result.width = roundf(r0.width * factor);
    result.height = roundf(r0.height * factor);
    return result;
}

#pragma mark - CGRect

CG_INLINE CGRect
CGSizeCenterOnRect(CGSize r0, CGRect r1)
{
    CGRect result;
    result.origin.x = roundf(r1.origin.x + (r1.size.width - r0.width) * 0.5f);
    result.origin.y = roundf(r1.origin.y + (r1.size.height - r0.height) * 0.5f);
    result.size = r0;
    return result;
}

CG_INLINE CGRect
CGRectCenterOnRect(CGRect r0, CGRect r1)
{
    return CGSizeCenterOnRect(r0.size, r1);
}

CG_INLINE CGPoint
CGRectCenter(const CGRect r)
{
    return CGPointMake(r.origin.x + r.size.width * 0.5f,
                       r.origin.y + r.size.height * 0.5f);
}
