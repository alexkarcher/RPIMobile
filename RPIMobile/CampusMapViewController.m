//
//  CampusMapViewController.m
//  RPIMobile
//
//  Created by Steve on 2/25/13.
//  Copyright (c) 2013 Rensselaer Polytechnic Institute. All rights reserved.
//

#import "CampusMapViewController.h"
#import "MTLocation.h"
#import "PrettyKit.h"
#import <MapKit/MapKit.h>
#import "UIImage+Tint.h"
#import "NSString+Score.h"
#import "MapPin.h"

#define kSearchThreshold 0.25

/*  BUGS:
    * empty
 
    TO-DO:
    * Comment code more
    * Filterable (0/1/2/3 checkbox) map markers
    * Design better map marker (think more gradient, no relying on tint)
    * Finish marking mapdata with category (colors listed in header file!)
    * Implement user location compass view (which direction user is facing) -- http://www.cocoacontrols.com/controls/mtlocation
    * Implement better callout -- http://www.cocoacontrols.com/controls/gikanimatedcallout
        ** ^^ NOT iOS 6 READY
*/

@interface CampusMapViewController ()
@property (nonatomic, retain) MTLocateMeButton *locateMeItem;
@property (nonatomic, strong) NSArray *resultsArr;
@end

@implementation CampusMapViewController
@synthesize locateMeItem;

/*Initilization*/
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

/*Places*/
-(void) loadPlaces {
    NSString *mapData = [[NSBundle mainBundle] pathForResource:@"MapData" ofType:@"plist"];
    mapPoints = [[NSArray alloc] initWithContentsOfFile:mapData];
    NSLog(@"MapPoints: %@", mapPoints);
}

- (void) filterPinsFromText:(NSString *)searchString withFuzzyNumber:(NSNumber *) fuzz {
    NSMutableArray *returnArr = [NSMutableArray array];
    
    for(MapPin *pin in mapPoints) {
//        NSLog(@"%@", [pin getTitle]);
        NSString *title = @"DCC";
        float stringResults = [searchString scoreAgainst:title];
        if(stringResults > [fuzz floatValue]) {
            [returnArr addObject:pin];
        }
    }
    _resultsArr = returnArr;
}

/*Build the map with pins*/
-(void) buildMapFromArray:(NSArray *) points {
    pins = [NSMutableArray array];
    for(id marker in points) {
        MapPin *pin;

        pin = [[MapPin alloc] initWithCoordinates:CLLocationCoordinate2DMake([[marker objectAtIndex:2] doubleValue], [[marker objectAtIndex:3] doubleValue]) placeName:[marker objectAtIndex:0] description:[marker objectAtIndex:1] category:[[marker objectAtIndex:4] intValue]];
        
        [pins addObject:pin];
    }
    NSLog(@"Pins: %@", pins);
    //All pins added to map
    [_mapView addAnnotations:pins];
}

- (void) locateMe:(id) sender {
    if(_mapView.showsUserLocation == YES) {
        _mapView.showsUserLocation = NO;
    } else {
        _mapView.showsUserLocation = NO;
    }
    
//    [_mapView setUserTrackingMode: MKUserTrackingModeFollowWithHeading animated: YES];
}

-(MKAnnotationView *)mapView:(MKMapView *)mV viewForAnnotation:(id <MKAnnotation>)annotation
{
    if (annotation==_mapView.userLocation)
        return nil;
    MapPin *t = annotation;
    MKAnnotationView *pinView = nil;
    if(annotation != _mapView.userLocation)
    {
        static NSString *defaultPinID = @"com.invasivecode.pin";
        pinView = (MKAnnotationView *)[_mapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
        if ( pinView == nil )
            pinView = [[MKAnnotationView alloc]
                       initWithAnnotation:annotation reuseIdentifier:defaultPinID];
        
        pinView.canShowCallout = YES;

        if(t.cat == 0) pinView.image = [UIImage imageNamed:@"marker_blue.png"];
        else if(t.cat == 1) pinView.image = [UIImage imageNamed:@"marker_yellow.png"];
        else if(t.cat == 2) pinView.image = [UIImage imageNamed:@"marker_green.png"];
        else if(t.cat == 3) pinView.image = [UIImage imageNamed:@"marker_orange.png"];
        else pinView.image = [UIImage imageNamed:@"marker_red.png"];
        
        CGRect pinFrame = pinView.frame;
        pinView.frame = CGRectMake(pinFrame.origin.x, pinFrame.origin.y, pinFrame.size.width/2, pinFrame.size.width/2);
    }
    else {
        [_mapView.userLocation setTitle:@"I am here"];
    }
    return pinView;
}

- (void) buildSearchBar {
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0,0,320,40)]; // frame has no effect.
    searchBar.delegate = self;
    searchBar.placeholder = @"Search buildings";
    searchBar.showsCancelButton = YES;
    [searchBar setTintColor:[UIColor redColor]];
    
    [self.view addSubview:searchBar];

    UISearchDisplayController *searchCon = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self ];
    self->searchController = searchCon;
    searchController.delegate = self;
