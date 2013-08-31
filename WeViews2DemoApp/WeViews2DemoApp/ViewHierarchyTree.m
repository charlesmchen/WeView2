//
//  ViewHierarchyTree.m
//  WeViews2DemoApp
//
//  Copyright (c) 2013 Charles Matthew Chen. All rights reserved.
//

#import "ViewHierarchyTree.h"
//#import "WeViews.h"
//#import "WeMacros.h"
//#import "WeLabel.h"
#import "DemoModel.h"
//#import "WePanel.h"
#import "WeView2DemoConstants.h"
//#import "ResizeCorner.h"
//#import "MockIPhone.h"
#import "WeView2DemoUtils.h"

@interface ViewHierarchyTree () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) UITableView *table;
@property (nonatomic) DemoModel *demoModel;
@property (nonatomic) NSMutableArray *visibleViews;
@property (nonatomic) NSMutableArray *indents;
@property (nonatomic) NSMutableSet *expandedViews;

- (void)updateState;
- (void)toggleExpanded:(UIView *)pseudoView;
- (void)selectItem:(id)item;

@end

#pragma mark

@interface TreeNode : WeView2

@property (nonatomic) DemoModel *demoModel;
@property (nonatomic) id item;
// Not retained.
@property (nonatomic, weak) ViewHierarchyTree *parent;
@property (nonatomic) BOOL expanded;
@property (nonatomic) int indentLevel;

@end

#pragma mark

@implementation TreeNode

- (void)updateContents {
//    NSLog(@"TreeNode updateContents expanded: %d %@", self.expanded, [self.item class]);
    [self removeAllSubviews];

    BOOL selected = self.demoModel.selection == self.item;
    if (selected)
    {
//        self.backgroundColor = [UIColor colorWithWhite:0.85f alpha:1.f];
        self.backgroundColor = [UIColor colorWithRed:0.8f
                                               green:0.9f
                                                blue:1.f
                                               alpha:1.f];
    } else {
        self.backgroundColor = [UIColor whiteColor];
    }
    self.opaque = YES;

#define WHITE_RIGHT_POINTING_TRIANGLE 0x25B7
#define WHITE_LEFT_POINTING_TRIANGLE 0x25C1
#define WHITE_DOWN_POINTING_TRIANGLE 0x25BD
#define BLACK_RIGHT_POINTING_TRIANGLE 0x25B6
#define BLACK_LEFT_POINTING_TRIANGLE 0x25C0
#define BLACK_DOWN_POINTING_TRIANGLE 0x25BC

    UILabel *expandLabel = [[UILabel alloc] init];
    expandLabel.backgroundColor = [UIColor clearColor];
    expandLabel.opaque = NO;
    expandLabel.text = [NSString stringWithFormat:@"%C",
                         (unichar) (self.expanded ? BLACK_DOWN_POINTING_TRIANGLE : WHITE_RIGHT_POINTING_TRIANGLE)];
    expandLabel.font = [UIFont systemFontOfSize:14];
    expandLabel.textColor = [UIColor blackColor];
    expandLabel.userInteractionEnabled = YES;
    [expandLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleExpand)]];

//    WeView2* expandButton = [[WeView2 alloc] init];
//    expandButton.backgroundColor = [UIColor clearColor];
//    expandButton.opaque = NO;
//    [expandButton addCenter1:expandLabel];
//    [expandButton addClickSelector:@selector(handleExpand)
//                            target:self];

    // TODO:
    NSString* description = [[self.item class] description];
//    NSString* description = [NSString stringWithFormat:@"%@ (%@)",
//                             [[self.item class] description],
//                             [self.item debugName]];

    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.opaque = NO;
    label.text = description;
//    label.font = [UIFont systemFontOfSize:14];
    label.font = [UIFont fontWithName:@"AvenirNext-DemiBold"
                                 size:14];
    label.textColor = [UIColor blackColor];
    label.userInteractionEnabled = YES;
//    [label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSelect)]];

    const int INDENT_PIXELS = 5;
    [[[[[[self setHLinearLayout]
         addSubviews:@[expandLabel, label,]]
        setHMargin:10 + self.indentLevel * INDENT_PIXELS]
        setVMargin:3]
       setSpacing:5]
      setHAlign:H_ALIGN_LEFT];

    [self setNeedsLayout];
}

