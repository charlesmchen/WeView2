//
//  ViewHierarchyTree.m
//  WeViews2DemoApp
//
//  Copyright (c) 2013 Charles Matthew Chen. All rights reserved.
//
//  Distributed under the Apache License v2.0.
//  http://www.apache.org/licenses/LICENSE-2.0.html
//

#import "ViewHierarchyTree.h"
#import "DemoModel.h"
#import "WeView2DemoConstants.h"
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

#pragma mark -

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

- (void)updateContents
{
    [self removeAllSubviews];

    BOOL selected = self.demoModel.selection == self.item;
    if (selected)
    {
        self.backgroundColor = [UIColor colorWithRed:0.8f
                                               green:0.9f
                                                blue:1.f
                                               alpha:1.f];
    }
    else
    {
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
    expandLabel.hidden = [[self.item subviews] count] == 0;

    // TODO:
    NSString* description = [[self.item class] description];

    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.opaque = NO;
    label.text = description;
    //    label.font = [UIFont systemFontOfSize:14];
    label.font = [UIFont fontWithName:@"AvenirNext-DemiBold"
                                 size:14];
    label.textColor = [UIColor blackColor];
    label.userInteractionEnabled = YES;

    const int INDENT_PIXELS = 5;
    [[[[[[self useHorizontalDefaultLayout]
         addSubviews:@[expandLabel, label,]]
        setHMargin:10 + self.indentLevel * INDENT_PIXELS]
       setVMargin:3]
      setSpacing:5]
     setContentHAlign:H_ALIGN_LEFT];

    [self setNeedsLayout];
}

- (void)handleExpand
{
    [self.parent toggleExpanded:self.item];
}

+ (TreeNode *)create:(id)item
           demoModel:(DemoModel *)demoModel
              parent:(ViewHierarchyTree *)parent
            expanded:(BOOL)expanded
         indentLevel:(int)indentLevel
{
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

#pragma mark -

@implementation ViewHierarchyTree

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)init
{
    self = [super init];
    if (self == nil)
    {
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

- (void)setup
{
    self.stretchWeight = 1.0f;
    self.table = [[UITableView alloc] init];
    self.table.backgroundColor = [UIColor whiteColor];
    self.table.opaque = YES;
    //    self.table.rowHeight = 5;
    self.table.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self.table setStretchesIgnoringDesiredSize];
    [[self addSubviews:@[self.table,]]
     setContentVAlign:V_ALIGN_TOP];

    self.table.delegate = self;
    self.table.dataSource = self;

    [self updateState];
}

+ (ViewHierarchyTree *)create:(DemoModel *)demoModel
{

    ViewHierarchyTree* result = [[ViewHierarchyTree alloc] init];
    result.opaque = YES;
    result.backgroundColor = [UIColor whiteColor];

    result.demoModel = demoModel;

    [result setup];

    return result;
}

- (void)handleItemAdded:(NSNotification *)notification
{
//    NSLog(@"tree handleItemAdded: %@", notification.object);
    [self.expandedViews addObject:notification.object];
}

- (void)handleSelectionChanged
{
//    NSLog(@"tree handleSelectionChanged");
    [self updateState];
}

#pragma mark - UITableViewDataSource

- (void)buildVisibleViews:(UIView *)pseudoView
                   indent:(int)indent
{

    [self.visibleViews addObject:pseudoView];
    [self.indents addObject:[NSNumber numberWithInt:indent]];

    if ([WeView2DemoUtils ignoreChildrenOfView:pseudoView])
    {
        // Ignore children of certain UIView subclasses.
        return;
    }

    NSMutableArray* ignores = [NSMutableArray array];
    if ([self.expandedViews containsObject:pseudoView])
    {
        for (UIView* subview in pseudoView.subviews)
        {
            if ([ignores containsObject:subview])
            {
                continue;
            }
            [self buildVisibleViews:subview
                             indent:indent + 1];
        }
    }
}

- (void)updateState
{
    if (![[NSThread currentThread] isMainThread])
    {
        [self performSelectorOnMainThread:_cmd withObject:nil waitUntilDone:NO];
        return;
    }

    self.visibleViews = [NSMutableArray array];
    self.indents = [NSMutableArray array];

    // Always expand root object.
    [self.expandedViews addObject:self.demoModel.rootView];

    [self buildVisibleViews:self.demoModel.rootView
                     indent:0];

    // Cull views from self.expandedViews which are not currently visible.
    [self.expandedViews intersectSet:[NSSet setWithArray:self.visibleViews]];

    [self.table reloadData];

    [self setNeedsLayout];
}

- (void)toggleExpanded:(id)item
{
    if ([self.expandedViews containsObject:item])
    {
        [self.expandedViews removeObject:item];
    } else
    {
        [self.expandedViews addObject:item];
    }

    [self updateState];
}

- (void)selectItem:(id)item
{
    if (self.demoModel.selection == item)
    {
        return;
    }
    self.demoModel.selection = item;
}

- (NSArray *)items
{
    return self.visibleViews;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self items] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self tableView:tableView cellForRowAtIndexPath:indexPath].frame.size.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath

{
    id item = [[self items] objectAtIndex:indexPath.row];
    [self selectItem:item];
}

@end
