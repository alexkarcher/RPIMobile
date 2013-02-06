//
//  AthleticsViewController.m
//  RPIMobile
//
//  Created by Stephen Silber on 6/18/12.
//  Copyright (c) 2012 Rensselaer Polytechnic Institute. All rights reserved.
//

#import "AthleticsViewController.h"
#import "SportViewController.h"
#import "PrettyKit.h"

@implementation AthleticsViewController
@synthesize sportsList, currentGender;

#define start_color [UIColor colorWithHex:0xEEEEEE]
#define end_color [UIColor colorWithHex:0xDEDEDE]

-(void) segmentedControlUpdated:(id)sender{
    UISegmentedControl *s = (UISegmentedControl *)sender;
    if(s.selectedSegmentIndex == 0) {
        self.currentGender = @"Men";
    } else {
        self.currentGender = @"Women";
    }
    [[NSUserDefaults standardUserDefaults] setObject:currentGender forKey:@"sportGender"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self filterSports];
}

-(void) filterSports {
    
    //Filter sports based on currentGender
    sports = [[NSMutableDictionary alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@Sports",currentGender] ofType:@"plist"]];
    sportsArr = [[NSMutableArray alloc] initWithArray:[sports allKeys]];
    [sportsArr sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    [self.sportsList reloadData];
}

#pragma mark -
#pragma mark Table View Data Source Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return sportsArr.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return tableView.rowHeight + [PrettyTableViewCell tableView:tableView neededHeightForIndexPath:indexPath];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.title = @"Athletics";
    
    SportViewController *nextView = [[SportViewController alloc] initWithNibName:@"SportViewController" bundle:nil];
    nextView.sportName = [sportsArr objectAtIndex:[indexPath row]];
    nextView.title = nextView.sportName;
    [self.navigationController pushViewController:nextView animated:YES];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    PrettyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[PrettyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.tableViewBackgroundColor = tableView.backgroundColor;
        cell.gradientStartColor = start_color;
        cell.gradientEndColor = end_color;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    [cell prepareForTableView:tableView indexPath:indexPath];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    
    
    cell.textLabel.text = [sportsArr objectAtIndex:indexPath.row];
    return cell;
    
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void) setUpShadows {
    [PrettyShadowPlainTableview setUpTableView:self.sportsList];
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    //Quick gender check/save
    if([[NSUserDefaults standardUserDefaults] stringForKey:@"sportGender"]) {
        self.currentGender = [[NSUserDefaults standardUserDefaults] stringForKey:@"sportGender"];
    } else {
        self.currentGender = @"Men";
    }
    
    self.sportsList.rowHeight = 60;
    self.sportsList.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.sportsList.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
    
    [self filterSports];
    
    UISegmentedControl *genderControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Men", @"Women", nil]];
    [genderControl addTarget:self
                      action:@selector(segmentedControlUpdated:)
            forControlEvents:UIControlEventValueChanged];
    
    genderControl.segmentedControlStyle = UISegmentedControlStyleBar;
    genderControl.selectedSegmentIndex = 0;
    [self segmentedControlUpdated:genderControl];
    genderControl.tintColor = COLOR(190, 0, 0);
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView: genderControl];
    
    [self setUpShadows];
    
}

-(void)viewDidAppear:(BOOL)animated {
    UILabel * nav_title = [[UILabel alloc] initWithFrame:CGRectMake(800, 2, 220, 25)];
    nav_title.font = [UIFont fontWithName:@"Arial-BoldMT" size:18];
    nav_title.textColor = [UIColor whiteColor];
    nav_title.adjustsFontSizeToFitWidth = YES;
    nav_title.text = @"     Athletics";
    self.title = @"";
    nav_title.backgroundColor = [UIColor clearColor];
    self.navigationItem.titleView = nav_title;
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end