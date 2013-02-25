//
//  DemoCalendarMonth.m
//  Created by Devin Ross on 10/31/09.
//
/*
 
 tapku.com || https://github.com/devinross/tapkulibrary
 
 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the "Software"), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:
 
 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.
 
 */

#import "AFNetworking.h"

#import "EventsMainViewController.h"
#import "RPIEvent.h"
#import "JSONKit.h"

#define kURL @"http://events.rpi.edu/webcache/v1.0/jsonRange/20130201/20130228/list-json/%28catuid%3D%2700f18254-27fe1f37-0127-fe1f37da-00000001%27%7Ccatuid%3D%2700f18254-2ed78a1d-012e-d985bd10-00002a26%27%7Ccatuid%3D%2700f18254-27ff9c18-0127-ff9c1912-00000013%27%29/no--object.json"


@interface EventsMainViewController () {
    NSMutableDictionary *event_array;
}

@end
@implementation EventsMainViewController


- (void) buildDotArray {
    self.dataArray = [NSMutableArray array];

    //Inialize array with all falses for days
    for(int i = 0; i < 18; ++i) {
        [self.dataArray addObject:[NSNumber numberWithBool:YES]];
    }
    for(int i = 0; i < 20; ++i) {
        [self.dataArray addObject:[NSNumber numberWithBool:NO]];
    }
    /*for(id e in event_array) {
        NSString *short_date = [[e objectForKey:@"start"] objectForKey:@"shortdate"];
        int location = [[[short_date componentsSeparatedByString:@"/"] objectAtIndex:1] intValue];
        
        if([self.dataArray objectAtIndex:location] == [NSNumber numberWithBool:NO]) {
            //Set the calendar to display a dot
            [self.dataArray replaceObjectAtIndex:location withObject:[NSNumber numberWithBool:YES]];
        }

    }*/
    
    NSLog(@"New dots built!");
}
- (void) fetchEvents:(NSString *)feed {
    event_array = [[NSMutableDictionary alloc] init];
    NSURL *url = [NSURL URLWithString:feed];

    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:7];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //Success!
        NSDictionary *events = [[[[operation responseString] objectFromJSONString] objectForKey:@"bwEventList"] objectForKey:@"events"];
//        NSLog(@"Events: %@", events);
        
        for(id e in events) {

            RPIEvent *temp = [[RPIEvent alloc] initWithSummary:[e objectForKey:@"summary"] description:[e objectForKey:@"description"]];
            NSString *sd = [[e objectForKey:@"start"] objectForKey:@"datetime"];
            NSString *ed = [[e objectForKey:@"end"] objectForKey:@"datetime"];
            [temp buildDatesFromStrings:sd endDateString:ed];
            
            [event_array setObject:temp forKey:[e objectForKey:@"guid"]];
            
            [self buildDotArray];
            
        }
  
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //
    }];
    
    [operation start];
}

#pragma mark - View Lifecycle
- (void) viewDidLoad{
	[super viewDidLoad];
	[self.monthView selectDate:[NSDate month]];
    [self fetchEvents:kURL];
}



#pragma mark - MonthView Delegate & DataSource
- (NSArray*) calendarMonthView:(TKCalendarMonthView*)monthView marksFromDate:(NSDate*)startDate toDate:(NSDate*)lastDate{
//	[self generateRandomDataForStartDate:startDate endDate:lastDate];
    [self buildDotArray];
	return self.dataArray;
}
- (void) calendarMonthView:(TKCalendarMonthView*)monthView didSelectDate:(NSDate*)date{
	
	// CHANGE THE DATE TO YOUR TIMEZONE
	TKDateInformation info = [date dateInformationWithTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
	NSDate *myTimeZoneDay = [NSDate dateFromDateInformation:info timeZone:[NSTimeZone systemTimeZone]];
	
	NSLog(@"Date Selected: %@",myTimeZoneDay);
	
	[self.tableView reloadData];
}
- (void) calendarMonthView:(TKCalendarMonthView*)mv monthDidChange:(NSDate*)d animated:(BOOL)animated{
	[super calendarMonthView:mv monthDidChange:d animated:animated];
	[self.tableView reloadData];
}


#pragma mark - UITableView Delegate & DataSource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
	
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSArray *ar = [self.dataDictionary objectForKey:[self.monthView dateSelected]];
	if(ar == nil) return 0;
	return [ar count];
}
- (UITableViewCell *) tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
	
    
	NSArray *ar = [self.dataDictionary objectForKey:[self.monthView dateSelected]];
	cell.textLabel.text = [ar objectAtIndex:indexPath.row];
	
    return cell;
	
}


- (void) generateRandomDataForStartDate:(NSDate*)start endDate:(NSDate*)end{
	// this function sets up dataArray & dataDictionary
	// dataArray: has boolean markers for each day to pass to the calendar view (via the delegate function)
	// dataDictionary: has items that are associated with date keys (for tableview)
	
	
	NSLog(@"Delegate Range: %@ %@ %d",start,end,[start daysBetweenDate:end]);
	
	self.dataArray = [NSMutableArray array];
	self.dataDictionary = [NSMutableDictionary dictionary];
	
	NSDate *d = start;
	while(YES){
		
		int r = arc4random();
		if(r % 3==1){
			[self.dataDictionary setObject:[NSArray arrayWithObjects:@"Item one",@"Item two",nil] forKey:d];
			[self.dataArray addObject:[NSNumber numberWithBool:YES]];
			
		}else if(r%4==1){
			[self.dataDictionary setObject:[NSArray arrayWithObjects:@"Item one",nil] forKey:d];
			[self.dataArray addObject:[NSNumber numberWithBool:YES]];
			
		}else
			[self.dataArray addObject:[NSNumber numberWithBool:NO]];
		
		
		TKDateInformation info = [d dateInformationWithTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
		info.day++;
		d = [NSDate dateFromDateInformation:info timeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
		if([d compare:end]==NSOrderedDescending) break;
	}
	
}


@end
