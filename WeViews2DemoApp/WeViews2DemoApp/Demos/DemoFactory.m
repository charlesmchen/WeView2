//
//  DemoFactory.m
//  WeView 2
//
//  Copyright (c) 2013 Charles Matthew Chen. All rights reserved.
//
//  Distributed under the Apache License v2.0.
//  http://www.apache.org/licenses/LICENSE-2.0.html
//

#import <QuartzCore/QuartzCore.h>

#import "WeView.h"
#import "DemoFactory.h"
#import "DemoViewFactory.h"

UIColor *UIColorRGB(unsigned int rgb)
{
    CGFloat alpha = 1.f;
    CGFloat red = ((rgb >> 16) & 0xff) / 255.f;
    CGFloat green = ((rgb >> 8) & 0xff) / 255.f;
    CGFloat blue = ((rgb >> 0) & 0xff) / 255.f;
    return [UIColor colorWithRed:red
                           green:green
                            blue:blue
                           alpha:alpha];
}

@implementation DemoFactory

+ (NSArray *)allDemos
{
    return @[
             [self stackDemo1],
             [self stackDemo2],
             [self flowDemo3],
             [self horizontalDemo1],
             [self horizontalDemo2],
             [self horizontalDemo3],
             [self verticalDemo1],
             [self verticalDemo2],
             [self flowDemo1],
             [self flowDemo2],
             [self flowDemo3],
             [self iphoneDemo1],
             [self iphoneDemo2],
             [self randomImageDemo1],
             [self sevenSmallViewsDemo],
             [self stretchDemo1],
             [self wrappingUILabelDemo1],
             [self smallUIImageViewDemo1],
             ];
}

+ (Demo *)defaultDemo
{
    return [self flowDemo3];
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
        [demoModel.rootView addSubviewWithCustomLayout:imageView];

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

        [[[[demoModel.rootView addSubviewWithCustomLayout:[DemoFactory createWrappingLabel]]
           setVMargin:10]
          setHMargin:20]
         setSpacing:5];

        [DemoFactory assignRandomBackgroundColors:[DemoFactory collectSubviews:demoModel.rootView]];
        //    result.debugLayout = YES;
        demoModel.rootView.debugName = demoName;
        return demoModel;
    };
    return demo;
}

