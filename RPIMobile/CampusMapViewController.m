//
//  CampusMapViewController.m
//  RPIMobile
//
//  Created by Steve on 2/25/13.
//  Copyright (c) 2013 Rensselaer Polytechnic Institute. All rights reserved.
//

#import "CampusMapViewController.h"
#import "MapPin.h"

@implementation CampusMapViewController

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
    mapPoints = [NSArray array];
    NSString *mapData = [[NSBundle mainBundle] pathForResource:@"MapData" ofType:@"plist"];
    mapPoints = [[NSArray alloc] initWithContentsOfFile:mapData];
    NSLog(@"MapPoints: %@", mapPoints);
}

/*Build the map with pins*/
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

/*Load View*/
- (void)viewDidLoad
{
    [super viewDidLoad];

    /*The RPI student union is at 42.729970,-73.676649*/
    MKCoordinateRegion region;
    region.center.latitude = 42.7312;
    region.center.longitude = -73.6753125;
    region.span.latitudeDelta = 0.0230;
    region.span.longitudeDelta = 0.0274;
    

    [self loadPlaces];
    mapView = [[MKMapView alloc] initWithFrame:self.view.frame];
    mapView.region = region;
    mapView.showsUserLocation = TRUE;
    mapView.mapType = MKMapTypeHybrid;
    
    [self buildMap];
    [self.view addSubview:mapView];
}


@end
