//
//  RMCalendarViewController.m
//  RPIMobile
//
//  Created by Stephen Silber on 3/5/13.
//  Copyright (c) 2013 Rensselaer Polytechnic Institute. All rights reserved.
//
#import "RMCalendarEventViewController.h"
#import "RMCalendarViewController.h"
#import "RMCalendarEvent.h"
#import "AFNetworking.h"
#import "PrettyKit.h"
#import "JSONKit.h"


@interface RMCalendarViewController ()
@property (nonatomic, weak)   CKCalendarView *calendar;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSMutableArray *eventData;
@property (nonatomic, strong) NSArray *dayData;
@property (nonatomic, strong) NSDate *currentDate;
@property (nonatomic) BOOL    emptyFlag;
@end

@implementation RMCalendarViewController
@synthesize dateLabel = _dateLabel;
@synthesize dateFormatter = _dateFormatter;
@synthesize tableView = _tableView;
@synthesize currentDate, eventData, dayData, emptyFlag;

#define kEventURLp1 @"http://events.rpi.edu/webcache/v1.0/jsonRange/"
#define kEventURLp2 @"/list-json/no--filter/no--object.json"

/* BUG LIST:
    * Resizing table only called when date is selected, not when month is changed
    * Certain months not able to parse JSON? (WHAT IS GOING ON!?!?!)
    * Tap gesture recognied not working on navigationcontroller.navigationbar (override needed somewhere)
*/

/* TO-DO LIST:
    * Filters
        * URL builder function
    * Comment code
    * Strip strings of unusual characters/convert to regular chars
*/

- (id)init {
    self = [super init];
    if (self) {
        CKCalendarView *calendar = [[CKCalendarView alloc] initWithStartDay:startMonday];
        self.calendar = calendar;
        calendar.delegate = self;
        self.dateFormatter = [[NSDateFormatter alloc] init];
        [self.dateFormatter setDateFormat:@"yyyyMMdd"];
        NSDate *todayDate = [NSDate date];
        calendar.selectedDate = todayDate;
        calendar.minimumDate=    [NSDate dateWithTimeInterval:-31556900 sinceDate:todayDate];
        calendar.maximumDate = [NSDate dateWithTimeInterval:31556900 sinceDate:todayDate];
        calendar.shouldFillCalendar = YES;

        
        calendar.frame = CGRectMake(10, 10, 300, 320);
        [self.view addSubview:calendar];

        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"event_background"]];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(localeDidChange) name:NSCurrentLocaleDidChangeNotification object:nil];
    }
    return self;
}

- (void) goToToday:(id)sender {
    [self calendar:self.calendar didSelectDate:[NSDate date]];
//    [self.calendar setMonthShowing:[NSDate date]];
}

- (void) minimizeCalendar {
    
    CGRect calendarFrame = self.calendar.frame;
    CGRect tableFrame = _tableView.frame;
    
    if(calendarFrame.origin.y < 10) {
        calendarFrame.origin.y = 10;
        tableFrame.origin.y = self.calendar.bounds.size.height + 15;
    } else {
        calendarFrame.origin.y = -calendarFrame.size.height;
        tableFrame.origin.y = 0;
        tableFrame.size.height = self.view.bounds.size.height;
    }
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    
    self.calendar.frame = calendarFrame;
    _tableView.frame = tableFrame;
    
    [UIView commitAnimations];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    emptyFlag = YES;
    dayData = [NSMutableArray array];

    //Allocate table and add to view
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.calendar.bounds.size.height - 15, self.view.frame.size.width, self.view.frame.size.height - self.calendar.frame.size.height ) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    
    //Delegate/Datasource
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    //Tap gesture on navigation bar ** not working
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(minimizeCalendar)];
    [tapGesture setNumberOfTapsRequired:1];
    [self.navigationController.navigationBar addGestureRecognizer:tapGesture];

    UIButton *a1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [a1 setFrame:CGRectMake(0.0f, 0.0f, 25.0f, 25.0f)];
    [a1 addTarget:self action:@selector(minimizeCalendar) forControlEvents:UIControlEventTouchUpInside];
    [a1 setImage:[UIImage imageNamed:@"events"] forState:UIControlStateNormal];
    [a1 setAlpha:0.75];
    
    UIBarButtonItem *random = [[UIBarButtonItem alloc] initWithCustomView:a1];
    
    self.navigationItem.rightBarButtonItem = random;
    
    [self fetchCalendarData:[NSDate date]];

    [_tableView setBackgroundView:nil];
    _tableView.backgroundColor = [UIColor clearColor];
    
    [self setTitle:@"Events"];

}

- (NSString *)stringByRemovingControlCharacters: (NSString *)inputString
{
    NSCharacterSet *controlChars = [NSCharacterSet controlCharacterSet];
    NSRange range = [inputString rangeOfCharacterFromSet:controlChars];
    if (range.location != NSNotFound) {
        NSMutableString *mutable = [NSMutableString stringWithString:inputString];
        while (range.location != NSNotFound) {
            [mutable deleteCharactersInRange:range];
            range = [mutable rangeOfCharacterFromSet:controlChars];
        }
        return mutable;
    }
    return inputString;
}

