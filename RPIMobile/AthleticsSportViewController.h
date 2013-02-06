//
//  AthleticsSportViewController.h
//  RPIMobile
//
//  Created by Stephen Silber on 9/27/12.
//  Copyright (c) 2012 Rensselaer Polytechnic Institute. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AthleticsSportViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    NSString *_sportName;
    NSString *_shorSportName;
    
    NSArray *_menuItems;
    UIImageView *teamPic;
    UIProgressView *progressView;
    
    UITableView *menuList;
    UILabel *noImageLabel;
}

@property (nonatomic) NSString *_sportName, *_shortSportName;
@property (nonatomic) UIImageView *teamPic;
@property (nonatomic) UIProgressView *progressView;

@property UITableView *menuList;
@property UILabel *noImageLabel;


@end
