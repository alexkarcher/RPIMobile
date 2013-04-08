//
//  AthleticsMainViewController.m
//  RPIMobile
//
//  Created by Stephen Silber on 9/27/12.
//  Copyright (c) 2012 Rensselaer Polytechnic Institute. All rights reserved.
//

#import "PrettyKit.h"
#import "SVSegmentedControl.h"
#import "AthleticsMainViewController.h"
#import "AthleticsSportViewController.h"

#define start_color [UIColor colorWithHex:0xEEEEEE]
#define end_color [UIColor colorWithHex:0xDEDEDE]

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-retain-cycles"


#define kInsetFloat 50

@interface AthleticsMainViewController ()

@end

@implementation AthleticsMainViewController
@synthesize _currentGender, genderControl;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) filterSports:(NSUInteger)newIndex {
    NSString *dataPath;

    if(newIndex == 0) { //male
        dataPath = [[NSBundle mainBundle] pathForResource:@"menSportsList" ofType:@"plist"];
        self._currentGender = @"Men";
    } else {
        dataPath = [[NSBundle mainBundle] pathForResource:@"womenSportsList" ofType:@"plist"];
        self._currentGender = @"Women";
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:self._currentGender forKey:@"sportGender"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    self->_sportsDic = [NSDictionary dictionaryWithContentsOfFile:dataPath];
    self->_sportsKeys = [NSMutableArray arrayWithArray:[self->_sportsDic allKeys]];
    [self->_sportsKeys sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    NSLog(@"Dic: %@ \n\nKeys: %@", self->_sportsDic, self->_sportsKeys);
    
    [self.tableView reloadData];
}

-(void) setupGenderControl {
    
    //Build SVSegmentedControl as header view for table view
    genderControl = [[SVSegmentedControl alloc] initWithSectionTitles:[NSArray arrayWithObjects:@"Men", @"Women", nil]];
    [genderControl setFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    [genderControl setCornerRadius:0];
    genderControl.thumb.tintColor = [UIColor darkGrayColor];
    genderControl.changeHandler = ^(NSUInteger newIndex) {
        __weak AthleticsMainViewController *self_ = self; // that's enough
        // respond to index change
        if(newIndex == 0) {
            self_._currentGender = @"Male";
        } else {
            self_._currentGender = @"Female";
        }
        NSLog(@"Filtering sports with gender: %@", self._currentGender);
        
        [self_ filterSports:newIndex];
    };
    
    [genderControl setCrossFadeLabelsOnDrag:YES];
    [genderControl setCenter:CGPointMake(self.view.frame.size.width/2, genderControl.frame.size.height/2)];
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    self._currentGender = @"Male";
    
    self.title = @"Athletics";
      
    self.tableView.rowHeight = 50;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
    
    [self setupGenderControl];
    [self filterSports:0];
    
    CGFloat _insetWidth = kInsetFloat;
    
    [genderControl setTitleEdgeInsets:UIEdgeInsetsMake(15, _insetWidth, 15, _insetWidth)];
    
    [self.tableView setTableHeaderView:genderControl];
//    [self setUpShadows];
    

}


- (void) setUpShadows {
    [PrettyShadowPlainTableview setUpTableView:self.tableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return tableView.rowHeight + [PrettyTableViewCell tableView:tableView neededHeightForIndexPath:indexPath];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self->_sportsKeys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
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
    
    [cell prepareForTableView:tableView indexPath:indexPath];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    
    
    cell.textLabel.text = [self->_sportsKeys objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AthleticsSportViewController *nextView = [[AthleticsSportViewController alloc] init];
    nextView._sportName = [self->_sportsKeys objectAtIndex:indexPath.row];
    nextView._shortSportName = [self->_sportsDic objectForKey:nextView._sportName];
    [self.navigationController pushViewController:nextView animated:YES];
    
}

-(BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    if(toInterfaceOrientation == UIDeviceOrientationLandscapeLeft || toInterfaceOrientation == UIDeviceOrientationLandscapeRight) {
        return NO;
    } else {
        return YES;
    }
}

-(BOOL) shouldAutorotate {
    return NO;
}

@end
