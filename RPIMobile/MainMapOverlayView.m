//
//  MainMapOverlayView.m
//  RPIMobile
//
//  Created by Stephen Silber on 9/24/12.
//  Copyright (c) 2012 Rensselaer Polytechnic Institute. All rights reserved.
//

#import "MainMapOverlayView.h"
#import "MainMapViewController.h"

@implementation MainMapOverlayView

- (void)drawMapRect:(MKMapRect)mapRect zoomScale:(MKZoomScale)zoomScale inContext:(CGContextRef)ctx
{
    
    UIImage *image = [UIImage imageNamed:@"campusMap.png"];
    CGImageRef imageReference = image.CGImage;
    
    MKMapRect theMapRect = [self.overlay boundingMapRect];
    CGRect theRect = [self rectForMapRect:theMapRect];
    
    CGContextScaleCTM(ctx, 1.0, -1.0);
    CGContextTranslateCTM(ctx, 0.0, -theRect.size.height);
    CGContextDrawImage(ctx, theRect, imageReference);

}

@end
