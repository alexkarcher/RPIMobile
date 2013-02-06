//
//  SportNewsViewController.h
//  RPIMobile
//
//  Created by Stephen Silber on 6/21/12.
//  Copyright (c) 2012 Rensselaer Polytechnic Institute. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrettyKit.h"

@interface SportNewsViewController : UITableViewController {
    NSString *feedURL;
    
    NSArray *newsItems;
    NSMutableArray *parsedItems;
    NSDateFormatter *formatter;
    
    NSArray *entries;
    NSString *_shortSportName;
}

@property (nonatomic) NSString *_shortSportName;
@property (strong) NSString *feedURL;
@property (strong) NSArray *newsItems;

- (id)initWithStyle:(UITableViewStyle)style name:(NSString *)shortSportName;

@end
