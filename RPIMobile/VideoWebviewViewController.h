//
//  AthleteViewController.h
//  RPIMobile
//
//  Created by Stephen Silber on 6/26/12.
//  Copyright (c) 2012 Rensselaer Polytechnic Institute. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoWebviewViewController : UIViewController <UIWebViewDelegate> {
    UIWebView *_webview;
    NSURL *_webviewURL;
    BOOL isVideo;
    UIActivityIndicatorView *m_activity;
}

@property (strong) IBOutlet UIWebView *_webview;
@property (nonatomic) NSURL *_webviewURL;
@property (readwrite) BOOL isVideo;
@property (strong) UIActivityIndicatorView *m_activity;


@end
