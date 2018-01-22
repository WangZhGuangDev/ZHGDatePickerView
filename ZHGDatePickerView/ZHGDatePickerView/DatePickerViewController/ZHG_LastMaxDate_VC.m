//
//  ZHG_LastMaxDate_VC.m
//  datePickerView
//
//  Created by DDing_Work on 2018/1/19.
//  Copyright © 2018年 DDing_Work. All rights reserved.
//

#import "ZHG_LastMaxDate_VC.h"

@interface ZHG_LastMaxDate_VC ()

@end

@implementation ZHG_LastMaxDate_VC

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
    return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cell_ID = @"ZHG_LastMaxDate_VC_Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_ID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cell_ID];
    }
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"先设置最小，再设置最大";
            break;
        case 1:
            cell.textLabel.text = @"先设置默认，再设置最大";
            break;
        case 2:
            cell.textLabel.text = @"先设置最小，再默认，再设置最大";
            break;
        case 3:
            cell.textLabel.text = @"先设置默认，再最小，再设置最大";
            break;
        default:
            break;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0: {
            ZHG_ToolBarDatePickerView *datePickerView = [[ZHG_ToolBarDatePickerView alloc] initWithFrame:SCREEN_BOUNDS];
            datePickerView.datePickerType = ZHG_CustomDatePickerView_Type_YearMonthDayHourMinute;
            
            //最大大于最小，且当前时间，处于最大最小之间，默认显示为当前
            datePickerView.minDate = [NSDate dateFromString:@"2015-03-02 12:00" formatter:@"yyyy-MM-dd HH:mm"];
            datePickerView.maxDate = [NSDate dateFromString:@"2034-03-31 12:00" formatter:@"yyyy-MM-dd HH:mm"];
            
            /**
             和当前时间相比较，主要是改变了数据源，根据情况来确定数据源
             */
            
            //最大大于最小，且当前时间大于最大，默认显示最小
//            datePickerView.maxDate = [NSDate dateFromString:@"2016-03-31 12:00" formatter:@"yyyy-MM-dd HH:mm"];
//            datePickerView.minDate = [NSDate dateFromString:@"2015-03-02 12:00" formatter:@"yyyy-MM-dd HH:mm"];
            
            //最大大于最小，且当前时间小于最小，默认显示最小
//            datePickerView.maxDate = [NSDate dateFromString:@"2050-03-31 12:00" formatter:@"yyyy-MM-dd HH:mm"];
//            datePickerView.minDate = [NSDate dateFromString:@"2020-03-02 12:00" formatter:@"yyyy-MM-dd HH:mm"];
            
            //最大等于最小，且当前时间小于最小，默认显示最小
//            datePickerView.maxDate = [NSDate dateFromString:@"2020-03-31 12:00" formatter:@"yyyy-MM-dd HH:mm"];
//            datePickerView.minDate = [NSDate dateFromString:@"2020-03-02 12:00" formatter:@"yyyy-MM-dd HH:mm"];
            
            //最大小于最小，异常情况
//            datePickerView.maxDate = [NSDate dateFromString:@"2010-03-31 12:00" formatter:@"yyyy-MM-dd HH:mm"];
//            datePickerView.minDate = [NSDate dateFromString:@"2020-03-02 12:00" formatter:@"yyyy-MM-dd HH:mm"];
            
            [datePickerView show];
        }
            break;
        case 1: {
            ZHG_ToolBarDatePickerView *datePickerView = [[ZHG_ToolBarDatePickerView alloc] initWithFrame:SCREEN_BOUNDS];
            datePickerView.datePickerType = ZHG_CustomDatePickerView_Type_YearMonthDayHourMinute;
            
            datePickerView.defaultDate = [NSDate dateFromString:@"2015-03-02 12:00" formatter:@"yyyy-MM-dd HH:mm"];
            datePickerView.maxDate = [NSDate dateFromString:@"2034-03-31 12:00" formatter:@"yyyy-MM-dd HH:mm"];
            
            //默认大于最小（也可以等于）且当前大于默认
//            datePickerView.defaultDate = [NSDate dateFromString:@"2017-03-31 12:00" formatter:@"yyyy-MM-dd HH:mm"];
//            datePickerView.maxDate = [NSDate dateFromString:@"2016-03-02 12:00" formatter:@"yyyy-MM-dd HH:mm"];
            
            //默认大于最小（也可以等于）且当前小于最小
//            datePickerView.defaultDate = [NSDate dateFromString:@"2028-03-31 12:00" formatter:@"yyyy-MM-dd HH:mm"];
//            datePickerView.maxDate = [NSDate dateFromString:@"2025-03-02 12:00" formatter:@"yyyy-MM-dd HH:mm"];
            
            //异常情况，默认大于最大
//            datePickerView.defaultDate = [NSDate dateFromString:@"2028-03-31 12:00" formatter:@"yyyy-MM-dd HH:mm"];
//            datePickerView.maxDate = [NSDate dateFromString:@"2025-03-02 12:00" formatter:@"yyyy-MM-dd HH:mm"];
            
            [datePickerView show];
        }
            break;
        case 2: {
            
            //最大最小默认三者同时存在的时候，最后设置最大和最后设置最小情况基本一样
            
            ZHG_ToolBarDatePickerView *datePickerView = [[ZHG_ToolBarDatePickerView alloc] initWithFrame:SCREEN_BOUNDS];
            datePickerView.datePickerType = ZHG_CustomDatePickerView_Type_YearMonthDayHourMinute;
            
            datePickerView.minDate = [NSDate dateFromString:@"2015-03-02 12:00" formatter:@"yyyy-MM-dd HH:mm"];
            datePickerView.defaultDate = [NSDate dateFromString:@"2016-03-02 12:00" formatter:@"yyyy-MM-dd HH:mm"];
            datePickerView.maxDate = [NSDate dateFromString:@"2034-03-31 12:00" formatter:@"yyyy-MM-dd HH:mm"];
            [datePickerView show];
        }
            break;
        case 3: {
            ZHG_ToolBarDatePickerView *datePickerView = [[ZHG_ToolBarDatePickerView alloc] initWithFrame:SCREEN_BOUNDS];
            datePickerView.datePickerType = ZHG_CustomDatePickerView_Type_YearMonthDayHourMinute;
            
            datePickerView.defaultDate = [NSDate dateFromString:@"2015-03-02 12:00" formatter:@"yyyy-MM-dd HH:mm"];
            datePickerView.minDate = [NSDate dateFromString:@"2015-03-02 12:00" formatter:@"yyyy-MM-dd HH:mm"];
            datePickerView.maxDate = [NSDate dateFromString:@"2034-03-31 12:00" formatter:@"yyyy-MM-dd HH:mm"];
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
