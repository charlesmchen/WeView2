//
//  DemoFactory.m
//  WeViews2DemoApp
//
//  Copyright (c) 2013 Charles Matthew Chen. All rights reserved.
//
//  Distributed under the Apache License v2.0.
//  http://www.apache.org/licenses/LICENSE-2.0.html
//

#import "WeView2.h"
#import "DemoFactory.h"
#import "DemoViewFactory.h"

@implementation DemoFactory

+ (NSArray *)allDemos
{
    return @[
             [self stackDemo1],
             [self horizontalDemo1],
             [self verticalDemo1],
             [self verticalDemo2],
             [self flowDemo1],
             [self iphoneDemo1],
             [self randomImageDemo1],
             [self horizontalDemo3],
             ];
}

+ (Demo *)defaultDemo
{
    return [self horizontalDemo1];
}

+ (Demo *)randomImageDemo1
{
    NSString *demoName = @"Random Image Demo 1";
    Demo *demo = [[Demo alloc] init];
    demo.name = demoName;
    demo.createDemoModelBlock = ^DemoModel *()
    {
        DemoModel *demoModel = [DemoModel create];

        NSArray *imageNames = @[
                                @"916px-Greatbasinmap.jpg",
                                @"finder_512.png",
                                @"The_shortening_winters_day_is_near_a_close_Farquharson.jpg",
                                @"Coat_of_Arms_of_Yekaterinoslav_Governorate.png",
                                @"finder_64.png",
                                ];
        NSString *imageName = imageNames[arc4random() % [imageNames count]];
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"Images/%@", imageName]];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        [[demoModel.rootView useStackDefaultLayout] addSubview:imageView];

        [DemoFactory assignRandomBackgroundColors:[DemoFactory collectSubviews:demoModel.rootView]];
        //    result.debugLayout = YES;
        demoModel.rootView.debugName = demoName;
        return demoModel;
    };
    return demo;
}

+ (Demo *)stackDemo1
{
    NSString *demoName = @"Stack Demo 1";
    Demo *demo = [[Demo alloc] init];
    demo.name = demoName;
    demo.createDemoModelBlock = ^DemoModel *()
    {
        DemoModel *demoModel = [DemoModel create];

        [[demoModel.rootView useStackDefaultLayout] addSubview:[DemoFactory createWrappingLabel]];
        [[[demoModel.rootView setVMargin:10]
          setHMargin:20]
         setSpacing:5];

        [DemoFactory assignRandomBackgroundColors:[DemoFactory collectSubviews:demoModel.rootView]];
        //    result.debugLayout = YES;
        demoModel.rootView.debugName = demoName;
        return demoModel;
    };
    return demo;
}

