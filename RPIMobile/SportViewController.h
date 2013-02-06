//
//  SportViewController.h
//  RPIMobile
//
//  Created by Stephen Silber on 6/18/12.
//  Copyright (c) 2012 Rensselaer Polytechnic Institute. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SportViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    NSArray *listItems;
    UITableView *menuList;
    UIImageView *teamPicture;
    UIProgressView *progressBar;
    
    UILabel *noImage;
    
    NSString *teamPicURL;
    
    NSString *sportName;
    NSString *currentGender;
    NSString *currentLink;
    
    NSMutableArray *links;
}

@property (strong) IBOutlet UITableView *menuList;
@property (strong) IBOutlet UIImageView *teamPicture;
@property (strong) IBOutlet UIProgressView *progressBar;
@property (strong) IBOutlet UILabel *noImage;
@property (strong) NSString *sportName, *currentGender, *currentLink;

@end
