//
//  RMCalendarEventViewController.h
//  RPIMobile
//
//  Created by Stephen Silber on 4/3/13.
//  Copyright (c) 2013 Rensselaer Polytechnic Institute. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrettyKit.h"

@class RMCalendarEvent;

@interface RMCalendarEventViewController : UITableViewController

- (id) initWithEvent:(RMCalendarEvent *) event;
@end
