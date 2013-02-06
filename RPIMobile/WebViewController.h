//
//  AthleteViewController.h
//  RPIMobile
//
//  Created by Stephen Silber on 6/26/12.
//  Copyright (c) 2012 Rensselaer Polytechnic Institute. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController <UIWebViewDelegate> {
    UIWebView *athleteView;
    NSString *webviewURL;
    BOOL isVideo;
    UIActivityIndicatorView *m_activity;
}

@property (nonatomic, retain) IBOutlet UIWebView *athleteView;
@property (nonatomic, retain) NSString *webviewURL;
@property (readwrite) BOOL isVideo;
@end
