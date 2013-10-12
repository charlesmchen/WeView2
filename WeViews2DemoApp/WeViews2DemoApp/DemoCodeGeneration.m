//
//  DemoCodeGeneration.m
//  WeView 2
//
//  Copyright (c) 2013 Charles Matthew Chen. All rights reserved.
//
//  Distributed under the Apache License v2.0.
//  http://www.apache.org/licenses/LICENSE-2.0.html
//

#import "DemoCodeGeneration.h"
#import "WeView.h"
#import "WeViewLinearLayout.h"
#import "WeViewFlowLayout.h"
#import "WeViewGridLayout.h"
#import "WeViewBlockLayout.h"
#import "WeViewStackLayout.h"
#import "DemoMacros.h"

@interface WeView (DemoCodeGeneration)

// We need private access to this class' internals to generate the code.
- (NSArray *)activeLayouts;
- (NSArray *)allLayouts;
- (NSArray *)subviewsForLayout:(WeViewLayout *)layout;

@end

#pragma mark -

@interface WeViewLinearLayout ()

// We need private access to this class' internals to generate the code.
- (BOOL)isHorizontal;

@end

#pragma mark -

@interface DemoCodeGeneration ()

@property (nonatomic) NSMutableDictionary *instanceNameMap;

@end

#pragma mark -

@implementation DemoCodeGeneration

- (id)init
{
    self = [super init];

    if (self)
    {
        self.instanceNameMap = [NSMutableDictionary dictionary];
    }

    return self;
}

- (NSString *)nameForInstanceOfClass:(Class)class
{
    NSString *result = NSStringFromClass(class);
    if ([result hasPrefix:@"UI"])
    {
        result = [result substringFromIndex:2];
    }
    result = [NSString stringWithFormat:@"%@%@",
              [[result substringToIndex:1] lowercaseString],
              [result substringFromIndex:1]];

    int instanceCount = 0;
    if (self.instanceNameMap[result])
    {
        instanceCount = [self.instanceNameMap[result] intValue];
    }
    instanceCount++;
    self.instanceNameMap[result] = @(instanceCount);

    result = [NSString stringWithFormat:@"%@%d",
              result,
              instanceCount];

    return result;
}

- (BOOL)isKindOfClasses:(UIView *)view
                classes:(NSArray *)classes
{
    for (Class class in classes)
    {
        if ([view isKindOfClass:class])
        {
            return YES;
        }
    }
    return NO;
}

- (NSString *)formatDebugName:(NSString *)debugName
{
    NSString *result = debugName;
    result = [result stringByReplacingOccurrencesOfString:@" " withString:@""];
    result = [NSString stringWithFormat:@"%@%@",
              [[result substringToIndex:1] lowercaseString],
              [result substringFromIndex:1]];
    return result;
}

- (NSString *)nameForView:(UIView *)view
{
    if (view.debugName)
    {
        return [self formatDebugName:view.debugName];
    }
    return [self nameForInstanceOfClass:[view class]];
}

- (NSString *)generateCodeForView:(UIView *)view
{
    NSString *viewName = [self nameForView:view];
    return [self generateCodeForView:view
                            viewName:viewName];
}

- (BOOL)layoutHasSingleForm:(WeViewLayout *)layout
{
    return ([layout isKindOfClass:[WeViewStackLayout class]]);
}

- (NSString *)methodNameForLayout:(WeViewLayout *)layout
                           plural:(BOOL)plural
{
    //#import "WeViewLinearLayout.h"
    //#import "WeViewFlowLayout.h"
    //#import "WeViewGridLayout.h"
    //#import "WeViewBlockLayout.h"
    //#import "WeViewStackLayout.h"

    if ([layout isKindOfClass:[WeViewLinearLayout class]])
    {
        WeViewLinearLayout *linearLayout = (WeViewLinearLayout *)layout;
        return (linearLayout.isHorizontal
                ? @"addSubviewsWithHorizontalLayout"
                : @"addSubviewsWithVerticalLayout");
    }
    else if ([layout isKindOfClass:[WeViewStackLayout class]])
    {
        return (plural
                ? @"addSubviewsWithStackLayout"
                : @"addSubviewWithCustomLayout");
    }
    else
    {
        NSLog(@"%@", [layout class]);
        WeViewAssert(0);
        return nil;
    }
}