+ (Demo *)horizontalDemo3
{
    NSString *demoName = @"Horizontal Demo 3";
    Demo *demo = [[Demo alloc] init];
    demo.name = demoName;
    demo.createDemoModelBlock = ^DemoModel *()
    {
        DemoModel *demoModel = [DemoModel create];

        [[demoModel.rootView useHorizontalDefaultLayout]
         addSubviews:@[
         [DemoFactory createLabel:@"A UILabel"
                         fontSize:16.f],
         [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Images/finder_64.png"]],
         [self buttonWithImageName:@"Images/ok_button_up"],
         ]];
        [[[demoModel.rootView setVMargin:5]
          setHMargin:10]
         setSpacing:5];

        [DemoFactory assignRandomBackgroundColors:[DemoFactory collectSubviews:demoModel.rootView]];
        //    result.debugLayout = YES;
        demoModel.rootView.debugName = demoName;
        return demoModel;
    };
    return demo;
}

+ (Demo *)horizontalDemo1
{
    NSString *demoName = @"Horizontal Demo 1";
    Demo *demo = [[Demo alloc] init];
    demo.name = demoName;
    demo.createDemoModelBlock = ^DemoModel *()
    {
        DemoModel *demoModel = [DemoModel create];

        [[demoModel.rootView useHorizontalDefaultLayout]
         addSubviews:@[
         [DemoFactory createLabel:@"Welcome"
                         fontSize:16.f],
         [DemoFactory createLabel:@"To"
                         fontSize:24.f],
         [DemoFactory createLabel:@"WeView2"
                         fontSize:32.f],
         [DemoFactory createWrappingLabel],
         ]];
        [[[demoModel.rootView setVMargin:10]
          setHMargin:20]
         setSpacing:5];

        [DemoFactory assignRandomBackgroundColors:[DemoFactory collectSubviews:demoModel.rootView]];
        //    result.debugLayout = YES;
        demoModel.rootView.debugName = demoName;
        return demoModel;
    };
    return demo;
}

+ (Demo *)verticalDemo1
{
    NSString *demoName = @"Vertical Demo 1";
    Demo *demo = [[Demo alloc] init];
    demo.name = demoName;
    demo.createDemoModelBlock = ^DemoModel *()
    {
        DemoModel *demoModel = [DemoModel create];

        [[demoModel.rootView useVerticalDefaultLayout]
         addSubviews:@[
         [DemoFactory createLabel:@"Welcome"
                         fontSize:16.f],
         [DemoFactory createLabel:@"To"
                         fontSize:24.f],
         [DemoFactory createLabel:@"WeView2"
                         fontSize:32.f],
         [DemoFactory createWrappingLabel],
         ]];
        [[[demoModel.rootView setVMargin:10]
          setHMargin:20]
         setSpacing:5];

        [DemoFactory assignRandomBackgroundColors:[DemoFactory collectSubviews:demoModel.rootView]];
        //    result.debugLayout = YES;
        demoModel.rootView.debugName = demoName;
        return demoModel;
    };
    return demo;
}

+ (Demo *)verticalDemo2
{
    NSString *demoName = @"Vertical Demo 2";
    Demo *demo = [[Demo alloc] init];
    demo.name = demoName;
    demo.createDemoModelBlock = ^DemoModel *()
    {
        DemoModel *demoModel = [DemoModel create];

        WeView2 *topPanel = [[WeView2 alloc] init];
        [[topPanel useHorizontalDefaultLayout]
         addSubviews:@[
         [DemoFactory createLabel:@"Welcome"
                  fontSize:16.f],
         [DemoFactory createLabel:@"To"
                  fontSize:24.f],
         [DemoFactory createLabel:@"WeView2"
                  fontSize:32.f],
         ]];
        [[[topPanel setVMargin:10]
          setHMargin:20]
         setSpacing:5];

        WeView2 *bottomPanel = [[WeView2 alloc] init];
        [[bottomPanel useHorizontalDefaultLayout]
         addSubviews:@[
         [DemoFactory createLabel:@"Welcome"
                  fontSize:16.f],
         [DemoFactory createLabel:@"To"
                  fontSize:24.f],
         [DemoFactory createLabel:@"WeView2"
                  fontSize:32.f],
         ]];
        [[[bottomPanel setVMargin:10]
          setHMargin:20]
         setSpacing:5];

        [[demoModel.rootView useVerticalDefaultLayout]
         addSubviews:@[
         topPanel,
         bottomPanel,
         ]];
        [[demoModel.rootView setMargin:10]
         setSpacing:10];

        [DemoFactory assignRandomBackgroundColors:[DemoFactory collectSubviews:demoModel.rootView]];
        //    result.debugLayout = YES;
        topPanel.debugName = @"topPanel";
        bottomPanel.debugName = @"bottomPanel";
        demoModel.rootView.debugName = demoName;
        return demoModel;
    };
    return demo;
}

+ (Demo *)flowDemo1
{
    NSString *demoName = @"Flow Demo 1";
    Demo *demo = [[Demo alloc] init];
    demo.name = demoName;
    demo.createDemoModelBlock = ^DemoModel *()
    {
        DemoModel *demoModel = [DemoModel create];

        WeView2 *singleViewPanel = [[WeView2 alloc] init];
        [[singleViewPanel useStackDefaultLayout] addSubview:[DemoFactory createWrappingLabel]];
        [[[singleViewPanel setVMargin:10]
          setHMargin:20]
         setSpacing:5];

        WeView2 *horizontalPanel = [[WeView2 alloc] init];
        [[horizontalPanel useHorizontalDefaultLayout]
         addSubviews:@[
         [DemoFactory createWrappingLabel],
         [DemoFactory createLabel:@"To"
                         fontSize:24.f],
         [DemoFactory createLabel:@"WeView2"
                         fontSize:32.f],
         ]];
        [[[horizontalPanel setVMargin:10]
          setHMargin:20]
         setSpacing:5];

        WeView2 *verticalPanel = [[WeView2 alloc] init];
        [[verticalPanel useVerticalDefaultLayout]
         addSubviews:@[
         [DemoFactory createLabel:@"Welcome"
                         fontSize:16.f],
         [DemoFactory createLabel:@"To"
                         fontSize:24.f],
         [DemoFactory createLabel:@"WeView2"
                         fontSize:32.f],
         ]];
        [[[verticalPanel setVMargin:10]
          setHMargin:20]
         setSpacing:5];

        [[demoModel.rootView useVerticalDefaultLayout]
         addSubviews:@[
         [DemoFactory createWrappingLabel],
         singleViewPanel,
         horizontalPanel,
         verticalPanel,
         ]];
        [[demoModel.rootView setMargin:10]
         setSpacing:10];

        [DemoFactory assignRandomBackgroundColors:[DemoFactory collectSubviews:demoModel.rootView]];
        //    result.debugLayout = YES;
        demoModel.rootView.debugName = demoName;
        singleViewPanel.debugName = @"singleViewPanel";
        horizontalPanel.debugName = @"horizontalPanel";
        verticalPanel.debugName = @"verticalPanel";
        return demoModel;
    };
    return demo;
}

+ (Demo *)iphoneDemo1
{
    NSString *demoName = @"iPhone Demo 1";
    Demo *demo = [[Demo alloc] init];
    demo.name = demoName;
    demo.createDemoModelBlock = ^DemoModel *()
    {
        DemoModel *demoModel = [DemoModel create];

        demoModel.useIPhoneSandboxByDefault = YES;

        UIToolbar *toolbar = [[UIToolbar alloc] init];
        [toolbar setItems:@[
         [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:nil action:nil],
         [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
         [[UIBarButtonItem alloc] initWithTitle:@"Demo" style:UIBarButtonItemStylePlain target:nil action:nil],
         [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
         ]
                 animated:NO];
        WeView2 *bodyView = [[WeView2 alloc] init];
        [[demoModel.rootView addSubviews:@[
          toolbar,
          [bodyView setStretchesIgnoringDesiredSize],
          ]]
         useVerticalDefaultLayout];

        [bodyView addSubviewWithFillLayoutWAspectRatio:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Images/The_shortening_winters_day_is_near_a_close_Farquharson.jpg"]]];
        bodyView.clipsToBounds = YES;

        [[[bodyView addSubviewsWithHorizontalLayout:@[
           [self buttonWithImageName:@"Images/gray_pillbox_left"],
           [self buttonWithImageName:@"Images/gray_pillbox_center"],
           [self buttonWithImageName:@"Images/gray_pillbox_right"],
           ]]
          setBottomMargin:20]
         setContentVAlign:V_ALIGN_BOTTOM];

        UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [activityIndicatorView startAnimating];
        [bodyView addSubviewWithCustomLayout:activityIndicatorView];

        [demoModel.rootView setStretchesIgnoringDesiredSize];
        demoModel.rootView.debugName = demoName;
        return demoModel;
    };
    return demo;
}

+ (UIColor *)colorWithRGBHex:(UInt32)hex
{
    return [DemoViewFactory colorWithRGBHex:hex];
}

+ (void)assignRandomBackgroundColor:(UIView *)view
{
    static NSArray *colors = nil;
    if (!colors)
    {
        colors = @[
                   [self colorWithRGBHex:0x5271cb],
                   [self colorWithRGBHex:0xfd9345],
                   [self colorWithRGBHex:0xb74d4d],
                   [self colorWithRGBHex:0x94c365],
                   [self colorWithRGBHex:0xffcd6a],
                   [self colorWithRGBHex:0x7fcedd],
                   [self colorWithRGBHex:0xc49a50],
                   [self colorWithRGBHex:0x658a57],
                   [self colorWithRGBHex:0xff8a8a],
                   [self colorWithRGBHex:0x363636],
                   [self colorWithRGBHex:0xb1b1b1],
                   ];
    }
    static int colorIndexCounter = 0;
    int colorIndex = colorIndexCounter;
    colorIndexCounter = (colorIndexCounter + 1) % [colors count];
    view.backgroundColor = colors[colorIndex];
    view.opaque = YES;
    view.opaque = NO;
}

+ (void)assignRandomBackgroundColors:(NSArray *)views
{
    for (UIView *view in views)
    {
        [self assignRandomBackgroundColor:view];
    }
}

+ (UILabel *)createLabel:(NSString *)text
                fontSize:(CGFloat)fontSize
{
    return [DemoViewFactory createLabel:text
                               fontSize:fontSize
                              textColor:[UIColor whiteColor]];

}

+ (UILabel *)createLabel:(NSString *)text
                fontSize:(CGFloat)fontSize
               textColor:(UIColor *)textColor
{
    return [DemoViewFactory createLabel:text
                               fontSize:fontSize
                              textColor:textColor];
}

+ (UILabel *)createWrappingLabel
{
    UILabel *label = [self createLabel:@"This text should wrap."
                              fontSize:14.f];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
//    label.stretchWeight = 1.f;
    return label;
}

+ (NSArray *)collectSubviews:(UIView *)view
{
    NSMutableArray *result = [NSMutableArray array];
    [result addObject:view];
    for (UIView *subview in view.subviews)
    {
        [result addObjectsFromArray:[self collectSubviews:subview]];
    }
    return result;
}

+ (UIButton *)buttonWithImageName:(NSString *)imageName
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:imageName]
            forState:UIControlStateNormal];
    [button sizeToFit];
    return button;
}

@end
