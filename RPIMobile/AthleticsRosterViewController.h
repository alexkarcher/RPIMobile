//
//  AthleticsRosterViewController.h
//  RPIMobile
//
//  Created by Stephen Silber on 9/28/12.
//  Copyright (c) 2012 Rensselaer Polytechnic Institute. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AthleticsRosterViewController : UITableViewController {
    NSMutableArray *rosterData;
    NSString *_shortSportName;
}

@property (nonatomic) NSString *_shortSportName;

- (id)initWithStyle:(UITableViewStyle)style name:(NSString *)shortSportName;
@end
