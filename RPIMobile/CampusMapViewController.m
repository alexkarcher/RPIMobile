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
#import "MapPin.h"

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
    mapPoints = [NSArray array];
    NSString *mapData = [[NSBundle mainBundle] pathForResource:@"MapData" ofType:@"plist"];
    mapPoints = [[NSArray alloc] initWithContentsOfFile:mapData];
    NSLog(@"MapPoints: %@", mapPoints);
}

/*Build the map with pins*/
-(void) buildMap {    
    pins = [NSMutableArray array];
    for(id marker in mapPoints) {
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
    
    [_mapView setUserTrackingMode: MKUserTrackingModeFollowWithHeading
                         animated: YES];
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

        
        if(t.cat == 0) pinView.image = [[UIImage imageNamed:@"marker.png"] imageTintedWithColor:[UIColor colorWithRed:0.049 green:0.743 blue:1.000 alpha:1.000]];
        else if(t.cat == 1) pinView.image = [[UIImage imageNamed:@"flag.png"] imageTintedWithColor:[UIColor colorWithRed:1.000 green:0.920 blue:0.105 alpha:1.000]];
        else if(t.cat == 2) pinView.image = [[UIImage imageNamed:@"flat.png"] imageTintedWithColor:[UIColor colorWithRed:0.255 green:0.866 blue:0.095 alpha:1.000]];
        else if(t.cat == 3) pinView.image = [[UIImage imageNamed:@"flag.png"] imageTintedWithColor:[UIColor colorWithRed:0.908 green:0.477 blue:0.184 alpha:1.000]];
        else pinView.image = [[UIImage imageNamed:@"marker.png"] imageTintedWithColor:[UIColor colorWithRed:0.892 green:0.000 blue:0.000 alpha:1.000]];
    }
    else {
        [_mapView.userLocation setTitle:@"I am here"];
    }
    return pinView;
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
    
    [self buildMap];
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

}


@end
