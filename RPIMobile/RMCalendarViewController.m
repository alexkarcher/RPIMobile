//
//  RMCalendarViewController.m
//  RPIMobile
//
//  Created by Stephen Silber on 3/5/13.
//  Copyright (c) 2013 Rensselaer Polytechnic Institute. All rights reserved.
//

#import "RMCalendarViewController.h"

@interface RMCalendarViewController ()
@property (assign, nonatomic) IBOutlet ABCalendarPicker *calendarPicker;
@property (strong, nonatomic) UIImageView * calendarShadow;
@property (unsafe_unretained, nonatomic) IBOutlet UITableView *eventsTable;
@property (unsafe_unretained, nonatomic) IBOutlet UIView *configPanel;
@end

@implementation RMCalendarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
