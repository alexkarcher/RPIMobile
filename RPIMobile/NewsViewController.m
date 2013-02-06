//
//  NewsViewController.m
//  RPIMobile
//
//  Created by Stephen Silber on 5/20/12.
//  Copyright (c) 2012 Rensselaer Polytechnic Institute. All rights reserved.
//

#import "NewsViewController.h"
#import "NewsDetailViewController.h"
#import "PrettyKit.h"
#import "RSSParser/RSSParser.h"
#import "UIImageView+AFNetworking.h"
#import "NSString+HTML.h"
#import "MFSideMenu.h"

#define start_color [UIColor colorWithHex:0xEEEEEE]
#define end_color [UIColor colorWithHex:0xDEDEDE]
#define kNumberOfStories 40
#define kCellHeight 90

/*
 To-do for RPI News page: 
    -Add caching. Try implementing NSData reader for MWFeedParser using old pull request.
    -Dynamically size UITableViewCell based on length of summary label
    -Remove readability stamp on the bottom of mobile webpages. Javascript injection?
    -RPIAthletics should not need readability. Mobile site is sufficient
 */

@implementation NewsViewController
@synthesize newsItems, launcherImage;
@synthesize newsTable;
@synthesize horizMenu = _horizMenu;
@synthesize items = _items;

- (void)quitView: (id) sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"closeView" object:self.navigationController.view];
}

- (void)updateTableWithParsedItems {
    self.title = @"RPI News";
	self.newsItems = [newsItems sortedArrayUsingDescriptors:[NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"pubDate" ascending:NO]]];
	self.newsTable.userInteractionEnabled = YES;
	self.newsTable.alpha = 1;
	[self.newsTable reloadData];
}

- (void) setUpShadows {
    [PrettyShadowPlainTableview setUpTableView:self.newsTable];
}

#pragma mark - View lifecycle



- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupSideMenuBarButtonItem];

    [self.newsTable setFrame:CGRectMake(0, 41, 320, self.view.frame.size.height-41)];
    
    self.navigationItem.title = @"RPI News";
    
    self.newsTable.rowHeight = kCellHeight;
    self.newsTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.newsTable.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
    self.newsTable.scrollsToTop = YES;
    
    self.items = [NSArray arrayWithObjects:@"All News", @"Academics", @"Faculty", @"Research", @"Arts", @"Community", @"Calendar", @"Athletics", nil];
    
    self.horizMenu = [[MKHorizMenu alloc] initWithFrame:CGRectMake(0, 0, 320, 41)];
    self.horizMenu.dataSource = self;
    self.horizMenu.delegate = self;
    self.horizMenu.itemSelectedDelegate = self;
    self.horizMenu.scrollsToTop = NO; //Fixes UITableView losing control over scrollsToTop due to UIScrollView priorities
    self.horizMenu.showsHorizontalScrollIndicator = NO;
    
    [self.horizMenu reloadData];
    [self.view addSubview:self.horizMenu];

    
    newsFeeds = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"http://www.rpi.edu/news/rss/allnews.xml", @"All News", @"http://www.rpi.edu/news/rss/academics.xml", @"Academics", @"http://www.rpi.edu/news/rss/faculty.xml", @"Faculty", @"http://www.rpi.edu/news/rss/research.xml", @"Research", @"http://www.rpi.edu/news/rss/arts.xml", @"Arts", @"http://www.rpi.edu/news/rss/community.xml", @"Community", @"http://www.rpi.edu/dept/cct/apps/oth/data/rpiTodaysEvents.rss", @"Calendar", @"http://www.rpiathletics.com/rss.aspx", @"Athletics",nil];

    //Initial value for news feed menubar
    [self.horizMenu setSelectedIndex:0 animated:YES];
	self.title = @"Loading...";
	
    formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"dd MMM yyyy HH:mm:ss zzz"];
	[formatter setTimeStyle:NSDateFormatterShortStyle];
	
	self.newsItems = [NSArray array];
	
	// Refresh button for feed
//	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh)];
    
    [self setUpShadows];
    


}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

#pragma mark - Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(newsItems.count <= kNumberOfStories)
        return newsItems.count;
    else
        return kNumberOfStories;
}


- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath 
{
/*    //    RSSItem *item = [newsItems objectAtIndex:indexPath.row];
    if([self.newsItems count] > 0) {
        NSString *string = [[self.newsItems objectAtIndex:indexPath.row] itemDescription];
        CGSize suggestedSize = [string sizeWithFont:[UIFont systemFontOfSize:10.0]
                                  constrainedToSize:CGSizeMake(224.0, FLT_MAX)
                                      lineBreakMode:UILineBreakModeWordWrap];
        return suggestedSize.height + 30; // add 40px for padding
    }
    
    return 44; */

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
    
    RSSItem *item = [newsItems objectAtIndex:indexPath.row];
    
    if(item) {
        // Process (from MWFeedParser by mywaterfall)
		NSString *itemTitle = item.title ? [item.title stringByConvertingHTMLToPlainText] : @"[No Title]";
		NSString *itemSummary = item.itemDescription ? [item.itemDescription stringByConvertingHTMLToPlainText] : @"[No Summary]";
        
        cell.textLabel.text = itemTitle;
        cell.detailTextLabel.text = itemSummary;
        /* FIX THE FORMATTING HERE. Athletics has html code before summary, rest of feeds run through stringByConvertingHTMLtoPlainText and return with messed up timestamps */
    }
    
    // Configure the cell.
    cell.textLabel.font = [UIFont boldSystemFontOfSize:12];
    cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
    cell.textLabel.numberOfLines = 2;
    
    cell.detailTextLabel.numberOfLines = 3;
    cell.detailTextLabel.font = [UIFont systemFontOfSize:10];
    cell.detailTextLabel.lineBreakMode = UILineBreakModeWordWrap;
    
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.detailTextLabel.backgroundColor = [UIColor clearColor];

    [cell prepareForTableView:tableView indexPath:indexPath];

    
    return cell;

}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    RSSItem *item = [newsItems objectAtIndex:indexPath.row];
    if (item) {
        
        NewsDetailViewController *detailViewController = [[NewsDetailViewController alloc] initWithNibName:@"NewsDetailViewController" bundle:nil];
        
        //Hack - View not being initialized, referenced here: http://stackoverflow.com/questions/2720662/uilabel-not-updating
        NSLog(@"%@",detailViewController.view);
   
        //Create a URL object.
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.readability.com/m?url=%@", item.link]];
        //URL Requst Object
        NSMutableURLRequest *requestObj = [NSURLRequest requestWithURL:url];
        //Load the request in the UIWebView.
        [detailViewController.storyView loadRequest:requestObj];
        detailViewController.title = self.title;

        
        [self.navigationController pushViewController:detailViewController animated:YES];
    }
}

#pragma mark -
#pragma mark HorizMenu Data Source
- (UIImage*) selectedItemImageForMenu:(MKHorizMenu*) tabMenu
{
    return [[UIImage imageNamed:@"ButtonSelected"] stretchableImageWithLeftCapWidth:16 topCapHeight:0];
}

- (UIColor*) backgroundColorForMenu:(MKHorizMenu *)tabView
{
    return [UIColor colorWithPatternImage:[UIImage imageNamed:@"MenuBar"]];
}

- (int) numberOfItemsForMenu:(MKHorizMenu *)tabView
{
    return [self.items count];
}

- (NSString*) horizMenu:(MKHorizMenu *)horizMenu titleForItemAtIndex:(NSUInteger)index
{
    return [self.items objectAtIndex:index];
}

#pragma mark -
#pragma mark HorizMenu Delegate

-(void) parseNewFeed:(NSString *) key {

    self.title = @"Downloading...";
    
    UIActivityIndicatorView *activityIndicator =
    [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    UIBarButtonItem * barButton =
    [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
    
    
    
    // Create feed parser and pass the URL of the feed
    NSURL *feedURL = [NSURL URLWithString:[newsFeeds objectForKey:key]];
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:feedURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5];
    [RSSParser parseRSSFeedForRequest:req success:^(NSArray *feedItems) {
        [activityIndicator stopAnimating];
        newsItems = feedItems;
        [self updateTableWithParsedItems];
    } failure:^(NSError *error) {
        NSLog(@"Error downloading: %@", error);
        [activityIndicator stopAnimating];
    }];
    
    // Set download indicator
    [[self navigationItem] setRightBarButtonItem:barButton];
    [activityIndicator startAnimating];

    
}
-(void) horizMenu:(MKHorizMenu *)horizMenu itemSelectedAtIndex:(NSUInteger)index
{  
     NSLog(@"Item at index: %@", [self.items objectAtIndex:index]);
 
    [self parseNewFeed:[self.items objectAtIndex:index]];
    
}

@end
