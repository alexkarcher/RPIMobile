//
//  SportNewsViewController.m
//  RPIMobile
//
//  Created by Stephen Silber on 6/21/12.
//  Copyright (c) 2012 Rensselaer Polytechnic Institute. All rights reserved.
//

#import "SportNewsViewController.h"
#import "NSString+HTML.h"
#import "WebViewController.h"
#import "AFNetworking.h"
#import "RSSParser.h"
#include "ServerURLFile.h"

#define start_color [UIColor colorWithHex:0xEEEEEE]
#define end_color [UIColor colorWithHex:0xDEDEDE]
#define numToDisplay 50

@implementation SportNewsViewController

@synthesize feedURL, newsItems, _shortSportName;

- (id)initWithStyle:(UITableViewStyle)style name:(NSString *)shortSportName
{
    self = [super initWithStyle:style];
    if (self) {
        self._shortSportName = shortSportName;
    }
    return self;
}


- (void)updateTableWithParsedItems {
	self.newsItems = [parsedItems sortedArrayUsingDescriptors:
                      [NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"pubDate" 
                                                                            ascending:NO]]];
	self.tableView.userInteractionEnabled = YES;
	self.tableView.alpha = 1;
	[self.tableView reloadData];
}

-(void) parseNewFeed {
    
    UIActivityIndicatorView *activityIndicator =
    [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    UIBarButtonItem * barButton =
    [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
    
    // Create feed parser and pass the URL of the feed
    if(self->_shortSportName) {
        NSLog(@"Specific sport: %@", self->_shortSportName);
    }
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kFeedURL, self->_shortSportName]];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5];
    [RSSParser parseRSSFeedForRequest:request success:^(NSArray *feedItems) {
        
        //Parsing was successful
        [activityIndicator stopAnimating];
        // Refresh button put back in place
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                                               target:self
                                                                                               action:@selector(parseNewFeed)];
        self.newsItems = feedItems;
        NSLog(@"Parsed: %@", self.newsItems);
        self.title = @"News";
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        //Parsing failed!
        NSLog(@"Parsing failed: %@", error);
        //Parsing was successful
        [activityIndicator stopAnimating];
        // Refresh button put back in place
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                                               target:self
                                                                                               action:@selector(parseNewFeed)];
    }];
    
    // Set download indicator
    [[self navigationItem] setRightBarButtonItem:barButton];
    [activityIndicator startAnimating];
    
}

- (void) setUpShadows {
    [PrettyShadowPlainTableview setUpTableView:self.tableView];
}


- (void)viewDidLoad {
    [super viewDidLoad];    
    self.newsItems = [NSMutableArray array];
    
    self.tableView.rowHeight = 90;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
    

	self.title = @"Loading...";
	formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"dd MMM yyyy HH:mm:ss zzz"];
	[formatter setTimeStyle:NSDateFormatterShortStyle];
	parsedItems = [[NSMutableArray alloc] init];
	self.newsItems = [NSArray array];
	
	// Refresh button for feed
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh 
																							target:self 
																							action:@selector(parseNewFeed)];
    [self parseNewFeed];
    [self setUpShadows]; 

    
}

-(NSURL *) getLink {
    if(self->_shortSportName) {
        return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kFeedURL, self->_shortSportName]];
    }
    return NULL;
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

#pragma mark -
#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [newsItems count];
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
    }
    
    
    // Configure the cell.
    RSSItem *item = [self.newsItems objectAtIndex:indexPath.row];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.detailTextLabel.backgroundColor = [UIColor clearColor];
    
	if (item) {

        //Image support for athletic news -> need to resize image and make correct placeholder for cells
/*        if(item.imagesFromItemDescription.count > 0) {
            [cell.imageView setImageWithURL:[NSURL URLWithString:[item.imagesFromItemDescription objectAtIndex:0]] placeholderImage:[UIImage imageNamed:@"Placeholder.png"]];
        } */
		
        // Process
		NSString *itemTitle = item.title ? [item.title stringByConvertingHTMLToPlainText] : @"[No Title]";
		NSString *itemSummary = item.itemDescription ? [item.itemDescription stringByConvertingHTMLToPlainText] : @"[No Summary]";
        
        cell.textLabel.text = itemTitle;
        cell.textLabel.font = [UIFont boldSystemFontOfSize:12];
        cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
        [cell.textLabel setNumberOfLines:2];
        
        
        cell.detailTextLabel.text = itemSummary;
		cell.detailTextLabel.font = [UIFont systemFontOfSize:10];
        cell.detailTextLabel.lineBreakMode = UILineBreakModeWordWrap;
        [cell.detailTextLabel setNumberOfLines:3];
		
	} else {
        cell.textLabel.text = @"Error";
    }


    [cell prepareForTableView:tableView indexPath:indexPath];
    
    
    return cell;
    
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WebViewController *nextView = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
    nextView.webviewURL = [NSString stringWithFormat:@"%@",[[newsItems objectAtIndex:indexPath.row] link]];
    [self.navigationController pushViewController:nextView animated:YES];
    
}

@end
