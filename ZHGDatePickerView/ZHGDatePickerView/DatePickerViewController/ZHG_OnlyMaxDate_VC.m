//
//  ZHG_OnlyMaxDate_ViewController.m
//  datePickerView
//
//  Created by DDing_Work on 2018/1/19.
//  Copyright © 2018年 DDing_Work. All rights reserved.
//

#import "ZHG_OnlyMaxDate_VC.h"

@interface ZHG_OnlyMaxDate_VC ()

@end

@implementation ZHG_OnlyMaxDate_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cell_ID = @"ZHG_OnlyMaxDate_VC_Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_ID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cell_ID];
    }
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"当前时间小于最大日期";
            break;
        case 1:
            cell.textLabel.text = @"当前时间大于最大日期";
            break;
        case 2:
            cell.textLabel.text = @"当前时间等于最大日期";
            break;
            
        default:
            break;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    /**
     情况不同，数据源也会不同，根据不同情况来确定数据源
     */
    switch (indexPath.row) {
        case 0: {
            ZHG_ToolBarDatePickerView *datePickerView = [[ZHG_ToolBarDatePickerView alloc] initWithFrame:SCREEN_BOUNDS];
            datePickerView.datePickerType = ZHG_CustomDatePickerView_Type_YearMonthDayHourMinute;
            //最大日期为明天
//            datePickerView.maxDate = [NSDate dateWithTimeIntervalSinceNow:(24 * 60 * 60)];
            
            datePickerView.maxDate = [NSDate dateFromString:@"2030-03-23 12:00" formatter:@"yyyy-MM-dd HH:mm"];

            [datePickerView show];
        }
            break;
        case 1: {
            ZHG_ToolBarDatePickerView *datePickerView = [[ZHG_ToolBarDatePickerView alloc] initWithFrame:SCREEN_BOUNDS];
            datePickerView.datePickerType = ZHG_CustomDatePickerView_Type_YearMonthDayHourMinute;
            
            //最大日期为昨天
//            datePickerView.maxDate = [NSDate dateWithTimeIntervalSinceNow:(-24 * 60 * 60)];
            datePickerView.maxDate = [NSDate dateFromString:@"2000-03-02 12:00" formatter:@"yyyy-MM-dd HH:mm"];

            [datePickerView show];
        }
            break;
        case 2: {
            ZHG_ToolBarDatePickerView *datePickerView = [[ZHG_ToolBarDatePickerView alloc] initWithFrame:SCREEN_BOUNDS];
            datePickerView.datePickerType = ZHG_CustomDatePickerView_Type_YearMonthDayHourMinute;
       
            datePickerView.maxDate = [NSDate date];
            [datePickerView show];
        }
            break;
            
        default:
            break;
    }
    
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
