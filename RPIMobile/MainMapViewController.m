//
//  MainMapViewController.m
//  RPIMobile
//
//  Created by Stephen Silber on 9/23/12.
//  Copyright (c) 2012 Rensselaer Polytechnic Institute. All rights reserved.
//

#import "MainMapViewController.h"
#import "MainMapOverlayView.h"

@implementation MapOverlay

#define kMapStartLat 42.7326
#define kMapStartLong -73.6756

-(CLLocationCoordinate2D)coordinate {
    return CLLocationCoordinate2DMake(kMapStartLat, kMapStartLong);
}

- (MKMapRect)boundingMapRect
{
    
    MKMapPoint upperLeft   = MKMapPointForCoordinate(CLLocationCoordinate2DMake(42.7410, -73.6860));
    MKMapPoint upperRight  = MKMapPointForCoordinate(CLLocationCoordinate2DMake(42.7386, -73.6647));
    MKMapPoint bottomLeft  = MKMapPointForCoordinate(CLLocationCoordinate2DMake(42.7267, -73.6890));
//    MKMapPoint bottomRight  = MKMapPointForCoordinate(CLLocationCoordinate2DMake(42.7257, -73.6694));
    
    MKMapRect bounds = MKMapRectMake(upperLeft.x, upperLeft.y, fabs(upperLeft.x - upperRight.x), fabs(upperLeft.y - bottomLeft.y));
    
    return bounds;
}

@end

@implementation MainMapViewController

@synthesize locationManager, _mapView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    MKAnnotationView *annotationView = [views objectAtIndex:0];
    id<MKAnnotation> mp = [annotationView annotation];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance([mp coordinate], 200, 200);
    
    [mapView setRegion:region animated:NO];
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay {
    
    MapOverlay *mapOverlay = (MapOverlay *)overlay;
    MainMapOverlayView *mapOverlayView = [[MainMapOverlayView alloc] initWithOverlay:mapOverlay];
    
    return mapOverlayView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"Campus Map"];
    _mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    [_mapView setDelegate:self];
    
    [self.view addSubview:_mapView];
    
    locationManager = [[CLLocationManager alloc] init];
    [locationManager setDelegate:self];
    
    CLLocationCoordinate2D annotationCoord;
    annotationCoord.latitude = kMapStartLat;
    annotationCoord.longitude = kMapStartLong;
    
    MKPointAnnotation *annotationPoint = [[MKPointAnnotation alloc] init];
    annotationPoint.coordinate = annotationCoord;
    annotationPoint.title = @"RPI Union";
    annotationPoint.subtitle = @"center of student life";
    [_mapView addAnnotation:annotationPoint];
    
    [locationManager setDistanceFilter:kCLDistanceFilterNone];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    
    [_mapView setShowsUserLocation:YES];
    
    MapOverlay * mapOverlay = [[MapOverlay alloc] init];
    [_mapView addOverlay:mapOverlay];
    
    
//    [locationManager setDistanceFilter:]
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