// Add a subview with a custom layout that applies to just that subview.
//- (WeViewLayout *)addSubviewWithCustomLayout:(UIView *)subview;
//
// Add subviews with a stack layout that applies to just these subviews.
//- (WeViewLayout *)addSubviewsWithStackLayout:(NSArray *)subviews;
//
// Add a subview with a layout that stretches the subview to fill this view's bounds.
//- (WeViewLayout *)addSubviewWithFillLayout:(UIView *)subview;
//
// Add a subview with a layout that stretches the subview to fill this view's bounds, while
// preserving its aspect ratio.
//- (WeViewLayout *)addSubviewWithFillLayoutWAspectRatio:(UIView *)subview;
//
// Add a subview with a layout that stretches the subview to fill this view's bounds, while
// preserving its aspect ratio.
//- (WeViewLayout *)addSubviewWithFitLayoutWAspectRatio:(UIView *)subview;
//
// Add subviews with a block-based layout that applies to just these subviews.
//
// The "layout" block positions and sizes these subviews.
//- (WeViewLayout *)addSubviews:(NSArray *)subviews
//              withLayoutBlock:(WeView2LayoutBlock)layoutBlock;
//
// Add subviews with a block-based layout that applies to just these subviews.
//
// The "layout" block positions and sizes these subviews and the "desired size" block determines
// the desired size of these subviews.
//- (WeViewLayout *)addSubviews:(NSArray *)subviews
//              withLayoutBlock:(WeView2LayoutBlock)layoutBlock
//             desiredSizeBlock:(WeView2DesiredSizeBlock)desiredSizeBlock;
//
// Add a subview with a block-based layout that applies to just that subview.
//
// The "layout" block positions and sizes this subview.
//- (WeViewLayout *)addSubview:(UIView *)subview
//             withLayoutBlock:(WeView2LayoutBlock)layoutBlock
//            desiredSizeBlock:(WeView2DesiredSizeBlock)desiredSizeBlock;
//
// Add a subview with a block-based layout that applies to just that subview.
//
// The "layout" block positions and sizes this subview and the "desired size" block determines the
// desired size of this subview.
//- (WeViewLayout *)addSubview:(UIView *)subview
//             withLayoutBlock:(WeView2LayoutBlock)layoutBlock;
//

- (NSString *)generateSubviewPropertiesForView:(UIView *)view
                                      viewName:(NSString *)viewName
{
    UIView *virginView = [[UIView alloc] init];
    NSMutableArray *lines = [NSMutableArray array];

    /* CODEGEN MARKER: Code Generation View Properties Start */

    if (view.minWidth != virginView.minWidth)
    {
        [lines addObject:[NSString stringWithFormat:@"%@:%@", @"setMinWidth", FormatFloat(view.minWidth)]];
    }

    if (view.maxWidth != virginView.maxWidth)
    {
        [lines addObject:[NSString stringWithFormat:@"%@:%@", @"setMaxWidth", FormatFloat(view.maxWidth)]];
    }

    if (view.minHeight != virginView.minHeight)
    {
        [lines addObject:[NSString stringWithFormat:@"%@:%@", @"setMinHeight", FormatFloat(view.minHeight)]];
    }

    if (view.maxHeight != virginView.maxHeight)
    {
        [lines addObject:[NSString stringWithFormat:@"%@:%@", @"setMaxHeight", FormatFloat(view.maxHeight)]];
    }

    if (view.hStretchWeight != virginView.hStretchWeight)
    {
        [lines addObject:[NSString stringWithFormat:@"%@:%@", @"setHStretchWeight", FormatFloat(view.hStretchWeight)]];
    }

    if (view.vStretchWeight != virginView.vStretchWeight)
    {
        [lines addObject:[NSString stringWithFormat:@"%@:%@", @"setVStretchWeight", FormatFloat(view.vStretchWeight)]];
    }

    if (view.previousSpacingAdjustment != virginView.previousSpacingAdjustment)
    {
        [lines addObject:[NSString stringWithFormat:@"%@:%@", @"setPreviousSpacingAdjustment", FormatInt(view.previousSpacingAdjustment)]];
    }

    if (view.nextSpacingAdjustment != virginView.nextSpacingAdjustment)
    {
        [lines addObject:[NSString stringWithFormat:@"%@:%@", @"setNextSpacingAdjustment", FormatInt(view.nextSpacingAdjustment)]];
    }

    if (view.desiredWidthAdjustment != virginView.desiredWidthAdjustment)
    {
        [lines addObject:[NSString stringWithFormat:@"%@:%@", @"setDesiredWidthAdjustment", FormatFloat(view.desiredWidthAdjustment)]];
    }

    if (view.desiredHeightAdjustment != virginView.desiredHeightAdjustment)
    {
        [lines addObject:[NSString stringWithFormat:@"%@:%@", @"setDesiredHeightAdjustment", FormatFloat(view.desiredHeightAdjustment)]];
    }

    if (view.ignoreDesiredSize != virginView.ignoreDesiredSize)
    {
        [lines addObject:[NSString stringWithFormat:@"%@:%@", @"setIgnoreDesiredSize", FormatBoolean(view.ignoreDesiredSize)]];
    }

    if (view.cellHAlign != virginView.cellHAlign)
    {
        [lines addObject:[NSString stringWithFormat:@"%@:%@", @"setCellHAlign", FormatHAlign(view.cellHAlign)]];
    }

    if (view.cellVAlign != virginView.cellVAlign)
    {
        [lines addObject:[NSString stringWithFormat:@"%@:%@", @"setCellVAlign", FormatVAlign(view.cellVAlign)]];
    }

    if (view.hasCellHAlign != virginView.hasCellHAlign)
    {
        [lines addObject:[NSString stringWithFormat:@"%@:%@", @"setHasCellHAlign", FormatBoolean(view.hasCellHAlign)]];
    }

    if (view.hasCellVAlign != virginView.hasCellVAlign)
    {
        [lines addObject:[NSString stringWithFormat:@"%@:%@", @"setHasCellVAlign", FormatBoolean(view.hasCellVAlign)]];
    }

/* CODEGEN MARKER: Code Generation View Properties End */

    if ([lines count] < 1)
    {
        return viewName;
    }

    NSString *result = nil;
    for (NSString *line in lines)
    {
        if (result)
        {
            result = [NSString stringWithFormat:@"[%@\n  %@]", result, line];
        }
        else
        {
            result = [NSString stringWithFormat:@"[%@ %@]", viewName, line];
        }
    }
//    result = [NSString stringWithFormat:@"%@;\n", result];

    return result;
}

