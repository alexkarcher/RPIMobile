//
//  RPIEvent.h
//  RPIMobile
//
//  Created by Stephen Silber on 2/21/13.
//  Copyright (c) 2013 Rensselaer Polytechnic Institute. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RPIEvent : NSObject {
    bool allday;
    NSDate *start_date;
    NSDate *end_date;
    
    NSString *event_summary;
    NSString *event_description;
    NSURL *event_link;
    
    NSString *contact_name;
    NSString *contact_number;
    NSURL *contact_link;
    
    NSMutableArray *categories;
}

@property (nonatomic) NSString *event_summary;
@property (nonatomic) NSString *event_description;
@property (nonatomic) NSString *contact_name;
@property (nonatomic) NSString *contact_number;
@property (nonatomic) NSURL *contact_link;
@property (nonatomic) NSURL *event_link;
@property (nonatomic) NSDate *start_date;
@property (nonatomic) NSDate *end_date;
@property (nonatomic) NSMutableArray *categories;

- (void) buildDatesFromStrings:(NSString *)sd_string endDateString:(NSString *)ed_string;
- (id) initWithSummary:(NSString *)sum description:(NSString *)desc startDate:(NSDate *)s_date endDate:(NSDate *)e_date;
- (id) initWithSummary:(NSString *)sum description:(NSString *)desc;


@end
