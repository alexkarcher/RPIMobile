//
//  VideoFeedViewController.h
//  RPIMobile
//
//  Created by Stephen Silber on 6/12/12.
//  Copyright (c) 2012 Rensselaer Polytechnic Institute. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoFeedViewController : UITableViewController {
    NSMutableDictionary *newsFeeds;
    UIImage *launcherImage;
//    IBOutlet UITableView *videoTable;
    NSString *feedURLString;

    NSMutableArray *_items;
    
    NSArray *newsItems;
    NSMutableArray *parsedItems;
    NSDateFormatter *formatter;
}

//@property (strong) IBOutlet UITableView *videoTable;
@property (strong) NSMutableArray *items;
@property (strong) NSArray *newsItems;
@property (nonatomic) UIImage *launcherImage;
@property (strong) NSString *feedURLString;
@end
