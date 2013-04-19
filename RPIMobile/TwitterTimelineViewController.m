//
//  TwitterTimelineViewController.m
//  RPIMobile
//
//  Created by Stephen Silber on 8/15/12.
//  Copyright (c) 2012 Rensselaer Polytechnic Institute. All rights reserved.
//


#import "RMAppDelegate.h"
#import "TwitterTimelineViewController.h"
#import "UIImageView+AFNetworking.h"
#import "SVWebViewController.h"
#import "TweetTableViewCell.h"
#import "AFNetworking.h"
#import "JSONKit.h"
#import "PrettyKit.h"
#import "ISRefreshControl.h"
#import <QuartzCore/QuartzCore.h>
#include "ServerURLFile.h"

/*TO-DO for Twitter: 
DONE      -Add custom XIB for tweet cells (link detection)
IGNORE    -Add separate tweet window?
DONE      -Dynamic UITableViewCell size
IGNORE    -Cache?
DONE      -UIWebView override for clicked links
          -Better design for UITableViewCell (UGLY)
 */

@interface UITextView (Override)
@end

@class WebView, WebFrame;
@protocol WebPolicyDecisionListener;

@implementation UITextView (Override)

- (void)webView:(WebView *)webView decidePolicyForNavigationAction:(NSDictionary *)actionInformation request:(NSURLRequest *)request frame:(WebFrame *)frame decisionListener:(id < WebPolicyDecisionListener >)listener
{
    SVModalWebViewController *_view = [[SVModalWebViewController alloc] initWithAddress:[NSString stringWithFormat:@"%@",[request URL]]];
    _view.barsTintColor = [UIColor darkGrayColor];
    RMAppDelegate *_appDelegate = (RMAppDelegate *)[[UIApplication sharedApplication] delegate];
    [_appDelegate.navigationController presentModalViewController:_view animated:YES];
}
@end


@interface Tweet : NSObject {
    NSString *_user;
    NSString *_screenname;
    NSString *_tweetText;
    NSString *_avatarURL;
    NSString *_timestamp;
    
    long long _id;
}

@property (strong) NSString *_user, *_tweetText, *_avatarURL, *_timestamp, *_screenname;
@property (nonatomic) long long _id;
@end

@implementation Tweet

@synthesize _timestamp, _avatarURL, _id, _screenname, _tweetText, _user;

-(NSString *) fetchTimestamp:(NSString *) timestamp {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    //Wed Dec 01 17:08:03 +0000 2010
    [df setDateFormat:@"eee MMM dd HH:mm:ss ZZZZ yyyy"];
    NSDate *date = [df dateFromString:timestamp];
    [df setDateFormat:@"MM/dd/yy hh:mma"];
    return [df stringFromDate:date];
}

//Custom initialization
- (id) initWithDictionary:(NSDictionary *) dic {
    if(self = [super init]) {
        self._user = [NSString stringWithFormat:@"%@", [[dic objectForKey:@"user"] objectForKey:@"name"]];
        self._screenname = [[dic objectForKey:@"user"] objectForKey:@"screen_name"];
        self._tweetText = [dic objectForKey:@"text"];
        self._avatarURL = [[dic objectForKey:@"user" ] objectForKey:@"profile_image_url"];
        
        self._id = [[dic objectForKey:@"id"] longLongValue];
        self._timestamp = [self fetchTimestamp:[dic objectForKey:@"created_at"]];
    }
    
    return self;
}

@end

@interface TwitterTimelineViewController () {
    int _currentPage;
    long long _lastID;
}
@end

#define kLoadingCellTag 999


@implementation TwitterTimelineViewController

@synthesize _tweets;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

//Change this to detect changes from the newest tweet and add them to the top of the array
- (void) refreshTweets {
    self.title = @"Downloading";
    //URL with last page being added to the end (for dynamically expanding UITableView

    long long newestID = 0;
    NSString *urlString;
    if([self._tweets count] > 0) {
        newestID = [[self._tweets objectAtIndex:0] _id];
        NSLog(@"WHAT: %lli", [[self._tweets objectAtIndex:0] _id]);
        urlString = [NSString stringWithFormat:@"%@%lli", kRPIMobileFeedURL_refresh, newestID];
    } else {
        urlString = [NSString stringWithFormat:@"%@", kRPIMobileFeedURL];
    }

    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    AFJSONRequestOperation *operation = [[AFJSONRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //Success downloading twitter timeline from RPI Mobile list
        // Use when fetching text data
        [self.refreshControl endRefreshing];
        NSArray *tweetArray = [[operation responseString] objectFromJSONString];
//        NSLog(@"TweetArray: %i \n\n\n\ %@", tweetArray.count, tweetArray);
        for(int i = tweetArray.count-1; i >= 0; i--) {
            Tweet *tweet = [[Tweet alloc] initWithDictionary:[tweetArray objectAtIndex:i]];
            [self._tweets insertObject:tweet atIndex:0];
            NSLog(@"Tweet added to the top: %@", tweet._tweetText);
        }
        
        //Set last ID of downloaded tweet for new Twitter API max_id protocol
        long long lastTweetID = [[self._tweets lastObject] _id];
        _lastID = lastTweetID - 5;
        NSLog(@"Last Object: %lli and lastID: %lli", [[self._tweets lastObject] _id], _lastID );

        self.title = @"Twitter";
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //Request failed
        NSLog(@"Error with twitter timeline request: %@", error);
        self.title = @"Request Failed";
        
    }];
    
    [operation start];
}

