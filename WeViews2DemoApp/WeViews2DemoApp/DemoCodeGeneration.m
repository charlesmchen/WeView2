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

CG_INLINE
NSString* ReprHAlign(HAlign value)
{
    switch (value)
    {
        case H_ALIGN_LEFT:
            return @"H_ALIGN_LEFT";
        case H_ALIGN_CENTER:
            return @"H_ALIGN_CENTER";
        case H_ALIGN_RIGHT:
            return @"H_ALIGN_RIGHT";
        default:
            WeViewAssert(0);
            return nil;
    }
}

CG_INLINE
NSString* ReprVAlign(VAlign value)
{
    switch (value)
    {
        case V_ALIGN_TOP:
            return @"V_ALIGN_TOP";
        case H_ALIGN_CENTER:
            return @"H_ALIGN_CENTER";
        case V_ALIGN_BOTTOM:
            return @"V_ALIGN_BOTTOM";
        default:
            WeViewAssert(0);
            return nil;
    }
}

CG_INLINE
NSString* ReprCellPositioningMode(CellPositioningMode value)
{
    switch (value)
    {
        case CELL_POSITION_NORMAL:
            return @"CELL_POSITION_NORMAL";
        case CELL_POSITION_FILL:
            return @"CELL_POSITION_FILL";
        case CELL_POSITION_FILL_W_ASPECT_RATIO:
            return @"CELL_POSITION_FILL_W_ASPECT_RATIO";
        case CELL_POSITION_FIT_W_ASPECT_RATIO:
            return @"CELL_POSITION_FIT_W_ASPECT_RATIO";
        default:
            WeViewAssert(0);
            return nil;
    }
}

#pragma mark -

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

@interface WeViewBlockLayout ()

// We need private access to this class' internals to generate the code.
- (WeView2DesiredSizeBlock)desiredSizeBlock;

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

    NSMutableString *result = [@"" mutableCopy];
    [result appendString:@"#import \"WeView.h\"\n\n"];
    [result appendString:[self generateCodeForView:view
                                          viewName:viewName]];
    return result;
}

- (BOOL)layoutHasSingleForm:(WeViewLayout *)layout
{
    return ([layout isKindOfClass:[WeViewStackLayout class]]);
}

