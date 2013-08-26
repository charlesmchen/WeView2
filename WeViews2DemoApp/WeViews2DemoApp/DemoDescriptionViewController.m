//
//  DemoDescriptionViewController.m
//  WeViews2DemoApp
//
//  Copyright (c) 2013 Charles Matthew Chen. All rights reserved.
//

#import "DemoDescriptionViewController.h"
#import "WeView2.h"

@interface DemoDescriptionViewController ()

@property (nonatomic) WeView2 *rootView;
@property (nonatomic) UITextView *textView;

@end

#pragma mark -

@implementation DemoDescriptionViewController

- (id)init
{
    self = [super init];
    if (self)
    {
        self.title = NSLocalizedString(@"Summary", nil);
    }
    return self;
}

- (void)loadView
{
    self.rootView = [[[WeView2 alloc] init]
                     setVLinearLayout];
    self.rootView.margin = 5;
    self.rootView.vAlign = V_ALIGN_TOP;
    self.rootView.hAlign = H_ALIGN_LEFT;
    self.rootView.opaque = YES;
    self.rootView.backgroundColor = [UIColor whiteColor];
    self.rootView.debugName = @"DemoViewController.rootView";
    self.view = self.rootView;

    self.textView = [[UITextView alloc] init];
    self.textView.editable = NO;
    self.textView.opaque = YES;
    self.textView.backgroundColor = [UIColor whiteColor];
    [self.rootView addSubviews:@[self.textView,]];
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

- (NSString *)prefixForDepth:(int)depth
{
    NSMutableString *result = [@"" mutableCopy];
    for (int i=0; i < depth; i++)
    {
        [result appendString:@"  "];
    }
    return result;
}

- (NSString *)describeView:(UIView *)view
{
    NSMutableString *result = [@"" mutableCopy];

    [result appendFormat:@"%@ %@ (%@) (min: %@)",
     [view class],
     NSStringFromCGRect(view.frame),
     [view layoutDescription],
     NSStringFromCGSize([view sizeThatFits:CGSizeZero])];

    return result;
}

- (NSString *)describeView:(UIView *)view
                     depth:(int)depth
{
    NSMutableString *result = [@"" mutableCopy];

    [result appendFormat:@"%@%@\n",
     [self prefixForDepth:depth],
     [self describeView:view]];

    for (UIView *subview in view.subviews)
    {
        [result appendString:[self describeView:subview depth:depth+1]];
    }
    return result;
}

- (void)displayView:(UIView *)view
{
    self.textView.text = [self describeView:view
                                      depth:0];
    [self.rootView setNeedsLayout];
    //    NSLog(@"self.textView.text: %@", self.textView.text);
}

@end
