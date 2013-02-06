//
//  WeatherViewController.m
//  RPIMobile
//
//  Created by Stephen Silber on 6/21/12.
//  Copyright (c) 2012 Rensselaer Polytechnic Institute. All rights reserved.
//

#import "WeatherViewController.h"
#import "PrettyKit.h"
#import "UIImageView+AFNetworking.h"
#import "JSONKit.h"


#define start_color [UIColor colorWithHex:0xEEEEEE]
#define end_color [UIColor colorWithHex:0xDEDEDE]

//API from http://www.worldweatheronline.com/ - decent api and unlimited requests
#define kWeatherFeedUrl @"http://free.worldweatheronline.com/feed/weather.ashx?q=12180&format=json&num_of_days=5&key=050d3d0eff023116122808"


/*
 To-do for RPI Weather page:
    -Add better design elements, especially images for corresponding weather conditions
    -Downsize images so that they aren't the main focus of the page
    -Clickable tableview cells with details such as humidity, wind speed, etc (expandable?)
    -Indicators on when data was last loaded?
 */

/* Settings for RPI Weather page:
    -Custom zip-code?
    -Cache period
    -Badge support for current temp on launch screen
 */

@class JKDictionary;
@implementation WeatherCondition

@synthesize _cloudCover, _current, _currentTemp, _date, _description, _humidity, _iconUrl, _percipitation, _tempMax, _tempMin, _visibility, _windDirection, _windSpeed;

- (id) initWithDictionary:(NSDictionary *) weatherInfo isCurrentCondition:(BOOL) currentCondition {
    
    NSLog(@"Initializing weather condition: %@", weatherInfo);
    if(self = [super init]) {
        //Initialize from dictionary here
        if(currentCondition) {
            self._current = YES; //For rendering a special table view cell with more information
            self._currentTemp = [weatherInfo objectForKey:@"temp_F"];
            self._cloudCover = [weatherInfo objectForKey:@"cloudcover"];
            self._humidity = [weatherInfo objectForKey:@"humidity"];
            self._visibility = [weatherInfo objectForKey:@"visibility"];
            self._description = [weatherInfo objectForKey:@"weatherDesc"];
            self._iconUrl = [weatherInfo  objectForKey:@"weatherIconUrl"];
            self._windDirection = [weatherInfo objectForKey:@"winddir16point"];
            self._windSpeed = [weatherInfo objectForKey:@"windspeedMiles"];
        } else {
            self._current = NO;
            self._iconUrl = [weatherInfo objectForKey:@"weatherIconUrl"];
            self._windDirection = [weatherInfo objectForKey:@"winddir16point"];
            self._windSpeed = [weatherInfo objectForKey:@"windspeedMiles"];
            self._description = [weatherInfo objectForKey:@"weatherDesc"];
            self._tempMax = [weatherInfo objectForKey:@"tempMaxF"];
            self._tempMin = [weatherInfo objectForKey:@"tempMinF"];
            self._date = [weatherInfo objectForKey:@"date"];
            self._percipitation = [weatherInfo objectForKey:@"percipMM"];
        }
    }
    
    return self;
}

-(NSString *) getDayOfWeek:(NSString *)date {
    
    
    return @"";
}

@end

/*Solution found on http://atastypixel.com/blog/easy-rounded-corners-on-uitableviewcell-image-view/ */
@interface UIImage (TPAdditions)
- (UIImage*)imageScaledToSize:(CGSize)size;
@end

@implementation UIImage (TPAdditions)
- (UIImage*)imageScaledToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end