//    searchController.searchResultsDataSource = self;
//    searchController.searchResultsDelegate = self;
    
//    [searchController setActive:YES animated:YES];
//    [searchBar becomeFirstResponder];
}

- (void) filter:(id) sender {
    
}

/*Load View*/
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Campus Map";

    /*The RPI student union is at 42.729970,-73.676649*/
    MKCoordinateRegion region;
    region.center.latitude = 42.7312;
    region.center.longitude = -73.6753125;
    region.span.latitudeDelta = 0.0230;
    region.span.longitudeDelta = 0.0274;
    

    [self loadPlaces];
    _mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    _mapView.region = region;
    _mapView.showsUserLocation = TRUE;
    _mapView.mapType = MKMapTypeHybrid;
    _mapView.delegate = self;

    
    // Configure Location Manager
    [MTLocationManager sharedInstance].locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [MTLocationManager sharedInstance].locationManager.distanceFilter = kCLDistanceFilterNone;
    [MTLocationManager sharedInstance].locationManager.headingFilter = 5; // 5 Degrees
    
    [self buildMapFromArray:mapPoints];
    [self.view addSubview:_mapView];
    
    // create locate-me item, automatically prepare mapView
    self.locateMeItem = [MTLocateMeBarButtonItem userTrackingBarButtonItemForMapView:_mapView]; // @property (nonatomic, strong) UIBarButtonItem *locationItem;
    // add target-action
    [self.locateMeItem addTarget:self action:@selector(locateMe:) forControlEvents:UIControlEventTouchUpInside];
    // disable heading
    self.locateMeItem.headingEnabled = YES;
    PrettyToolbar *toolbar = [[PrettyToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 88, self.view.frame.size.width, 44)];
    toolbar.topLineColor = [UIColor colorWithHex:0xFF1000];
    toolbar.gradientStartColor = [UIColor colorWithHex:0xDD0000];
    toolbar.gradientEndColor = [UIColor colorWithHex:0xAA0000];
    toolbar.bottomLineColor = [UIColor colorWithHex:0x990000];
    [self.view addSubview:toolbar];
    // create array with ToolbarItems
    NSArray *toolbarItems = [NSArray arrayWithObject:self.locateMeItem];
    // set toolbar items
    [toolbar setItems:toolbarItems animated:NO];
    [MTLocationManager sharedInstance].mapView = _mapView;
    [self buildSearchBar];
//    [self filterPinsFromText:@"DCC" withFuzzyNumber:[NSNumber numberWithFloat:0.25]];
    
    UIBarButtonItem *m_barButtonRight = [[UIBarButtonItem alloc] initWithTitle:@"Filter" style:UIBarButtonItemStylePlain target:self action:@selector(filter:)];
    [m_barButtonRight setTintColor:[UIColor colorWithRed:0.579 green:0.000 blue:0.000 alpha:1.000]];
    
    self.navigationItem.rightBarButtonItem = m_barButtonRight;


}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
//    [self->tableView setHidden:YES];
    [_mapView removeAnnotations:_mapView.annotations];
    [self filterPinsFromText:searchBar.text withFuzzyNumber:[NSNumber numberWithFloat:kSearchThreshold]];
    [self buildMapFromArray:_resultsArr];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if ([searchText length]>5) {
//        [self filterDataWithKeyword:searchText];
//        [self.tableView reloadData];
    } else {
//        [self resetFilter];
//        [self.tableView reloadData];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    //count of section
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 0;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
//    savedSearchTerm = searchString;
    
    [controller.searchResultsTableView setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.8]];
    [controller.searchResultsTableView setRowHeight:800];
    [controller.searchResultsTableView setScrollEnabled:NO];
    return NO;
}

- (void)searchDisplayController:(UISearchDisplayController *)controller didHideSearchResultsTableView:(UITableView *)tableView
{
    // undo the changes above to prevent artefacts reported below by mclin
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellId";
    
    UITableViewCell *cell = [self->tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
//    MapPin *pin = [_resultsArr objectAtIndex:indexPath.row];
    cell.textLabel.text = @"tt";
//    cell.detailTextLabel.text = [pin subtitle];
    
    return cell;
}

@end