- (NSString *)generateCodeForView:(UIView *)view
                         viewName:(NSString *)viewName
{
    NSMutableString *result = [@"" mutableCopy];

    if ([self isKindOfClasses:view
                      classes:@[
         [UILabel class],
         [UIButton class],
         ]] ||
        [view isMemberOfClass:[UIView class]])
    {
        [result appendFormat:@"%@ *%@ = [[%@ alloc] init];\n",
         NSStringFromClass([view class]),
         viewName,
         NSStringFromClass([view class])];
    }
    else if ([view isKindOfClass:[WeView class]])
    {
        [result appendFormat:@"%@ *%@ = [[%@ alloc] init];\n",
         NSStringFromClass([view class]),
         viewName,
         NSStringFromClass([view class])];

        WeView *weView = (WeView *)view;
        for (WeViewLayout *layout in [weView activeLayouts])
        {
            NSArray *layoutSubviews = [weView subviewsForLayout:layout];
            NSMutableString *layoutSubviewsClause = [@"" mutableCopy];
            [layoutSubviewsClause appendString:@"@[\n"];
            NSMutableArray *subviewNames = [NSMutableArray array];
            for (UIView *subview in layoutSubviews)
            {
                NSString *subviewName = [self nameForView:subview];
                [result appendString:[self generateCodeForView:subview
                                                      viewName:subviewName]];
                NSString *subviewWProperties = [self generateSubviewPropertiesForView:subview
                                                                            viewName:subviewName];
//                if (subviewProperties)
//                {
//                    [result appendString:subviewProperties];
//                }

                [subviewNames addObject:subviewWProperties];
                [layoutSubviewsClause appendFormat:@"    %@,\n", subviewWProperties];
//                [subviewNames addObject:subviewName];
//                [layoutSubviewsClause appendFormat:@"    %@,\n", subviewName];
            }
            [layoutSubviewsClause appendString:@"]"];

            BOOL plural = (![self layoutHasSingleForm:layout] ||
                           [layoutSubviews count] > 1);
            NSString *layoutStatement;
            if (plural)
            {
                layoutStatement = [NSString stringWithFormat:@"[%@ %@:%@]",
                                   viewName,
                                   [self methodNameForLayout:layout
                                                      plural:plural],
                                   layoutSubviewsClause];
            }
            else
            {
                layoutStatement = [NSString stringWithFormat:@"[%@ %@:%@]",
                                   viewName,
                                   [self methodNameForLayout:layout
                                                      plural:plural],
                                   subviewNames[0]];
            }

            layoutStatement = [NSString stringWithFormat:@"%@;\n\n",
                               layoutStatement];

            [result appendString:layoutStatement];
        }
    }
    else if ([view isKindOfClass:[UIImageView class]])
    {
        NSString *imageName = [self nameForInstanceOfClass:[UIImage class]];
        [result appendFormat:@"UIImage *%@ = [UIImage alloc] imageNamed:...];\n",
         imageName];
        [result appendFormat:@"UIImageView *%@ = [[UIImageView alloc] initWithImage:%@];\n",
         viewName,
         imageName];
    }
    else
    {
        [result appendFormat:@"%@ *%@ = ...;\n",
         NSStringFromClass([view class]),
         viewName];
    }
    return result;
}

@end
