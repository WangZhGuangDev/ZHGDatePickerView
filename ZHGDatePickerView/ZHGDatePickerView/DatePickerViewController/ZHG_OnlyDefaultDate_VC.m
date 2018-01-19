//
//  ZHG_OnlyDefaultDate_VC.m
//  datePickerView
//
//  Created by DDing_Work on 2018/1/19.
//  Copyright © 2018年 DDing_Work. All rights reserved.
//

#import "ZHG_OnlyDefaultDate_VC.h"

@interface ZHG_OnlyDefaultDate_VC ()

@end

@implementation ZHG_OnlyDefaultDate_VC

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
    static NSString *cell_ID = @"ZHG_OnlyDefaultDate_VC_Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_ID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cell_ID];
    }
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"当前时间小于置默认显示日期";
            break;
        case 1:
            cell.textLabel.text = @"当前时间大于置默认显示日期";
            break;
        case 2:
            cell.textLabel.text = @"当前时间等于置默认显示日期";
            break;
        
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
            //默认显示日期为明天
//            datePickerView.defaultDate = [NSDate dateWithTimeIntervalSinceNow:(24 * 60 * 60)];
            datePickerView.defaultDate = [NSDate dateFromString:@"2030-03-02 12:00" formatter:@"yyyy-MM-dd HH:mm"];

            
            [datePickerView show];
        }
            break;
        case 1: {
            ZHG_ToolBarDatePickerView *datePickerView = [[ZHG_ToolBarDatePickerView alloc] initWithFrame:SCREEN_BOUNDS];
            datePickerView.datePickerType = ZHG_CustomDatePickerView_Type_YearMonthDayHourMinute;
            
            //默认显示日期为昨天
//            datePickerView.defaultDate = [NSDate dateWithTimeIntervalSinceNow:(-24 * 60 * 60)];
            
            datePickerView.defaultDate = [NSDate dateFromString:@"2016-03-02 12:00" formatter:@"yyyy-MM-dd HH:mm"];

            
            [datePickerView show];
        }
            break;
        case 2: {
            ZHG_ToolBarDatePickerView *datePickerView = [[ZHG_ToolBarDatePickerView alloc] initWithFrame:SCREEN_BOUNDS];
            datePickerView.datePickerType = ZHG_CustomDatePickerView_Type_YearMonthDayHourMinute;
            //默认日期为当前日期的话，可以不设置，若不设置，默认显示当前时间
//            datePickerView.defaultDate = [NSDate date];
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
