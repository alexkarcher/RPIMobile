//
//  MenuViewController.h
//  RPIMobile
//
//  Created by Stephen Silber on 7/29/12.
//  Copyright (c) 2012 Rensselaer Polytechnic Institute. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    UITableView *menuTable;
    UIImageView *headerImage;
    NSArray *menuItems;
}

@property (strong) IBOutlet UITableView *menuTable;
@property (strong) IBOutlet UIImageView *headerImage;

@end
