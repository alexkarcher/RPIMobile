//
//  MainMapViewController.h
//  RPIMobile
//
//  Created by Stephen Silber on 9/23/12.
//  Copyright (c) 2012 Rensselaer Polytechnic Institute. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface MapOverlay : NSObject <MKOverlay> {
    
}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly) MKMapRect boundingMapRect;

- (MKMapRect)boundingMapRect;

@end
@interface MainMapViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate>  {
    MKMapView *_mapView;
    CLLocationManager *locationManager;
}

@property (nonatomic) MKMapView *_mapView;
@property (nonatomic) CLLocationManager *locationManager;


@end
