//
//  CampusMapViewController.h
//  RPIMobile
//
//  Created by Steve on 2/25/13.
//  Copyright (c) 2013 Rensselaer Polytechnic Institute. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface CampusMapViewController : UIViewController <MKMapViewDelegate> {
    MKMapView *mapView;
    NSArray *mapPoints;
    NSMutableArray *pins;
}

@end
