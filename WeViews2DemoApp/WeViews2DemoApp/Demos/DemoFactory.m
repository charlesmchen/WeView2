//
//  DemoFactory.m
//  WeView v2
//
//  Copyright (c) 2014 Charles Matthew Chen. All rights reserved.
//
//  Distributed under the Apache License v2.0.
//  http://www.apache.org/licenses/LICENSE-2.0.html
//

#import <QuartzCore/QuartzCore.h>

#import "DemoFactory.h"
#import "DemoViewFactory.h"
#import "WeView.h"
#import "WeViewSpacingView.h"

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
             [self miscDemo1],
             [self multiDemo1],
             [self gridDemo1],
             [self gridDemo2],
             ];
}

+ (Demo *)defaultDemo
{
    //    return [self iphoneDemo2_transformDesign];
//    return [self iphoneDemo2_transforml10n];
    //    return [self iphoneDemo2_dynamicContent];
//    return [self horizontalDemo1];
//    return [self flowDemo4];
//    return [self verticalDemo3];
    return [self gridDemo2];
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
        [demoModel.rootView addSubviewWithLayout:imageView];

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

        [[[[demoModel.rootView addSubviewWithLayout:[DemoFactory createWrappingLabel]]
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

        [[[[demoModel.rootView addSubviewWithLayout:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Images/finder_64.png"]]]
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

+ (Demo *)miscDemo1
{
    NSString *demoName = @"Misc Demo 1";
    Demo *demo = [[Demo alloc] init];
    demo.name = demoName;
    demo.createDemoModelBlock = ^DemoModel *()
    {
        DemoModel *demoModel = [DemoModel create];

        [[[demoModel.rootView addSubviewWithLayout:
          [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Images/ok_button_up.png"]]]
         setBottomMargin:20]
         setVAlign:V_ALIGN_BOTTOM];

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

+ (Demo *)gridDemo1
{
    NSString *demoName = @"Grid Demo 1";
    Demo *demo = [[Demo alloc] init];
    demo.name = demoName;
    demo.createDemoModelBlock = ^DemoModel *()
    {
        DemoModel *demoModel = [DemoModel create];

        [[[[demoModel.rootView addSubviewsWithGridLayout:@[
                                                           [DemoFactory createLabel:@"Welcome" fontSize:16.f],
                                                           [DemoFactory createLabel:@"To" fontSize:24.f],
                                                           [DemoFactory createLabel:@"WeView" fontSize:32.f],
                                                           ]
                                             columnCount:2]
           setVMargin:10]
          setHMargin:10]
         setSpacing:5];

        [DemoFactory assignRandomBackgroundColors:[DemoFactory collectSubviews:demoModel.rootView]];
        //    result.debugLayout = YES;
        demoModel.rootView.debugName = demoName;
        return demoModel;
    };
    return demo;
}

+ (Demo *)gridDemo2
{
    NSString *demoName = @"Grid Demo 2";
    Demo *demo = [[Demo alloc] init];
    demo.name = demoName;
    demo.createDemoModelBlock = ^DemoModel *()
    {
        DemoModel *demoModel = [DemoModel create];

        [[[[[demoModel.rootView addSubviewsWithGridLayout:@[
                                                           [DemoFactory createLabel:@"Welcome" fontSize:16.f],
                                                           [DemoFactory createLabel:@"To" fontSize:24.f],
                                                           [DemoFactory createLabel:@"WeView" fontSize:32.f],
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
                                                           ]
                                             columnCount:3]
           setDefaultSpacingStretchWeight:1.f]
           setVMargin:10]
          setHMargin:10]
          setSpacing:15];

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

        [[[[demoModel.rootView addSubviewsWithHorizontalLayout:@[
                                                                 [DemoFactory createLabel:@"Welcome" fontSize:16.f],
                                                                 [DemoFactory createLabel:@"To" fontSize:24.f],
                                                                 [DemoFactory createLabel:@"WeView" fontSize:32.f],
                                                                 ]]
           setVMargin:10]
          setHMargin:10]
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

        [demoModel.rootView addSubviewWithLayout:[DemoFactory createWrappingLabel]];

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
        [demoModel.rootView addSubviewWithLayout:imageView];

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
        [[[[singleViewPanel addSubviewWithLayout:[DemoFactory createWrappingLabel]]
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

        [demoModel.rootView setBackgroundColor:[UIColor colorWithWhite:0.75f alpha:1.f]];
        demoModel.rootView.layer.borderColor = [UIColor yellowColor].CGColor;
        demoModel.rootView.layer.borderWidth = 1.f;

        //        [DemoFactory assignRandomBackgroundColors:[DemoFactory collectSubviews:demoModel.rootView]];
        demoModel.rootView.debugName = demoName;
        return demoModel;
    };
    return demo;
}

+ (Demo *)flowDemo4
{
    NSString *demoName = @"Flow Demo 4";
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
           [DemoViewFactory createFlatUIButton:@"A UIButton"
                                     textColor:[UIColor whiteColor]
                                   buttonColor:[UIColor colorWithWhite:0.5f alpha:1.f]
                                        target:nil
                                      selector:nil],
           [self createWrappingLabel],
           ]]
          setMargin:10]
         setSpacing:10];

        [demoModel.rootView setBackgroundColor:[UIColor colorWithWhite:0.75f alpha:1.f]];
        demoModel.rootView.layer.borderColor = [UIColor yellowColor].CGColor;
        demoModel.rootView.layer.borderWidth = 1.f;

        //        [DemoFactory assignRandomBackgroundColors:[DemoFactory collectSubviews:demoModel.rootView]];
        demoModel.rootView.debugName = demoName;
        return demoModel;
    };
    return demo;
}

+ (NSArray *)createVerticalDemo3RowViewsWithLabel:(NSString *)label
                                            value:(NSString *)value
{
    return @[
             [[DemoFactory createLabel:label
                              fontSize:14.f
                             textColor:[UIColor colorWithWhite:0.25f
                                                         alpha:0.5f]]
              setCellHAlign:H_ALIGN_RIGHT],
             [[DemoFactory createLabel:value
                              fontSize:14.f
                             textColor:[UIColor colorWithWhite:0.1f
                                                         alpha:0.5f]]
              setCellHAlign:H_ALIGN_LEFT],
             ];
}

+ (Demo *)verticalDemo3
{
    NSString *demoName = @"Vertical Demo 3";
    Demo *demo = [[Demo alloc] init];
    demo.name = demoName;
    demo.createDemoModelBlock = ^DemoModel *()
    {
        DemoModel *demoModel = [DemoModel create];

        demoModel.useIPhoneSandboxByDefault = YES;
        demoModel.rootView.backgroundColor = [UIColor whiteColor];
        demoModel.rootView.opaque = YES;
        [demoModel.rootView setStretches];

        WeView *headerView = [[WeView alloc] init];
        headerView.debugName = @"headerView";
        [[headerView addSubviewWithLayout:[DemoFactory createLabel:@"Thunersee mit Stockhornkette"
                                                                fontSize:16.f
                                                               textColor:[UIColor colorWithWhite:0.1f
                                                                                           alpha:0.5f]]]
         setMargin:15];

        // Add image that exactly fills the background of the body panel while retaining its aspect ratio.
        UIImage *image = [UIImage imageNamed:@"Images/thun-stockhornkette-1904 1600.jpg"];
        UIImageView *background = [[UIImageView alloc] initWithImage:image];
        WeView *imageView = [[WeView alloc] init];
        imageView.debugName = @"imageView";
        [[imageView addSubviewWithFillLayoutWAspectRatio:[[background setStretches]
                                                          setIgnoreDesiredSize]]
         setVAlign:V_ALIGN_TOP];
        // The background will exceed the imageView's bounds, so we need to clip.
        imageView.clipsToBounds = YES;

        NSMutableArray *infoViews = [NSMutableArray array];
        [infoViews addObjectsFromArray:[self createVerticalDemo3RowViewsWithLabel:@"Artist"
                                                                            value:@"Ferdinand Hodler"]];
        [infoViews addObjectsFromArray:[self createVerticalDemo3RowViewsWithLabel:@"Date"
                                                                            value:@"1904"]];
        [infoViews addObjectsFromArray:[self createVerticalDemo3RowViewsWithLabel:@"Genre"
                                                                            value:@"Landscape"]];
        [infoViews addObjectsFromArray:[self createVerticalDemo3RowViewsWithLabel:@"Materials"
                                                                            value:@"Oil on Canvas"]];
        [infoViews addObjectsFromArray:[self createVerticalDemo3RowViewsWithLabel:@"Dimensions"
                                                                            value:@"71 x 105 cm"]];
        WeView *infoView = [[WeView alloc] init];
        infoView.debugName = @"infoView";
        [[[infoView addSubviewsWithGridLayout:infoViews
                                  columnCount:2]
          setSpacing:10]
         setMargin:20];

        [demoModel.rootView addSubviewsWithVerticalLayout:@[
         headerView,
         [imageView setStretches],
         infoView,
         ]];

        demoModel.rootView.debugName = demoName;
        return demoModel;
    };
    return demo;
}

+ (Demo *)iphoneDemo2
{
    return [self iphoneDemo2:NO
               transforml10n:NO
              dynamicContent:NO];
}

+ (Demo *)iphoneDemo2_transformDesign
{
    return [self iphoneDemo2:YES
               transforml10n:NO
              dynamicContent:NO];
}

+ (Demo *)iphoneDemo2_transforml10n
{
    return [self iphoneDemo2:NO
               transforml10n:YES
              dynamicContent:NO];
}

+ (Demo *)iphoneDemo2_dynamicContent
{
    return [self iphoneDemo2:NO
               transforml10n:NO
              dynamicContent:YES];
}

+ (Demo *)iphoneDemo2:(BOOL)transformDesign
        transforml10n:(BOOL)transforml10n
       dynamicContent:(BOOL)dynamicContent
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
        UIImageView *background = [[UIImageView alloc] initWithImage:image];
        WeView *backgroundWrapper = [[WeView alloc] init];
        [[backgroundWrapper addSubviewWithFillLayoutWAspectRatio:background]
         setVAlign:V_ALIGN_TOP];
        // The background will exceed the backgroundWrapper's bounds, so we need to clip.
        backgroundWrapper.clipsToBounds = YES;
        [demoModel.rootView addSubviewWithLayout:[backgroundWrapper setStretches]];

        WeView *headerView = [[WeView alloc] init];
        headerView.backgroundColor = [UIColor colorWithWhite:0.5f alpha:0.5f];
        headerView.opaque = NO;
        // Add "title" UILabel to header.
        UILabel *headerLabel = [DemoFactory createLabel:@"Ferdinand Hodler"
                                               fontSize:20.f];
        [[headerView addSubviewWithLayout:headerLabel]
         setMargin:5];
        // Add "tag" button to header.
        [[[[headerView addSubviewWithLayout:[DemoFactory buttonWithImageName:@"Glyphish_Icons/14-tag.png"]]
           setHMargin:10]
          setVMargin:5]
         setHAlign:H_ALIGN_RIGHT];

        // Add header to top of screen.
        [[demoModel.rootView addSubviewWithLayout:[headerView setHStretches]]
         setVAlign:V_ALIGN_TOP];

        // Add pillbox buttons to bottom of screen.
        //
        // No need to set horizontal alignment; centering is the default.
        WeView *pillboxButtonsView = [[WeView alloc] init];
        pillboxButtonsView.layer.cornerRadius = 5.f;
        pillboxButtonsView.clipsToBounds = YES;
        [pillboxButtonsView addSubviewsWithHorizontalLayout:@[
         [self createFlatUIPillboxButton:@"Prev"],
         [self createFlatUIPillboxSpacer],
         [self createFlatUIPillboxButton:@"Details"],
         [self createFlatUIPillboxSpacer],
         [self createFlatUIPillboxButton:@"Next"],
         ]];
        [[[demoModel.rootView addSubviewWithLayout:pillboxButtonsView]
          setBottomMargin:25]
         setVAlign:V_ALIGN_BOTTOM];
        //        pillboxButtonsView.layer.borderWidth = 1.f;
        //        pillboxButtonsView.layer.borderColor = [UIColor yellowColor].CGColor;

        // Add activity indicator, centered on screen.
        UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [activityIndicatorView startAnimating];
        // No need to set alignment; centering is the default.
        [demoModel.rootView addSubviewWithLayout:activityIndicatorView];

        [demoModel.rootView setStretchesIgnoringDesiredSize];
        //        demoModel.rootView.debugName = demoName;
        demoModel.rootView.debugName = @"rootView";
        headerView.debugName = @"headerView";
        backgroundWrapper.debugName = @"backgroundWrapper";

        if (transformDesign)
        {
            demoModel.transformBlocks = @[
                                          ^{
                                              static int counter = 0;
                                              counter = (counter + 1) % 2;
                                              headerLabel.font = [headerLabel.font fontWithSize:((counter == 0) ? 20.f : 24.f)];
                                              for (UIView *subview in pillboxButtonsView.subviews)
                                              {
                                                  if (![subview isKindOfClass:[UIButton class]])
                                                  {
                                                      continue;
                                                  }
                                                  UIButton *pillboxButton = (UIButton *)subview;
                                                  pillboxButton.titleLabel.font = [headerLabel.font fontWithSize:((counter == 0) ? 16.f : 18.f)];
                                              }
                                              [demoModel.rootView setNeedsLayout];
                                          },
                                           ];
        }
        else if (transforml10n)
        {
            demoModel.transformBlocks = @[
                                          ^{
                                              static int counter = 0;
                                              counter = (counter + 1) % 2;

                                              [pillboxButtonsView removeAllSubviews];
                                              [pillboxButtonsView addSubviewsWithHorizontalLayout:@[
                                               [self createFlatUIPillboxButton:(counter == 0) ? @"Prev" : @"Anterior"],
                                               [self createFlatUIPillboxSpacer],
                                               [self createFlatUIPillboxButton:(counter == 0) ? @"Details" : @"Detalles"],
                                               [self createFlatUIPillboxSpacer],
                                               [self createFlatUIPillboxButton:(counter == 0) ? @"Next" : @"Proximo"],
                                               ]];
                                              [demoModel.rootView setNeedsLayout];
                                          },
                                           ];
        }
        else if (dynamicContent)
        {
            demoModel.transformBlocks = @[
                                          ^{
                                              static int counter = 0;
                                              counter = (counter + 1) % 2;

                                              background.image = [UIImage imageNamed:((counter == 0)
                                                                                      ? @"Images/thun-stockhornkette-1904 1600.jpg"
                                                                                      : @"Images/ferdinand hodler - rhythmic landscape on lake geneva (1908) 1600px.jpg")];

                                              [demoModel.rootView setNeedsLayout];
                                          },
                                           ];
        }

        return demoModel;
    };
    return demo;
}

+ (UIView *)multiDemo1_subpanelWithTitle:(NSString *)title
                            descriptions:(NSArray *)descriptions
{
    UILabel *titleLabel = [DemoFactory createLabel:title
                                          fontSize:20.f
                                         textColor:[UIColor whiteColor]];
    titleLabel.font = [UIFont fontWithName:@"AvenirNext-Bold"
                                      size:17.f];
    [titleLabel setBottomSpacingAdjustment:5];
    NSMutableArray *subviews = [NSMutableArray arrayWithObject:titleLabel];
    for (NSString *description in descriptions)
    {
        UILabel *descriptionLabel = [DemoFactory createLabel:description
                                                    fontSize:14.f
                                                   textColor:[UIColor whiteColor]];
        descriptionLabel.numberOfLines = 0;
        descriptionLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [subviews addObject:descriptionLabel];
    }
    WeView *subpanel = [[WeView alloc] init];
    [[[subpanel addSubviewsWithVerticalLayout:subviews]
      setSpacing:-3]
      setHAlign:H_ALIGN_LEFT];
    [subpanel setHStretches];

//    subpanel.layer.borderWidth = 1.f;
//    subpanel.layer.borderColor = [UIColor yellowColor].CGColor;

    subpanel.debugName = @"imageTitlesPanel";

    return subpanel;
}

+ (UIView *)multiDemo1_subpanelWithImage:(NSString *)imagePath
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imagePath]];
    WeView *subpanel = [[WeView alloc] init];
    [[subpanel addSubviewWithFillLayoutWAspectRatio:[[imageView setStretches]
                                                     setIgnoreDesiredSize]]
     setVAlign:V_ALIGN_TOP];
    [subpanel setFixedDesiredSize:CGSizeMake(120, 120)];
    subpanel.clipsToBounds = YES;

    subpanel.layer.borderWidth = 1.f;
    subpanel.layer.borderColor = [UIColor colorWithWhite:0.85f alpha:0.55f].CGColor;
    subpanel.layer.cornerRadius = 5.f;

    subpanel.debugName = @"imagePanel";

//    subpanel.layer.borderWidth = 1.f;
//    subpanel.layer.borderColor = [UIColor yellowColor].CGColor;

    return subpanel;
}

+ (Demo *)multiDemo1
{
    NSString *demoName = @"Multi Demo 1";
    Demo *demo = [[Demo alloc] init];
    demo.name = demoName;
    demo.createDemoModelBlock = ^DemoModel *()
    {
        DemoModel *demoModel = [DemoModel create];

        demoModel.rootView.backgroundColor = [UIColor colorWithRed:0.65f
                                                             green:0.85f
                                                              blue:0.95f
                                                             alpha:1.f];
        demoModel.rootView.layer.cornerRadius = 5.f;

//        imagePanel1.layer.borderWidth = 1.f;
        //        imagePanel1.layer.borderColor = [UIColor yellowColor].CGColor;

        UILabel *titleLabel = [DemoFactory createLabel:@"Ferdinand Hodler"
                                              fontSize:30.f
                                             textColor:[UIColor whiteColor]];
        titleLabel.font = [UIFont fontWithName:@"AvenirNext-Bold"
                                          size:30.f];
        UILabel *subtitleLabel = [DemoFactory createLabel:@"Swiss, March 14, 1853 – May 19, 1918"
                                                    fontSize:14.f
                                                   textColor:[UIColor colorWithWhite:1.f alpha:0.9f]];
        WeViewSpacingView *titleSpacer = [[WeViewSpacingView alloc] init];
        titleSpacer.backgroundColor = [UIColor whiteColor];
        WeView *titlesPanel = [[WeView alloc] init];
        [[titlesPanel addSubviewsWithVerticalLayout:@[
          titleLabel,
          [[[titleSpacer setHStretches]
            setMinDesiredHeight:1.f]
           setTopSpacingAdjustment:-5.f],
          subtitleLabel,
            ]]
           setVSpacing:3.f];

        WeView *gridPanel = [[WeView alloc] init];
        [[[gridPanel addSubviewsWithGridLayout:@[
            [self multiDemo1_subpanelWithImage:@"Images/thun-stockhornkette-1904 1600.jpg"],
            [self multiDemo1_subpanelWithTitle:@"Thunersee mit Stockhornkette"
                                   descriptions:@[@"Materials: Oil on Canvas.", @"Date: 1904.", @"Dimensions: 71 x 105 cm."]],
            [self multiDemo1_subpanelWithImage:@"Images/ferdinand hodler - rhythmic landscape on lake geneva (1908) 1600px.jpg"],
            [self multiDemo1_subpanelWithTitle:@"Rhythmic Landscape on Lake Geneva"
                                   descriptions:@[@"Materials: Oil on Canvas.", @"Date: 1908.", @"Dimensions: 67 x 91 cm."]],
            ]
                                    columnCount:2]
           setHSpacing:25]
          setVSpacing:30];

        [[[demoModel.rootView addSubviewsWithVerticalLayout:@[
           titlesPanel,
           gridPanel,
           ]]
         setSpacing:30]
          setMargin:30];
        demoModel.rootView.debugName = demoName;
        gridPanel.debugName = @"gridPanel";
        titlesPanel.debugName = @"titlesPanel";

        return demoModel;
    };
    return demo;
}

+ (UIView *)createFlatUIPillboxSpacer
{
    WeViewSpacingView *spacer = [[WeViewSpacingView alloc] init];
    spacer.backgroundColor = [UIColor colorWithWhite:0.9f alpha:1.f];
    spacer.opaque = YES;
    [spacer setVStretches];
    [spacer setMinDesiredWidth:1];
    return spacer;
}

+ (UIButton *)createFlatUIPillboxButton:(NSString *)label
{
    return [self createFlatUIPillboxButton:label
                                 textColor:[UIColor whiteColor]
                               buttonColor:[UIColor colorWithWhite:0.65f alpha:1.f]];
}

+ (UIButton *)createFlatUIPillboxButton:(NSString *)label
                              textColor:(UIColor *)textColor
                            buttonColor:(UIColor *)buttonColor
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
        [bodyView addSubviewWithLayout:activityIndicatorView];

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