@implementation WeatherViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) updateTable {
    NSLog(@"weatherArr: %@", weatherArr);
    [self.tableView reloadData];
}
/*

#pragma mark -
#pragma mark NSXMLParser

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict {
    
    NSLog(@"Element: %@", elementName);
    
    if([elementName isEqualToString:@"city"]) {
        if (!weatherDic)
            weatherDic = [[NSMutableDictionary alloc] init];
            weatherArr = [[NSMutableArray alloc] init];
        return;
    }
    
    if([elementName isEqualToString:@"forecast_date"]) {
        [weatherDic setObject:[attributeDict objectForKey:@"data"]  forKey:@"forecast_date"];
        return;
    }
    
    if([elementName isEqualToString:@"current_date_time"]) {
        [weatherDic setObject:[attributeDict objectForKey:@"data"] forKey:@"current_date_time"];
        return;
    }
    
    if([elementName isEqualToString:@"current_conditions"]) {
        condition = [[WeatherCondition alloc] init];
        return;
    }
    
    if([elementName isEqualToString:@"forecast_conditions"]) {
        condition = [[WeatherCondition alloc] init];
        return;
    }
    
    //For current day conditions
    if([elementName isEqualToString:@"wind"]) {
        condition.wind = [attributeDict objectForKey:@"data"];
        return;
    }
    if([elementName isEqualToString:@"humidity"]) {
        condition.humidity = [attributeDict objectForKey:@"data"];
        return;
    }
    if([elementName isEqualToString:@"temp_f"]) {
        condition.tempF = [attributeDict objectForKey:@"data"];
        return;
    }
    //For other day conditions
    if([elementName isEqualToString:@"day_of_week"]) {
        condition.dayOfWeek = [attributeDict objectForKey:@"data"];
        return;
    }
    if([elementName isEqualToString:@"low"]) {
        condition.low = [attributeDict objectForKey:@"data"];
        return;
    }
    if([elementName isEqualToString:@"high"]) {
        condition.high = [attributeDict objectForKey:@"data"];    
        return;
    }
    if([elementName isEqualToString:@"icon"]) {
        condition.iconURL = [attributeDict objectForKey:@"data"];
        return;
    }
    if([elementName isEqualToString:@"condition"]) {
        condition.condition = [attributeDict objectForKey:@"data"];
        return;
    }


}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if([elementName isEqualToString:@"current_conditions"]) {
        [weatherDic setObject:condition forKey:@"current_conditions"];
        [weatherArr addObject:condition];
        return;
    }
    if([elementName isEqualToString:@"forecast_conditions"]) {
        [weatherDic setObject:condition forKey:condition.dayOfWeek];
        [weatherArr addObject:condition];
        return;
    }
    if([elementName isEqualToString:@"weather"]) {
        NSLog(@"Parsing Complete");
        [self updateTable];
    }
}


-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if (!currentStringValue) {
        // currentStringValue is an NSMutableString instance variable
        currentStringValue = [[NSMutableString alloc] initWithCapacity:50];
    }
    [currentStringValue appendString:string];
    
}

-(void) parseXMLData:(NSData *) data {
    
    BOOL success;
    weatherParser = [[NSXMLParser alloc] initWithData:data];
    [weatherParser setDelegate:self];
    [weatherParser setShouldResolveExternalEntities:YES];

    //Send data from ASIHTTPRequest to NSXMLParser for parsing
    success = [weatherParser parse];
    
}*/

- (void) setUpShadows {
    [PrettyShadowPlainTableview setUpTableView:self.tableView];
}

/*
-(void) downloadData {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.google.com/ig/api?weather=12180"] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5];
    AFXMLRequestOperation *operation = [AFXMLRequestOperation XMLParserRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, NSXMLParser *XMLParser) {
        XMLParser.delegate = self;
        [XMLParser parse];
    } failure:nil];
    [operation start];
}*/

