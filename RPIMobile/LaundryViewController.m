//
//  LaundryViewController.m
//  RPIMobile
//
//  Created by Stephen Silber on 9/23/12.
//  Copyright (c) 2012 Rensselaer Polytechnic Institute. All rights reserved.
//

#import "LaundryViewController.h"
#import "AFNetworking.h"
#import "PrettyKit.h"
#import "JSONKit.h"

#define kLaundryFeedUrl @"http://mobilerpi.jcmcmillan.com/v1/laundry"
#define start_color [UIColor colorWithHex:0xEEEEEE]
#define end_color [UIColor colorWithHex:0xDEDEDE]

@interface LaundryMachine : NSObject {
    NSString *_dormName;
    NSInteger _washAvail;
    NSInteger _dryAvail;
    NSInteger _washInUse;
    NSInteger _dryInUse;
}

@property (nonatomic, strong) NSString *_dormName;
@property (nonatomic) NSInteger _washAvail, _dryAvail, _washInUse, _dryInUse;

- (id) initWithDic:(NSDictionary *)laundryData;

@end

@implementation LaundryMachine

@synthesize _dormName, _dryInUse, _dryAvail, _washInUse, _washAvail;

- (id) initWithDic:(NSDictionary *)laundryData {
    if(self = [super init]) {
        self->_dormName = [laundryData objectForKey:@"Room"];
        self->_washAvail = [[laundryData objectForKey:@"WashersAvailable"] integerValue];
        self->_dryAvail = [[laundryData objectForKey:@"DryersAvailable"] integerValue];
        self->_washInUse = [[laundryData objectForKey:@"WashersInUse"] integerValue];
        self->_dryInUse = [[laundryData objectForKey:@"DryersInUse"] integerValue];
    }
    
    return self;
}

@end

@implementation LaundryViewController
@synthesize laundryMachines=_laundryMachines;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) fetchLaundryStatus {
    NSURL *url = [[NSURL alloc] initWithString:kLaundryFeedUrl];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    UIActivityIndicatorView *activityIndicator =
    [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
    
    
    AFJSONRequestOperation *operation = [[AFJSONRequestOperation alloc] initWithRequest:request];
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //Successful download of JSON Laundry machine status
        NSString *responseString = [operation responseString];
//        NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *_status = [responseString objectFromJSONString];
        for(id dic in [_status objectForKey:@"rooms"]) {
            NSLog(@"DIc: %@", dic);
            LaundryMachine *machine = [[LaundryMachine alloc] initWithDic:dic];
            [self.laundryMachines addObject:machine];
        }
        
        NSLog(@"Laundry Machines: %@", self.laundryMachines);
        
        [activityIndicator stopAnimating];
        
        // Refresh button for feed
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(fetchLaundryStatus)];
        
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //Failure downloading
        NSLog(@"Error fetching laundry: %@", error);
        [activityIndicator stopAnimating];
        
        // Refresh button for feed
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(fetchLaundryStatus)];
        
    }];
    
    // Set download indicator
    [[self navigationItem] setRightBarButtonItem:barButton];
    [activityIndicator startAnimating];
    [operation start];
    

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.laundryMachines = [NSMutableArray array];
    [self fetchLaundryStatus];
    self.title = @"Laundry Status";
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return self.laundryMachines.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [[self.laundryMachines objectAtIndex:section] _dormName];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *GridCellIdentifier = @"GridCell";
;
    PrettyGridTableViewCell *gridCell = [tableView dequeueReusableCellWithIdentifier:GridCellIdentifier];
    if (gridCell == nil) {
        gridCell = [[PrettyGridTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:GridCellIdentifier];
        gridCell.tableViewBackgroundColor = tableView.backgroundColor;
        gridCell.selectionStyle = UITableViewCellSelectionStyleNone;
//        gridCell.selectionGradientStartColor = [UIColor clearColor];
//        gridCell.selectionGradientEndColor = [UIColor clearColor];
    }
    
    LaundryMachine *cellMachine = [self.laundryMachines objectAtIndex:indexPath.section];
    if(cellMachine ) {
        [gridCell prepareForTableView:tableView indexPath:indexPath];
        gridCell.textLabel.font = [UIFont systemFontOfSize:10];
        gridCell.textLabel.numberOfLines = 2;
        gridCell.numberOfElements = 4;
        [gridCell setText:@"Washers\nAvailable" atIndex:0];
        [gridCell setDetailText:[NSString stringWithFormat:@"%i", cellMachine._washAvail] atIndex:0];
        [gridCell setText:@"Dryers\nAvailable" atIndex:1];
        [gridCell setDetailText:[NSString stringWithFormat:@"%i", cellMachine._dryAvail] atIndex:1];
        [gridCell setText:@"Washers\nIn Use" atIndex:2];
        [gridCell setDetailText:[NSString stringWithFormat:@"%i", cellMachine._washInUse] atIndex:2];
        [gridCell setText:@"Dryers\nIn Use" atIndex:3];
        [gridCell setDetailText:[NSString stringWithFormat:@"%i", cellMachine._dryInUse] atIndex:3];
    }

    return gridCell;
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
