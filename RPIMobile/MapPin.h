//
//  MapPin.h
//  RPIMobile
//
//  Created by Steve on 2/25/13.
//  Copyright (c) 2013 Rensselaer Polytechnic Institute. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MapPin : NSObject<MKAnnotation> {
    CLLocationCoordinate2D coordinate;
    NSString *title;
    NSString *subtitle;
    int cat;
    /*
     0 - Blue   (Student Housing)
     1 - Yellow (Student Life)
     2 - Green  (Administration/Operations)
     3 - Orange (Academics/Research)
        
        Source:
        https://www.rpi.edu/tour/rpi_campus_map_2010.pdf
     */
}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) NSString *subtitle;
@property (nonatomic) int cat;

- (id)initWithCoordinates:(CLLocationCoordinate2D)location placeName:(NSString *)placeName description:(NSString *)description category:(int)cat;
@end