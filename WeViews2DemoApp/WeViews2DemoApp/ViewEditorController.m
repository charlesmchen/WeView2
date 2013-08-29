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
    nameLabel.font = [UIFont boldSystemFontOfSize:14.f];
    nameLabel.text = [NSString stringWithFormat:@"%@:", self.name];

    UILabel *valueLabel = [[UILabel alloc] init];
    valueLabel.backgroundColor = [UIColor clearColor];
    valueLabel.opaque = NO;
    valueLabel.textColor = [UIColor blackColor];
    valueLabel.font = [UIFont systemFontOfSize:14.f];
    valueLabel.text = self.getterBlock(view);

    NSMutableArray *subviews = [@[
                                nameLabel,
                                valueLabel,
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
        setterButton.titleLabel.font = [UIFont systemFontOfSize:14.f];
        [setterButton addTarget:setter
                         action:@selector(perform:)
               forControlEvents:UIControlEventTouchUpInside];
        [subviews addObject:setterButton];
    }

    [[[[[container addSubviews:subviews]
        setHAlign:H_ALIGN_LEFT]
       setHMargin:10]
      setVMargin:5]
     setSpacing:10];
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

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

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
                            /* CODEGEN MARKER: Parameters End */

//                             [LinearDemo1 class],
                             ];

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

@end
