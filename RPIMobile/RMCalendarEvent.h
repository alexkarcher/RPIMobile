//
//  RMCalendarEvent.h
//  RPIMobile
//
//  Created by Stephen Silber on 4/3/13.
//  Copyright (c) 2013 Rensselaer Polytechnic Institute. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RMCalendarEvent : NSObject {
    
}

@property (nonatomic, strong) NSString *ev_summary;
@property (nonatomic, strong) NSString *ev_description;
@property (nonatomic, strong) NSString *ev_guid;
@property (nonatomic, strong) NSString *ev_link;
@property (nonatomic, strong) NSString *ev_cost;
@property (nonatomic, strong) NSString *ev_location;
@property (nonatomic, strong) NSString *ev_loclink;
@property (nonatomic, strong) NSArray *ev_categories;

@property (nonatomic, strong) NSMutableDictionary *ev_contact;
@property (nonatomic, strong) NSMutableDictionary *ev_start;
@property (nonatomic, strong) NSMutableDictionary *ev_end;

- (id) initWithData:(NSMutableDictionary *) data;

@end
