//
//  RosterViewController.h
//  RPIMobile
//
//  Created by Stephen Silber on 6/18/12.
//  Copyright (c) 2012 Rensselaer Polytechnic Institute. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"

@interface RosterViewController : UITableViewController <NSXMLParserDelegate, NSURLConnectionDelegate> {
    NSString *sportName;
    NSMutableData *receivedData;
    NSMutableArray *athleteData;
}

@property (strong) NSMutableArray *athleteData;
@property (strong) NSString *sportName;
@property (strong) NSArray* entries;
@property (strong) NSMutableData *receivedData;



@end
