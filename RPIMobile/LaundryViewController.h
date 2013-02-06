//
//  LaundryViewController.h
//  RPIMobile
//
//  Created by Stephen Silber on 9/23/12.
//  Copyright (c) 2012 Rensselaer Polytechnic Institute. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LaundryViewController : UITableViewController {
    NSMutableArray *laundryMachines;
}

@property (nonatomic) NSMutableArray *laundryMachines;

@end
