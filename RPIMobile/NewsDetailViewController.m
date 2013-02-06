//
//  NewsDetailViewController.m
//  RPIMobile
//
//  Created by Stephen Silber on 5/20/12.
//  Copyright (c) 2012 Rensselaer Polytechnic Institute. All rights reserved.
//

#import "NewsDetailViewController.h"
#import "PrettyKit.h"


@implementation NewsDetailViewController
@synthesize articleText, titleLabel, dateLabel, storyURL, newsBar;
@synthesize storyView, _backButton, _forwardButton;

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [m_activity startAnimating];
}

-(void) webViewDidFinishLoad:(UIWebView *)webView {
    [m_activity stopAnimating];
//    NSLog(@"CURRENT WEBVIEW URL: %@", [self.storyView request]);
}
-(IBAction)showCurrentURL:(id)sender {
    NSLog(@"CURRENT WEBVIEW URL: %@", [self.storyView request]);
    NSString *readScript = @"javascript:(function(){var script = document.createElement(\"script\");script.src = \"http://ajax.googleapis.com/ajax/libs/jquery/1/jquery.min.js\";script.onload = script.onreadystatechange = function(){$('.contentinfo').remove();};document.body.appendChild( script );})();";
    
    
    [storyView stringByEvaluatingJavaScriptFromString:readScript];
}

-(void) setTitleText:(NSString *)titleText date:(NSString *)dateText content:(NSString *)contentText url:(NSString *)urlText {
    [self.titleLabel setText:@"RPI News"];
    [self.dateLabel setText:dateText];
    [self.articleText setText:contentText];

    NSLog(@"Set up view with %@", titleText);
    NSLog(@"UILabel text: %@", titleLabel.text);
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.newsBar.topLineColor =  [UIColor colorWithHex:0xFF1000];
    self.newsBar.gradientStartColor = [UIColor colorWithHex:0xDD0000];
    self.newsBar.gradientEndColor = [UIColor colorWithHex:0xAA0000];    
    self.newsBar.bottomLineColor = [UIColor colorWithHex:0x990000];   
    self.newsBar.tintColor = self.newsBar.gradientEndColor;
    m_activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    UIBarButtonItem * barButton = [[UIBarButtonItem alloc] initWithCustomView:m_activity];
    
    // Set download indicator
    [[self navigationItem] setRightBarButtonItem:barButton];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
