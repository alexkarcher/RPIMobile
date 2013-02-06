//
//  Athlete.h
//  RPIMobile
//
//  Created by Stephen Silber on 6/18/12.
//  Copyright (c) 2012 Rensselaer Polytechnic Institute. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Athlete : NSObject {
    NSString *_name;
    NSString *_hometown;
    NSString *_profileURL;
    NSString *_imageURL;
}

@property (strong) NSString *_name, *_hometown, *_profileURL, *_imageURL;

- (id) initWithDic:(NSDictionary *)dic;

@end
