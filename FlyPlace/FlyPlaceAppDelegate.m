//
//  FlyPlaceAppDelegate.m
//  FlyPlace
//
//  Created by Vince Mansel on 11/19/11.
//  Copyright (c) 2011 Wave Ocean Software. All rights reserved.
//

#import "FlyPlaceAppDelegate.h"
//#import "FlickrFetcher.h"
#import "PlacesTableViewController.h"
#import "PhotosTableViewController.h"
#import "RecentlyViewedTableViewController.h"

@implementation FlyPlaceAppDelegate

@synthesize window = _window;

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL) iPad
{
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
//    NSArray *topPlacesCheck = [FlickrFetcher topPlaces];
//    NSLog(@"Top Places: %@", [FlickrFetcher topPlaces]);
    
    PlacesTableViewController *placesTVC = [[PlacesTableViewController alloc] init];
    placesTVC.title = @"Places";
    PhotosTableViewController *recentPhotosTVC = [[RecentlyViewedTableViewController alloc] init];
    recentPhotosTVC.title = @"Recently Viewed";
    
    UINavigationController *placesNav = [[UINavigationController alloc] init];
    UINavigationController *recentNav = [[UINavigationController alloc] init];
    [placesNav pushViewController:placesTVC animated:NO];
    [recentNav pushViewController:recentPhotosTVC animated:NO];
    
    UITabBarController *tbc = tbc = [[UITabBarController alloc] init];
    tbc.viewControllers = [NSArray arrayWithObjects:placesNav, recentNav, nil];
    
    if (NO) { // 11/24/2011 - Inhibiting iPad functionaly until issue is resolved.
        UISplitViewController *svc = [[UISplitViewController alloc] init];
        
        UINavigationController *rightNav = [[UINavigationController alloc] init];
        
        placesTVC.detailViewController = placesTVC.locationPhotosTVC.photoDetailViewController;
        [rightNav pushViewController:placesTVC.locationPhotosTVC.photoDetailViewController animated:NO];
        svc.delegate = placesTVC.locationPhotosTVC.photoDetailViewController;
        svc.viewControllers = [NSArray arrayWithObjects:tbc, rightNav, nil];
        
        [rightNav release];
        [tbc release];
        [self.window addSubview:svc.view];
    }
    else {
        [self.window addSubview:tbc.view];
    }
    
    [placesNav release]; [recentNav release];
    [placesTVC release]; [recentPhotosTVC release];
    
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