- (void) fetchTweets {
    self.title = @"Downloading";
    //URL with last page being added to the end (for dynamically expanding UITableView
    NSString *urlString = [NSString stringWithFormat:@"%@", kRPIMobileFeedURL];
    
    if(_lastID != 0) {
        urlString = [urlString stringByAppendingFormat:@"&max_id=%lli", _lastID];
    }
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLCacheStorageAllowed timeoutInterval:8.0];

    
    AFJSONRequestOperation *operation = [[AFJSONRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //Success downloading twitter timeline from RPI Mobile list
        // Use when fetching text data

        NSArray *tweetArray = [[operation responseString] objectFromJSONString];
    
        NSLog(@"Tweet Count: %i", [tweetArray count]);
        for(id tempTweet in tweetArray) {
            Tweet *tweet = [[Tweet alloc] initWithDictionary:tempTweet];
            [self._tweets addObject:tweet];
            NSLog(@"Tweet by %@ added", tweet._user);
        }
        
        //Set last ID of downloaded tweet for new Twitter API max_id protocol
        long long lastTweetID = [[self._tweets lastObject] _id];
        _lastID = lastTweetID - 5;
        NSLog(@"Last Object: %lli and lastID: %lli", [[self._tweets lastObject] _id], _lastID );
        
        self.title = @"Twitter";
        [self.tableView reloadData];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //Request failed
        NSLog(@"Error with twitter timeline request: %@", error);
        self.title = @"Request Failed";
        [self.refreshControl endRefreshing];
    }];
    
    [operation start];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _lastID = 0;
    self._tweets = [NSMutableArray array];
    [self fetchTweets];

    self.refreshControl = (id)[[ISRefreshControl alloc] init];
    [self.refreshControl addTarget:self
                            action:@selector(refreshTweets)
                  forControlEvents:UIControlEventValueChanged];
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshTweets)];
    
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

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    if (_lastID == 0) {
        return 1;
    }
    return self._tweets.count + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if([self._tweets count] > 0 && indexPath.row < [self._tweets count]) {
        NSString *string = [[self._tweets objectAtIndex:indexPath.row] _tweetText];
        CGSize suggestedSize = [string sizeWithFont:[UIFont systemFontOfSize:11.0]
                                  constrainedToSize:CGSizeMake(224.0, FLT_MAX)
                                      lineBreakMode:UILineBreakModeWordWrap];
        return suggestedSize.height + 50; // add 40px for padding
    }
    
    return 44;
    
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


- (UITableViewCell *)tweetCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    TweetTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        // Load the top-level objects from the custom cell XIB.
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"TweetTableViewCell" owner:self options:nil];
        // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
        cell = [topLevelObjects objectAtIndex:0];
    }
    
    Tweet *cellTweet = [self._tweets objectAtIndex:indexPath.row];
    
    if(cellTweet) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell._username.text = cellTweet._user;
        cell._tweet.text = cellTweet._tweetText;
        cell._timestamp.text = cellTweet._timestamp;
        
        NSString *urlString = [NSString stringWithFormat:@"http://api.twitter.com/1/users/profile_image?screen_name=%@&size=bigger", cellTweet._user];
        NSLog(@"String: %@", urlString);
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.twitter.com/1/users/profile_image?screen_name=%@&size=bigger", cellTweet._screenname]];
        NSLog(@"URL FOR IMAGE: %@", url);
        
        [cell._avatar setImageWithURL:url placeholderImage:[UIImage imageNamed:@"Placeholder.png"]];
        [cell._avatar setContentMode:UIViewContentModeScaleAspectFit];
        
        CGSize suggestedSize = [cellTweet._tweetText sizeWithFont:[UIFont systemFontOfSize:11.0]
                                  constrainedToSize:CGSizeMake(224.0, FLT_MAX)
                                      lineBreakMode:UILineBreakModeWordWrap];
        [cell._avatar setFrame:CGRectMake(10, ((suggestedSize.height + 40) - 50)/2, 50, 50)];
        [cell._avatar.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
        [cell._avatar.layer setBorderWidth: 1.5f];
        [cell._avatar.layer setCornerRadius:6.0f];
        [cell._avatar.layer setMasksToBounds:YES];
    }

    
    return cell;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self._tweets.count) {
        return [self tweetCellForRowAtIndexPath:indexPath];
    } else {
        return [self loadingCell];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (cell.tag == kLoadingCellTag) {
        [self fetchTweets];
    }
    
    if(indexPath.row % 2 == 0) {
        cell.backgroundColor = [UIColor colorWithHex:0xEFEFEF];
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

@end