+ (Demo *)stackDemo2
{
    NSString *demoName = @"Stack Demo 2";
    Demo *demo = [[Demo alloc] init];
    demo.name = demoName;
    demo.createDemoModelBlock = ^DemoModel *()
    {
        DemoModel *demoModel = [DemoModel create];

        [[[[demoModel.rootView addSubviewWithCustomLayout:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Images/finder_64.png"]]]
           setVMargin:10]
          setHMargin:20]
         setSpacing:5];

        [DemoFactory assignRandomBackgroundColors:[DemoFactory collectSubviews:demoModel.rootView]];
        //    result.debugLayout = YES;
        demoModel.rootView.debugName = demoName;
        return demoModel;
    };
    return demo;
}

+ (Demo *)stackDemo3
{
    NSString *demoName = @"Stack Demo 3";
    Demo *demo = [[Demo alloc] init];
    demo.name = demoName;
    demo.createDemoModelBlock = ^DemoModel *()
    {
        DemoModel *demoModel = [DemoModel create];

        [[[[demoModel.rootView addSubviewsWithStackLayout:@[
                                                         [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Images/finder_64.png"]],
         [DemoFactory createLabel:@"A UILabel"
                         fontSize:16.f],
         ]]
           setVMargin:10]
          setHMargin:20]
         setSpacing:5];

        [DemoFactory assignRandomBackgroundColors:[DemoFactory collectSubviews:demoModel.rootView]];
        //    result.debugLayout = YES;
        demoModel.rootView.debugName = demoName;
        return demoModel;
    };
    return demo;
}

+ (Demo *)sevenSmallViewsDemo
{
    NSString *demoName = @"7 Small Views Demo";
    Demo *demo = [[Demo alloc] init];
    demo.name = demoName;
    demo.createDemoModelBlock = ^DemoModel *()
    {
        DemoModel *demoModel = [DemoModel create];

        [[[[demoModel.rootView addSubviewsWithHorizontalLayout:@[
         [DemoFactory createLabel:@"A UILabel"
                         fontSize:16.f],
         [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Images/finder_64.png"]],
         [DemoFactory createLabel:@"=^)"
                         fontSize:24.f],
         [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Images/ok_button_up.png"]],
         [DemoFactory createLabel:@"=^)"
                         fontSize:24.f],
         [DemoViewFactory createFlatUIButton:@"A UIButton"
                                   textColor:[UIColor whiteColor]
                                 buttonColor:[UIColor colorWithWhite:0.5f alpha:1.f]
                                      target:nil
                                    selector:nil],
         [self createWrappingLabel],
         ]]
           setVMargin:5]
          setHMargin:10]
         setSpacing:5];

        demoModel.rootView.layer.borderWidth = 1.f;
        demoModel.rootView.layer.borderColor = [UIColor yellowColor].CGColor;
        demoModel.rootView.backgroundColor = [UIColor colorWithWhite:0.75f alpha:1.f];

        //        [DemoFactory assignRandomBackgroundColors:[DemoFactory collectSubviews:demoModel.rootView]];
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

        [[[[demoModel.rootView addSubviewsWithHorizontalLayout:@[
         [DemoFactory createLabel:@"A UILabel"
                         fontSize:16.f],
         [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Images/finder_64.png"]],
         [DemoViewFactory createFlatUIButton:@"A UIButton"
                                   textColor:[UIColor whiteColor]
                                 buttonColor:[UIColor colorWithWhite:0.5f alpha:1.f]
                                      target:nil
                                    selector:nil],
         //         [self buttonWithImageName:@"Images/ok_button_up.png"],
         ]]
           setVMargin:5]
          setHMargin:10]
         setSpacing:5];

        demoModel.rootView.layer.borderWidth = 1.f;
        demoModel.rootView.layer.borderColor = [UIColor yellowColor].CGColor;
        demoModel.rootView.backgroundColor = [UIColor colorWithWhite:0.75f alpha:1.f];

        //        [DemoFactory assignRandomBackgroundColors:[DemoFactory collectSubviews:demoModel.rootView]];
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

        [[[[demoModel.rootView addSubviewsWithHorizontalLayout:@[
            [DemoFactory createLabel:@"Welcome" fontSize:16.f],
            [DemoFactory createLabel:@"To" fontSize:24.f],
            [DemoFactory createLabel:@"WeView" fontSize:32.f],
            ]]
           setVMargin:10]
          setHMargin:20]
         setSpacing:5];

        [DemoFactory assignRandomBackgroundColors:[DemoFactory collectSubviews:demoModel.rootView]];
        //    result.debugLayout = YES;
        demoModel.rootView.debugName = demoName;
        return demoModel;
    };
    return demo;
}

+ (Demo *)horizontalDemo2
{
    NSString *demoName = @"Horizontal Demo 2";
    Demo *demo = [[Demo alloc] init];
    demo.name = demoName;
    demo.createDemoModelBlock = ^DemoModel *()
    {
        DemoModel *demoModel = [DemoModel create];

        [[[[demoModel.rootView addSubviewsWithHorizontalLayout:@[
            [DemoFactory createLabel:@"Welcome"
                            fontSize:16.f],
            [DemoFactory createLabel:@"To"
                            fontSize:24.f],
            [DemoFactory createLabel:@"WeView"
                            fontSize:32.f],
            [DemoFactory createWrappingLabel],
            ]]
           setVMargin:10]
          setHMargin:20]
         setSpacing:5];

        [DemoFactory assignRandomBackgroundColors:[DemoFactory collectSubviews:demoModel.rootView]];
        //    result.debugLayout = YES;
        demoModel.rootView.debugName = demoName;
        return demoModel;
    };
    return demo;
}

+ (Demo *)wrappingUILabelDemo1
{
    NSString *demoName = @"UILabel Wrap Demo 1";
    Demo *demo = [[Demo alloc] init];
    demo.name = demoName;
    demo.createDemoModelBlock = ^DemoModel *()
    {
        DemoModel *demoModel = [DemoModel create];

        [demoModel.rootView addSubviewWithCustomLayout:[DemoFactory createWrappingLabel]];

        [DemoFactory assignRandomBackgroundColors:[DemoFactory collectSubviews:demoModel.rootView]];
        demoModel.rootView.debugName = demoName;
        return demoModel;
    };
    return demo;
}

+ (Demo *)smallUIImageViewDemo1
{
    NSString *demoName = @"Small UIImageView Demo 1";
    Demo *demo = [[Demo alloc] init];
    demo.name = demoName;
    demo.createDemoModelBlock = ^DemoModel *()
    {
        DemoModel *demoModel = [DemoModel create];

        UIImageView *imageView = [self imageViewWithImageName:@"Images/finder_64.png"];
        [demoModel.rootView addSubviewWithCustomLayout:imageView];

        [DemoFactory assignRandomBackgroundColors:[DemoFactory collectSubviews:demoModel.rootView]];
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

        [[[[demoModel.rootView addSubviewsWithVerticalLayout:@[
            [DemoFactory createLabel:@"Welcome"
                            fontSize:16.f],
            [DemoFactory createLabel:@"To"
                            fontSize:24.f],
            [DemoFactory createLabel:@"WeView"
                            fontSize:32.f],
            [DemoFactory createWrappingLabel],
            ]]
           setVMargin:10]
          setHMargin:20]
         setSpacing:5];

        [DemoFactory assignRandomBackgroundColors:[DemoFactory collectSubviews:demoModel.rootView]];
        //    result.debugLayout = YES;
        demoModel.rootView.debugName = demoName;
        return demoModel;
    };
    return demo;
}

+ (Demo *)stretchDemo1
{
    NSString *demoName = @"Stretch Demo 1";
    Demo *demo = [[Demo alloc] init];
    demo.name = demoName;
    demo.createDemoModelBlock = ^DemoModel *()
    {
        DemoModel *demoModel = [DemoModel create];

        UIImageView *imageView = [self imageViewWithImageName:@"Images/916px-Greatbasinmap.jpg"];
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        [scrollView addSubview:imageView];
        scrollView.contentSize = imageView.size;
        scrollView.bounces = NO;

        [[demoModel.rootView addSubviewsWithVerticalLayout:@[
          [DemoFactory createLabel:@"Welcome To WeView"
                          fontSize:16.f],
          [[scrollView setStretches]
           setIgnoreDesiredSize],
          ]]
         setSpacing:5];

        demoModel.rootView.layer.borderColor = [UIColor colorWithWhite:0.5f alpha:1.f].CGColor;
        demoModel.rootView.layer.borderWidth = 2.f;

        [self assignRandomBackgroundColor:demoModel.rootView];
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

        WeView *topPanel = [[WeView alloc] init];
        [[[[topPanel addSubviewsWithHorizontalLayout:@[
            [DemoFactory createLabel:@"Welcome"
                            fontSize:16.f],
            [DemoFactory createLabel:@"To"
                            fontSize:24.f],
            [DemoFactory createLabel:@"WeView"
                            fontSize:32.f],
            ]]
           setVMargin:10]
          setHMargin:20]
         setSpacing:5];

        WeView *bottomPanel = [[WeView alloc] init];
        [[[[bottomPanel addSubviewsWithHorizontalLayout:@[
            [DemoFactory createLabel:@"Welcome"
                            fontSize:16.f],
            [DemoFactory createLabel:@"To"
                            fontSize:24.f],
            [DemoFactory createLabel:@"WeView"
                            fontSize:32.f],
            ]]
           setVMargin:10]
          setHMargin:20]
         setSpacing:5];

        [[[demoModel.rootView addSubviewsWithVerticalLayout:@[
           topPanel,
           bottomPanel,
           ]]
          setMargin:10]
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

        WeView *singleViewPanel = [[WeView alloc] init];
        [[[[singleViewPanel addSubviewWithCustomLayout:[DemoFactory createWrappingLabel]]
           setVMargin:10]
          setHMargin:20]
         setSpacing:5];

        WeView *horizontalPanel = [[WeView alloc] init];
        [[[[horizontalPanel addSubviewsWithHorizontalLayout:@[
            [DemoFactory createWrappingLabel],
            [DemoFactory createLabel:@"To"
                            fontSize:24.f],
            [DemoFactory createLabel:@"WeView"
                            fontSize:32.f],
            ]]
           setVMargin:10]
          setHMargin:20]
         setSpacing:5];

        WeView *verticalPanel = [[WeView alloc] init];
        [[[[verticalPanel addSubviewsWithVerticalLayout:@[
            [DemoFactory createLabel:@"Welcome"
                            fontSize:16.f],
            [DemoFactory createLabel:@"To"
                            fontSize:24.f],
            [DemoFactory createLabel:@"WeView"
                            fontSize:32.f],
            ]]
           setVMargin:10]
          setHMargin:20]
         setSpacing:5];

        [[[demoModel.rootView addSubviewsWithVerticalLayout:@[
           [DemoFactory createWrappingLabel],
           singleViewPanel,
           horizontalPanel,
           verticalPanel,
           ]]
          setMargin:10]
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

+ (Demo *)flowDemo2
{
    NSString *demoName = @"Flow Demo 2";
    Demo *demo = [[Demo alloc] init];
    demo.name = demoName;
    demo.createDemoModelBlock = ^DemoModel *()
    {
        DemoModel *demoModel = [DemoModel create];

        [[[demoModel.rootView addSubviewsWithFlowLayout:@[
           [DemoFactory createLabel:@"Before" fontSize:16.f],
           [self imageViewWithImageName:@"Images/finder_64.png"],
           [DemoFactory createLabel:@"After" fontSize:16.f],
           ]]
          setMargin:10]
         setSpacing:10];

        [DemoFactory assignRandomBackgroundColors:[DemoFactory collectSubviews:demoModel.rootView]];
        demoModel.rootView.debugName = demoName;
        return demoModel;
    };
    return demo;
}

+ (Demo *)flowDemo3
{
    NSString *demoName = @"Flow Demo 3";
    Demo *demo = [[Demo alloc] init];
    demo.name = demoName;
    demo.createDemoModelBlock = ^DemoModel *()
    {
        DemoModel *demoModel = [DemoModel create];

        [[[demoModel.rootView addSubviewsWithFlowLayout:@[
           [DemoFactory createLabel:@"A UILabel"
                           fontSize:16.f],
           [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Images/finder_64.png"]],
           [DemoFactory createLabel:@"=^)"
                           fontSize:24.f],
           [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Images/ok_button_up.png"]],
           [DemoFactory createLabel:@"=^)"
                           fontSize:24.f],
           [DemoViewFactory createFlatUIButton:@"A UIButton"
                                     textColor:[UIColor whiteColor]
                                   buttonColor:[UIColor colorWithWhite:0.5f alpha:1.f]
                                        target:nil
                                      selector:nil],
           [self createWrappingLabel],
           ]]
          setMargin:10]
         setSpacing:10];

        [DemoFactory assignRandomBackgroundColors:[DemoFactory collectSubviews:demoModel.rootView]];
        demoModel.rootView.debugName = demoName;
        return demoModel;
    };
    return demo;
}

+ (Demo *)iphoneDemo2
{
    NSString *demoName = @"iPhone Demo 2";
    Demo *demo = [[Demo alloc] init];
    demo.name = demoName;
    demo.createDemoModelBlock = ^DemoModel *()
    {
        DemoModel *demoModel = [DemoModel create];

        demoModel.useIPhoneSandboxByDefault = YES;

        // Add image that exactly fills the background of the body panel while retaining its aspect ratio.
        UIImage *image = [UIImage imageNamed:@"Images/thun-stockhornkette-1904 1600.jpg"];
        [[[demoModel.rootView addSubviewWithCustomLayout:[[UIImageView alloc] initWithImage:image]]
          setCellPositioning:CELL_POSITION_FILL_W_ASPECT_RATIO]
         setVAlign:V_ALIGN_TOP];
        // The background will exceed the rootView's bounds, so we need to clip.
        demoModel.rootView.clipsToBounds = YES;

        WeView *headerView = [[WeView alloc] init];
        headerView.backgroundColor = [UIColor colorWithWhite:0.5f alpha:0.5f];
        headerView.opaque = NO;
        // Add "title" UILabel to header.
        [[headerView addSubviewWithCustomLayout:[DemoFactory createLabel:@"Ferdinand Hodler"
                                                                fontSize:20.f]]
         setMargin:5];
        // Add "tag" button to header.
        [[[[headerView addSubviewWithCustomLayout:[DemoFactory buttonWithImageName:@"Glyphish_Icons/14-tag.png"]]
           setHMargin:10]
          setVMargin:5]
         setHAlign:H_ALIGN_RIGHT];

        // Add header to top of screen.
        [[demoModel.rootView addSubviewWithCustomLayout:[headerView setHStretches]]
         setVAlign:V_ALIGN_TOP];

        // Add pillbox buttons to bottom of screen.
        //
        // No need to set horizontal alignment; centering is the default.
        [[[demoModel.rootView addSubviewsWithHorizontalLayout:@[
           [self createFlatUIPillboxButton:@"Prev"
                                     shape:H_ALIGN_LEFT],
           [self createFlatUIPillboxButton:@"Details"
                                     shape:H_ALIGN_CENTER],
           [self createFlatUIPillboxButton:@"Next"
                                     shape:H_ALIGN_RIGHT],
           ]]
          setBottomMargin:25]
         setVAlign:V_ALIGN_BOTTOM];

        // Add activity indicator, centered on screen.
        UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [activityIndicatorView startAnimating];
        // No need to set alignment; centering is the default.
        [demoModel.rootView addSubviewWithCustomLayout:activityIndicatorView];

        [demoModel.rootView setStretchesIgnoringDesiredSize];
//        demoModel.rootView.debugName = demoName;
        demoModel.rootView.debugName = @"rootView";
        headerView.debugName = @"headerView";
        return demoModel;
    };
    return demo;
}

+ (UIButton *)createFlatUIPillboxButton:(NSString *)label
                                  shape:(HAlign)shape
{
    return [self createFlatUIPillboxButton:label
                                 textColor:[UIColor whiteColor]
                               buttonColor:[UIColor colorWithWhite:0.65f alpha:1.f]
                                     shape:shape];
}

+ (UIButton *)createFlatUIPillboxButton:(NSString *)label
                              textColor:(UIColor *)textColor
                            buttonColor:(UIColor *)buttonColor
                                  shape:(HAlign)shape
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.opaque = NO;
    button.backgroundColor = buttonColor;
    button.contentEdgeInsets = UIEdgeInsetsMake(6, 15, 6, 15);
    [button setTitle:label
            forState:UIControlStateNormal];
    [button setTitleColor:textColor
                 forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont fontWithName:@"AvenirNext-DemiBold"
                                             size:16.f];
    button.titleLabel.backgroundColor = [UIColor clearColor];
    button.titleLabel.opaque = NO;
    [button sizeToFit];

    const int kPillboxRounding = 8;
    if (shape == H_ALIGN_LEFT)
    {
        CGRect clipRect = button.bounds;
        clipRect.size.width += kPillboxRounding;
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.path = [UIBezierPath bezierPathWithRoundedRect:clipRect
                                                    cornerRadius:kPillboxRounding].CGPath;
        button.layer.mask = maskLayer;
    }
    else
    {
//        CALayer *sublayer = [CALayer layer];
//        sublayer.backgroundColor = [UIColor colorWithWhite:1.f alpha:0.5f].CGColor;
//        sublayer.frame = CGRectMake(0, 0, 1.f, button.height);
//        [button.layer addSublayer:sublayer];
    }

    if (shape == H_ALIGN_RIGHT)
    {
        CGRect clipRect = button.bounds;
        clipRect.origin.x -= kPillboxRounding;
        clipRect.size.width += kPillboxRounding;
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.path = [UIBezierPath bezierPathWithRoundedRect:clipRect
                                                    cornerRadius:kPillboxRounding].CGPath;
        button.layer.mask = maskLayer;
    }
    else
    {
        CALayer *sublayer = [CALayer layer];
        sublayer.backgroundColor = [UIColor colorWithWhite:1.f alpha:0.5f].CGColor;
        sublayer.frame = CGRectMake(button.width - 1.f, 0, 1.f, button.height);
        [button.layer addSublayer:sublayer];
    }

    return button;
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
        WeView *bodyView = [[WeView alloc] init];
        [demoModel.rootView addSubviewsWithVerticalLayout:@[
         toolbar,
         [bodyView setStretchesIgnoringDesiredSize],
         ]];

        [bodyView addSubviewWithFillLayoutWAspectRatio:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Images/The_shortening_winters_day_is_near_a_close_Farquharson.jpg"]]];
        bodyView.clipsToBounds = YES;

        [[[bodyView addSubviewsWithHorizontalLayout:@[
           [self buttonWithImageName:@"Images/gray_pillbox_left"],
           [self buttonWithImageName:@"Images/gray_pillbox_center"],
           [self buttonWithImageName:@"Images/gray_pillbox_right"],
           ]]
          setBottomMargin:20]
         setVAlign:V_ALIGN_BOTTOM];

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
        if (![subview isKindOfClass:[UIButton class]])
        {
            [result addObjectsFromArray:[self collectSubviews:subview]];
        }
    }
    return result;
}

+ (UIImageView *)imageViewWithImageName:(NSString *)imageName
{
    UIImageView *result = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    [result sizeToFit];
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

+ (NSArray *)backgroundColors
{
    return [NSArray arrayWithObjects:
            [UIColor redColor],
            [UIColor greenColor],
            [UIColor blueColor],
            //            [UIColor colorWithWhite:0.25f alpha:1.0f],
            [UIColor orangeColor],
            [UIColor purpleColor],
            [UIColor brownColor],
            [UIColor yellowColor],
            [UIColor cyanColor],
            [UIColor magentaColor],

            [UIColor whiteColor],
            [UIColor colorWithWhite:0.75f alpha:1.0f],
            [UIColor colorWithWhite:0.5f alpha:1.0f],
            [UIColor colorWithWhite:0.25f alpha:1.0f],
            [UIColor blackColor],

            UIColorRGB(0x5f8ab7),
            UIColorRGB(0xf3f6f9),
            UIColorRGB(0xb9c8cf),
            UIColorRGB(0xe7e7e7),
            UIColorRGB(0x026db1),
            UIColorRGB(0xa5a5a5),
            UIColorRGB(0x0196ce),
            UIColorRGB(0x3e5386),
            UIColorRGB(0x314d8a),
            UIColorRGB(0x5572b1),
            UIColorRGB(0xf7f7f7),
            UIColorRGB(0x303034),
            UIColorRGB(0xE6E6E6),

            //            [[UIColor redColor] colorWithAlphaComponent:0.5f],
            //            [[UIColor greenColor] colorWithAlphaComponent:0.5f],
            //            [[UIColor blueColor] colorWithAlphaComponent:0.5f],
            //            [[UIColor orangeColor] colorWithAlphaComponent:0.5f],
            //            [[UIColor purpleColor] colorWithAlphaComponent:0.5f],
            //            [[UIColor brownColor] colorWithAlphaComponent:0.5f],
            //            [[UIColor yellowColor] colorWithAlphaComponent:0.5f],
            //            [[UIColor cyanColor] colorWithAlphaComponent:0.5f],
            //            [[UIColor magentaColor] colorWithAlphaComponent:0.5f],
            //            [[UIColor whiteColor] colorWithAlphaComponent:0.5f],
            //            [[UIColor blackColor] colorWithAlphaComponent:0.5f],

            //            [UIColor clearColor],
            nil];
}

//+ (NSArray*) allColors {
//    return [NSArray arrayWithObjects:
//            [UIColor redColor],
//            [UIColor greenColor],
//            [UIColor blueColor],
//            //            [UIColor colorWithWhite:0.25f alpha:1.0f],
//            [UIColor orangeColor],
//            [UIColor purpleColor],
//            [UIColor brownColor],
//            [UIColor yellowColor],
//            [UIColor cyanColor],
//            [UIColor magentaColor],
//
//            [UIColor whiteColor],
//            [UIColor colorWithWhite:0.75f alpha:1.0f],
//            [UIColor colorWithWhite:0.5f alpha:1.0f],
//            [UIColor colorWithWhite:0.25f alpha:1.0f],
//            [UIColor blackColor],
//
//            UIColorRGB(0x5f8ab7),
//            UIColorRGB(0xf3f6f9),
//            UIColorRGB(0xb9c8cf),
//            UIColorRGB(0xe7e7e7),
//            UIColorRGB(0x026db1),
//            UIColorRGB(0xa5a5a5),
//            UIColorRGB(0x0196ce),
//            UIColorRGB(0x3e5386),
//            UIColorRGB(0x314d8a),
//            UIColorRGB(0x5572b1),
//            UIColorRGB(0xf7f7f7),
//            UIColorRGB(0x303034),
//            UIColorRGB(0xE6E6E6),
//
//            [[UIColor redColor] colorWithAlphaComponent:0.5f],
//            [[UIColor greenColor] colorWithAlphaComponent:0.5f],
//            [[UIColor blueColor] colorWithAlphaComponent:0.5f],
//            [[UIColor orangeColor] colorWithAlphaComponent:0.5f],
//            [[UIColor purpleColor] colorWithAlphaComponent:0.5f],
//            [[UIColor brownColor] colorWithAlphaComponent:0.5f],
//            [[UIColor yellowColor] colorWithAlphaComponent:0.5f],
//            [[UIColor cyanColor] colorWithAlphaComponent:0.5f],
//            [[UIColor magentaColor] colorWithAlphaComponent:0.5f],
//            [[UIColor whiteColor] colorWithAlphaComponent:0.5f],
//            [[UIColor blackColor] colorWithAlphaComponent:0.5f],
//
//            [UIColor clearColor],
//            nil];
//}
//
//+ (NSArray*) foregroundColors {
//    return [self allColors];
//}
//
//+ (NSArray*) backgroundColors {
//    return [self allColors];
//}

+ (NSArray *)foregroundColors
{
    return [NSArray arrayWithObjects:
            [UIColor redColor],
            [UIColor greenColor],
            [UIColor blueColor],
            //            [UIColor colorWithWhite:0.25f alpha:1.0f],
            [UIColor colorWithWhite:0.75f alpha:1.0f],
            [UIColor colorWithWhite:0.5f alpha:1.0f],
            [UIColor orangeColor],
            [UIColor purpleColor],
            [UIColor brownColor],
            [UIColor yellowColor],
            nil];
}
//
//+ (NSArray*) backgroundColors {
//    return [NSArray arrayWithObjects:
//            [UIColor whiteColor],
//            [UIColor colorWithWhite:0.25f alpha:1.0f],
//            [UIColor blackColor],
//            [UIColor clearColor],
//            nil];
//}
//
//+ (NSArray*) allColors {
//    NSMutableArray* result = [NSMutableArray array];
//    [result addObjectsFromArray:[self foregroundColors]];
//    [result addObjectsFromArray:[self backgroundColors]];
//    return result;
//}

+ (UIColor *)randomForegroundColor
{
    NSArray* colorOptions = [self foregroundColors];
    UIColor* value = [colorOptions objectAtIndex:arc4random() % [colorOptions count]];
    return value;
}

+ (UIColor *)randomBackgroundColor
{
    NSArray* colorOptions = [self backgroundColors];
    UIColor* value = [colorOptions objectAtIndex:arc4random() % [colorOptions count]];
    return value;
}

@end
