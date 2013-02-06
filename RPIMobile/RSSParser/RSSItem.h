//
//  RSSItem.h
//  RSSParser
//
//  Created by Thibaut LE LEVIER on 2/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RSSItem : NSObject

@property (strong) NSString *title;
@property (strong) NSString *itemDescription;
@property (strong) NSString *content;
@property (strong) NSURL *link;
@property (strong) NSURL *commentsLink;
@property (strong) NSURL *commentsFeed;
@property (strong) NSNumber *commentsCount;
@property (strong) NSDate *pubDate;
@property (strong) NSString *author;
@property (strong) NSString *guid;

-(NSArray *)imagesFromItemDescription;
-(NSArray *)imagesFromContent;

@end
