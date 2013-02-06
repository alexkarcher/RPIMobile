//
//  MasterViewController.m
//  RPI Directory
//
//  Created by Brendon Justin on 4/13/12.
//  Copyright (c) 2012 Brendon Justin. All rights reserved.
//

#import "DirectoryMasterViewController.h"
#import "DirectoryDetailViewController.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "Person.h"

const NSString *SEARCH_URL = @"http://rpidirectory.appspot.com/api?source=rpimobile&q=";     //  Base search URL
//const NSTimeInterval SEARCH_INTERVAL = 1.0f;                                //  3 seconds

@interface DirectoryMasterViewController () {
    NSMutableArray      *m_people;
    NSTimer             *m_searchTimer;
    NSString            *m_searchString;
    NSString            *m_lastString;
    UITableView         *m_currentTableView;
    
    //    dispatch_queue_t    m_queue;
    
    //    Boolean             m_textChanged;
}

@end

@implementation DirectoryMasterViewController

@synthesize detailViewController = _detailViewController;
@synthesize PersonSearchBar, resultsTableView;


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"RPI Directory";
    
    self.PersonSearchBar.delegate = self;
    self.PersonSearchBar.showsCancelButton = YES;
    self.PersonSearchBar.tintColor = [UIColor darkGrayColor];
    self.PersonSearchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
    } else {
        return YES;
    }
}
-(void) updateTable:(NSMutableArray *)p {
    m_people = [[NSMutableArray alloc] initWithArray:p];
    [self.searchDisplayController.searchResultsTableView reloadData];
    [self.resultsTableView reloadData];
}

#pragma mark - Search Delegate

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.PersonSearchBar resignFirstResponder];
}

-(void) downloadSearchData:(NSURL *) url {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{

    });
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //Successful download from RPI Directory API
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSData *resultData = responseObject;
        id results = [NSJSONSerialization JSONObjectWithData:resultData
                                                     options:NSJSONReadingMutableLeaves
                                                       error:nil];
        
        if (results && [results isKindOfClass:[NSDictionary class]]) {
            NSMutableArray *people = [NSMutableArray array];
            if([[results objectForKey:@"data"] count] > 0) {
                for (NSDictionary *personDict in [results objectForKey:@"data"]) {
                    NSMutableDictionary *editDict;
                    Person *person = [[Person alloc] init];
                    person.name = [personDict objectForKey:@"name"];
                    
                    //  Remove the 'name' field from the details dictionary
                    //  as it is redundant.
                    editDict = [personDict mutableCopy];
                    if ([editDict objectForKey:@"name"] != nil) {
                        [editDict removeObjectForKey:@"name"];
                    }
                    person.details = editDict;
                    
                    [people addObject:person];
                }
                [self updateTable:people];
            } else {
                //No people found
                NSLog(@"No people found!");
                m_people = [NSMutableArray arrayWithCapacity:0];
                [self updateTable:m_people];
            }
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //Error downloading data
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if([error code] == 2) {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                [self setTitle:@"Request Timed Out!"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                });
            });
        }
        NSLog(@"Error: %@", error);
    }];
    [operation start];

}
//Need to implement separate thread searching to keep UI from locking user out
-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {

    NSString *query = [PersonSearchBar.text stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    NSString *searchUrl = [SEARCH_URL stringByAppendingString:query];
    NSURL *url = [NSURL URLWithString:searchUrl];
    [self downloadSearchData:url];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return m_people.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonCell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:@"PersonCell"];
    }
    
    Person *person = [m_people objectAtIndex:indexPath.row];
    cell.textLabel.text = [person name];
    
    NSString *subtitle = [[person details] objectForKey:@"year"];
    if (subtitle == nil) {
        subtitle = [[person details] objectForKey:@"title"];
    }
    
    if (subtitle != nil) {
        cell.detailTextLabel.text = subtitle;
    }
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DirectoryDetailViewController *personView = [[DirectoryDetailViewController alloc] initWithStyle:UITableViewStyleGrouped];
    personView.person = [m_people objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:personView animated:YES];
    /*
     m_currentTableView = tableView;
     if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
     Person *person = [m_people objectAtIndex:indexPath.row];
     self.detailViewController.person = person;
     } else if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
     [self performSegueWithIdentifier:@"showDetail" sender:self];
     }*/
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [m_currentTableView indexPathForSelectedRow];
        Person *person = [m_people objectAtIndex:indexPath.row];
        [[segue destinationViewController] setPerson:person];
    }
}

@end
