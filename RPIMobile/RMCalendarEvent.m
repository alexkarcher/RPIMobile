//
//  RMCalendarEvent.m
//  RPIMobile
//
//  Created by Stephen Silber on 4/3/13.
//  Copyright (c) 2013 Rensselaer Polytechnic Institute. All rights reserved.
//

#import "RMCalendarEvent.h"

@implementation RMCalendarEvent


/*
 @property (nonatomic, strong) NSString *ev_summary;
 @property (nonatomic, strong) NSString *ev_description;
 @property (nonatomic, strong) NSString *ev_guid;
 @property (nonatomic, strong) NSString *ev_link;
 @property (nonatomic, strong) NSString *ev_cost;
 @property (nonatomic, strong) NSString *ev_location;
 
 @property (nonatomic, strong) NSArray *ev_categories;
 
 @property (nonatomic, strong) NSMutableDictionary *ev_contact;
 @property (nonatomic, strong) NSMutableDictionary *ev_start;
 @property (nonatomic, strong) NSMutableDictionary *ev_end;
 */

- (id) initWithData:(NSMutableDictionary *) data {
    
    if(self = [super init]) {
        //Custom calls
        self.ev_summary = [data objectForKey:@"summary"];
        self.ev_description = [data objectForKey:@"description"];
        self.ev_guid = [data objectForKey:@"guid"];
        self.ev_link = [data objectForKey:@"eventlink"];
        self.ev_cost = [data objectForKey:@"cost"];
        self.ev_location = [[data objectForKey:@"location"] objectForKey:@"address"];
        
        self.ev_contact = [data objectForKey:@"contact"];
        self.ev_start = [data objectForKey:@"start"];
        self.ev_end = [data objectForKey:@"end"];
    }
    
    
    return self;
}
@end
