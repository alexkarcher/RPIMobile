//
//  AthleticsMainViewController.h
//  RPIMobile
//
//  Created by Stephen Silber on 9/27/12.
//  Copyright (c) 2012 Rensselaer Polytechnic Institute. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SVSegmentedControl;

@interface AthleticsMainViewController : UITableViewController {
    NSDictionary *_sportsDic;
    
    NSMutableArray *_sportsKeys;
    
    NSString *_currentGender;
    SVSegmentedControl *genderControl;
}

@property (nonatomic) NSString *_currentGender;
@property (nonatomic, strong) SVSegmentedControl *genderControl;

@end
