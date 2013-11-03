//
//  DemoCodeGeneration.m
//  WeView v2
//
//  Copyright (c) 2013 Charles Matthew Chen. All rights reserved.
//
//  Distributed under the Apache License v2.0.
//  http://www.apache.org/licenses/LICENSE-2.0.html
//

#import "DemoCodeGeneration.h"
#import "DemoMacros.h"
#import "WeView.h"
#import "WeViewBlockLayout.h"
#import "WeViewFlowLayout.h"
#import "WeViewGridLayout.h"
#import "WeViewLinearLayout.h"
#import "WeViewStackLayout.h"

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
        case V_ALIGN_CENTER:
            return @"V_ALIGN_CENTER";
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
        case CELL_POSITIONING_NORMAL:
            return @"CELL_POSITIONING_NORMAL";
        case CELL_POSITIONING_FILL:
            return @"CELL_POSITIONING_FILL";
        case CELL_POSITIONING_FILL_W_ASPECT_RATIO:
            return @"CELL_POSITIONING_FILL_W_ASPECT_RATIO";
        case CELL_POSITIONING_FIT_W_ASPECT_RATIO:
            return @"CELL_POSITIONING_FIT_W_ASPECT_RATIO";
        default:
            WeViewAssert(0);
            return nil;
    }
}

CG_INLINE
NSString* ReprGridStretchPolicy(GridStretchPolicy value)
{
    switch (value)
    {
        case GRID_STRETCH_POLICY_STRETCH_CELLS:
            return @"GRID_STRETCH_POLICY_STRETCH_CELLS";
        case GRID_STRETCH_POLICY_STRETCH_SPACING:
            return @"GRID_STRETCH_POLICY_STRETCH_SPACING";
        case GRID_STRETCH_POLICY_NO_STRETCH:
            return @"GRID_STRETCH_POLICY_NO_STRETCH";
        default:
            WeViewAssert(0);
            return nil;
    }
}

#pragma mark -

@interface WeView (DemoCodeGeneration)

// We need private access to this class' internals to generate the code.
- (NSArray *)layouts;
- (NSArray *)subviewsForLayout:(WeViewLayout *)layout;

@end

#pragma mark -

@interface WeViewLinearLayout (DemoCodeGeneration)

// We need private access to this class' internals to generate the code.
- (BOOL)isHorizontal;

@end

#pragma mark -

@interface WeViewBlockLayout (DemoCodeGeneration)

// We need private access to this class' internals to generate the code.
- (WeViewDesiredSizeBlock)desiredSizeBlock;

@end

#pragma mark -

@interface WeViewGridLayout (DemoCodeGeneration)

- (int)columnCount;
- (BOOL)isGridUniform;
- (GridStretchPolicy)stretchPolicy;

- (BOOL)hasCellSizeHint;
- (CGSize)cellSizeHint;

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

- (NSString *)nameForInstanceWithBasename:(NSString *)basename
               skipSuffixForFirstInstance:(BOOL)skipSuffixForFirstInstance
{
    NSString *result = basename;

    int instanceCount = 0;
    if (self.instanceNameMap[result])
    {
        instanceCount = [self.instanceNameMap[result] intValue];
    }
    instanceCount++;
    self.instanceNameMap[result] = @(instanceCount);

    if (instanceCount == 1 && skipSuffixForFirstInstance)
    {
        return result;
    }
    result = [NSString stringWithFormat:@"%@%d",
              result,
              instanceCount];

    return result;
}

