//
//  CampusMapViewController.m
//  RPIMobile
//
//  Created by Stephen Silber on 10/31/12.
//  Copyright (c) 2012 Rensselaer Polytechnic Institute. All rights reserved.
//

#import "CampusMapViewController.h"
#import "MKMapView+ZoomLevel.h"
#import "MapPin.h"
@interface CampusMapViewController ()

@end

@implementation CampusMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) loadPlaces {
    mapPoints = [NSArray array];
    NSString *mapData = [[NSBundle mainBundle] pathForResource:@"MapData" ofType:@"plist"];
    mapPoints = [[NSArray alloc] initWithContentsOfFile:mapData];
    NSLog(@"MapPoints: %@", mapPoints);
}

-(void) buildMap {    
    pins = [NSMutableArray array];
    for(id marker in mapPoints) {
        MapPin *pin = [[MapPin alloc] initWithCoordinates:CLLocationCoordinate2DMake([[marker objectAtIndex:2] doubleValue], [[marker objectAtIndex:3] doubleValue]) placeName:[marker objectAtIndex:0] description:[marker objectAtIndex:1]];
        [pins addObject:pin];
    }
    NSLog(@"Pins: %@", pins);
    //All pins added to map
    [mapView addAnnotations:pins];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    MKCoordinateRegion region;
    region.center.latitude = 42.7312;
    region.center.longitude = -73.6753125;
    region.span.latitudeDelta = 0.0230;
    region.span.longitudeDelta = 0.0274;
    

    [self loadPlaces];
    mapView = [[MKMapView alloc] initWithFrame:self.view.frame];
    mapView.region = region;
    [self buildMap];
    [self.view addSubview:mapView];
    [mapView setCenterCoordinate:CLLocationCoordinate2DMake(42.746632, -75.770041) zoomLevel:13 animated:YES];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
