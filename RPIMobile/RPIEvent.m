//
//  RPIEvent.m
//  RPIMobile
//
//  Created by Stephen Silber on 2/21/13.
//  Copyright (c) 2013 Rensselaer Polytechnic Institute. All rights reserved.
//

#import "RPIEvent.h"

@implementation RPIEvent

- (void) buildDatesFromStrings:(NSString *)sd_string endDateString:(NSString *)ed_string {
    
}
- (id) initWithSummary:(NSString *)sum description:(NSString *)desc startDate:(NSDate *)s_date endDate:(NSDate *)e_date {
    if(self = [super init]) {
        _event_summary = sum;
        _event_description = desc;
        _start_date = s_date;
        _end_date = e_date;
    }
    
    return self;
}
- (id) initWithSummary:(NSString *)sum description:(NSString *)desc {
    if(self = [super init]) {
        _event_summary = sum;
        _event_description = desc;
    }
    
    return self;
}


@end