//- (void)handleSelect {
//    NSLog(@"handleSelect");
//    [self.parent selectItem:self.item];
//}

- (void)handleExpand {
//    NSLog(@"handleExpand");
    [self.parent toggleExpanded:self.item];
}

+ (TreeNode *)create:(id)item
           demoModel:(DemoModel *)demoModel
              parent:(ViewHierarchyTree *)parent
            expanded:(BOOL)expanded
         indentLevel:(int)indentLevel {
    TreeNode* result = [[TreeNode alloc] init];
    result.item = item;
    result.demoModel = demoModel;
    result.parent = parent;
    result.expanded = expanded;
    result.indentLevel = indentLevel;

    [result updateContents];

    return result;
}

@end

#pragma mark

@implementation ViewHierarchyTree

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)init {
    self = [super init];
    if (self == nil) {
        assert(0);
    }

    self.visibleViews = [NSMutableArray array];
    self.expandedViews = [NSMutableSet set];
    self.indents = [NSMutableArray array];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleSelectionChanged)
                                                 name:NOTIFICATION_SELECTION_CHANGED
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleItemAdded:)
                                                 name:NOTIFICATION_ITEM_ADDED
                                               object:nil];

    return self;
}

- (void)setup {
    self.stretchWeight = 1.0f;
    self.table = [[UITableView alloc] init];
    self.table.backgroundColor = [UIColor whiteColor];
    self.table.opaque = YES;
//    self.table.rowHeight = 5;
    self.table.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self.table withPureStretch];
    [[self addSubviews:@[self.table,]]
     setVAlign:V_ALIGN_TOP];

    self.table.delegate = self;
    self.table.dataSource = self;

    [self updateState];
}

+ (ViewHierarchyTree *)create:(DemoModel *)demoModel {

    ViewHierarchyTree* result = [[ViewHierarchyTree alloc] init];
    result.opaque = YES;
    result.backgroundColor = [UIColor whiteColor];

    result.demoModel = demoModel;

    [result setup];

    return result;
}

- (void)handleItemAdded:(NSNotification *)notification {
    NSLog(@"tree handleItemAdded: %@", notification.object);
    [self.expandedViews addObject:notification.object];
}

- (void)handleSelectionChanged {
    NSLog(@"tree handleSelectionChanged");
    [self updateState];
}

#pragma mark -
#pragma mark UITableViewDataSource

- (void)buildVisibleViews:(UIView *)pseudoView
                   indent:(int)indent {

//    if ([pseudoView isKindOfClass:[ResizeCorner class]]) {
//        return;
//    }
    [self.visibleViews addObject:pseudoView];
    [self.indents addObject:[NSNumber numberWithInt:indent]];

//    if ([pseudoView isKindOfClass:[UIToolbar class]]) {
//        UIToolbar* toolbar = (UIToolbar*) pseudoView;
//        if ([self.expandedViews containsObject:pseudoView]) {
//            for (UIBarButtonItem* toolbarItem in toolbar.items) {
//                [self.visibleViews addObject:toolbarItem];
//                [self.indents addObject:[NSNumber numberWithInt:indent+1]];
//            }
//        }
//
//        return;
//    }

    if ([WeView2DemoUtils ignoreChildrenOfView:pseudoView]) {
        // Ignore children of certain UIView subclasses.
        return;
    }

//    NSLog(@"buildVisibleViews: %@ %@ %d", [pseudoView class], [pseudoView debugName], [pseudoView.subviews count]);

    NSMutableArray* ignores = [NSMutableArray array];
    if ([self.expandedViews containsObject:pseudoView]) {

//        if ([pseudoView respondsToSelector:@selector(mockSubviews)]) {
//            NSArray* mockSubviews = [pseudoView performSelector:@selector(mockSubviews)];
//            for (UIView* subview in mockSubviews) {
//                [self buildVisibleViews:subview
//                                 indent:indent + 1];
//            }
//            return;
//        }

//        if ([pseudoView isKindOfClass:[WePanel class]]) {
//            WePanel* fpanel = (WePanel*) pseudoView;
//            for (WePanelLayer* layer in fpanel.layers) {
//                [self.visibleViews addObject:layer];
//                [self.indents addObject:[NSNumber numberWithInt:indent+1]];
//
//                BOOL layerExpanded = [self.expandedViews containsObject:layer];
//                for (UIView* subview in layer.views) {
//                    [ignores addObject:subview];
//                    if (layerExpanded) {
//                        [self buildVisibleViews:subview
//                                         indent:indent + 2];
//                        //                    [self.visibleViews addObject:subview];
//                        //                    [self.indents addObject:[NSNumber numberWithInt:indent+2]];
//                    }
//                }
//            }
//        }

        for (UIView* subview in pseudoView.subviews) {
            if ([ignores containsObject:subview]) {
                continue;
            }
            [self buildVisibleViews:subview
                             indent:indent + 1];
        }
    }
}

