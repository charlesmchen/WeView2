//
//  ViewEditorController.m
//  WeViews2DemoApp
//
//  Copyright (c) 2013 Charles Matthew Chen. All rights reserved.
//
 //
//  ViewEditorController.m
//  WeViews2DemoApp
//
//  Copyright (c) 2013 Charles Matthew Chen. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "UIView+WeView2.h"
#import "ViewEditorController.h"
//#import "ViewHierarchyTree.h"
#import "WeView2DemoConstants.h"
#import "WeView2Macros.h"

NSString *FormatFloat(CGFloat value)
{
    if (value == CGFLOAT_MAX)
    {
        return @"Max";
    }
    else if (value == CGFLOAT_MIN)
    {
        return @"Min";
    }
    else
    {
        return [@(value) description];
    }
}

NSString *FormatBoolean(BOOL value)
{
    return value ? @"YES" : @"NO";
}

@protocol ViewParameterDelegate <NSObject>

- (void)viewChanged;

@end

#pragma mark -

@interface ViewParameter : NSObject

@property (nonatomic, weak) id<ViewParameterDelegate> delegate;

@end

#pragma mark -

@implementation ViewParameter

- (void)configureCell:(UITableViewCell *)cell
             withView:(UIView *)view
{
    WeView2Assert(0);
}

@end

#pragma mark -

typedef NSString *(^GetterBlock)(UIView *view);
typedef void (^SetterBlock)(UIView *view);

@interface ViewParameterSetter : NSObject

@property (nonatomic) NSString *name;
@property (copy, nonatomic) SetterBlock setterBlock;
@property (nonatomic) UIView *view;
@property (nonatomic, weak) id<ViewParameterDelegate> delegate;

@end

#pragma mark -

@implementation ViewParameterSetter

+ (ViewParameterSetter *)create:(NSString *)name
                    setterBlock:(SetterBlock)setterBlock
{
    ViewParameterSetter *result = [[ViewParameterSetter alloc] init];
    result.name = name;
    result.setterBlock = setterBlock;
    return result;
}

- (void)perform:(id)sender
{
    self.setterBlock(self.view);
    [self.delegate viewChanged];
}

@end

#pragma mark -

@interface ViewParameterSimple : ViewParameter

@property (nonatomic) NSString *name;
@property (copy, nonatomic) GetterBlock getterBlock;
@property (copy, nonatomic) NSArray *setters;

@end

#pragma mark -

@implementation ViewParameterSimple

+ (ViewParameterSimple *)create:(NSString *)name
                    getterBlock:(GetterBlock)getterBlock
                        setters:(NSArray *)setters
{
    ViewParameterSimple *result = [[ViewParameterSimple alloc] init];
    result.name = name;
    result.getterBlock = getterBlock;
    result.setters = setters;
    return result;
}

