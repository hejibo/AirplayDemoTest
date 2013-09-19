//
//  AppDelegate.h
//  AirplayDemoTest
//
//  Created by Johnny Sung on 5/12/13.
//  Copyright (c) 2013 Johnny Sung. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

//@property (strong, nonatomic) ViewController *viewController;

@property (nonatomic, retain) NSMutableArray *windows;

+ (AppDelegate *)sharedDelegate;
-(void) useSperateView:(BOOL)sperate_on;
-(BOOL) isSperateView;
@end
