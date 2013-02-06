//
//  PrettyNavigationController.m
//  RPIMobile
//
//  Created by Stephen Silber on 5/20/12.
//  Copyright (c) 2012 Rensselaer Polytechnic Institute. All rights reserved.
//

#import "PrettyNavigationController.h"
#import "PrettyKit.h"

@implementation PrettyNavigationController
- (id)initWithRootViewController:(UIViewController *)rootViewController
{
    if ((self = [super initWithRootViewController:rootViewController])) {
        NSLog(@"Initializing Pretty Bar!");
        //temporary fix to get PrettyKit working in the rest of the app.
        PrettyNavigationBar *navBar = [[PrettyNavigationBar alloc] init];
        
        navBar.topLineColor = [UIColor colorWithHex:0xFF1000];
        navBar.gradientStartColor = [UIColor colorWithHex:0xDD0000];
        navBar.gradientEndColor = [UIColor colorWithHex:0xAA0000];    
        navBar.bottomLineColor = [UIColor colorWithHex:0x990000];   
        navBar.tintColor = navBar.gradientEndColor;
//        navBar.roundedCornerRadius = 2;
        
        [self setValue:navBar forKeyPath:@"navigationBar"];
    }
    return self;
}
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView
 {
 }
 */

/*
 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 - (void)viewDidLoad
 {
 [super viewDidLoad];
 }
 */

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
