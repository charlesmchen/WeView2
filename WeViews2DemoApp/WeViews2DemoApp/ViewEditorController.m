//
//  ViewEditorController.m
//  WeViews2DemoApp
//
//  Copyright (c) 2013 Charles Matthew Chen. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "UIView+WeView2.h"
#import "ViewEditorController.h"
#import "WeView2DemoConstants.h"
#import "WeView2Macros.h"

NSString *FormatFloat(CGFloat value)
{
    if (value == CGFLOAT_MAX)
    {
        return @"\u221E";
    }
    else if (value == CGFLOAT_MIN)
    {
        return @"-\u221E";
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
    [self.view setNeedsLayout];
    [self.view.superview setNeedsLayout];
    [self.delegate viewChanged];
}

@end

#pragma mark -

@interface ViewParameterSimple : ViewParameter

@property (nonatomic) NSString *name;
@property (copy, nonatomic) GetterBlock getterBlock;
@property (copy, nonatomic) NSArray *setters;
@property (nonatomic) BOOL doubleHeight;

@end

#pragma mark -

@implementation ViewParameterSimple

+ (ViewParameterSimple *)create:(NSString *)name
                    getterBlock:(GetterBlock)getterBlock
                        setters:(NSArray *)setters
{
    return [self create:name
            getterBlock:getterBlock
                setters:setters
           doubleHeight:NO];
}

+ (ViewParameterSimple *)create:(NSString *)name
                    getterBlock:(GetterBlock)getterBlock
                        setters:(NSArray *)setters
                   doubleHeight:(BOOL)doubleHeight
{
    ViewParameterSimple *result = [[ViewParameterSimple alloc] init];
    result.name = name;
    result.getterBlock = getterBlock;
    result.setters = setters;
    result.doubleHeight = doubleHeight;
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
    nameLabel.font = [UIFont fontWithName:@"AvenirNext-DemiBold"
                                     size:14];
    nameLabel.text = [NSString stringWithFormat:@"%@:", self.name];

    UILabel *valueLabel = [[UILabel alloc] init];
    valueLabel.backgroundColor = [UIColor clearColor];
    valueLabel.opaque = NO;
    valueLabel.textColor = [UIColor blackColor];
    valueLabel.font = [UIFont fontWithName:@"AvenirNext-DemiBold"
                                      size:14];
    valueLabel.text = self.getterBlock(view);

    NSMutableArray *subviews = [@[
                                nameLabel,
                                valueLabel,
                                ] mutableCopy];

    NSMutableArray *setterViews = [NSMutableArray array];
    for (ViewParameterSetter *setter in self.setters)
    {
        setter.view = view;
        setter.delegate = self.delegate;

        UIButton *setterButton = [UIButton buttonWithType:UIButtonTypeCustom];
        setterButton.opaque = NO;
        setterButton.backgroundColor = [UIColor colorWithWhite:0.5f alpha:1.f];
        setterButton.layer.cornerRadius = 5.f;
        setterButton.contentEdgeInsets = UIEdgeInsetsMake(3, 5, 2, 5);
        [setterButton setTitle:setter.name forState:UIControlStateNormal];
        [setterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        //        setterButton.titleLabel.font = [UIFont systemFontOfSize:14.f];
        setterButton.titleLabel.font = [UIFont fontWithName:@"AvenirNext-DemiBold"
                                                       size:14];
        [setterButton addTarget:setter
                         action:@selector(perform:)
               forControlEvents:UIControlEventTouchUpInside];
        [setterViews addObject:setterButton];
    }

    if (self.doubleHeight)
    {
        WeView2 *topPanel = [[WeView2 alloc] init];
        [topPanel useHorizontalDefaultLayout];
        topPanel.backgroundColor = [UIColor clearColor];
        topPanel.opaque = NO;
        [[[topPanel addSubviews:subviews]
            setContentHAlign:H_ALIGN_LEFT]
         setSpacing:4];

        WeView2 *bottomPanel = [[WeView2 alloc] init];
        [bottomPanel useHorizontalDefaultLayout];
        bottomPanel.backgroundColor = [UIColor clearColor];
        bottomPanel.opaque = NO;
        [[[bottomPanel addSubviews:setterViews]
            setContentHAlign:H_ALIGN_RIGHT]
         setSpacing:4];

        [container useVerticalDefaultLayout];
        [[[[container addSubviews:@[[topPanel withStretch],
                                    [bottomPanel withStretch], ]]
           setHMargin:10]
          setVMargin:2]
         setSpacing:4];
    }
    else
    {
        [subviews addObject: [[[UIView alloc] init] withPureStretch]];
        [subviews addObjectsFromArray:setterViews];
        [[[[[container addSubviews:subviews]
            setContentHAlign:H_ALIGN_LEFT]
           setHMargin:10]
          setVMargin:2]
         setSpacing:4];
    }

    cell.height = container.height = [container sizeThatFits:CGSizeMake(cell.width, CGFLOAT_MAX)].height;

}

+ (ViewParameterSimple *)booleanProperty:(NSString *)name
{
    return [ViewParameterSimple create:name
                           getterBlock:^NSString *(UIView *view) {
                               BOOL value = [[view valueForKey:name] boolValue];
                               return FormatBoolean(value);
                           }
                               setters:@[
            [ViewParameterSetter create:@"YES"
                            setterBlock:^(UIView *view) {
                                [view setValue:@(YES) forKey:name];
                            }
             ],
            [ViewParameterSetter create:@"NO"
                            setterBlock:^(UIView *view) {
                                [view setValue:@(NO) forKey:name];
                            }
             ],
            ]];
}

+ (ViewParameterSimple *)floatProperty:(NSString *)name
{
    return [ViewParameterSimple create:name
                           getterBlock:^NSString *(UIView *view) {
                               CGFloat value = [[view valueForKey:name] floatValue];
                               return FormatFloat(value);
                           }
                               setters:@[
            [ViewParameterSetter create:@"-5"
                            setterBlock:^(UIView *view) {
                                CGFloat value = [[view valueForKey:name] floatValue];
                                [view setValue:@(value - 5) forKey:name];
                            }],
            [ViewParameterSetter create:@"-1"
                            setterBlock:^(UIView *view) {
                                CGFloat value = [[view valueForKey:name] floatValue];
                                [view setValue:@(value - 1) forKey:name];
                            }],
            [ViewParameterSetter create:@"0"
                            setterBlock:^(UIView *view) {
                                [view setValue:@(0.f) forKey:name];
                            }],
            [ViewParameterSetter create:@"+1"
                            setterBlock:^(UIView *view) {
                                CGFloat value = [[view valueForKey:name] floatValue];
                                [view setValue:@(value + 1) forKey:name];
                            }],
            [ViewParameterSetter create:@"+5"
                            setterBlock:^(UIView *view) {
                                CGFloat value = [[view valueForKey:name] floatValue];
                                [view setValue:@(value + 5) forKey:name];
                            }
             ],
            ]];
}

@end

#pragma mark -

@interface ViewEditorController () <ViewParameterDelegate>

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

                            [ViewParameterSimple create:@"class"
                                            getterBlock:^NSString *(UIView *view) {
                                                return [[view class] description];
                                            }
                                                setters:@[]],
                            [ViewParameterSimple create:@"frame"
                                            getterBlock:^NSString *(UIView *view) {
                                                return FormatCGRect(view.frame);
                                            }
                                                setters:@[]],
                            [ViewParameterSimple create:@"desired size"
                                            getterBlock:^NSString *(UIView *view) {
                                                return FormatCGSize([view sizeThatFits:CGSizeZero]);
                                            }
                                                setters:@[]],

                            [ViewParameterSimple booleanProperty:@"hidden"],
                            [ViewParameterSimple booleanProperty:@"clipsToBounds"],

        /* CODEGEN MARKER: Parameters Start */

                            [ViewParameterSimple floatProperty:@"minWidth"],

                            [ViewParameterSimple floatProperty:@"maxWidth"],

                            [ViewParameterSimple floatProperty:@"minHeight"],

                            [ViewParameterSimple floatProperty:@"maxHeight"],

                            [ViewParameterSimple floatProperty:@"leftMargin"],

                            [ViewParameterSimple floatProperty:@"rightMargin"],

                            [ViewParameterSimple floatProperty:@"topMargin"],

                            [ViewParameterSimple floatProperty:@"bottomMargin"],

                            [ViewParameterSimple floatProperty:@"vSpacing"],

                            [ViewParameterSimple floatProperty:@"hSpacing"],

                            [ViewParameterSimple floatProperty:@"hStretchWeight"],

                            [ViewParameterSimple floatProperty:@"vStretchWeight"],

                            [ViewParameterSimple floatProperty:@"desiredWidthAdjustment"],

                            [ViewParameterSimple floatProperty:@"desiredHeightAdjustment"],

                            [ViewParameterSimple booleanProperty:@"ignoreDesiredSize"],

                            [ViewParameterSimple create:@"contentHAlign"
                                            getterBlock:^NSString *(UIView *view) {
                                                return FormatHAlign(view.contentHAlign);
                                            }
                                                setters:@[
                             [ViewParameterSetter create:@"Left"
                                             setterBlock:^(UIView *view) {
                                                 view.contentHAlign = H_ALIGN_LEFT;
                                             }],
                             [ViewParameterSetter create:@"Center"
                                             setterBlock:^(UIView *view) {
                                                 view.contentHAlign = H_ALIGN_CENTER;
                                             }],
                             [ViewParameterSetter create:@"Right"
                                             setterBlock:^(UIView *view) {
                                                 view.contentHAlign = H_ALIGN_RIGHT;
                                             }],
                             ]
                             doubleHeight:YES],

                            [ViewParameterSimple create:@"contentVAlign"
                                            getterBlock:^NSString *(UIView *view) {
                                                return FormatVAlign(view.contentVAlign);
                                            }
                                                setters:@[
                             [ViewParameterSetter create:@"Top"
                                             setterBlock:^(UIView *view) {
                                                 view.contentVAlign = V_ALIGN_TOP;
                                             }],
                             [ViewParameterSetter create:@"Center"
                                             setterBlock:^(UIView *view) {
                                                 view.contentVAlign = V_ALIGN_CENTER;
                                             }],
                             [ViewParameterSetter create:@"Bottom"
                                             setterBlock:^(UIView *view) {
                                                 view.contentVAlign = V_ALIGN_BOTTOM;
                                             }],
                             ]
                             doubleHeight:YES],

                            [ViewParameterSimple create:@"cellHAlign"
                                            getterBlock:^NSString *(UIView *view) {
                                                return FormatHAlign(view.cellHAlign);
                                            }
                                                setters:@[
                             [ViewParameterSetter create:@"Left"
                                             setterBlock:^(UIView *view) {
                                                 view.cellHAlign = H_ALIGN_LEFT;
                                             }],
                             [ViewParameterSetter create:@"Center"
                                             setterBlock:^(UIView *view) {
                                                 view.cellHAlign = H_ALIGN_CENTER;
                                             }],
                             [ViewParameterSetter create:@"Right"
                                             setterBlock:^(UIView *view) {
                                                 view.cellHAlign = H_ALIGN_RIGHT;
                                             }],
                             ]
                             doubleHeight:YES],

                            [ViewParameterSimple create:@"cellVAlign"
                                            getterBlock:^NSString *(UIView *view) {
                                                return FormatVAlign(view.cellVAlign);
                                            }
                                                setters:@[
                             [ViewParameterSetter create:@"Top"
                                             setterBlock:^(UIView *view) {
                                                 view.cellVAlign = V_ALIGN_TOP;
                                             }],
                             [ViewParameterSetter create:@"Center"
                                             setterBlock:^(UIView *view) {
                                                 view.cellVAlign = V_ALIGN_CENTER;
                                             }],
                             [ViewParameterSetter create:@"Bottom"
                                             setterBlock:^(UIView *view) {
                                                 view.cellVAlign = V_ALIGN_BOTTOM;
                                             }],
                             ]
                             doubleHeight:YES],

                            [ViewParameterSimple booleanProperty:@"hasCellHAlign"],

                            [ViewParameterSimple booleanProperty:@"hasCellVAlign"],

                            [ViewParameterSimple booleanProperty:@"cropSubviewOverflow"],

                            [ViewParameterSimple create:@"cellPositioning"
                                            getterBlock:^NSString *(UIView *view) {
                                                return FormatCellPositioningMode(view.cellPositioning);
                                            }
                                                setters:@[
                             [ViewParameterSetter create:FormatCellPositioningMode(CELL_POSITION_NORMAL)
                                             setterBlock:^(UIView *view) {
                                                 view.cellPositioning = CELL_POSITION_NORMAL;
                                             }],
                             [ViewParameterSetter create:FormatCellPositioningMode(CELL_POSITION_FILL)
                                             setterBlock:^(UIView *view) {
                                                 view.cellPositioning = CELL_POSITION_FILL;
                                             }],
                             [ViewParameterSetter create:FormatCellPositioningMode(CELL_POSITION_FILL_W_ASPECT_RATIO)
                                             setterBlock:^(UIView *view) {
                                                 view.cellPositioning = CELL_POSITION_FILL_W_ASPECT_RATIO;
                                             }],
                             [ViewParameterSetter create:FormatCellPositioningMode(CELL_POSITION_FIT_W_ASPECT_RATIO)
                                             setterBlock:^(UIView *view) {
                                                 view.cellPositioning = CELL_POSITION_FIT_W_ASPECT_RATIO;
                                             }],
                             ]
                             doubleHeight:YES],

                            [ViewParameterSimple booleanProperty:@"debugLayout"],

                            [ViewParameterSimple booleanProperty:@"debugMinSize"],

/* CODEGEN MARKER: Parameters End */
                            ];

        //        self.tableView.rowHeight = 25;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.sectionHeaderHeight = 10;
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

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)handleItemAdded:(NSNotification *)notification
{
    //    NSLog(@"tree handleItemAdded: %@", notification.object);
    self.currentView = notification.object;
    [self updateContent];
}

- (void)handleSelectionChanged:(NSNotification *)notification
{
    //    NSLog(@"tree handleSelectionChanged");
    self.currentView = notification.object;
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

//    ((WeView2 *)cell.subviews[0]).debugLayout = indexPath.row == 2;

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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self tableView:tableView cellForRowAtIndexPath:indexPath].frame.size.height;
}

@end
