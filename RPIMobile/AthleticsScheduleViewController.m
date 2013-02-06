//
//  AthleticsScheduleViewController.m
//  RPIMobile
//
//  Created by Stephen Silber on 10/10/12.
//  Copyright (c) 2012 Rensselaer Polytechnic Institute. All rights reserved.
//

#import "AFNetworking.h"
#import "ScheduleEntry.h"
#import "UIImageExtras.h"
#import "AthleticsScheduleViewController.h"

#define kScheduleURL @"http://mobilerpi.jcmcmillan.com/v1/schedule/"
#define kLoadingCellTag 999
@implementation AthleticsScheduleViewController

- (id)initWithStyle:(UITableViewStyle)style name:(NSString *)shortSportName
{
    self = [super initWithStyle:style];
    if (self) {
        self->_shortSportName = shortSportName;
    }
    return self;
}

-(void) fetchSchedule {

    //Progress indicator for UINavBar
    UIActivityIndicatorView *activityIndicator =
    [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
    
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kScheduleURL, self->_shortSportName]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:7];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        scheduleData = [NSMutableArray array];
        NSDictionary *_status = [NSDictionary dictionaryWithDictionary:JSON];
        for(id _entry in [_status objectForKey:@"events"]) {
            ScheduleEntry *tempEntry = [[ScheduleEntry alloc] initWithDictionary:_entry];
            [scheduleData addObject:tempEntry];
        }
        // Refresh button for feed
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(fetchSchedule)];

        [self.tableView reloadData];
        NSLog(@"Entries added: %i", scheduleData.count);

    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        //Failed
        NSLog(@"Schedule download failed!");
        
        // Refresh button for feed
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(fetchSchedule)];
    }];
    
    // Set download indicator
    [[self navigationItem] setRightBarButtonItem:barButton];
    [activityIndicator startAnimating];
    [operation start];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self fetchSchedule];
    self.tableView.rowHeight = 100;
    
    self.title = @"Schedule";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return scheduleData.count;
}

-(CGFloat ) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
    if([[[scheduleData objectAtIndex:indexPath.row] _score] isEqualToString:@"None"]) {
        return 100;
    } else {
        return 80;
    }
}

- (UITableViewCell *)loadingCell {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.center = cell.center;
    [cell addSubview:activityIndicator];
    
    [activityIndicator startAnimating];
    
    cell.tag = kLoadingCellTag;
    
    return cell;
}


- (UITableViewCell *)scheduleCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    [cell setGestureRecognizers:nil];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    // Here we use the new provided setImageWithURL: method to load the web image asynchronously
    ScheduleEntry *cellEntry = [scheduleData objectAtIndex:indexPath.row];
    
    if(!cellEntry._imageURL)
        [cell.imageView setImage:[UIImage imageNamed:@"Placeholder.png"]];
    else
        [cell.imageView setImageWithURL:[[scheduleData objectAtIndex:indexPath.row] _imageURL] placeholderImage:[UIImage imageNamed:@"Placeholder.png"]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[[scheduleData objectAtIndex:indexPath.row] _imageURL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5];
    [cell.imageView setImageWithURLRequest:request placeholderImage:[UIImage imageNamed:@"Placeholder.png"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        //Successful team image download
        UIImage *newImage = [UIImage imageWithImage:image scaledToSize:CGSizeMake(50, 50)];
        [[cell imageView] setImage:newImage];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        //Image failed
        [cell.imageView setImage:[UIImage imageNamed:@"Placeholder.png"]];
        NSLog(@"Image could not be downloaded for %@", request);
    }];
    
    cell.textLabel.text = cellEntry._team;
    cell.detailTextLabel.numberOfLines = 4;
    if([cellEntry._score isEqualToString:@"None"])
        cell.detailTextLabel.text = [NSString stringWithFormat:@"Date: %@\nTime: %@\nLocation: %@", cellEntry._date, cellEntry._time, cellEntry._location];
    else
        cell.detailTextLabel.text = [NSString stringWithFormat:@"Date: %@\nTime: %@\nLocation: %@\nResult: %@", cellEntry._date, cellEntry._time, cellEntry._location, cellEntry._score];
    
    return cell;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (scheduleData.count != 0) {
        return [self scheduleCellForRowAtIndexPath:indexPath];
    } else {
        return [self loadingCell];
    }
}

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