- (void) fetchWeather {
    NSURL *url = [NSURL URLWithString:kWeatherFeedUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5.0];
    AFJSONRequestOperation *operation = [[AFJSONRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //JSON data downloaded
        weatherArr = [NSMutableArray array];
        NSLog(@"Response: %@", [operation responseString]);
        NSDictionary *_weatherArray = [[operation responseString] objectFromJSONString];

        //Add current conditions to top of array
        NSMutableDictionary *_currentConditions = [[_weatherArray objectForKey:@"data"] objectForKey:@"current_condition"];
        [weatherArr addObject:[[WeatherCondition alloc] initWithDictionary:_currentConditions isCurrentCondition:YES]];
        NSLog(@"CLASS: %@", _currentConditions);
        NSArray *_forecastArray = [[_weatherArray objectForKey:@"data"] objectForKey:@"weather"];
        NSLog(@"Weather Array: %@", _forecastArray);
        for(id weatherObject in _forecastArray) {
            WeatherCondition *_weatherCon = [[WeatherCondition alloc] initWithDictionary:weatherObject isCurrentCondition:NO];
            [weatherArr addObject:_weatherCon];
        }
        
        NSLog(@"Weather Arr: %@", weatherArr);

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //Could not fetch weather - do not update table but alert user data could be outdated
        NSLog(@"Error fetching weather: %@ :: %@", error, [error localizedDescription]);
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Could not fetch weather. Data could be outdated. Please try again in a few minutes" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles: nil] show];
    }];
    
    [operation start];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"RPI Weather";
    
    self.tableView.scrollEnabled = NO;
    weatherArr = [[NSMutableArray alloc] init];
    
    self.tableView.rowHeight = 75;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];

    [self setUpShadows];
    
    [self fetchWeather];
    // Refresh button for feed
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh 
																							target:self 
																							action:@selector(downloadData)];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(NSString *)getWeekName:(NSString *)abbr {
    if([abbr isEqualToString:@"Sat"])
        return @"Saturday";
    else if([abbr isEqualToString:@"Sun"])
        return @"Sunday";
    else if([abbr isEqualToString:@"Mon"])
        return @"Monday";
    else if([abbr isEqualToString:@"Tue"])
        return @"Tuesday";
    else if([abbr isEqualToString:@"Wed"])
        return @"Wednesday";
    else if([abbr isEqualToString:@"Thu"])
        return @"Thursday";
    else if([abbr isEqualToString:@"Fri"])
        return @"Friday";
    else 
        return @"Uknown day";
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return [weatherArr count];
    return 5;

}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    return tableView.frame.size.height/5;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    PrettyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[PrettyTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.tableViewBackgroundColor = tableView.backgroundColor;        
        cell.gradientStartColor = start_color;
        cell.gradientEndColor = end_color;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.detailTextLabel.backgroundColor = [UIColor clearColor];
    cell.imageView.alpha = 0.5;

  /*  if([weatherArr count] > 0) {
        WeatherCondition *cellCondition = [weatherArr objectAtIndex:indexPath.row];   

        NSString *imageName = [[cellCondition.iconURL componentsSeparatedByString:@"/ig/images/weather/"] lastObject];
        NSString *fileName = [[imageName componentsSeparatedByString:@".gif"] objectAtIndex:0];
            
        //Uses category defined above to resize UITableViewCell imageview image elegantly
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", fileName]];
        if (image) {
            cell.imageView.image = [image imageScaledToSize:CGSizeMake(45, 45)];
        }
        
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"Current Conditions";
                cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
                cell.detailTextLabel.numberOfLines = 2;
                cell.detailTextLabel.text = [NSString stringWithFormat:@"Temp: %@º\nCondition: %@",cellCondition.tempF,cellCondition.condition];
                break;
            default:
                cell.textLabel.text = [self getWeekName:cellCondition.dayOfWeek];
                cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
                cell.detailTextLabel.numberOfLines = 3;
                cell.detailTextLabel.text = [NSString stringWithFormat:@"High: %@º\n Low: %@º \nCondition: %@",cellCondition.high, cellCondition.low,cellCondition.condition];
                break;
        }
    }*/
    [cell prepareForTableView:tableView indexPath:indexPath];


    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

@end
