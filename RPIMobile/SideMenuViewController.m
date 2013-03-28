//
//  SideMenuViewController.m
//  MFSideMenuDemo
//
//  Created by Michael Frederick on 3/19/12.

#import "SideMenuViewController.h"
#import "MFSideMenu.h"
#import "PrettyKit.h"
#import "UIImage+Tint.h"



//Import Views Here
#import "NewsViewController.h"
#import "WeatherViewController.h"
#import "AthleticsViewController.h"
#import "MenuViewController.h"
#import "VideoFeedViewController.h"
#import "DirectoryMasterViewController.h"
#import "TwitterTimelineViewController.h"
#import "LaundryViewController.h"
#import "MainMapViewController.h"
#import "STMapViewController.h"
#import "AthleticsMainViewController.h"
#import "CampusMapViewController.h"
//#import "EventsMainViewController.h"

//Temporary for presentation
#include "PresentationNotReadyViewController.h"


#define start_color [UIColor colorWithHex:0x343434]
#define end_color [UIColor colorWithHex:0x343434]
#define kHeaderHeight 40
@interface menuItems : NSObject {
    NSString *_name;
    NSString *_imageName;
    NSString *_viewControllerName;
}

@property (strong) NSString *_name, *_imageName, *_viewControllerName;

@end

@implementation menuItems

@synthesize _imageName, _name, _viewControllerName;

- (id) initWithName:(NSString *)name image:(NSString *)image {
    if(self = [super init]) {
        self._name = name;
        self._imageName = image;
    }
    
    return self;
}
@end

@implementation SideMenuViewController
@synthesize _menuItems;
#pragma mark - UITableViewDataSource

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    return [NSString stringWithFormat:@"Section %d", section];
    return @"";
}

- (void) viewDidLoad {

    [super viewDidLoad];

    self.tableView.rowHeight = 50;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
    self.tableView.separatorColor = [UIColor colorWithHex:0x222222];
    
    // Menu item allocation
    menuItems *menuNews = [[menuItems alloc] initWithName:@"News" image:@"announcement_icon"];
    menuItems *menuLaundry = [[menuItems alloc] initWithName:@"Laundry" image:@"laundry_icon" ];
    menuItems *menuMap = [[menuItems alloc] initWithName:@"Map" image:@"map_icon"];
    menuItems *menuTwitter = [[menuItems alloc] initWithName:@"Twitter" image:@"twitter_icon"];
    menuItems *menuAthletics = [[menuItems alloc] initWithName:@"Athletics" image:@"athletics_icon"];
    menuItems *menuEvents = [[menuItems alloc] initWithName:@"Events" image:@"event_icon"];
    menuItems *menuShuttles = [[menuItems alloc] initWithName:@"Shuttles" image:@"shuttle_icon"];
    menuItems *menuDirectory = [[menuItems alloc] initWithName:@"Directory" image:@"directory_icon"];
    menuItems *menuVideos = [[menuItems alloc] initWithName:@"Videos" image:@"video_icon"];

    // Controls the order of the menu items along with #define statements below **looking for better alternative
    _menuItems = [[NSArray alloc] initWithObjects:menuNews, menuLaundry, menuMap, menuTwitter, menuAthletics, menuEvents, menuShuttles, menuDirectory, menuVideos, nil];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _menuItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    PrettyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[PrettyTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.tableViewBackgroundColor = tableView.backgroundColor;
        cell.gradientStartColor = start_color;
        cell.gradientEndColor = end_color;
        cell.borderColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.selectionGradientStartColor = [UIColor colorWithHex:0x777777];
        cell.selectionGradientEndColor = [UIColor colorWithHex:0x777777];
    }
    
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.text = [[_menuItems objectAtIndex:indexPath.row] _name];
    
    UIImage *icon = [UIImage imageNamed:[[_menuItems objectAtIndex:indexPath.row] _imageName]];
    icon = [icon imageTintedWithColor:[UIColor whiteColor]];
    [cell.imageView setImage:icon];
    cell.cornerRadius = 0.3f;
    
    return cell;
}


#pragma mark - UITableViewDelegate

// Controls which view controller to push when menu item selected
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    /* Menu Order  -- Must also restructure 
     array allocation with objects order */
    #define menuNews        0
    #define menuLaundry     1
    #define menuMap         2
    #define menuTwitter     3
    #define menuAthletics   4
    #define menuEvents      5
    #define menuShuttles    6
    #define menuDirectory   7
    #define menuVideos      8
    
    
    int indexRow = indexPath.row;
    NSArray *controllers;
    
    if(indexRow == menuNews) {
        NewsViewController *nextView = [[NewsViewController alloc] initWithNibName:@"NewsViewController" bundle:nil];
        controllers = [NSArray arrayWithObject:nextView];
    } else if(indexRow == menuLaundry) {
        LaundryViewController *nextView = [[LaundryViewController alloc] initWithStyle:UITableViewStyleGrouped];
        controllers = [NSArray arrayWithObject:nextView];
    } else if(indexRow == menuMap) {
        CampusMapViewController *nextView = [[CampusMapViewController alloc] init];
        controllers = [NSArray arrayWithObject:nextView];
    } else if(indexRow == menuTwitter) {
        TwitterTimelineViewController *nextView = [[TwitterTimelineViewController alloc] initWithStyle:UITableViewStylePlain];
        controllers = [NSArray arrayWithObject:nextView];
    } else if(indexRow == menuAthletics) {
        AthleticsMainViewController *nextView = [[AthleticsMainViewController alloc] initWithStyle:UITableViewStylePlain];
        controllers = [NSArray arrayWithObject:nextView];
    } else if(indexRow == menuEvents) {
        PresentationNotReadyViewController *nextView = [[PresentationNotReadyViewController alloc] init];
        controllers = [NSArray arrayWithObject:nextView];
    } else if(indexRow == menuShuttles) {
        STMapViewController *nextView = [[STMapViewController alloc] init];
        controllers = [NSArray arrayWithObject:nextView];
    } else if(indexRow == menuDirectory) {
        DirectoryMasterViewController *nextView = [[DirectoryMasterViewController alloc] initWithNibName:@"DirectoryMasterViewController" bundle:nil];
        controllers = [NSArray arrayWithObject:nextView];
    } else if(indexRow == menuVideos) {
        VideoFeedViewController *nextView = [[VideoFeedViewController alloc] init];
        controllers = [NSArray arrayWithObject:nextView];
    }

    [MFSideMenuManager sharedManager].navigationController.viewControllers = controllers;
    [MFSideMenuManager sharedManager].navigationController.menuState = MFSideMenuStateHidden;
}

@end
