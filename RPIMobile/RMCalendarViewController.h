//
//  RMCalendarViewController.h
//  RPIMobile
//
//  Created by Stephen Silber on 3/5/13.
//  Copyright (c) 2013 Rensselaer Polytechnic Institute. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ABCalendarPicker.h"

@interface RMCalendarViewController : UIViewController <ABCalendarPickerDataSourceProtocol, ABCalendarPickerDelegateProtocol, UITableViewDataSource, UITableViewDelegate> {
    
}

@end
