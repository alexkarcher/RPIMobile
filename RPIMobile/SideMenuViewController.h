//
//  SideMenuViewController.h
//  MFSideMenuDemo
//
//  Created by Michael Frederick on 3/19/12.

#import <UIKit/UIKit.h>
//#import "ORGMEngine.h"

@interface SideMenuViewController : UITableViewController {
    NSArray *_menuItems;
//    ORGMEngine *player;
}

@property (strong) NSArray *_menuItems;

@end