- (NSString *)nameForInstanceOfClass:(Class)class
{
    NSString *classBasedName = NSStringFromClass(class);
    if ([classBasedName hasPrefix:@"UI"])
    {
        classBasedName = [classBasedName substringFromIndex:2];
    }
    classBasedName = [NSString stringWithFormat:@"%@%@",
                      [[classBasedName substringToIndex:1] lowercaseString],
                      [classBasedName substringFromIndex:1]];

    return [self nameForInstanceWithBasename:classBasedName
                  skipSuffixForFirstInstance:NO];
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
    NSString *basename = debugName;
    basename = [basename stringByReplacingOccurrencesOfString:@" " withString:@""];
    basename = [NSString stringWithFormat:@"%@%@",
              [[basename substringToIndex:1] lowercaseString],
              [basename substringFromIndex:1]];
    return [self nameForInstanceWithBasename:basename
                  skipSuffixForFirstInstance:YES];
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
    else if ([layout isKindOfClass:[WeViewGridLayout class]])
    {
        WeViewGridLayout *gridLayout = (WeViewGridLayout *)layout;
        if (gridLayout.hasCellSizeHint)
        {
            return [NSString stringWithFormat:@"[%@ addSubviewsWithGridLayout:%@ columnCount:%d isGridUniform:%d stretchPolicy:%@]",
                    viewName,
                    layoutSubviewsClause,
                    gridLayout.columnCount,
                    gridLayout.isGridUniform,
                    ReprGridStretchPolicy(gridLayout.stretchPolicy)];
        }
        else
        {
            return [NSString stringWithFormat:@"[%@ addSubviewsWithGridLayout:%@ columnCount:%d isGridUniform:%d stretchPolicy:%@ cellSizeHint:%@]",
                    viewName,
                    layoutSubviewsClause,
                    gridLayout.columnCount,
                    gridLayout.isGridUniform,
                    ReprGridStretchPolicy(gridLayout.stretchPolicy),
                    [NSString stringWithFormat:@"CGSizeMake(%f, %f)", gridLayout.cellSizeHint.width, gridLayout.cellSizeHint.height]];
        }
    }
    else
    {
        NSLog(@"%@", [layout class]);
        WeViewAssert(0);
        return nil;
    }
}

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
        [lines addObject:[NSString stringWithFormat:@"%@:%@", @"setSpacing", FormatInt(layout.hSpacing)]];
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

    if (view.minDesiredWidth != virginView.minDesiredWidth)
    {
        [lines addObject:[NSString stringWithFormat:@"%@:%@", @"setMinDesiredWidth", FormatFloat(view.minDesiredWidth)]];
    }

    if (view.maxDesiredWidth != virginView.maxDesiredWidth)
    {
        [lines addObject:[NSString stringWithFormat:@"%@:%@", @"setMaxDesiredWidth", FormatFloat(view.maxDesiredWidth)]];
    }

    if (view.minDesiredHeight != virginView.minDesiredHeight)
    {
        [lines addObject:[NSString stringWithFormat:@"%@:%@", @"setMinDesiredHeight", FormatFloat(view.minDesiredHeight)]];
    }

    if (view.maxDesiredHeight != virginView.maxDesiredHeight)
    {
        [lines addObject:[NSString stringWithFormat:@"%@:%@", @"setMaxDesiredHeight", FormatFloat(view.maxDesiredHeight)]];
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

    if ([self doDecorations:lines haveLinesWithPrefixes:@[@"setMinDesiredHeight:", @"setMaxDesiredHeight:"]] &&
        view.minDesiredHeight == view.maxDesiredHeight)
    {
        lines = [self removeLines:lines withPrefixes:@[@"setMinDesiredHeight:", @"setMaxDesiredHeight:"]];
        [lines addObject:[NSString stringWithFormat:@"%@:%@", @"setFixedDesiredHeight", FormatFloat(view.minDesiredHeight)]];
    }

    if ([self doDecorations:lines haveLinesWithPrefixes:@[@"setMinDesiredWidth:", @"setMaxDesiredWidth:"]] &&
        view.minDesiredWidth == view.maxDesiredWidth)
    {
        lines = [self removeLines:lines withPrefixes:@[@"setMinDesiredWidth:", @"setMaxDesiredWidth:"]];
        [lines addObject:[NSString stringWithFormat:@"%@:%@", @"setFixedDesiredWidth", FormatFloat(view.minDesiredWidth)]];
    }

/* CODEGEN MARKER: Code Generation View Properties End */

    if ([self doDecorations:lines haveLinesWithPrefixes:@[@"setStretchWeight:"]] &&
        view.vStretchWeight == 1.f &&
        view.hStretchWeight == 1.f)
    {
        lines = [self removeLines:lines withPrefixes:@[@"setStretchWeight:"]];
        [lines addObject:@"setStretches"];
    }

    if ([self doDecorations:lines haveLinesWithPrefixes:@[@"setVStretchWeight:", @"setHStretchWeight:"]] &&
        view.vStretchWeight == 1.f &&
        view.hStretchWeight == 1.f)
    {
        lines = [self removeLines:lines withPrefixes:@[@"setVStretchWeight:", @"setHStretchWeight:"]];
        [lines addObject:@"setStretches"];
    }

    if ([self doDecorations:lines haveLinesWithPrefixes:@[@"setVStretchWeight:"]] &&
        view.vStretchWeight == 1.f)
    {
        lines = [self removeLines:lines withPrefixes:@[@"setVStretchWeight:"]];
        [lines addObject:@"setVStretches"];
    }

    if ([self doDecorations:lines haveLinesWithPrefixes:@[@"setHStretchWeight:"]] &&
        view.hStretchWeight == 1.f)
    {
        lines = [self removeLines:lines withPrefixes:@[@"setHStretchWeight:"]];
        [lines addObject:@"setHStretches"];
    }

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

    return result;
}

- (NSString *)generateCodeForView:(UIView *)view
                         viewName:(NSString *)viewName
{
    NSMutableString *result = [@"" mutableCopy];

    if ([view isKindOfClass:[WeView class]])
    {
        [result appendFormat:@"%@ *%@ = [[%@ alloc] init];\n",
         NSStringFromClass([view class]),
         viewName,
         NSStringFromClass([view class])];

        WeView *weView = (WeView *)view;
        for (WeViewLayout *layout in [weView layouts])
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
    else
    {
        [result appendFormat:@"%@ *%@ = ...;\n",
         NSStringFromClass([view class]),
         viewName];
    }
    return result;
}

@end
