//
//  AthleteViewController.m
//  RPIMobile
//
//  Created by Stephen Silber on 6/26/12.
//  Copyright (c) 2012 Rensselaer Polytechnic Institute. All rights reserved.
//

#import "VideoWebviewViewController.h"

/*To-do for Web View:
 -Add rotation support!
 */

@implementation VideoWebviewViewController

@synthesize _webview, _webviewURL;
@synthesize isVideo;
@synthesize m_activity;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
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

-(void) webViewDidStartLoad:(UIWebView *)webView {
    [m_activity startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)_webView {
    [m_activity stopAnimating];
    UIButton *b = [self findButtonInView:_webView];
    [b sendActionsForControlEvents:UIControlEventTouchUpInside];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"Init with URL: %@", _webviewURL);
    [self._webview loadRequest:[NSURLRequest requestWithURL:_webviewURL]];
    m_activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    UIBarButtonItem * barButton = [[UIBarButtonItem alloc] initWithCustomView:m_activity];
    
    // Set download indicator
    [[self navigationItem] setRightBarButtonItem:barButton];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self._webview stopLoading];
}

//Need to add support for landscape video/webview
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (BOOL) shouldAutorotate {
    return YES;
}

- (NSUInteger) supportedInterfaceOrientations {
    return UIInterfaceOrientationLandscapeLeft | UIInterfaceOrientationLandscapeRight | UIInterfaceOrientationPortrait;
}

@end
