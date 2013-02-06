//
//  AthleteViewController.m
//  RPIMobile
//
//  Created by Stephen Silber on 6/26/12.
//  Copyright (c) 2012 Rensselaer Polytechnic Institute. All rights reserved.
//

#import "WebViewController.h"

/*To-do for Web View:
    -Add rotation support!
    -Clean up memory management
 */

@implementation WebViewController
@synthesize athleteView, webviewURL, isVideo;

-(void) refresh {
    [self.athleteView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:webviewURL]]];
    NSLog(@"Refreshing with URL: %@", webviewURL);
}

//StackOverflow trick to find YouTube button and press play automatically
- (UIButton *)findButtonInView:(UIView *)view {
    UIButton *button = nil;
    
    if ([view isMemberOfClass:[UIButton class]]) {
        return (UIButton *)view;
    }
    
    if (view.subviews && [view.subviews count] > 0) {
        for (UIView *subview in view.subviews) {
            button = [self findButtonInView:subview];
            if (button) return button;
        }
    }
    
    return button;
}

- (void)webViewDidFinishLoad:(UIWebView *)_webView {
    [m_activity stopAnimating];
    // Refresh button for feed
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                                           target:self
                                                                                           action:@selector(refresh)];
    if(isVideo) {
        UIButton *b = [self findButtonInView:_webView];
        [b sendActionsForControlEvents:UIControlEventTouchUpInside];
        [self shouldAutorotateToInterfaceOrientation:UIInterfaceOrientationLandscapeRight];
    }
}

-(void)webViewDidStartLoad:(UIWebView *)webView {
    [m_activity startAnimating];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    m_activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    UIBarButtonItem * barButton = [[UIBarButtonItem alloc] initWithCustomView:m_activity];
    
    // Set download indicator
    [[self navigationItem] setRightBarButtonItem:barButton];
    [self.athleteView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:webviewURL]]];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self.athleteView stopLoading];
}

//Need to add support for landscape video/webview
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

@end
