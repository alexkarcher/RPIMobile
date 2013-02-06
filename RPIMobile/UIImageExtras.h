//
//  UIImageExtras.h
//  RPIMobile
//
//  Created by Stephen Silber on 6/19/12.
//  Copyright (c) 2012 Rensselaer Polytechnic Institute. All rights reserved.
//

@interface UIImage (Extras)
- (UIImage *)imageByScalingProportionallyToSize:(CGSize)targetSize;
-(UIImage*) scaleAndCropToSize:(CGSize)newSize;
- (UIImage *)resizedImageWithContentMode:(UIViewContentMode)contentMode imageToScale:(UIImage*)imageToScale bounds:(CGSize)bounds interpolationQuality:(CGInterpolationQuality)quality;
+ (UIImage*)imageWithImage:(UIImage*)image 
              scaledToSize:(CGSize)newSize;
@end;