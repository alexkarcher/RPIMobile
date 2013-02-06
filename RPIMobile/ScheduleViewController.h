//
//  ScheduleViewController.h
//  RPIMobile
//
//  Created by Stephen Silber on 6/23/12.
//  Copyright (c) 2012 Rensselaer Polytechnic Institute. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScheduleViewController : UITableViewController {
    NSString *scheduleURL;
    NSMutableArray *scheduleData;
}

@property (nonatomic, retain) NSMutableArray *scheduleData;
@property (nonatomic, retain) NSString *scheduleURL;
@property (nonatomic, retain) NSArray* entries;



@end
