//
//  NewsDetailViewController.h
//  RPIMobile
//
//  Created by Stephen Silber on 5/20/12.
//  Copyright (c) 2012 Rensselaer Polytechnic Institute. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrettyKit.h"
#import "PrettyToolbar.h"

@interface NewsDetailViewController : UIViewController <UITextViewDelegate, UIWebViewDelegate> {
    IBOutlet UILabel *dateLabel, *titleLabel;
    IBOutlet UITextView *articleText;
    IBOutlet PrettyToolbar *newsBar;
    IBOutlet UIWebView *storyView;
    
    NSArray *items;
    
    IBOutlet UIBarButtonItem *_backButton, *_forwardButton;
    NSString *storyURL;
    
    UIActivityIndicatorView *m_activity;
}

@property (strong) IBOutlet UIBarButtonItem *_backButton, *_forwardButton;
@property (strong) IBOutlet UILabel *dateLabel, *titleLabel;
@property (strong) IBOutlet UITextView *articleText;
@property (strong) NSString *storyURL;
@property (strong) IBOutlet PrettyToolbar *newsBar;
@property (strong) IBOutlet UIWebView *storyView;

-(void) setTitleText:(NSString *)titleText date:(NSString *)dateText content:(NSString *)contentText url:(NSString *)urlText;

-(IBAction)showCurrentURL:(id)sender;
@end


