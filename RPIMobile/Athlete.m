//
//  Athlete.m
//  RPIMobile
//
//  Created by Stephen Silber on 6/18/12.
//  Copyright (c) 2012 Rensselaer Polytechnic Institute. All rights reserved.
//

#import "Athlete.h"

@implementation Athlete

@synthesize _name, _hometown, _imageURL, _profileURL;

- (id) initWithDic:(NSDictionary *)dic {
    if(self = [super init]) {
        self._name = [self checkForNull:[dic objectForKey:@"name"]];
        self._hometown = [self checkForNull:[dic objectForKey:@"hometown"]];
        self._imageURL = [self checkForNull:[dic objectForKey:@"image"] ];
        self._profileURL = [self checkForNull:[dic objectForKey:@"url"]];
    }
    
    return self;
}

- (NSString *) checkForNull:(id)inString {
    if([inString isKindOfClass:[NSString class]]) {
        return (NSString *)inString;
    }
    
    return @"";
}
@end
