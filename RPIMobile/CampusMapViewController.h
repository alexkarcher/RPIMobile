//
//  CampusMapViewController.h
//  RPIMobile
//
//  Created by Stephen Silber on 10/31/12.
//  Copyright (c) 2012 Rensselaer Polytechnic Institute. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface CampusMapViewController : UIViewController <MKMapViewDelegate> {
    MKMapView *mapView;
    NSArray *mapPoints;
    NSMutableArray *pins;
}

@end
