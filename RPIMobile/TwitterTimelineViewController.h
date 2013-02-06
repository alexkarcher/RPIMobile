//
//  TwitterTimelineViewController.h
//  RPIMobile
//
//  Created by Stephen Silber on 8/15/12.
//  Copyright (c) 2012 Rensselaer Polytechnic Institute. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TwitterTimelineViewController : UITableViewController {
    NSMutableArray *_tweets;
}

@property (strong) NSMutableArray *_tweets;

@end
