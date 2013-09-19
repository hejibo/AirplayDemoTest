//
//  AppDelegate.m
//  AirplayDemoTest
//
//  Created by Johnny Sung on 5/12/13.
//  Copyright (c) 2013 Johnny Sung. All rights reserved.
//

#import "AppDelegate.h"

#import "ViewController.h"
#import "ViewController_TV.h"
@interface AppDelegate ()

@property(nonatomic) BOOL sperate_on;
- (UIWindow *)  createWindowForScreen:(UIScreen *)screen;
- (void)        addViewController:(UIViewController *)controller toWindow:(UIWindow *)window;
- (void)        screenDidConnect:(NSNotification *) notification;
- (void)        screenDidDisconnect:(NSNotification *) notification;
@end

@implementation AppDelegate

@synthesize windows;

+ (AppDelegate *)sharedDelegate {
	// Just a wrapper of [UIApplication sharedApplication].delegate.
	return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    UIWindow    *window    = nil;
    NSArray     *screens   = nil;
    
    windows = [[NSMutableArray alloc] init];
    
    screens = [UIScreen screens];
    for (UIScreen *screen in screens){
        
        NSLog(@"%.0fx%.0f", [screen bounds].size.width, [screen bounds].size.height);

        window = [self createWindowForScreen:screen];
        
        // If you don't do this here, you will get the "Applications are expected to have a root view controller" message.
        if (screen == [UIScreen mainScreen]){
        
            ViewController *viewController = nil;
            
            viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
            window.rootViewController=viewController;
            viewController = nil;
            
            [window makeKeyAndVisible];
            NSLog(@"isMainScreen");
        }else{
            
            ViewController_TV *viewController = nil;
            
            viewController = [[ViewController_TV alloc] initWithNibName:@"ViewController_TV" bundle:nil];
            window.rootViewController=viewController;
            viewController = nil;
            NSLog(@"~***~W: %.0f H:%.0f", window.bounds.size.width, window.bounds.size.height);
            window.hidden=NO;
            NSLog(@"is NOT MainScreen");
            self.sperate_on=YES;
        }
    }
    
    // Register for notification
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(screenDidConnect:)
												 name:UIScreenDidConnectNotification
											   object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(screenDidDisconnect:)
												 name:UIScreenDidDisconnectNotification
											   object:nil];
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
    
    // Unregister for notifications
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIScreenDidConnectNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIScreenDidDisconnectNotification object:nil];
}

-(void) useSperateView:(BOOL)sperate_on
{
    NSLog(@"setScreenMirror=%@", sperate_on?@"YES":@"NO");
    UIWindow    *window    = nil;
    NSArray     *screens   = nil;
    screens = [UIScreen screens];
    for (UIScreen *screen in screens){
        window = [self createWindowForScreen:screen];
        if (screen != [UIScreen mainScreen]){
            if (sperate_on) {
                
                ViewController_TV *viewController = nil;
                
                viewController = [[ViewController_TV alloc] initWithNibName:@"ViewController_TV" bundle:nil];
                window.rootViewController=viewController;
                viewController = nil;
                
                window.hidden=NO;
                window.screen=screen;
                self.sperate_on=YES;
            }else{
                window.hidden=YES;
                window.screen=nil;
                self.sperate_on=NO;
            }
            break;
        }
    }
}

-(BOOL) isSperateView
{
    UIWindow    *window    = nil;
    NSArray     *screens   = nil;
    screens = [UIScreen screens];
    for (UIScreen *screen in screens){
        window = [self createWindowForScreen:screen];
        if (screen != [UIScreen mainScreen])
        {
            if(window.screen==nil)
                return YES;
            else
                return NO;
        }
    }
    return YES;
}


#pragma mark Private methods

- (UIWindow *) createWindowForScreen:(UIScreen *)screen {
    UIWindow    *tWindow    = nil;
    
    // Do we already have a window for this screen?
    for (UIWindow *window in self.windows){
        if (window.screen == screen){
            tWindow = window;
        }
    }
    // Still nil? Create a new one.
    if (tWindow == nil){
        tWindow = [[UIWindow alloc] initWithFrame:[screen bounds]];
        tWindow.screen=screen;
        [self.windows addObject:tWindow];
    }
    
    return tWindow;
}

- (void) addViewController:(UIViewController *)controller toWindow:(UIWindow *)window {
    window.rootViewController=controller;
    window.hidden=NO;
}

- (void) screenDidConnect:(NSNotification *) notification {
    UIScreen                    *screen            = nil;
    UIWindow                    *window            = nil;
    
    NSLog(@"Screen connected");
    screen = [notification object];

    ViewController_TV *viewController = [[ViewController_TV alloc] initWithNibName:@"ViewController_TV" bundle:nil];
    
    window = [self createWindowForScreen:screen];
    [self addViewController:viewController toWindow:window];
    
    [self useSperateView:self.sperate_on];
}

- (void) screenDidDisconnect:(NSNotification *) notification {
    UIScreen    *screen    = nil;
    
    NSLog(@"Screen disconnected");
    screen = [notification object];
    
    // Find any window attached to this screen, remove it from our window list, and release it.
    for (UIWindow *window in self.windows){
        if (window.screen == screen){
            NSUInteger windowIndex = [self.windows indexOfObject:window];
            [self.windows removeObjectAtIndex:windowIndex];
            // If it wasn't autorelease, you would deallocate it here.
        }
    }
    return;
}


@end
