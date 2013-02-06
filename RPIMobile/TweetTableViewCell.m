//
//  TweetTableViewCell.m
//  RPIMobile
//
//  Created by Stephen Silber on 8/17/12.
//  Copyright (c) 2012 Rensselaer Polytechnic Institute. All rights reserved.
//

#import "TweetTableViewCell.h"

@interface TweetTableViewCell ()

@end

@implementation TweetTableViewCell

@synthesize _avatar;
@synthesize _username;
@synthesize _tweet;
@synthesize _timestamp;

- (NSString *) formattedTimestamp:(NSString *)timestamp {
    
    return @"";
}
- (id) initWithUsername:(NSString *)username timestamp:(NSString *)timestamp tweet:(NSString *)tweet avatar:(UIImage *)avatar {
    if(self = [super init]) {
        self._username.text = username;
        self._timestamp.text = [self formattedTimestamp:timestamp];
        self._tweet.text = tweet;
        
        //Load avatar image from main viewcontroller. 
    }
    
    return self;
}
@end
