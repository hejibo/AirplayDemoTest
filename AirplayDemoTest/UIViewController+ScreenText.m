//
//  UIViewController+ScreenUpdate.m
//  AirplayDemoTest
//
//  Created by Johnny Sung on 9/19/13.
//  Copyright (c) 2013 Johnny Sung. All rights reserved.
//

#import "UIViewController+ScreenText.h"

@implementation UIViewController (ScreenText)

- (NSString *) screenText
{
    NSArray* _screens = [UIScreen screens];
    
    CGRect screenRect = [[[[self view] window] screen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    return [NSString stringWithFormat:@"Screen: %d/%d (%.0fx%.0f)", [self screenNumber], [_screens count], screenWidth, screenHeight];
}

- (NSUInteger) screenNumber {
    NSUInteger  result      = 1;
    UIWindow    *_window    = nil;
    UIScreen    *_screen    = nil;
    NSArray     *_screens   = nil;
    
    _screens = [UIScreen screens];
    
    if ([_screens count] > 1){
        _window = [[self view] window];
        _screen = [_window screen];
        if (_screen != nil){
            for(size_t i = 0; i < [_screens count]; ++i){
                UIScreen *_currentScreen = [_screens objectAtIndex:i];
                if (_currentScreen == _screen){
                    result = i+1;
                }
            }
        }
    }
    return result;
}

@end
