//
//  ScheduleEntry.m
//  RPIMobile
//
//  Created by Stephen Silber on 10/10/12.
//  Copyright (c) 2012 Rensselaer Polytechnic Institute. All rights reserved.
//

#import "ScheduleEntry.h"

@implementation ScheduleEntry

@synthesize _time, _location, _score, _date, _imageURL, _team;

-(id) initWithDictionary:(NSDictionary *) dic {
    if(self = [super init]) {
        self->_date = [dic objectForKey:@"date"];
        self->_imageURL = [NSURL URLWithString:[dic objectForKey:@"image"]];
        self->_location = [dic objectForKey:@"location"];
        self->_score = [dic objectForKey:@"score"];
        self->_time = [dic objectForKey:@"time"];
        self->_team = [dic objectForKey:@"team"];
    }
    
    return self;
}

@end