//
//  ViewController.m
//  AirplayDemoTest
//
//  Created by Johnny Sung on 5/12/13.
//  Copyright (c) 2013 Johnny Sung. All rights reserved.
//

#import "ViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "UIViewController+ScreenText.h"
#import "AppDelegate.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UISwitch *sperateView_switch;
@property (strong, nonatomic) IBOutlet UILabel *ScreenNumLabel;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    // Register for notification
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(screenConnected:)
												 name:UIScreenDidConnectNotification
											   object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(screenDisconnected:)
												 name:UIScreenDidDisconnectNotification
											   object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(statusFrameChanged:)
                                                 name:UIApplicationWillChangeStatusBarFrameNotification
                                               object:nil];
}

-(void) viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIScreenDidConnectNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIScreenDidDisconnectNotification object:nil];

    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationWillChangeStatusBarFrameNotification
                                                  object:nil];
    
    [self setScreenNumLabel:nil];
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    UIWindow        *_window    = nil;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // Triple it!
    _window = [[self view] window];
    CGFloat scale = [[_window screen] scale];
    
    NSLog(@"scale: %f", scale);
    
    [self screenNumberUpdate];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)option_sperateView_changed:(id)sender {
    [[AppDelegate sharedDelegate] useSperateView:self.sperateView_switch.on];
}

- (void) screenConnected:(NSNotification *) notification
{
    [self screenNumberUpdate];
}
- (void) screenDisconnected:(NSNotification *) notification
{
    [self screenNumberUpdate];
}

- (void) statusFrameChanged:(NSNotification *) notification
{
    [self screenNumberUpdate];
}

- (void) screenNumberUpdate
{
    self.ScreenNumLabel.text=[self screenText];
    self.sperateView_switch.enabled=([[UIScreen screens] count]>1);
}

@end