- (NSString *)addStatementForLayout:(WeViewLayout *)layout
                           viewName:(NSString *)viewName
                 firstSubviewClause:(NSString *)firstSubviewClause
               layoutSubviewsClause:(NSString *)layoutSubviewsClause
{
    // TODO:
    //#import "WeViewGridLayout.h"

    if ([layout isKindOfClass:[WeViewLinearLayout class]])
    {
        WeViewLinearLayout *linearLayout = (WeViewLinearLayout *)layout;
        return [NSString stringWithFormat:@"[%@ %@:%@]",
                viewName,
                (linearLayout.isHorizontal
                 ? @"addSubviewsWithHorizontalLayout"
                 : @"addSubviewsWithVerticalLayout"),
                layoutSubviewsClause];
    }
    else if ([layout isKindOfClass:[WeViewStackLayout class]])
    {
        if (firstSubviewClause)
        {
            return [NSString stringWithFormat:@"[%@ %@:%@]",
                    viewName,
                    @"addSubviewWithCustomLayout",
                    firstSubviewClause];
        }
        else
        {
            return [NSString stringWithFormat:@"[%@ %@:%@]",
                    viewName,
                    @"addSubviewsWithStackLayout",
                    layoutSubviewsClause];
        }
    }
    else if ([layout isKindOfClass:[WeViewFlowLayout class]])
    {
        return [NSString stringWithFormat:@"[%@ %@:%@]",
                viewName,
                @"addSubviewsWithFlowLayout",
                layoutSubviewsClause];
    }
    else if ([layout isKindOfClass:[WeViewBlockLayout class]])
    {
        WeViewBlockLayout *blockLayout = (WeViewBlockLayout *)layout;
        if (blockLayout.desiredSizeBlock)
        {
            return [NSString stringWithFormat:@"[%@ %@:%@ withLayoutBlock:...]",
                    viewName,
                    @"addSubviews",
                    layoutSubviewsClause];
        }
        else
        {
            return [NSString stringWithFormat:@"[%@ %@:%@ withLayoutBlock:... desiredSizeBlock:...]",
                    viewName,
                    @"addSubviews",
                    layoutSubviewsClause];
        }
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

- (BOOL)doDecorations:(NSArray *)lines
   haveLineWithPrefix:(NSString *)prefix
{
    for (NSString *line in lines)
    {
        if ([line hasPrefix:prefix])
        {
            return YES;
        }
    }
    return NO;
}

- (BOOL)doDecorations:(NSArray *)lines
haveLinesWithPrefixes:(NSArray *)prefixes
{
    for (NSString *prefix in prefixes)
    {
        if (![self doDecorations:lines
              haveLineWithPrefix:prefix])
        {
            return NO;
        }
    }
    return YES;
}

- (BOOL)doesLine:(NSString *)line
haveAnyOfPrefixes:(NSArray *)prefixes
{
    for (NSString *prefix in prefixes)
    {
        if ([line hasPrefix:prefix])
        {
            return YES;
        }
    }
    return NO;
}

- (NSMutableArray *)removeLines:(NSArray *)lines
                   withPrefixes:(NSArray *)prefixes
{
    NSMutableArray *result = [NSMutableArray array];
    for (NSString *line in lines)
    {
        if (![self doesLine:line
          haveAnyOfPrefixes:prefixes])
        {
            [result addObject:line];
        }
    }
    return result;
}

- (NSString *)decorateLayoutWithProperties:(NSString *)layoutStatement
                                    layout:(WeViewLayout *)layout
{
    WeViewLayout *virginLayout = [[WeViewLayout alloc] init];
    NSMutableArray *lines = [NSMutableArray array];

    /* CODEGEN MARKER: Code Generation Layout Properties Start */

    if (layout.leftMargin != virginLayout.leftMargin)
    {
        [lines addObject:[NSString stringWithFormat:@"%@:%@", @"setLeftMargin", FormatFloat(layout.leftMargin)]];
    }

    if (layout.rightMargin != virginLayout.rightMargin)
    {
        [lines addObject:[NSString stringWithFormat:@"%@:%@", @"setRightMargin", FormatFloat(layout.rightMargin)]];
    }

    if (layout.topMargin != virginLayout.topMargin)
    {
        [lines addObject:[NSString stringWithFormat:@"%@:%@", @"setTopMargin", FormatFloat(layout.topMargin)]];
    }

    if (layout.bottomMargin != virginLayout.bottomMargin)
    {
        [lines addObject:[NSString stringWithFormat:@"%@:%@", @"setBottomMargin", FormatFloat(layout.bottomMargin)]];
    }

    if (layout.vSpacing != virginLayout.vSpacing)
    {
        [lines addObject:[NSString stringWithFormat:@"%@:%@", @"setVSpacing", FormatInt(layout.vSpacing)]];
    }

    if (layout.hSpacing != virginLayout.hSpacing)
    {
        [lines addObject:[NSString stringWithFormat:@"%@:%@", @"setHSpacing", FormatInt(layout.hSpacing)]];
    }

    if (layout.hAlign != virginLayout.hAlign)
    {
        [lines addObject:[NSString stringWithFormat:@"%@:%@", @"setHAlign", ReprHAlign(layout.hAlign)]];
    }

    if (layout.vAlign != virginLayout.vAlign)
    {
        [lines addObject:[NSString stringWithFormat:@"%@:%@", @"setVAlign", ReprVAlign(layout.vAlign)]];
    }

    if (layout.spacingStretches != virginLayout.spacingStretches)
    {
        [lines addObject:[NSString stringWithFormat:@"%@:%@", @"setSpacingStretches", FormatBoolean(layout.spacingStretches)]];
    }

    if (layout.cropSubviewOverflow != virginLayout.cropSubviewOverflow)
    {
        [lines addObject:[NSString stringWithFormat:@"%@:%@", @"setCropSubviewOverflow", FormatBoolean(layout.cropSubviewOverflow)]];
    }

    if (layout.cellPositioning != virginLayout.cellPositioning)
    {
        [lines addObject:[NSString stringWithFormat:@"%@:%@", @"setCellPositioning", ReprCellPositioningMode(layout.cellPositioning)]];
    }

    if (layout.debugLayout != virginLayout.debugLayout)
    {
        [lines addObject:[NSString stringWithFormat:@"%@:%@", @"setDebugLayout", FormatBoolean(layout.debugLayout)]];
    }

    if (layout.debugMinSize != virginLayout.debugMinSize)
    {
        [lines addObject:[NSString stringWithFormat:@"%@:%@", @"setDebugMinSize", FormatBoolean(layout.debugMinSize)]];
    }

    // Custom Accessors

    if ([self doDecorations:lines haveLinesWithPrefixes:@[@"setHSpacing:", @"setVSpacing:"]] &&
        layout.hSpacing == layout.vSpacing)
    {
        lines = [self removeLines:lines withPrefixes:@[@"setHSpacing:", @"setVSpacing:"]];
        [lines addObject:[NSString stringWithFormat:@"%@:%@", @"setSpacing", FormatBoolean(layout.hSpacing)]];
    }

    if ([self doDecorations:lines haveLinesWithPrefixes:@[@"setLeftMargin:", @"setRightMargin:", @"setTopMargin:", @"setBottomMargin:"]] &&
        layout.leftMargin == layout.rightMargin && layout.leftMargin == layout.topMargin && layout.leftMargin == layout.bottomMargin)
    {
        lines = [self removeLines:lines withPrefixes:@[@"setLeftMargin:", @"setRightMargin:", @"setTopMargin:", @"setBottomMargin:"]];
        [lines addObject:[NSString stringWithFormat:@"%@:%@", @"setMargin", FormatFloat(layout.leftMargin)]];
    }

    if ([self doDecorations:lines haveLinesWithPrefixes:@[@"setTopMargin:", @"setBottomMargin:"]] &&
        layout.topMargin == layout.bottomMargin)
    {
        lines = [self removeLines:lines withPrefixes:@[@"setTopMargin:", @"setBottomMargin:"]];
        [lines addObject:[NSString stringWithFormat:@"%@:%@", @"setVMargin", FormatFloat(layout.topMargin)]];
    }

    if ([self doDecorations:lines haveLinesWithPrefixes:@[@"setLeftMargin:", @"setRightMargin:"]] &&
        layout.leftMargin == layout.rightMargin)
    {
        lines = [self removeLines:lines withPrefixes:@[@"setLeftMargin:", @"setRightMargin:"]];
        [lines addObject:[NSString stringWithFormat:@"%@:%@", @"setHMargin", FormatFloat(layout.leftMargin)]];
    }

/* CODEGEN MARKER: Code Generation Layout Properties End */

    NSString *result = layoutStatement;
    for (NSString *line in lines)
    {
        result = [NSString stringWithFormat:@"[%@\n  %@]", result, line];
    }
    return result;
}

- (NSString *)decorateSubviewWithProperties:(UIView *)view
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

    if (view.leftSpacingAdjustment != virginView.leftSpacingAdjustment)
    {
        [lines addObject:[NSString stringWithFormat:@"%@:%@", @"setLeftSpacingAdjustment", FormatInt(view.leftSpacingAdjustment)]];
    }

    if (view.topSpacingAdjustment != virginView.topSpacingAdjustment)
    {
        [lines addObject:[NSString stringWithFormat:@"%@:%@", @"setTopSpacingAdjustment", FormatInt(view.topSpacingAdjustment)]];
    }

    if (view.rightSpacingAdjustment != virginView.rightSpacingAdjustment)
    {
        [lines addObject:[NSString stringWithFormat:@"%@:%@", @"setRightSpacingAdjustment", FormatInt(view.rightSpacingAdjustment)]];
    }

    if (view.bottomSpacingAdjustment != virginView.bottomSpacingAdjustment)
    {
        [lines addObject:[NSString stringWithFormat:@"%@:%@", @"setBottomSpacingAdjustment", FormatInt(view.bottomSpacingAdjustment)]];
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
        [lines addObject:[NSString stringWithFormat:@"%@:%@", @"setCellHAlign", ReprHAlign(view.cellHAlign)]];
    }

    if (view.cellVAlign != virginView.cellVAlign)
    {
        [lines addObject:[NSString stringWithFormat:@"%@:%@", @"setCellVAlign", ReprVAlign(view.cellVAlign)]];
    }

    if (view.hasCellHAlign != virginView.hasCellHAlign)
    {
        [lines addObject:[NSString stringWithFormat:@"%@:%@", @"setHasCellHAlign", FormatBoolean(view.hasCellHAlign)]];
    }

    if (view.hasCellVAlign != virginView.hasCellVAlign)
    {
        [lines addObject:[NSString stringWithFormat:@"%@:%@", @"setHasCellVAlign", FormatBoolean(view.hasCellVAlign)]];
    }

    // Custom Accessors

    if ([self doDecorations:lines haveLinesWithPrefixes:@[@"setVStretchWeight:", @"setHStretchWeight:"]] &&
        view.vStretchWeight == view.hStretchWeight)
    {
        lines = [self removeLines:lines withPrefixes:@[@"setVStretchWeight:", @"setHStretchWeight:"]];
        [lines addObject:[NSString stringWithFormat:@"%@:%@", @"setStretchWeight", FormatFloat(view.vStretchWeight)]];
    }

    if ([self doDecorations:lines haveLinesWithPrefixes:@[@"setMinHeight:", @"setMaxHeight:"]] &&
        view.minHeight == view.maxHeight)
    {
        lines = [self removeLines:lines withPrefixes:@[@"setMinHeight:", @"setMaxHeight:"]];
        [lines addObject:[NSString stringWithFormat:@"%@:%@", @"setFixedHeight", FormatFloat(view.minHeight)]];
    }

    if ([self doDecorations:lines haveLinesWithPrefixes:@[@"setMinWidth:", @"setMaxWidth:"]] &&
        view.minWidth == view.maxWidth)
    {
        lines = [self removeLines:lines withPrefixes:@[@"setMinWidth:", @"setMaxWidth:"]];
        [lines addObject:[NSString stringWithFormat:@"%@:%@", @"setFixedWidth", FormatFloat(view.minWidth)]];
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
            result = [NSString stringWithFormat:@"[%@\n      %@]", result, line];
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

//    if ([self isKindOfClasses:view
//                      classes:@[
//         [UILabel class],
//         [UIButton class],
//         ]] ||
//        [view isMemberOfClass:[UIView class]])
//    {
//        [result appendFormat:@"%@ *%@ = [[%@ alloc] init];\n",
//         NSStringFromClass([view class]),
//         viewName,
//         NSStringFromClass([view class])];
//
//        if ([view isKindOfClass:[UILabel class]])
//        {
//            UILabel *label = (UILabel *)view;
//            if (label.text)
//            {
//                [result appendFormat:@"%@.text = @\"%@\";\n",
//                 viewName,
//                 label.text];
//            }
//
//            [result appendFormat:@"//%@.text = @\"%@\";\n",
//             viewName,
//             label.text];
//        }
//    }
//    else
        if ([view isKindOfClass:[WeView class]])
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
                NSString *subviewWProperties = [self decorateSubviewWithProperties:subview
                                                                            viewName:subviewName];

                [subviewNames addObject:subviewWProperties];
                [layoutSubviewsClause appendFormat:@"    %@,\n", subviewWProperties];
            }
            [layoutSubviewsClause appendString:@"   ]"];

            NSString *firstSubviewClause = ([layoutSubviews count] != 1
                                            ? nil
                                            : subviewNames[0]);
            NSString *layoutStatement = [self addStatementForLayout:layout
                                                           viewName:viewName
                                                 firstSubviewClause:firstSubviewClause
                                               layoutSubviewsClause:layoutSubviewsClause];

            layoutStatement = [self decorateLayoutWithProperties:layoutStatement
                                                          layout:layout];

            layoutStatement = [NSString stringWithFormat:@"%@;\n\n",
                               layoutStatement];

            [result appendString:layoutStatement];
        }
    }
//    else if ([view isKindOfClass:[UIImageView class]])
//    {
//        NSString *imageName = [self nameForInstanceOfClass:[UIImage class]];
//        [result appendFormat:@"UIImage *%@ = [UIImage alloc] imageNamed:...];\n",
//         imageName];
//        [result appendFormat:@"UIImageView *%@ = [[UIImageView alloc] initWithImage:%@];\n",
//         viewName,
//         imageName];
//    }
    else
    {
        [result appendFormat:@"%@ *%@ = ...;\n",
         NSStringFromClass([view class]),
         viewName];
    }
    return result;
}

@end
