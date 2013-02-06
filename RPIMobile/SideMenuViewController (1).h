//
//  SideMenuViewController.h
//  MFSideMenuDemo
//
//  Created by Michael Frederick on 3/19/12.

#import <UIKit/UIKit.h>

@interface SideMenuViewController : UITableViewController {
    NSArray *_menuItems;
}

@property (strong) NSArray *_menuItems;

@end