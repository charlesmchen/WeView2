//
//  ViewHierarchyTree.m
//  WeViews2DemoApp
//
//  Copyright (c) 2013 Charles Matthew Chen. All rights reserved.
//

//#import "ViewHierarchyTree.h"
//#import "WeViews.h"
//#import "WeMacros.h"
//#import "WeLabel.h"
//#import "WindowModel.h"
//#import "WePanel.h"
//#import "WeViewsDemoConstants.h"
//#import "ResizeCorner.h"
//#import "MockIPhone.h"
//#import "WeViewsDemoUtils.h"
//
//@interface ViewHierarchyTree ()
//
//- (void)updateState;
//- (void)toggleExpanded:(UIView *)pseudoView;
//- (void)selectItem:(id)item;
//
//@end
//
//#pragma mark
//
//@interface TreeNode : WePanel
//
//@property (nonatomic, retain) WindowModel *windowModel;
//@property (nonatomic, retain) id item;
// Not retained.
//@property (assign, nonatomic) ViewHierarchyTree *parent;
//@property (assign, nonatomic) BOOL expanded;
//@property (assign, nonatomic) int indentLevel;
//
//@end
//
//#pragma mark
//
//@implementation TreeNode
//
//@synthesize windowModel;
//@synthesize item;
//@synthesize parent;
//@synthesize expanded;
//@synthesize indentLevel;
//
//- (void)dealloc {
//    self.windowModel = nil;
//    self.item = nil;
//    self.parent = nil;
//
//    [super dealloc];
//}
//
//- (void)updateContents {
//    NSLog(@"TreeNode updateContents expanded: %d", expanded);
//    [self clearWithoutPurge];
//
//    BOOL selected = windowModel.selection == item;
//    if (selected) {
//        [self withOpaqueBackground:[UIColor blueColor]];
//    } else {
//        [self withOpaqueBackground:[UIColor blackColor]];
//    }
//
//#define WHITE_RIGHT_POINTING_TRIANGLE 0x25B7
//#define WHITE_LEFT_POINTING_TRIANGLE 0x25C1
//#define WHITE_DOWN_POINTING_TRIANGLE 0x25BD
//#define BLACK_RIGHT_POINTING_TRIANGLE 0x25B6
//#define BLACK_LEFT_POINTING_TRIANGLE 0x25C0
//#define BLACK_DOWN_POINTING_TRIANGLE 0x25BC
//    UILabel* expandLabel = [WeViews createUILabel:[NSString stringWithFormat:@"%C", expanded ? BLACK_DOWN_POINTING_TRIANGLE : WHITE_RIGHT_POINTING_TRIANGLE]
//                                        font:[UIFont systemFontOfSize:14]
//                                       color:[UIColor whiteColor]];
//    WePanel* expandButton = [WePanel create];
//    expandButton.backgroundColor = [UIColor clearColor];
//    expandButton.opaque = NO;
//    [expandButton addCenter1:expandLabel];
//    [expandButton addClickSelector:@selector(handleExpand)
//                            target:self];
//
//    NSString* description = [[item class] description];
//    if ([item isKindOfClass:[WePanelLayer class]]) {
//        description = @"WePanelLayer";
//    } else if ([item isKindOfClass:[MockIPhoneScreen class]]) {
//        description = @"MockIPhoneScreen (WePanel)";
//    }
//
//    UILabel* label = [WeViews createUILabel:description
//                                        font:[UIFont systemFontOfSize:14]
//                                       color:[UIColor whiteColor]];
//    label.userInteractionEnabled = NO;
//
//#define INDENT_PIXELS 10
//    [[[[self addHorizontal:[NSArray arrayWithObjects:
//                        expandButton,
//                        label,
//                        nil]]
//       withHMargin:10 + indentLevel * INDENT_PIXELS
//       vMargin:3]
//      withSpacing:5]
//     withHAlign:H_ALIGN_LEFT];
//
//    [self addClickSelector:@selector(handleSelect)
//                            target:self];
//
//    [self layoutContents];
//}
//
//- (void)handleSelect {
//    [parent selectItem:self.item];
//}
//
//- (void)handleExpand {
//    [parent toggleExpanded:self.item];
//}
//
//+ (TreeNode *)create:(id)item
//         windowModel:(WindowModel *)windowModel
//              parent:(ViewHierarchyTree *)parent
//            expanded:(BOOL)expanded
//         indentLevel:(int)indentLevel {
//    TreeNode* result = [[[TreeNode alloc] init] autorelease];
//    result.item = item;
//    result.windowModel = windowModel;
//    result.parent = parent;
//    result.expanded = expanded;
//    result.indentLevel = indentLevel;
//
//    [result updateContents];
//
//    return result;
//}
//
//@end
//
//#pragma mark
//
//@implementation ViewHierarchyTree
//
//@synthesize table;
//@synthesize windowModel;
//@synthesize pseudoView;
//@synthesize visibleViews;
//@synthesize expandedViews;
//@synthesize indents;
//
//- (void)dealloc {
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//
//    self.table = nil;
//    self.windowModel = nil;
//    self.pseudoView = nil;
//    self.visibleViews = nil;
//    self.expandedViews = nil;
//    self.indents = nil;
//
//    [super dealloc];
//}
//
//- (id)init {
//    self = [super init];
//    if (self == nil) {
//        _wv__FAIL(@"could not allocate...");
//    }
//
//    self.visibleViews = [NSMutableArray array];
//    self.expandedViews = [NSMutableSet set];
//    self.indents = [NSMutableArray array];
//
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(handleSelectionChanged)
//                                                 name:NOTIFICATION_SELECTION_CHANGED
//                                               object:nil];
//
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(handleItemAdded:)
//                                                 name:NOTIFICATION_ITEM_ADDED
//                                               object:nil];
//
//    return self;
//}
//
//- (void)setup {
//    self.stretchWeight = 1.0f;
//    self.table = [[[UITableView alloc] init] autorelease];
//    table.backgroundColor = [UIColor blackColor];
//    table.opaque = YES;
//    [[self addVerticalFill1:table]
//     withVAlign:V_ALIGN_TOP];
//
//    table.delegate = self;
//    table.dataSource = self;
//
//    [self updateState];
//}
//
//+ (ViewHierarchyTree *)create:(UIView *)pseudoView
//                  windowModel:(WindowModel *)windowModel {
//    ViewHierarchyTree* result = [[[ViewHierarchyTree alloc] init] autorelease];
//    [result withOpaqueBackground:[UIColor blackColor]];
//    result.windowModel = windowModel;
//
//    [result setup];
//
//    return result;
//}
//
//- (void)handleItemAdded:(NSNotification *)notification {
//    NSLog(@"tree handleItemAdded: %@", notification.object);
//    [expandedViews addObject:notification.object];
//
//    if ([notification.object isKindOfClass:[MockIPhone class]]) {
//        MockIPhone* mockIPhone = (MockIPhone*) notification.object;
//        [expandedViews addObject:mockIPhone.screen];
//    }
//}
//
//- (void)handleSelectionChanged {
//    NSLog(@"tree handleSelectionChanged");
//    [self updateState];
//}
//
//#pragma mark -
//#pragma mark UITableViewDataSource
//
//- (void)buildVisibleViews:(UIView *)pseudoView
//                   indent:(int)indent {
//
//    if ([pseudoView isKindOfClass:[ResizeCorner class]]) {
//        return;
//    }
//    [visibleViews addObject:pseudoView];
//    [indents addObject:[NSNumber numberWithInt:indent]];
//
//    if ([pseudoView isKindOfClass:[UIToolbar class]]) {
//        UIToolbar* toolbar = (UIToolbar*) pseudoView;
//        if ([expandedViews containsObject:pseudoView]) {
//            for (UIBarButtonItem* toolbarItem in toolbar.items) {
//                [visibleViews addObject:toolbarItem];
//                [indents addObject:[NSNumber numberWithInt:indent+1]];
//            }
//        }
//
//        return;
//    }
//
//    if ([WeViewsDemoUtils ignoreChildrenOfView:pseudoView]) {
//        // Ignore children of certain UIView subclasses.
//        return;
//    }
//
//    NSLog(@"buildVisibleViews: %@", [pseudoView class]);
//
//    NSMutableArray* ignores = [NSMutableArray array];
//    if ([expandedViews containsObject:pseudoView]) {
//
//        if ([pseudoView respondsToSelector:@selector(mockSubviews)]) {
//            NSArray* mockSubviews = [pseudoView performSelector:@selector(mockSubviews)];
//            for (UIView* subview in mockSubviews) {
//                [self buildVisibleViews:subview
//                                 indent:indent + 1];
//            }
//            return;
//        }
//
//        if ([pseudoView isKindOfClass:[WePanel class]]) {
//            WePanel* fpanel = (WePanel*) pseudoView;
//            for (WePanelLayer* layer in fpanel.layers) {
//                [visibleViews addObject:layer];
//                [indents addObject:[NSNumber numberWithInt:indent+1]];
//
//                BOOL layerExpanded = [expandedViews containsObject:layer];
//                for (UIView* subview in layer.views) {
//                    [ignores addObject:subview];
//                    if (layerExpanded) {
//                        [self buildVisibleViews:subview
//                                         indent:indent + 2];
//                        //                    [visibleViews addObject:subview];
//                        //                    [indents addObject:[NSNumber numberWithInt:indent+2]];
//                    }
//                }
//            }
//        }
//
//        for (UIView* subview in pseudoView.subviews) {
//            if ([ignores containsObject:subview]) {
//                continue;
//            }
//            [self buildVisibleViews:subview
//                             indent:indent + 1];
//        }
//    }
//}
//
//- (void)updateState {
//    if (![[NSThread currentThread] isMainThread]) {
//        [self performSelectorOnMainThread:_cmd withObject:nil waitUntilDone:NO];
//        return;
//    }
//
//    NSLog(@"updateState");
//
//    self.visibleViews = [NSMutableArray array];
//    self.indents = [NSMutableArray array];
//
//    // Always expand root object.
//    [expandedViews addObject:windowModel.pseudoRoot];
//
//    [self buildVisibleViews:windowModel.pseudoRoot
//                 indent:0];
//
//    for (id item in expandedViews) {
//        NSLog(@"expandedViews raw: %@", [item class]);
//    }
//    NSLog(@"expandedViews raw: %d", [expandedViews count]);
//    for (int i=0; i < [visibleViews count]; i++) {
//        id item = [visibleViews objectAtIndex:i];
//        id indent = [indents objectAtIndex:i];
//        NSLog(@"visibleViews raw: %@ (%@)", [item class], indent);
//    }
//    NSLog(@"visibleViews raw: %d", [visibleViews count]);
//
//    // Cull views from expandedViews which are not currently visible.
//    [expandedViews intersectSet:[NSSet setWithArray:visibleViews]];
//
//    for (id item in expandedViews) {
//        NSLog(@"expandedViews after: %@", [item class]);
//    }
//    NSLog(@"expandedViews after: %d", [expandedViews count]);
//
//    [table reloadData];
//
//    [self layoutContents];
//}
//
//- (void)toggleExpanded:(id)item {
//    if ([expandedViews containsObject:item]) {
//        [expandedViews removeObject:item];
//    } else {
//        [expandedViews addObject:item];
//    }
//
//    [self updateState];
//}
//
//- (void)selectItem:(id)item {
//    NSLog(@"selectItem: %@", [item class]);
//    if (windowModel.selection == item) {
//        return;
//    }
//    windowModel.selection = item;
//}
//
//- (NSArray *)items {
//    return visibleViews;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return [[self items] count];
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell* result = [[[UITableViewCell alloc] init] autorelease];
//    result.backgroundColor = [UIColor blackColor];
//    result.opaque = YES;
//
//    id item = [[self items] objectAtIndex:indexPath.row];
//    NSNumber* indent = [indents objectAtIndex:indexPath.row];
//
//    UIView* itemView;
//
//    BOOL expanded = [expandedViews containsObject:item];
//    itemView = [TreeNode create:item
//                    windowModel:windowModel
//                         parent:self
//                       expanded:expanded
//                    indentLevel:[indent intValue]];
//
//    CGRect resultFrame = CGRectZero;
//    resultFrame.size.width = tableView.frame.size.width;
//    resultFrame.size.height = [itemView sizeThatFits:CGSizeZero].height;
//    result.frame = resultFrame;
//    itemView.frame = resultFrame;
//    [result addSubview:itemView];
//
//    return result;
//}
//
//#pragma mark -
//#pragma mark UITableViewDelegate
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return [self tableView:tableView cellForRowAtIndexPath:indexPath].frame.size.height;
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    id item = [[self items] objectAtIndex:indexPath.row];
//    NSLog(@"didSelectRowAtIndexPath: %@", [item class]);
//    [self selectItem:item];
//}
//
//@end