- (void)configureCell:(UITableViewCell *)cell
             withView:(UIView *)view
{
    WeView2 *container = [[WeView2 alloc] init];
    container.backgroundColor = [UIColor clearColor];
    container.opaque = NO;
    [cell addSubview:container];
    container.frame = cell.bounds;

    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.opaque = NO;
    nameLabel.textColor = [UIColor blackColor];
//    nameLabel.font = [UIFont boldSystemFontOfSize:14.f];
    nameLabel.font = [UIFont fontWithName:@"AvenirNext-DemiBold"
                                     size:14];
    nameLabel.text = [NSString stringWithFormat:@"%@:", self.name];

    UILabel *valueLabel = [[UILabel alloc] init];
    valueLabel.backgroundColor = [UIColor clearColor];
    valueLabel.opaque = NO;
    valueLabel.textColor = [UIColor blackColor];
//    valueLabel.font = [UIFont systemFontOfSize:14.f];
    valueLabel.font = [UIFont fontWithName:@"AvenirNext-DemiBold"
                                      size:14];
    valueLabel.text = self.getterBlock(view);

    NSMutableArray *subviews = [@[
                                nameLabel,
                                valueLabel,
                                [[[UIView alloc] init] withPureStretch],
                                ] mutableCopy];

    for (ViewParameterSetter *setter in self.setters)
    {
        setter.view = view;
        setter.delegate = self.delegate;

        UIButton *setterButton = [UIButton buttonWithType:UIButtonTypeCustom];
        setterButton.opaque = NO;
        setterButton.backgroundColor = [UIColor colorWithWhite:0.5f alpha:1.f];
        setterButton.layer.cornerRadius = 5.f;
        setterButton.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        [setterButton setTitle:setter.name forState:UIControlStateNormal];
        [setterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        setterButton.titleLabel.font = [UIFont systemFontOfSize:14.f];
        setterButton.titleLabel.font = [UIFont fontWithName:@"AvenirNext-DemiBold"
                                                       size:14];
        [setterButton addTarget:setter
                         action:@selector(perform:)
               forControlEvents:UIControlEventTouchUpInside];
        [subviews addObject:setterButton];
    }

    [[[[[container addSubviews:subviews]
        setHAlign:H_ALIGN_LEFT]
       setHMargin:10]
      setVMargin:2]
     setSpacing:5];

    cell.height = container.height = [container sizeThatFits:CGSizeMake(cell.width, CGFLOAT_MAX)].height;
//    [container
    //    WeView2 *container = [[WeView2 alloc] init];

}

@end

#pragma mark -

@interface ViewEditorController () <ViewParameterDelegate>

//@property (nonatomic) WeView2 *rootView;
//
//@property (nonatomic) ViewHierarchyTree *viewHierarchyTree;

@property (nonatomic) NSArray *viewParams;

@property (nonatomic) UIView *currentView;

@end

#pragma mark -

@implementation ViewEditorController

- (id)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self)
    {
        self.title = NSLocalizedString(@"View Config", nil);
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
        {
            self.clearsSelectionOnViewWillAppear = NO;
        }
        self.viewParams = @[

                            [ViewParameterSimple create:@"frame"
                                            getterBlock:^NSString *(UIView *view) {
                                                return FormatCGRect(view.frame);
                                            }
                                                setters:@[
                             ]],

                            [ViewParameterSimple create:@"hAlign"
                                            getterBlock:^NSString *(UIView *view) {
                                                return FormatHAlign(view.hAlign);
                                            }
                                                setters:@[
                             [ViewParameterSetter create:@"Left"
                                             setterBlock:^(UIView *view) {
                                                 view.hAlign = H_ALIGN_LEFT;
                                             }
                              ],
                             [ViewParameterSetter create:@"Center"
                                             setterBlock:^(UIView *view) {
                                                 view.hAlign = H_ALIGN_CENTER;
                                             }
                              ],
                             [ViewParameterSetter create:@"Right"
                                             setterBlock:^(UIView *view) {
                                                 view.hAlign = H_ALIGN_RIGHT;
                                             }
                              ],
                             ]],

                            [ViewParameterSimple create:@"vAlign"
                                            getterBlock:^NSString *(UIView *view) {
                                                return FormatVAlign(view.vAlign);
                                            }
                                                setters:@[
                             [ViewParameterSetter create:@"Top"
                                             setterBlock:^(UIView *view) {
                                                 view.vAlign = V_ALIGN_TOP;
                                             }
                              ],
                             [ViewParameterSetter create:@"Center"
                                             setterBlock:^(UIView *view) {
                                                 view.vAlign = V_ALIGN_CENTER;
                                             }
                              ],
                             [ViewParameterSetter create:@"Bottom"
                                             setterBlock:^(UIView *view) {
                                                 view.vAlign = V_ALIGN_BOTTOM;
                                             }
                              ],
                             ]],

/* CODEGEN MARKER: Parameters Start */

// --- minWidth ---
                            [ViewParameterSimple create:@"minWidth"
                                            getterBlock:^NSString *(UIView *view) {
                                                return FormatFloat(view.minWidth);
                                            }
                                                setters:@[
                             [ViewParameterSetter create:@"-5"
                                             setterBlock:^(UIView *view) {
                                                 view.minWidth = view.minWidth - 5;
                                             }],
                             [ViewParameterSetter create:@"-1"
                                             setterBlock:^(UIView *view) {
                                                 view.minWidth = view.minWidth - 1;
                                             }],
                             [ViewParameterSetter create:@"0"
                                             setterBlock:^(UIView *view) {
                                                 view.minWidth = 0;
                                             }],
                             [ViewParameterSetter create:@"+1"
                                             setterBlock:^(UIView *view) {
                                                 view.minWidth = view.minWidth + 1;
                                             }],
                             [ViewParameterSetter create:@"+5"
                                             setterBlock:^(UIView *view) {
                                                 view.minWidth = view.minWidth + 5;
                                             }],
                             ]],

// --- maxWidth ---
                            [ViewParameterSimple create:@"maxWidth"
                                            getterBlock:^NSString *(UIView *view) {
                                                return FormatFloat(view.maxWidth);
                                            }
                                                setters:@[
                             [ViewParameterSetter create:@"-5"
                                             setterBlock:^(UIView *view) {
                                                 view.maxWidth = view.maxWidth - 5;
                                             }],
                             [ViewParameterSetter create:@"-1"
                                             setterBlock:^(UIView *view) {
                                                 view.maxWidth = view.maxWidth - 1;
                                             }],
                             [ViewParameterSetter create:@"0"
                                             setterBlock:^(UIView *view) {
                                                 view.maxWidth = 0;
                                             }],
                             [ViewParameterSetter create:@"+1"
                                             setterBlock:^(UIView *view) {
                                                 view.maxWidth = view.maxWidth + 1;
                                             }],
                             [ViewParameterSetter create:@"+5"
                                             setterBlock:^(UIView *view) {
                                                 view.maxWidth = view.maxWidth + 5;
                                             }],
                             ]],

// --- minHeight ---
                            [ViewParameterSimple create:@"minHeight"
                                            getterBlock:^NSString *(UIView *view) {
                                                return FormatFloat(view.minHeight);
                                            }
                                                setters:@[
                             [ViewParameterSetter create:@"-5"
                                             setterBlock:^(UIView *view) {
                                                 view.minHeight = view.minHeight - 5;
                                             }],
                             [ViewParameterSetter create:@"-1"
                                             setterBlock:^(UIView *view) {
                                                 view.minHeight = view.minHeight - 1;
                                             }],
                             [ViewParameterSetter create:@"0"
                                             setterBlock:^(UIView *view) {
                                                 view.minHeight = 0;
                                             }],
                             [ViewParameterSetter create:@"+1"
                                             setterBlock:^(UIView *view) {
                                                 view.minHeight = view.minHeight + 1;
                                             }],
                             [ViewParameterSetter create:@"+5"
                                             setterBlock:^(UIView *view) {
                                                 view.minHeight = view.minHeight + 5;
                                             }],
                             ]],

// --- maxHeight ---
                            [ViewParameterSimple create:@"maxHeight"
                                            getterBlock:^NSString *(UIView *view) {
                                                return FormatFloat(view.maxHeight);
                                            }
                                                setters:@[
                             [ViewParameterSetter create:@"-5"
                                             setterBlock:^(UIView *view) {
                                                 view.maxHeight = view.maxHeight - 5;
                                             }],
                             [ViewParameterSetter create:@"-1"
                                             setterBlock:^(UIView *view) {
                                                 view.maxHeight = view.maxHeight - 1;
                                             }],
                             [ViewParameterSetter create:@"0"
                                             setterBlock:^(UIView *view) {
                                                 view.maxHeight = 0;
                                             }],
                             [ViewParameterSetter create:@"+1"
                                             setterBlock:^(UIView *view) {
                                                 view.maxHeight = view.maxHeight + 1;
                                             }],
                             [ViewParameterSetter create:@"+5"
                                             setterBlock:^(UIView *view) {
                                                 view.maxHeight = view.maxHeight + 5;
                                             }],
                             ]],

// --- hStretchWeight ---
                            [ViewParameterSimple create:@"hStretchWeight"
                                            getterBlock:^NSString *(UIView *view) {
                                                return FormatFloat(view.hStretchWeight);
                                            }
                                                setters:@[
                             [ViewParameterSetter create:@"-5"
                                             setterBlock:^(UIView *view) {
                                                 view.hStretchWeight = view.hStretchWeight - 5;
                                             }],
                             [ViewParameterSetter create:@"-1"
                                             setterBlock:^(UIView *view) {
                                                 view.hStretchWeight = view.hStretchWeight - 1;
                                             }],
                             [ViewParameterSetter create:@"0"
                                             setterBlock:^(UIView *view) {
                                                 view.hStretchWeight = 0;
                                             }],
                             [ViewParameterSetter create:@"+1"
                                             setterBlock:^(UIView *view) {
                                                 view.hStretchWeight = view.hStretchWeight + 1;
                                             }],
                             [ViewParameterSetter create:@"+5"
                                             setterBlock:^(UIView *view) {
                                                 view.hStretchWeight = view.hStretchWeight + 5;
                                             }],
                             ]],

// --- vStretchWeight ---
                            [ViewParameterSimple create:@"vStretchWeight"
                                            getterBlock:^NSString *(UIView *view) {
                                                return FormatFloat(view.vStretchWeight);
                                            }
                                                setters:@[
                             [ViewParameterSetter create:@"-5"
                                             setterBlock:^(UIView *view) {
                                                 view.vStretchWeight = view.vStretchWeight - 5;
                                             }],
                             [ViewParameterSetter create:@"-1"
                                             setterBlock:^(UIView *view) {
                                                 view.vStretchWeight = view.vStretchWeight - 1;
                                             }],
                             [ViewParameterSetter create:@"0"
                                             setterBlock:^(UIView *view) {
                                                 view.vStretchWeight = 0;
                                             }],
                             [ViewParameterSetter create:@"+1"
                                             setterBlock:^(UIView *view) {
                                                 view.vStretchWeight = view.vStretchWeight + 1;
                                             }],
                             [ViewParameterSetter create:@"+5"
                                             setterBlock:^(UIView *view) {
                                                 view.vStretchWeight = view.vStretchWeight + 5;
                                             }],
                             ]],

// --- ignoreNaturalSize ---
                            [ViewParameterSimple create:@"ignoreNaturalSize"
                                            getterBlock:^NSString *(UIView *view) {
                                                return FormatBoolean(view.ignoreNaturalSize);
                                            }
                                                setters:@[
                             [ViewParameterSetter create:@"YES"
                                             setterBlock:^(UIView *view) {
                                                 view.ignoreNaturalSize = YES;
                                             }
                              ],
                             [ViewParameterSetter create:@"NO"
                                             setterBlock:^(UIView *view) {
                                                 view.ignoreNaturalSize = NO;
                                             }
                              ],
                             ]],

// --- leftMargin ---
                            [ViewParameterSimple create:@"leftMargin"
                                            getterBlock:^NSString *(UIView *view) {
                                                return FormatFloat(view.leftMargin);
                                            }
                                                setters:@[
                             [ViewParameterSetter create:@"-5"
                                             setterBlock:^(UIView *view) {
                                                 view.leftMargin = view.leftMargin - 5;
                                             }],
                             [ViewParameterSetter create:@"-1"
                                             setterBlock:^(UIView *view) {
                                                 view.leftMargin = view.leftMargin - 1;
                                             }],
                             [ViewParameterSetter create:@"0"
                                             setterBlock:^(UIView *view) {
                                                 view.leftMargin = 0;
                                             }],
                             [ViewParameterSetter create:@"+1"
                                             setterBlock:^(UIView *view) {
                                                 view.leftMargin = view.leftMargin + 1;
                                             }],
                             [ViewParameterSetter create:@"+5"
                                             setterBlock:^(UIView *view) {
                                                 view.leftMargin = view.leftMargin + 5;
                                             }],
                             ]],

// --- rightMargin ---
                            [ViewParameterSimple create:@"rightMargin"
                                            getterBlock:^NSString *(UIView *view) {
                                                return FormatFloat(view.rightMargin);
                                            }
                                                setters:@[
                             [ViewParameterSetter create:@"-5"
                                             setterBlock:^(UIView *view) {
                                                 view.rightMargin = view.rightMargin - 5;
                                             }],
                             [ViewParameterSetter create:@"-1"
                                             setterBlock:^(UIView *view) {
                                                 view.rightMargin = view.rightMargin - 1;
                                             }],
                             [ViewParameterSetter create:@"0"
                                             setterBlock:^(UIView *view) {
                                                 view.rightMargin = 0;
                                             }],
                             [ViewParameterSetter create:@"+1"
                                             setterBlock:^(UIView *view) {
                                                 view.rightMargin = view.rightMargin + 1;
                                             }],
                             [ViewParameterSetter create:@"+5"
                                             setterBlock:^(UIView *view) {
                                                 view.rightMargin = view.rightMargin + 5;
                                             }],
                             ]],

// --- topMargin ---
                            [ViewParameterSimple create:@"topMargin"
                                            getterBlock:^NSString *(UIView *view) {
                                                return FormatFloat(view.topMargin);
                                            }
                                                setters:@[
                             [ViewParameterSetter create:@"-5"
                                             setterBlock:^(UIView *view) {
                                                 view.topMargin = view.topMargin - 5;
                                             }],
                             [ViewParameterSetter create:@"-1"
                                             setterBlock:^(UIView *view) {
                                                 view.topMargin = view.topMargin - 1;
                                             }],
                             [ViewParameterSetter create:@"0"
                                             setterBlock:^(UIView *view) {
                                                 view.topMargin = 0;
                                             }],
                             [ViewParameterSetter create:@"+1"
                                             setterBlock:^(UIView *view) {
                                                 view.topMargin = view.topMargin + 1;
                                             }],
                             [ViewParameterSetter create:@"+5"
                                             setterBlock:^(UIView *view) {
                                                 view.topMargin = view.topMargin + 5;
                                             }],
                             ]],

// --- bottomMargin ---
                            [ViewParameterSimple create:@"bottomMargin"
                                            getterBlock:^NSString *(UIView *view) {
                                                return FormatFloat(view.bottomMargin);
                                            }
                                                setters:@[
                             [ViewParameterSetter create:@"-5"
                                             setterBlock:^(UIView *view) {
                                                 view.bottomMargin = view.bottomMargin - 5;
                                             }],
                             [ViewParameterSetter create:@"-1"
                                             setterBlock:^(UIView *view) {
                                                 view.bottomMargin = view.bottomMargin - 1;
                                             }],
                             [ViewParameterSetter create:@"0"
                                             setterBlock:^(UIView *view) {
                                                 view.bottomMargin = 0;
                                             }],
                             [ViewParameterSetter create:@"+1"
                                             setterBlock:^(UIView *view) {
                                                 view.bottomMargin = view.bottomMargin + 1;
                                             }],
                             [ViewParameterSetter create:@"+5"
                                             setterBlock:^(UIView *view) {
                                                 view.bottomMargin = view.bottomMargin + 5;
                                             }],
                             ]],

// --- vSpacing ---
                            [ViewParameterSimple create:@"vSpacing"
                                            getterBlock:^NSString *(UIView *view) {
                                                return FormatFloat(view.vSpacing);
                                            }
                                                setters:@[
                             [ViewParameterSetter create:@"-5"
                                             setterBlock:^(UIView *view) {
                                                 view.vSpacing = view.vSpacing - 5;
                                             }],
                             [ViewParameterSetter create:@"-1"
                                             setterBlock:^(UIView *view) {
                                                 view.vSpacing = view.vSpacing - 1;
                                             }],
                             [ViewParameterSetter create:@"0"
                                             setterBlock:^(UIView *view) {
                                                 view.vSpacing = 0;
                                             }],
                             [ViewParameterSetter create:@"+1"
                                             setterBlock:^(UIView *view) {
                                                 view.vSpacing = view.vSpacing + 1;
                                             }],
                             [ViewParameterSetter create:@"+5"
                                             setterBlock:^(UIView *view) {
                                                 view.vSpacing = view.vSpacing + 5;
                                             }],
                             ]],

// --- hSpacing ---
                            [ViewParameterSimple create:@"hSpacing"
                                            getterBlock:^NSString *(UIView *view) {
                                                return FormatFloat(view.hSpacing);
                                            }
                                                setters:@[
                             [ViewParameterSetter create:@"-5"
                                             setterBlock:^(UIView *view) {
                                                 view.hSpacing = view.hSpacing - 5;
                                             }],
                             [ViewParameterSetter create:@"-1"
                                             setterBlock:^(UIView *view) {
                                                 view.hSpacing = view.hSpacing - 1;
                                             }],
                             [ViewParameterSetter create:@"0"
                                             setterBlock:^(UIView *view) {
                                                 view.hSpacing = 0;
                                             }],
                             [ViewParameterSetter create:@"+1"
                                             setterBlock:^(UIView *view) {
                                                 view.hSpacing = view.hSpacing + 1;
                                             }],
                             [ViewParameterSetter create:@"+5"
                                             setterBlock:^(UIView *view) {
                                                 view.hSpacing = view.hSpacing + 5;
                                             }],
                             ]],

// --- debugLayout ---
                            [ViewParameterSimple create:@"debugLayout"
                                            getterBlock:^NSString *(UIView *view) {
                                                return FormatBoolean(view.debugLayout);
                                            }
                                                setters:@[
                             [ViewParameterSetter create:@"YES"
                                             setterBlock:^(UIView *view) {
                                                 view.debugLayout = YES;
                                             }
                              ],
                             [ViewParameterSetter create:@"NO"
                                             setterBlock:^(UIView *view) {
                                                 view.debugLayout = NO;
                                             }
                              ],
                             ]],

/* CODEGEN MARKER: Parameters End */

//                             [LinearDemo1 class],
                             ];

//        self.tableView.rowHeight = 25;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleSelectionChanged:)
                                                     name:NOTIFICATION_SELECTION_CHANGED
                                                   object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleItemAdded:)
                                                     name:NOTIFICATION_ITEM_ADDED
                                                   object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)handleItemAdded:(NSNotification *)notification {
    NSLog(@"tree handleItemAdded: %@", notification.object);
    self.currentView = notification.object;
//    UIView *currentView
//    [self.expandedViews addObject:notification.object];
    [self updateContent];
}

- (void)handleSelectionChanged:(NSNotification *)notification {
    NSLog(@"tree handleSelectionChanged");
    self.currentView = notification.object;
//    [self updateState];
    [self updateContent];
}

- (void)viewChanged
{
    [self updateContent];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SELECTION_ALTERED
                                                        object:self.currentView];
}

- (void)updateContent
{
    [self.tableView reloadData];
//    [super viewDidLoad];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return (self.currentView ? 1 : 0);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.viewParams.count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }

    for (UIView *subview in cell.subviews)
    {
        [subview removeFromSuperview];
    }

    ViewParameter *viewParameter = self.viewParams[indexPath.row];
    viewParameter.delegate = self;
    [viewParameter configureCell:cell withView:self.currentView];
//    cell.textLabel.text = [clazz description];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

//    Class clazz = self.demoClasses[indexPath.row];
//    Demo *demo = [[clazz alloc] init];
//    [self.delegate demoSelected:demo];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self tableView:tableView cellForRowAtIndexPath:indexPath].frame.size.height;
}

@end
