//
//  RTAppDelegate.m
//  RPagingView
//
//  Created by  on 12-4-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RTAppDelegate.h"

#import "RPagingViewController.h"
#import "BlueController.h"
#import "RedController.h"
#import "GreenController.h"

@implementation RTAppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;

- (void)dealloc
{
    [_window release];
    [_viewController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    self.window.backgroundColor = [UIColor whiteColor];
    // Override point for customization after application launch.
    RPagingViewController *vc = [[RPagingViewController alloc] init];
    [vc setHeaderViewBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"gbg.png"]]];
    [vc setHeaderHeight:64];
    
    UIViewController *r = [[RedController alloc] initWithNibName:@"RedController"
                                                          bundle:nil];
    r.title = @"Red";
    UIViewController *b = [[BlueController alloc] initWithNibName:@"BlueController"
                                                           bundle:nil];
    b.title = @"Blue";
    UIViewController *g = [[GreenController alloc] initWithNibName:@"GreenController"
                                                            bundle:nil];
    g.title = @"Green";
    vc.viewControllers = [NSArray arrayWithObjects:r,g,b, nil];
    [r release],[g release],[b release];
    self.viewController = vc;
    [vc release];
    UINavigationController *n = [[UINavigationController alloc] initWithRootViewController:self.viewController];
    self.window.rootViewController = n;
    [n release];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end
