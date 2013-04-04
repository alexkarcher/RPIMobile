//
//  RMCalendarEventViewController.m
//  RPIMobile
//
//  Created by Stephen Silber on 4/3/13.
//  Copyright (c) 2013 Rensselaer Polytechnic Institute. All rights reserved.
//

#import "RMCalendarEventViewController.h"
#import "RMCalendarEvent.h"

@interface RMCalendarEventViewController ()
@property (nonatomic, strong) RMCalendarEvent *ev;
@end

@implementation RMCalendarEventViewController

- (id) initWithEvent:(RMCalendarEvent *) event {
        self = [super initWithStyle:UITableViewStyleGrouped];
        if (self) {
            self.ev = event;
        }
        return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView setBackgroundView:nil];
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"event_background"]];
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
    return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    int sec = section;
    switch (sec) {
        case 0:
            return @"General:";
            break;
        case 1:
            return @"Location:";
            break;
        case 2:
            return @"Contact:";
        default:
            return @"";
            break;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    int sec = section;
    int cnt = 0;
    switch (sec) {
        case 0:
            if(self.ev.ev_cost.length < 1) return 2;
            else return 3;
            break;
        case 1:
            if(self.ev.ev_loclink.length < 1) return 1;
            else return 2;
            break;
        case 2:
            if([[self.ev.ev_contact objectForKey:@"name"] length] > 1) cnt++;
            if([[self.ev.ev_contact objectForKey:@"phone"] length] > 1) cnt++;
            if([[self.ev.ev_contact objectForKey:@"link"] length] > 1) cnt++;
            if(self.ev.ev_link.length > 1) cnt++;
            if(cnt > 0) return cnt;
            else return 0;
            break;
        default:
            break;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if(indexPath.section == 0 && indexPath.row == 1) {
        
        UIFont *cellFont = [UIFont systemFontOfSize:12];
        CGSize constraintSize = CGSizeMake(280.0f, MAXFLOAT);
        CGSize labelSize = [self.ev.ev_description sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
    
        return labelSize.height + 20;
    }
    if(indexPath.section == 0 && indexPath.row == 0) return 60;
    
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    //Prettykit call to set up shadows, etc
//    [cell prepareForTableView:tableView indexPath:indexPath];
    int row = indexPath.row;
    int sec = indexPath.section;
    if(sec == 0) {
        switch (row) {
            case 0:
                cell.textLabel.text = [self.ev.ev_summary stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
                cell.textLabel.numberOfLines = 0;
                cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
                break;
            case 1:
                cell.textLabel.text = self.ev.ev_description;
                cell.textLabel.numberOfLines = 0;
                cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
                cell.textLabel.font = [UIFont systemFontOfSize:14];
                break;
            case 2:
                cell.textLabel.text = [NSString stringWithFormat:@"Cost: %@",self.ev.ev_cost];
                cell.textLabel.numberOfLines = 0;
                cell.textLabel.font = [UIFont systemFontOfSize:14];
            default:
                break;
        }
    } else if(sec == 1) {
            switch (row) {
                case 0:
                    cell.textLabel.text = self.ev.ev_location;
                    cell.textLabel.numberOfLines = 0;
                    cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
                    break;
                case 1:
                    cell.textLabel.text = self.ev.ev_loclink;
                    cell.textLabel.numberOfLines = 0;
                    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
                    cell.textLabel.font = [UIFont systemFontOfSize:12];
                    break;
                default:
                    break;
            }

    } else if(sec == 2) {
        switch (row) {
            case 0:
                cell.textLabel.text = @"Link to event webpage";
                cell.textLabel.font = [UIFont systemFontOfSize:14];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                break;
            case 1:
                cell.textLabel.text = [self.ev.ev_contact objectForKey:@"name"];
                cell.textLabel.numberOfLines = 0;
                cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
                break;
            case 2:
                cell.textLabel.text = [self.ev.ev_contact objectForKey:@"phone"];
                cell.textLabel.numberOfLines = 6;
                cell.textLabel.font = [UIFont systemFontOfSize:12];
                break;

            default:
                break;
        }
    } 
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

@end
