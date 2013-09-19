//
//  ViewController.m
//  AirplayDemoTest
//
//  Created by Johnny Sung on 5/12/13.
//  Copyright (c) 2013 Johnny Sung. All rights reserved.
//

#import "ViewController_TV.h"
#import "UIViewController+ScreenText.h"

@interface ViewController_TV ()
@property (strong, nonatomic) IBOutlet UILabel *ScreenNumLabel;
@end

@implementation ViewController_TV

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    UIWindow        *_window    = nil;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // Set up the layer that draws our text.
    
    self.ScreenNumLabel.text=[self screenText];
    
    // Triple it!
    _window = [[self view] window];
    CGFloat scale = [[_window screen] scale];
    
    NSLog(@"scale: %f", scale);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
