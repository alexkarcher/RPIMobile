//
//  AthleticsScheduleViewController.h
//  RPIMobile
//
//  Created by Stephen Silber on 10/10/12.
//  Copyright (c) 2012 Rensselaer Polytechnic Institute. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AthleticsScheduleViewController : UITableViewController {
    NSString *_shortSportName;
    NSMutableArray *scheduleData;
}

-(id) initWithStyle:(UITableViewStyle)style name:(NSString *)shortSportName;

@end
