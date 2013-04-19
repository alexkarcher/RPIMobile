//
//  VideoFeedViewController.m
//  RPIMobile
//
//  Created by Stephen Silber on 6/12/12.
//  Copyright (c) 2012 Rensselaer Polytechnic Institute. All rights reserved.
//

#import "VideoFeedViewController.h"
#import "PrettyKit.h"
#import "NSString+HTML.h"
#import "UIImageView+WebCache.h"
#import "VideoWebviewViewController.h"
#import "WCXMLParser.h"
#include "ServerURLFile.h"

#define start_color [UIColor colorWithHex:0xEEEEEE]
#define end_color [UIColor colorWithHex:0xDEDEDE]

/*To-do for RPIVideos:
    -Fix delayed launch!!
    -Rotation support!!
    -Add options for more channels
    -Add ability to load further down channel
 */

/*Settings for RPIVideos:
    -Autoplay on/off
*/

@implementation VideoFeedViewController

@synthesize items;
@synthesize newsItems;
@synthesize launcherImage;
@synthesize feedURLString;

// Reset and reparse
- (void)refresh {
	self.title = @"Refreshing...";
    [self fetchVideoFeed:[NSURL URLWithString:kVideoFeedURL]];
    self.tableView.userInteractionEnabled = NO;
    self.tableView.alpha = 0.8;
}

- (void)updateTableWithParsedItems {
/*	self.newsItems = [parsedItems sortedArrayUsingDescriptors:
                      [NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"date" 
                                                                            ascending:NO]]];
    */
	self.tableView.userInteractionEnabled = YES;
	self.tableView.alpha = 1;
	[self.tableView reloadData];
}

- (void) setUpShadows {
    [PrettyShadowPlainTableview setUpTableView:self.tableView];
}


-(void) fetchVideoFeed:(NSURL *) url {
    NSLog(@"URL: %@", url);
    [WCXMLParser parseContentFromURL:url withOptions:0 success:^(WCXMLParser *parser, id parsedObject) {
        _items = [NSMutableArray array];
        for(NSDictionary *entry in [[parsedObject objectForKey:@"feed"] objectForKey:@"entry"]) {
            [_items addObject:entry];
        }

        self.tableView.userInteractionEnabled = YES;
        self.tableView.alpha = 1.0;
        self.title = @"RPI Videos";
        [self.tableView reloadData];
    } failure:^(WCXMLParser *parser, NSError *error) {
        NSLog(@"PARSE ERROR: %@", [error description]);
    }];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    [self.tableView setScrollsToTop:YES];
    
    self.tableView.rowHeight = 90;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];

	self.title = @"Loading...";
	formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"dd MMM yyyy HH:mm:ss zzz"];
	[formatter setTimeStyle:NSDateFormatterShortStyle];
	parsedItems = [NSMutableArray array];
	self.newsItems = [NSArray array];
	
	// Refresh button for feed
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh 
																							target:self 
																							action:@selector(refresh)];
    
    NSURL *url;
    // Create feed parser and pass the URL of the feed
    if(!feedURLString)
        url = [NSURL URLWithString:kVideoFeedURL];
    else //temporary for sport video feeds
        url = [NSURL URLWithString:feedURLString];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    
    dispatch_async(queue, ^{
        [self fetchVideoFeed:url];
    });
    [self setUpShadows]; 
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _items.count;
}


- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    return tableView.rowHeight + [PrettyTableViewCell tableView:tableView neededHeightForIndexPath:indexPath];
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
    NSDictionary *cellItem = [_items objectAtIndex:indexPath.row];
    
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.detailTextLabel.backgroundColor = [UIColor clearColor];
    
	if (cellItem) {
        NSURL *url = [NSURL URLWithString:[[[[cellItem objectForKey:@"media:group"] objectForKey:@"media:thumbnail"] objectAtIndex:1] objectForKey:@"url" ]];
        [cell.imageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"PlaceholderVideo.png"]];

        NSString *itemTitle = [[cellItem objectForKey:@"title"] objectForKey:@"text"];
        NSString *itemSummary = [[cellItem objectForKey:@"content"] objectForKey:@"text"];

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
//Implement autoplay trick, must create separate uiviewcontroller file
//for simplicity: http://stackoverflow.com/questions/3010708/youtube-video-autoplay-on-iphones-safari-or-uiwebview
#pragma mark - Table view delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"SELECTED. SUCK A DICK. FUCK. FUCK");
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    VideoWebviewViewController *nextView = [[VideoWebviewViewController alloc] initWithNibName:@"VideoWebviewViewController" bundle:nil];
    
    //Hack - View not being initialized, referenced here: http://stackoverflow.com/questions/2720662/uilabel-not-updating
    NSLog(@"%@",nextView.view);
    
    //Create a URL object.
    NSURL *url = [NSURL URLWithString:[[[[_items objectAtIndex:indexPath.row] objectForKey:@"link"] objectAtIndex:0] objectForKey:@"href"]];
    nextView._webviewURL = url;
    NSLog(@"Pushing!");
    [self.navigationController pushViewController:nextView animated:YES];
}



@end
