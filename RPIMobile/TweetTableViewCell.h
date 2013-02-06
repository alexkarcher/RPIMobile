//
//  TweetTableViewCell.h
//  RPIMobile
//
//  Created by Stephen Silber on 8/17/12.
//  Copyright (c) 2012 Rensselaer Polytechnic Institute. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TweetTableViewCell : UITableViewCell {
    IBOutlet UIImageView *_avatar;
    IBOutlet UILabel *_username;
    IBOutlet UILabel *_timestamp;
    IBOutlet UITextView *_tweet;
    
}

@property (strong) IBOutlet UIImageView *_avatar;
@property (strong) IBOutlet UILabel *_username;
@property (strong) IBOutlet UILabel *_timestamp;
@property (strong) IBOutlet UITextView *_tweet;

/* Tweet Data */

@end
