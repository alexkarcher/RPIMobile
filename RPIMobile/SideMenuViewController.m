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
#import "EventsMainViewController.h"

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

- (id) initWithName:(NSString *)name image:(NSString *)image viewController:(NSString *)viewName {
    if(self = [super init]) {
        self._name = name;
        self._imageName = image;
        self._viewControllerName = viewName;
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
//    CGRect oldSize = self.view.frame;
//    [self.view setFrame:CGRectMake(0, 0, oldSize.size.width/2, oldSize.size.height)];
    [super viewDidLoad];
    
//    player = [[ORGMEngine alloc] init];
//    NSURL *playerURL = [NSURL URLWithString:@"http://icecast1.wrpi.org:8000/mp3-128.mp3.m3u"];
//    [player playUrl:playerURL];
    
    self.tableView.rowHeight = 50;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
    self.tableView.separatorColor = [UIColor colorWithHex:0x222222];

    
    menuItems *menuNews = [[menuItems alloc] initWithName:@"News" image:@"announcement_icon" viewController:@"NewsViewController"];
    menuItems *menuWeather = [[menuItems alloc] initWithName:@"Weather" image:@"weather_icon" viewController:@"WeatherViewController"];
    menuItems *menuLaundry = [[menuItems alloc] initWithName:@"Laundry" image:@"laundry_icon" viewController:@"none"];
    menuItems *menuTwitter = [[menuItems alloc] initWithName:@"Twitter" image:@"twitter_icon" viewController:@"TwitterTimelineViewController"];
    menuItems *menuAthletics = [[menuItems alloc] initWithName:@"Athletics" image:@"athletics_icon" viewController:@"AthleticsMainViewController"];
    menuItems *menuEvents = [[menuItems alloc] initWithName:@"Events" image:@"event_icon" viewController:@"EventsViewController"];
    menuItems *menuShuttles = [[menuItems alloc] initWithName:@"Shuttles" image:@"shuttle_icon" viewController:@"STMapViewController"];
    menuItems *menuDirectory = [[menuItems alloc] initWithName:@"Directory" image:@"directory_icon" viewController:@"DirectoryMasterViewController"];
    menuItems *menuTV = [[menuItems alloc] initWithName:@"TV Listings" image:@"tv_icon" viewController:@"none"];
    menuItems *menuBuilding = [[menuItems alloc] initWithName:@"Building Hours" image:@"map_icon" viewController:@"none"];
    menuItems *menuVideos = [[menuItems alloc] initWithName:@"Videos" image:@"video_icon" viewController:@"none"];
    menuItems *menuMap = [[menuItems alloc] initWithName:@"Map" image:@"map_icon" viewController:@"CampusMapViewController"];
    
    //Initialize menu array and link with views above
    _menuItems = [[NSArray alloc] initWithObjects:menuNews, menuWeather, menuLaundry, menuTwitter, menuAthletics, menuEvents, menuShuttles, menuDirectory, menuTV, menuBuilding, menuVideos, menuMap, nil];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if(indexPath.row == 0) {
        NewsViewController *nextView = [[NewsViewController alloc] initWithNibName:@"NewsViewController" bundle:nil];
        NSArray *controllers = [NSArray arrayWithObject:nextView];
        [MFSideMenuManager sharedManager].navigationController.viewControllers = controllers;
        [MFSideMenuManager sharedManager].navigationController.menuState = MFSideMenuStateHidden;

    } else if(indexPath.row == 1) {
//        WeatherViewController *nextView = [[WeatherViewController alloc] initWithNibName:@"WeatherViewController" bundle:nil];
        PresentationNotReadyViewController *nextView = [[PresentationNotReadyViewController alloc] initWithNibName:@"PresentationNotReadyViewController" bundle:nil];
        NSArray *controllers = [NSArray arrayWithObject:nextView];
        [MFSideMenuManager sharedManager].navigationController.viewControllers = controllers;
        [MFSideMenuManager sharedManager].navigationController.menuState = MFSideMenuStateHidden;

    } else if(indexPath.row == 2) {
        LaundryViewController *nextView = [[LaundryViewController alloc] initWithStyle:UITableViewStyleGrouped];
        NSArray *controllers = [NSArray arrayWithObject:nextView];
        [MFSideMenuManager sharedManager].navigationController.viewControllers = controllers;
        [MFSideMenuManager sharedManager].navigationController.menuState = MFSideMenuStateHidden;

    }  else if(indexPath.row == 3) {
        TwitterTimelineViewController *nextView = [[TwitterTimelineViewController alloc] initWithStyle:UITableViewStylePlain];
        NSArray *controllers = [NSArray arrayWithObject:nextView];
        [MFSideMenuManager sharedManager].navigationController.viewControllers = controllers;
        [MFSideMenuManager sharedManager].navigationController.menuState = MFSideMenuStateHidden;
        
    } else if(indexPath.row == 4) {
        AthleticsMainViewController *nextView = [[AthleticsMainViewController alloc] initWithStyle:UITableViewStylePlain];
        NSArray *controllers = [NSArray arrayWithObject:nextView];
        [MFSideMenuManager sharedManager].navigationController.viewControllers = controllers;
        [MFSideMenuManager sharedManager].navigationController.menuState = MFSideMenuStateHidden;
        
    } else if(indexPath.row == 5) {
//        MapViewController *nextView = [[MapViewController alloc] init]; //EVENTS
        EventsMainViewController *nextView = [[EventsMainViewController alloc] init];
        NSArray *controllers = [NSArray arrayWithObject:nextView];
        [MFSideMenuManager sharedManager].navigationController.viewControllers = controllers;
        [MFSideMenuManager sharedManager].navigationController.menuState = MFSideMenuStateHidden;
        
    }else if(indexPath.row == 6) {
        STMapViewController *nextView = [[STMapViewController alloc] init];
        NSArray *controllers = [NSArray arrayWithObject:nextView];
        [MFSideMenuManager sharedManager].navigationController.viewControllers = controllers;
        [MFSideMenuManager sharedManager].navigationController.menuState = MFSideMenuStateHidden;
        
    } else if(indexPath.row == 7) {
        DirectoryMasterViewController *nextView = [[DirectoryMasterViewController alloc] initWithNibName:@"DirectoryMasterViewController" bundle:nil];
        NSArray *controllers = [NSArray arrayWithObject:nextView];
        [MFSideMenuManager sharedManager].navigationController.viewControllers = controllers;
        [MFSideMenuManager sharedManager].navigationController.menuState = MFSideMenuStateHidden;
        
    } else if(indexPath.row == 8) {
//        MapViewController *nextView = [[MapViewController alloc] init]; //EVENTS
        PresentationNotReadyViewController *nextView = [[PresentationNotReadyViewController alloc] initWithNibName:@"PresentationNotReadyViewController" bundle:nil];
        NSArray *controllers = [NSArray arrayWithObject:nextView];
        [MFSideMenuManager sharedManager].navigationController.viewControllers = controllers;
        [MFSideMenuManager sharedManager].navigationController.menuState = MFSideMenuStateHidden;
        
    }else if(indexPath.row == 9) {
//        MapViewController *nextView = [[MapViewController alloc] init];
        PresentationNotReadyViewController *nextView = [[PresentationNotReadyViewController alloc] initWithNibName:@"PresentationNotReadyViewController" bundle:nil];
        NSArray *controllers = [NSArray arrayWithObject:nextView];
        [MFSideMenuManager sharedManager].navigationController.viewControllers = controllers;
        [MFSideMenuManager sharedManager].navigationController.menuState = MFSideMenuStateHidden;
        
    } else if(indexPath.row == 10) {
        VideoFeedViewController *nextView = [[VideoFeedViewController alloc] init];
//        PresentationNotReadyViewController *nextView = [[PresentationNotReadyViewController alloc] initWithNibName:@"PresentationNotReadyViewController" bundle:nil];
        NSArray *controllers = [NSArray arrayWithObject:nextView];
        [MFSideMenuManager sharedManager].navigationController.viewControllers = controllers;
        [MFSideMenuManager sharedManager].navigationController.menuState = MFSideMenuStateHidden;
    } else if(indexPath.row == 11) {
        CampusMapViewController *nextView = [[CampusMapViewController alloc] init];
        NSArray *controllers = [NSArray arrayWithObject:nextView];
        [MFSideMenuManager sharedManager].navigationController.viewControllers = controllers;
        [MFSideMenuManager sharedManager].navigationController.menuState = MFSideMenuStateHidden;
    }

}

@end