-(void) resetMinimizeButton {
    UIButton *a1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [a1 setFrame:CGRectMake(0.0f, 0.0f, 25.0f, 25.0f)];
    [a1 addTarget:self action:@selector(minimizeCalendar) forControlEvents:UIControlEventTouchUpInside];
    [a1 setImage:[UIImage imageNamed:@"events"] forState:UIControlStateNormal];
    [a1 setAlpha:0.75];
    
    UIBarButtonItem *random = [[UIBarButtonItem alloc] initWithCustomView:a1];
    
    self.navigationItem.rightBarButtonItem = random;
}
- (void) fetchCalendarData:(NSDate *) date {
    
    //Progress indicator for UINavBar
    UIActivityIndicatorView *activityIndicator =
    [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
    self.title = @"Downloading...`";
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comp = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:date];
    [comp setDay:1];
    NSDate *firstDay = [gregorian dateFromComponents:comp];
    
    //Last day
    NSDate *curDate = date;
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* comps = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSWeekCalendarUnit|NSWeekdayCalendarUnit fromDate:curDate]; // Get necessary date components
    
    comps = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSWeekCalendarUnit|NSWeekdayCalendarUnit fromDate:curDate]; // Get necessary date components
    // set last of month
    [comps setMonth:[comps month]+1];
    [comps setDay:0];
    NSDate *lastDay = [calendar dateFromComponents:comps];

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd"];
    

    
    NSString *urlString = [NSString stringWithFormat:@"%@%@/%@%@", kEventURLp1, [formatter stringFromDate:firstDay], [formatter stringFromDate:lastDay] ,kEventURLp2];
    urlString = [self stringByRemovingControlCharacters:urlString];
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLRequest *req = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15.0];

    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:req];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.title = @"Events";
        // Set up events in a dictionary
        eventData = [NSMutableArray array];
        
        NSString *jsonString = [operation responseString];

        NSLog(@"Data(C): %i", jsonString.length);
        NSDictionary *_status = [jsonString objectFromJSONString];

        for(id _entry in [[_status objectForKey:@"bwEventList"] objectForKey:@"events"]) {
            RMCalendarEvent *tempEvent = [[RMCalendarEvent alloc] initWithData:_entry];
            [eventData addObject:tempEvent];
        }
        
        NSLog(@"Total events: %i\nOutput:%@", eventData.count, eventData);

        [_tableView reloadData];
        [self calendar:self.calendar didSelectDate:date];
        [self resetMinimizeButton];
        

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //Show error
        NSLog(@"Failure with request: %@\nError: %@", req, error);
        [self resetMinimizeButton];        
    }];
    [operation start];
    // Set download indicator
    [[self navigationItem] setRightBarButtonItem:barButton];
    [activityIndicator startAnimating];
    
    NSLog(@"URL: %@", url);
}

- (BOOL)date:(NSDate*)date isBetweenDate:(NSDate*)beginDate andDate:(NSDate*)endDate
{
    if ([date compare:beginDate] == NSOrderedAscending)
    	return NO;
    
    if ([date compare:endDate] == NSOrderedDescending)
    	return NO;
    
    return YES;
}

#pragma mark -
#pragma mark - CKCalendarDelegate

- (void)calendar:(CKCalendarView *)calendar didSelectDate:(NSDate *)date {
    self.dateLabel.text = [self.dateFormatter stringFromDate:date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM"];
    
    if([[formatter stringFromDate:currentDate] isEqualToString:[formatter stringFromDate:date]] == NO) {
        // New month, need to fetch data
        [self fetchCalendarData:date];
    }
    NSMutableArray *dayTemp = [NSMutableArray array];
    
    [formatter setDateFormat:@"M/dd/yyyy"];
    for(RMCalendarEvent *event in eventData) {
        
        NSDate *startDate = [formatter dateFromString:[[event ev_start] objectForKey:@"shortdate"]];
        NSDate *endDate = [formatter dateFromString:[[event ev_end] objectForKey:@"shortdate"]];
        if([self date:date isBetweenDate:startDate andDate:endDate]) {
            [dayTemp addObject:event];
        }
    }
    
    dayData = [dayTemp sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSString *first = [(RMCalendarEvent*)a ev_summary];
        NSString *second = [(RMCalendarEvent*)b ev_summary];
        return [first compare:second];
    }];

    [_tableView reloadData];
    currentDate = date;
    NSLog(@"Date selected: %@", date);
    

}

- (void)localeDidChange {
    // Deprecated
    // [self.calendar setLocale:[NSLocale currentLocale]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    if(dayData.count == 0) {
        emptyFlag = YES;
        return 1;
    } else {
        emptyFlag = NO;
        return dayData.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    
    PrettyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[PrettyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.tableViewBackgroundColor = tableView.backgroundColor;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    //Prettykit call to set up shadows, etc
    [cell prepareForTableView:tableView indexPath:indexPath];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    
    cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
    cell.textLabel.numberOfLines = 2;
    
    // Show empty cell if there are no events on this day
    if(emptyFlag) {
        cell.textLabel.text = @"No events on this day!";
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    } else {
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        NSString *labelString = [[dayData objectAtIndex:indexPath.row] ev_summary];
        labelString = [labelString stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];

        cell.textLabel.text = labelString;
    }
    
    return cell;
    
}

- (void) setUpShadows {
    [PrettyShadowPlainTableview setUpTableView:self.tableView];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(!emptyFlag) {
        RMCalendarEventViewController *nextview = [[RMCalendarEventViewController alloc] initWithEvent:[dayData objectAtIndex:indexPath.row]];
        [self.navigationController pushViewController:nextview animated:YES];
    }
}

@end
