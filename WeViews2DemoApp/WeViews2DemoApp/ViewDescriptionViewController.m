//
//  ViewDescriptionViewController.m
//  WeView 2
//
//  Copyright (c) 2013 Charles Matthew Chen. All rights reserved.
//
//  Distributed under the Apache License v2.0.
//  http://www.apache.org/licenses/LICENSE-2.0.html
//

#import "UIView+WeView.h"
#import "ViewDescriptionViewController.h"

@interface ViewDescriptionViewController ()

@property (nonatomic) UITextView *textView;

@end

#pragma mark -

@implementation ViewDescriptionViewController

- (id)init
{
    self = [super init];
    if (self)
{
    }
    return self;
}

- (void)loadView
{
    self.textView = [[UITextView alloc] init];
    self.textView.editable = NO;
    self.textView.opaque = YES;
    self.textView.backgroundColor = [UIColor whiteColor];
    self.view = self.textView;
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
//    NSLog(@"self.textView.text: %@", self.textView.text);
}

@end
