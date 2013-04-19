//
//  AthleticsSportViewController.m
//  RPIMobile
//
//  Created by Stephen Silber on 9/27/12.
//  Copyright (c) 2012 Rensselaer Polytechnic Institute. All rights reserved.
//
#import "JSONKit.h"
#import "PrettyKit.h"
#import "AFNetworking.h"
#import "UIImageExtras.h"
#import "SportNewsViewController.h"
#import "AthleticsSportViewController.h"
#import "AthleticsRosterViewController.h"
#import "AthleticsScheduleViewController.h"
#include "ServerURLFile.h"


#define start_color [UIColor colorWithHex:0xEEEEEE]
#define end_color [UIColor colorWithHex:0xDEDEDE]

@interface AthleticsSportViewController ()

@end

@implementation AthleticsSportViewController
@synthesize _shortSportName, _sportName, teamPic, menuList, progressView, noImageLabel;
- (id) init {
    if(self == [super init]) {
        //custom initialization here
    }
    
    return self;
}

- (void) downloadImage:(NSString *)imageURL {
    NSURL *url = [NSURL URLWithString:imageURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLCacheStorageAllowed timeoutInterval:8];
    AFImageRequestOperation *operation = [AFImageRequestOperation imageRequestOperationWithRequest:request success:^(UIImage *image) {
        //Picture downloaded
        UIImage *scaledPic = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFill imageToScale:image bounds:CGSizeMake(320, 181) interpolationQuality:kCGInterpolationHigh];
             [self.teamPic setImage:scaledPic];
             [self.progressView setHidden:YES];
    }];

    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        float tbr = [[NSNumber numberWithLongLong:totalBytesRead] floatValue];
        float tbe = [[NSNumber numberWithLongLong:totalBytesExpectedToRead] floatValue];
        [self.progressView setProgress:(tbr/tbe)];
    }];
    [operation start];


}
- (void) getPicture {
    NSString *urlString = [NSString stringWithFormat:@"%@%@", kTeamPicURL, self->_shortSportName];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [[AFJSONRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //Found picture link
        NSDictionary *_status = [[operation responseString] objectFromJSONString];
        NSLog(@"Dic: %@", _status);

        NSString *imageURL = [_status objectForKey:@"url"];

        if([imageURL isKindOfClass:[NSString class]]) {
            [self downloadImage:imageURL];
        } else {
            //No picture available
            NSLog(@"picture null!");
            self.noImageLabel.hidden = NO;
            self.progressView.hidden = YES;
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //
    }];
    
    [operation start];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self->_menuItems = [NSArray arrayWithObjects:@"News", @"Roster", @"Schedule", @"Mobile Web", nil];
    self.title = self->_sportName;
    
    self.view.backgroundColor = [UIColor darkGrayColor];
    
    self.teamPic = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 180)];
    
    
    self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
    [self.progressView setCenter:self.teamPic.center];
    
    self.noImageLabel = [[UILabel alloc] initWithFrame:self.teamPic.frame];
    self.noImageLabel.text = @"Team Image Not Found!";
    self.noImageLabel.textColor = [UIColor whiteColor];
    self.noImageLabel.backgroundColor = [UIColor clearColor];
    self.noImageLabel.font = [UIFont systemFontOfSize:16];
    self.noImageLabel.center = self.teamPic.center;
    self.noImageLabel.hidden = YES;
    self.noImageLabel.textAlignment = NSTextAlignmentCenter;
    
    self.menuList = [[UITableView alloc] initWithFrame:CGRectMake(0, self.teamPic.frame.size.height, self.view.frame.size.width, (self.view.frame.size.height-self.teamPic.frame.size.height-self.navigationController.navigationBar.frame.size.height)) style:UITableViewStylePlain];
    self.menuList.dataSource = self;
    self.menuList.delegate = self;
    self.menuList.scrollEnabled = NO;

    [self.view addSubview:progressView];
    [self.view addSubview:teamPic];
    [self.view addSubview:noImageLabel];
    [self.view addSubview:menuList];
    
    self.menuList.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.menuList.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
    
    [self getPicture];
    [self setUpShadows];

    
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

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (tableView.frame.size.height/self->_menuItems.count);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    NSLog(@"Count: %@", self->_menuItems);
    return self->_menuItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";  
    
    PrettyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[PrettyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.tableViewBackgroundColor = tableView.backgroundColor;
        cell.gradientStartColor = start_color;
        cell.gradientEndColor = end_color;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
//    cell.textLabel.font = [UIFont systemFontOfSize:16];
    [cell prepareForTableView:tableView indexPath:indexPath];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    
    cell.textLabel.font = [UIFont boldSystemFontOfSize:20];
    cell.textLabel.text = [self->_menuItems objectAtIndex:[indexPath row]];
    
    return cell;
    
}

- (void) setUpShadows {
    [PrettyShadowPlainTableview setUpTableView:self.menuList];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.row == 0) {
        SportNewsViewController *nextView = [[SportNewsViewController alloc] initWithStyle:UITableViewStylePlain name:self->_shortSportName];
        NSLog(@"Test: %@", nextView);
//        nextView._shortSportName = [[NSString alloc] initWithString:self->_shorSportName ];
        [self.navigationController pushViewController:nextView animated:YES];
    } else if(indexPath.row == 1) {
        AthleticsRosterViewController *nextView = [[AthleticsRosterViewController alloc] initWithStyle:UITableViewStylePlain name:self->_shortSportName];
        [self.navigationController pushViewController:nextView animated:YES];
    } else if(indexPath.row == 2) {
        AthleticsScheduleViewController *nextView = [[AthleticsScheduleViewController alloc] initWithStyle:UITableViewStylePlain name:self->_shortSportName];
        [self.navigationController pushViewController:nextView animated:YES];
    } else if(indexPath.row == 3) {
        
    } else {
        
    }
}

@end
