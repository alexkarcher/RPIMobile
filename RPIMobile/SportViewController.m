//
//  SportViewController.m
//  RPIMobile
//
//  Created by Stephen Silber on 6/18/12.
//  Copyright (c) 2012 Rensselaer Polytechnic Institute. All rights reserved.
//

#import "SportViewController.h"
#import "RosterViewController.h"
#import "SportNewsViewController.h"
#import "ScheduleViewController.h"
#import "PrettyKit.h"
#import "UIImageExtras.h"
#import "AFNetworking.h"
#import "SDURLCache.h"
#import "UIImageView+WebCache.h"



@implementation SportViewController
@synthesize menuList, sportName, currentGender, progressBar, teamPicture, currentLink, noImage;

#define start_color [UIColor colorWithHex:0xEEEEEE]
#define end_color [UIColor colorWithHex:0xDEDEDE]

#define red_start_color [UIColor colorWithHex:0x595959]
#define red_end_color [UIColor colorWithHex:0x303030]
#define kTeamPicURL @"http://silb.es/rpi/teampic.php?url="


#pragma mark -
#pragma mark Table View Data Source Methods

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [listItems count];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath 
{
//        return tableView.rowHeight + [PrettyTableViewCell tableView:tableView neededHeightForIndexPath:indexPath];
    return tableView.frame.size.height / listItems.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.row == 0) {
        SportNewsViewController *nextView = [[SportNewsViewController alloc] initWithNibName:@"SportNewsViewController" bundle:nil];
        nextView.title = @"News";
        nextView.feedURL = [self getLink:1];
        [self.navigationController pushViewController:nextView animated:YES];
    } else if(indexPath.row == 1) {
        RosterViewController *nextView = [[RosterViewController alloc] initWithNibName:@"RosterViewController" bundle:nil];
        nextView.title = sportName;
        nextView.sportName = sportName;
        [self.navigationController pushViewController:nextView animated:YES];
    }  else if(indexPath.row == 2) {
        ScheduleViewController *nextView = [[ScheduleViewController alloc] initWithNibName:@"ScheduleViewController" bundle:nil];
        nextView.scheduleURL = [self getLink:2];
        nextView.title = @"Schedule";
        [self.navigationController pushViewController:nextView animated:YES];
    }
    //Mobile web page implementation goes below
    /*else if(indexPath.row == 3) {
        ScheduleViewController *nextView = [[ScheduleViewController alloc] initWithNibName:@"ScheduleViewController" bundle:nil];
        nextView.scheduleURL = [self getLink:2];
        nextView.title = @"Schedule";
        [self.navigationController pushViewController:nextView animated:YES];
    } */
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

    cell.textLabel.font = [UIFont systemFontOfSize:16];
    [cell prepareForTableView:tableView indexPath:indexPath];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    
    
    cell.textLabel.text = [listItems objectAtIndex:[indexPath row]];
    return cell;
    
}

- (void) setUpShadows {
    [PrettyShadowPlainTableview setUpTableView:self.menuList];
}

-(void) findPictureLink {
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kTeamPicURL, currentLink]];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:6];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //Team Picture URL
        teamPicURL = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"Team Pic URL: %@", teamPicURL);
        if([teamPicURL length] < 15) {
            return; //Image url not found or returned
        }

        NSURLRequest *pictureRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:teamPicURL] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:6];
        AFImageRequestOperation *pictureOperation = [AFImageRequestOperation imageRequestOperationWithRequest:pictureRequest imageProcessingBlock:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                        //Image successfully downloaded
                        UIImage *scaledPic = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFill imageToScale:image bounds:CGSizeMake(320, 181) interpolationQuality:kCGInterpolationHigh];
                        [self.teamPicture setImage:scaledPic];
                        [self.progressBar setHidden:YES];
                    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                        //            //Error
                        NSLog(@"Failed to get team image: %@", error);
                        self.noImage.hidden = NO;
                        self.progressBar.hidden = YES;
            
        }];
        [pictureOperation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
            float tbr = [[NSNumber numberWithLongLong:totalBytesRead] floatValue];
            float tbe = [[NSNumber numberWithLongLong:totalBytesExpectedToRead] floatValue];
            [self.progressBar setProgress:(tbr/tbe)];
        }];
        
        [pictureOperation start];
                
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failed to get team picture url: %@", error);
        //Show error dialog here
    }];
    [operation start];
}

-(NSString *)getLink:(int) mode {
    NSMutableDictionary *sports = [[NSMutableDictionary alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"AthleticLinks" ofType:@"plist"]];

    if([sports valueForKey:sportName]) {
        NSLog(@"Gender: %@ Sport: %@ return value: %@", currentGender, sportName, [[[sports valueForKey:sportName] valueForKey:currentGender] objectAtIndex:mode]);
        return [[[sports valueForKey:sportName] valueForKey:currentGender] objectAtIndex:mode];
    }
    return NULL;
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.teamPicture.contentMode = UIViewContentModeScaleAspectFit;
    self.progressBar.progress = 0.0;
    
    self.teamPicture.image = [UIImage imageNamed:@"TeamPlaceholder.png"];
    
    self.currentGender = [[NSUserDefaults standardUserDefaults] stringForKey:@"sportGender"];
    self.currentLink = [self getLink:0];
    [self findPictureLink];
    
    //Menu items for each sport
    listItems = [[NSArray alloc]initWithObjects:@"News", @"Roster", @"Schedule & Results", @"Mobile Webpage", nil];
    
    //Table customization - PrettyKit
    self.menuList.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.menuList.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
    
    [self setUpShadows];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
