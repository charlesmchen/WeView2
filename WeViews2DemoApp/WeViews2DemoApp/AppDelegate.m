//
//  AppDelegate.m
//  WeViews2DemoApp
//
//  Copyright (c) 2013 Charles Matthew Chen. All rights reserved.
//

#import "AppDelegate.h"

#import "Demo.h"
#import "LinearDemo1.h"
//#import "DemoViewController.h"
#import "SandboxViewController.h"
#import "SidebarViewController.h"

@interface AppDelegate ()
<SelectDemoViewControllerDelegate, DemoModelDelegate>
//<SelectDemoViewControllerDelegate, DemoViewControllerDelegate, DemoModelDelegate>

//@property (nonatomic) DemoViewController *demoViewController;
@property (nonatomic) SandboxViewController *sandboxViewController;
@property (nonatomic) SidebarViewController *sidebarViewController;
@property (nonatomic) DemoModel *demoModel;

@end

#pragma mark -

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    self.sidebarViewController = [[SidebarViewController alloc] init];
    self.sidebarViewController.selectDemoViewController.delegate = self;

    self.sandboxViewController = [[SandboxViewController alloc] init];
//    self.demoViewController.delegate = self;

//    self.demoViewController = [[DemoViewController alloc] init];
//    self.demoViewController.delegate = self;

    self.splitViewController = [[UISplitViewController alloc] init];
    self.splitViewController.viewControllers = @[self.sidebarViewController, self.sandboxViewController];

    self.window.rootViewController = self.splitViewController;

    dispatch_async(dispatch_get_main_queue(), ^{
        [self demoSelected:[[LinearDemo1 alloc] init]];
    });

    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - SelectDemoViewControllerDelegate

- (void)demoSelected:(Demo *)demo
{
//    [self.demoViewController displayDemo:demo];
    [self.sandboxViewController displayDemo:demo];
}

#pragma mark - DemoViewControllerDelegate

//- (void)demoModelChanged:(DemoModel *)demoModel
//{
//    self.demoModel.delegate = nil;
//    self.demoModel = demoModel;
//    self.demoModel.delegate = self;
//    [self.sidebarViewController.demoDescriptionViewController displayView:demoModel.rootView];
//    [self.sidebarViewController.viewTreeViewController updateDemoModel:demoModel];
//}
//
//- (void)demoViewChanged:(UIView *)view
//{
//    [self.sidebarViewController.demoDescriptionViewController displayView:view];
//}

#pragma mark - DemoModelDelegate

- (void)selectionChanged:(id)selection
{

}

@end
