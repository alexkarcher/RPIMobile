//
//  ScheduleEntry.h
//  RPIMobile
//
//  Created by Stephen Silber on 10/10/12.
//  Copyright (c) 2012 Rensselaer Polytechnic Institute. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ScheduleEntry : NSObject {
    NSString *_time;
    NSString *_date;
    NSString *_location;
    NSString *_score;
    NSString *_team;
    NSURL *_imageURL;
    
}

@property (strong) NSString *_time, *_date, *_location, *_score, *_team;
@property (strong) NSURL *_imageURL;

-(id) initWithDictionary:(NSDictionary *) dic;
@end