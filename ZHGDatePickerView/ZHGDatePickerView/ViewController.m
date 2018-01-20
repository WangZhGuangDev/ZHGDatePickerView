//
//  ViewController.m
//  ZHGDatePickerView
//
//  Created by DDing_Work on 2018/1/19.
//  Copyright © 2018年 DDing_Work. All rights reserved.
//

#import "ViewController.h"
#import "ZHG_OnlyMinDate_VC.h"
#import "ZHG_OnlyMaxDate_VC.h"
#import "ZHG_OnlyDefaultDate_VC.h"
#import "ZHG_LastMinDate_VC.h"
#import "ZHG_LastMaxDate_VC.h"
#import "ZHG_LastDefault_VC.h"
#import "ZHG_ToolBarDatePickerView.h"
#import "ZHG_ExportTableViewController.h"


@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    // Do any additional setup after loading the view, typically from a nib.
}


#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 8;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cell_ID = @"cell_ID_id";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cell_ID];
    }
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"只设置最小日期";
            break;
        case 1:
            cell.textLabel.text = @"只设置最大日期";
            break;
        case 2:
            cell.textLabel.text = @"只设置默认显示日期";
            break;
        case 3:
            cell.textLabel.text = @"最后设置最小日期";
            break;
        case 4:
            cell.textLabel.text = @"最后设置最大日期";
            break;
        case 5:
            cell.textLabel.text = @"最后设置默认日期";
            break;
        case 6:
            cell.textLabel.text = @"不设置最大、最小和默认";
            break;
        case 7:
            cell.textLabel.text = @"导出";
            break;
        default:
            break;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0: {
            ZHG_OnlyMinDate_VC *vc = [[ZHG_OnlyMinDate_VC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1: {
            ZHG_OnlyMaxDate_VC *vc = [[ZHG_OnlyMaxDate_VC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2: {
            ZHG_OnlyDefaultDate_VC *vc = [[ZHG_OnlyDefaultDate_VC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3: {
            ZHG_LastMinDate_VC *vc = [[ZHG_LastMinDate_VC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 4: {
            ZHG_LastMaxDate_VC *vc = [[ZHG_LastMaxDate_VC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 5: {
            ZHG_LastDefault_VC *vc = [[ZHG_LastDefault_VC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 6: {
            ZHG_ToolBarDatePickerView *view = [[ZHG_ToolBarDatePickerView alloc] initWithFrame:[UIScreen mainScreen].bounds];
            
            view.datePickerType = ZHG_CustomDatePickerView_Type_YearMonthDayHourMinute;
            view.DatePickerSelectedBlock = ^(NSString *selectString, NSDate *selectedDate) {
                NSLog(@"这是选择的日期转化的字符串：%@",selectString);
                NSString *string = [NSDate stringFromDate:selectedDate formatter:@"yyyy-MM-dd HH:mm:ss"];
                NSLog(@"%@",string);
            };
            
            [view show];
        }
            break;
        case 7: {
            ZHG_ExportTableViewController *vc = [[ZHG_ExportTableViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        
        default:
            break;
    }
}


@end