- (void)updateState {
    if (![[NSThread currentThread] isMainThread]) {
        [self performSelectorOnMainThread:_cmd withObject:nil waitUntilDone:NO];
        return;
    }

//    NSLog(@"updateState");

    self.visibleViews = [NSMutableArray array];
    self.indents = [NSMutableArray array];

    // Always expand root object.
    [self.expandedViews addObject:self.demoModel.rootView];

    [self buildVisibleViews:self.demoModel.rootView
                 indent:0];

//    for (id item in self.expandedViews) {
//        NSLog(@"self.expandedViews raw: %@", [item class]);
//    }
//    NSLog(@"self.expandedViews raw: %d", [self.expandedViews count]);
//    for (int i=0; i < [self.visibleViews count]; i++) {
//        id item = [self.visibleViews objectAtIndex:i];
//        id indent = [self.indents objectAtIndex:i];
//        NSLog(@"self.visibleViews raw: %@ (%@)", [item class], indent);
//    }
//    NSLog(@"self.visibleViews raw: %d", [self.visibleViews count]);

    // Cull views from self.expandedViews which are not currently visible.
    [self.expandedViews intersectSet:[NSSet setWithArray:self.visibleViews]];

//    for (id item in self.expandedViews) {
//        NSLog(@"self.expandedViews after: %@", [item class]);
//    }
//    NSLog(@"self.expandedViews after: %d", [self.expandedViews count]);

    [self.table reloadData];

    [self setNeedsLayout];
}

- (void)toggleExpanded:(id)item {
    if ([self.expandedViews containsObject:item]) {
        [self.expandedViews removeObject:item];
    } else {
        [self.expandedViews addObject:item];
    }

    [self updateState];
}

- (void)selectItem:(id)item {
//    NSLog(@"selectItem: %@", [item class]);
    if (self.demoModel.selection == item) {
        return;
    }
    self.demoModel.selection = item;
}

- (NSArray *)items {
    return self.visibleViews;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    NSLog(@"numberOfRowsInSection: %d", [[self items] count]);
    return [[self items] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: Reuse cells.
    UITableViewCell* result = [[UITableViewCell alloc] init];
    result.backgroundColor = [UIColor whiteColor];
    result.opaque = YES;

    id item = [[self items] objectAtIndex:indexPath.row];
    NSNumber* indent = [self.indents objectAtIndex:indexPath.row];

    UIView* itemView;

    BOOL expanded = [self.expandedViews containsObject:item];
    itemView = [TreeNode create:item
                      demoModel:self.demoModel
                         parent:self
                       expanded:expanded
                    indentLevel:[indent intValue]];

    CGRect resultFrame = CGRectZero;
    resultFrame.size.width = tableView.frame.size.width;
    resultFrame.size.height = [itemView sizeThatFits:CGSizeZero].height;
    result.frame = resultFrame;
    itemView.frame = resultFrame;
    [result addSubview:itemView];

    return result;
}

#pragma mark -
#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self tableView:tableView cellForRowAtIndexPath:indexPath].frame.size.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    id item = [[self items] objectAtIndex:indexPath.row];
//    NSLog(@"didSelectRowAtIndexPath: %@", [item class]);
    [self selectItem:item];
}

@end
