//
//  RosterViewController.m
//  RPIMobile
//
//  Created by Stephen Silber on 6/18/12.
//  Copyright (c) 2012 Rensselaer Polytechnic Institute. All rights reserved.
//

#import "RosterViewController.h"
#import "JSONKit.h"
#import "UIImageView+AFNetworking.h"
#import "Athlete.h"
#import "WebViewController.h"
#import "HTMLParser.h"


#define kCustomRowHeight  60.0
#define kAppIconHeight    48

#define kRosterURL @"http://mobilerpi.jcmcmillan.com/v1/roster/"

@implementation RosterViewController
@synthesize sportName;
@synthesize receivedData;
@synthesize athleteData;

/*
- (void)downloadData
{
    self.title = @"Downloading...";
    
    UIActivityIndicatorView *activityIndicator =
    [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    UIBarButtonItem * barButton =
    [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];

    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", k_rosterURL, _rosterURL]];

    //Caching won't work until I rewrite the RPIAthletics parsing with Beautiful Soup or find a more efficient way to get data from the site!
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //Reset back to normal look and feel
        self.title = @"Roster";
        self.tableView.userInteractionEnabled = YES;

        [activityIndicator stopAnimating];
        
        // Use when fetching text data
        NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSArray *team = [responseString objectFromJSONString];
        
        athleteData = [[NSMutableArray alloc] init];
        for(int i = 1; i < [team count]; ++i) {
            Athlete *tempAthlete = [[Athlete alloc] initWithArray:[team objectAtIndex:i]];
            if(tempAthlete)
                [athleteData addObject:tempAthlete];
        }
        [self.tableView reloadData];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        self.title = @"Error";
        [activityIndicator stopAnimating];
        NSLog(@"Could not download: %@", error);
    }];
    
    [operation start];
    
      
    // Set download indicator
    [[self navigationItem] setRightBarButtonItem:barButton];
    [activityIndicator startAnimating];

}
*/
-(void) downloadData {
    
    self.title = @"Downloading...";
    
    UIActivityIndicatorView *activityIndicator =
    [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    UIBarButtonItem * barButton =
    [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", kRosterURL, self.sportName];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5];
    AFJSONRequestOperation *operation = [[AFJSONRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Roster downloaded: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //YQL Query Failed
        [activityIndicator stopAnimating];
        NSLog(@"Error: %@", error);
    }];
    
    [operation start];
    
    
    // Set download indicator
    [[self navigationItem] setRightBarButtonItem:barButton];
    [activityIndicator startAnimating];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.athleteData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Here we use the new provided setImageWithURL: method to load the web image asynchronously
    Athlete *cellAthlete = [self.athleteData objectAtIndex:indexPath.row];

    if([cellAthlete._imageURL isEqualToString:@""])
        [cell.imageView setImage:[UIImage imageNamed:@"Placeholder.png"]];
//    else 
//        [cell.imageView setImageWithURL:[NSURL URLWithString:[[self.athleteData objectAtIndex:indexPath.row] imageURL]] placeholderImage:[UIImage imageNamed:@"Placeholder.png"]];
    
    cell.textLabel.text = cellAthlete._name;
    cell.detailTextLabel.text = cellAthlete._hometown;

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
/*    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WebViewController *nextView = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
    NSLog(@"Athlete data url: %@", [[self.athleteData objectAtIndex:indexPath.row] profileURL]);
    nextView.webviewURL = [[self.athleteData objectAtIndex:indexPath.row] profileURL];
    [self.navigationController pushViewController:nextView animated:YES]; */
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}
- ( void )connection: (NSURLConnection *)connection didReceiveData: (NSData *)data
{
    // receivedData is an NSMutableData object
    [ receivedData appendData: data ];
}

- ( void )connectionDidFinishLoading: (NSURLConnection *)connection
{
//    [ self parseHTMLData: receivedData ];
    NSLog(@"received data: %@", receivedData);
}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

	self.tableView.rowHeight = kCustomRowHeight;
    
    self.athleteData = [NSMutableArray array];
    [self downloadData];
    //Disable until data downloaded
    self.tableView.userInteractionEnabled = NO;

}

- (void)viewDidUnload
{
    [super viewDidUnload];

}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
