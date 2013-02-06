//
//  NewsViewController.h
//  RPIMobile
//
//  Created by Stephen Silber on 5/20/12.
//  Copyright (c) 2012 Rensselaer Polytechnic Institute. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKHorizMenu.h"
#import "MFSideMenu.h"

@interface NewsViewController : UIViewController < MKHorizMenuDataSource, MKHorizMenuDelegate, UITableViewDelegate, UITableViewDataSource> {
    NSMutableDictionary *newsFeeds;

    UIImage *launcherImage;
    IBOutlet UITableView *newsTable;
    
    MKHorizMenu *_horizMenu;
    NSMutableArray *_items;
    
    BOOL isAthletics;
    
    NSArray *newsItems;
    NSDateFormatter *formatter;
}

@property (strong) IBOutlet MKHorizMenu *horizMenu;
@property (strong) IBOutlet UITableView *newsTable;
@property (strong) NSMutableArray *items;
@property (strong) NSArray *newsItems;
@property (strong) UIImage *launcherImage;

@end
