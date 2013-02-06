//
//  AthleticsRosterViewController.m
//  RPIMobile
//
//  Created by Stephen Silber on 9/28/12.
//  Copyright (c) 2012 Rensselaer Polytechnic Institute. All rights reserved.
//

#import "JSONKit.h"
#import "Athlete.h"
#import "AFNetworking.h"
#import "ImageManipulator.h"
#import "WebViewController.h"
#import "SVWebViewController.h"
#import "UIImageView+AFNetworking.h"
#import "AthleticsRosterViewController.h"

#import <QuartzCore/QuartzCore.h>

#define kRosterURL @"http://mobilerpi.jcmcmillan.com/v1/roster/"

@implementation AthleticsRosterViewController
@synthesize _shortSportName;;
- (id)initWithStyle:(UITableViewStyle)style name:(NSString *)shortSportName
{
    self = [super initWithStyle:style];
    if (self) {
        self->_shortSportName = shortSportName;
    }
    return self;
}

- (void) fetchRoster {
  
    
    UIActivityIndicatorView *activityIndicator =
    [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
    


    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kRosterURL, self->_shortSportName]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:6.0];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        //Successful roster download
        rosterData = [NSMutableArray array];
        NSDictionary *_status = [NSDictionary dictionaryWithDictionary:JSON];
        for(id _athlete in [_status objectForKey:@"players"]) {
            Athlete *tempAthlete = [[Athlete alloc] initWithDic:_athlete];
            [rosterData addObject:tempAthlete];
        }
        
        [self.tableView reloadData];
        NSLog(@"Athletes added: %i", rosterData.count);
        // Refresh button for feed
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(fetchRoster)];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        //Failed
        NSLog(@"Failed download: %@", error);
        // Refresh button for feed
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(fetchRoster)];
    }];
    
    // Set download indicator
    [[self navigationItem] setRightBarButtonItem:barButton];
    [activityIndicator startAnimating];
    [operation start];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self fetchRoster];
    
    self.tableView.rowHeight = 60;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return self->rosterData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Here we use the new provided setImageWithURL: method to load the web image asynchronously
    Athlete *cellAthlete = [rosterData objectAtIndex:indexPath.row];
    
    NSLog(@"Athlete Image: %@", cellAthlete._imageURL);
    
    if(cellAthlete._imageURL.length < 8)
        [cell.imageView setImage:[UIImage imageNamed:@"Placeholder.png"]];
    else {
        [cell.imageView setImageWithURL:[NSURL URLWithString:[[rosterData objectAtIndex:indexPath.row] _imageURL]] placeholderImage:[UIImage imageNamed:@"Placeholder.png"]];
    }
    
    [cell.imageView.layer setBorderColor: [[UIColor darkGrayColor] CGColor]];
    [cell.imageView.layer setBorderWidth: 1.5f];
    [cell.imageView.layer setCornerRadius:6.0f];
    [cell.imageView.layer setMasksToBounds:YES];
    
    
    cell.textLabel.text = cellAthlete._name;
    cell.detailTextLabel.text = cellAthlete._hometown;
    
    return cell;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
  /*
    SVWebViewController *detailViewController = [[SVWebViewController alloc] initWithAddress:[[rosterData objectAtIndex:indexPath.row] _profileURL]];

     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
    */
    
    WebViewController *nextView = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
    nextView.webviewURL = [NSString stringWithFormat:@"%@",[[rosterData objectAtIndex:indexPath.row] _profileURL]];
    [self.navigationController pushViewController:nextView animated:YES];
}

@end
