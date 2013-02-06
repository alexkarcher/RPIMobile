//
//  MenuViewController.m
//  RPIMobile
//
//  Created by Stephen Silber on 7/29/12.
//  Copyright (c) 2012 Rensselaer Polytechnic Institute. All rights reserved.
//

#import "MenuViewController.h"

@interface MenuItem : NSObject
@property (strong) NSString *title;
@property (strong) UIImage *icon;

@end

@implementation MenuItem

-(id)initWithTitle:(NSString *)menuTitle icon:(UIImage *)menuIcon {
    self = [super init];
    if(self) {
        self.title = menuTitle;
        self.icon = menuIcon;
    }
    
    return self;
}

@end
@interface MenuViewController ()

@end

@implementation MenuViewController

@synthesize menuTable, headerImage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    MenuItem *eventsItem = [[MenuItem alloc] initWithTitle:@"Events" icon:[UIImage imageNamed:@"events.png"]];
    MenuItem *newsItem = [[MenuItem alloc] initWithTitle:@"News" icon:[UIImage imageNamed:@"newsIcon.png"]];
    MenuItem *directoryItem = [[MenuItem alloc] initWithTitle:@"Directory" icon:[UIImage imageNamed:@"directoryIcon.png"]];
    MenuItem *mapItem = [[MenuItem alloc] initWithTitle:@"Map" icon:[UIImage imageNamed:@"mapIcon.png"]];
    MenuItem *twitterItem = [[MenuItem alloc] initWithTitle:@"Twitter" icon:[UIImage imageNamed:@"twitterIcon.png"]];
    MenuItem *shuttleItem = [[MenuItem alloc] initWithTitle:@"Shuttle Tracker" icon:[UIImage imageNamed:@"shuttleIcon.png"]];
    MenuItem *athleticsItem = [[MenuItem alloc] initWithTitle:@"Athletics" icon:[UIImage imageNamed:@"athleticsIcon.png"]];
    MenuItem *weatherItem = [[MenuItem alloc] initWithTitle:@"Weather" icon:[UIImage imageNamed:@"weatherIcon.png"]];
    MenuItem *videoItem = [[MenuItem alloc] initWithTitle:@"Videos" icon:[UIImage imageNamed:@"videosIcon.png"]];
    MenuItem *qrItem = [[MenuItem alloc] initWithTitle:@"QR Scanner" icon:[UIImage imageNamed:@"qrIcon.png"]];
    MenuItem *redditItem = [[MenuItem alloc] initWithTitle:@"RPI Reddit" icon:[UIImage imageNamed:@"events.png"]];
    MenuItem *radioItem = [[MenuItem alloc] initWithTitle:@"WRPI Radio" icon:[UIImage imageNamed:@"radioIcon.png"]];
    
    menuItems = [NSArray arrayWithObjects:eventsItem, newsItem, directoryItem, mapItem, twitterItem, shuttleItem, athleticsItem, weatherItem, videoItem, qrItem, redditItem, radioItem, nil];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return menuItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = [[menuItems objectAtIndex:indexPath.row] title];
    cell.imageView.image = [[menuItems objectAtIndex:indexPath.row] icon];
    
    return cell;
    
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
