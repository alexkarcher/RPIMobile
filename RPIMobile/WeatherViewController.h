//
//  WeatherViewController.h
//  RPIMobile
//
//  Created by Stephen Silber on 6/21/12.
//  Copyright (c) 2012 Rensselaer Polytechnic Institute. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrettyKit.h"
#import "AFNetworking.h"

@interface WeatherCondition : NSObject {
    NSString *_description;
    NSString *_percipitation;
    NSString *_date;
    NSString *_tempMax;
    NSString *_tempMin;
    NSString *_iconUrl;
    NSString *_windDirection;
    NSString *_windSpeed;
    
    //Current Conditions
    BOOL _current;
    NSString *_cloudCover;
    NSString *_currentTemp;
    NSString *_visibility;
    NSString *_humidity;
    
}
@property (nonatomic) NSString *_description, *_percipitation, *_date, *_tempMax, *_tempMin, *_iconUrl, *_windDirection, *_windSpeed, *_cloudCover, *_currentTemp, *_visibility, *_humidity;
@property (nonatomic) BOOL _current;
@end



@interface WeatherViewController : UITableViewController <NSXMLParserDelegate> {
    NSXMLParser *weatherParser;
    NSMutableDictionary *weatherDic;
    NSMutableArray *weatherArr;
    NSMutableString *currentStringValue;
    WeatherCondition *condition;
}

@end
