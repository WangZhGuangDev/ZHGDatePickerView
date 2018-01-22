//
//  ZHG_ExportExcel_VC.m
//  ZHG
//
//  Created by ZHG on 2017/12/3.
//  Copyright © 2017年 ZHG. All rights reserved.
//

#import "ZHG_ExportExcel_Group_VC.h"
#import "ZHG_CustomDatePickerView.h"
#import "ZHG_ExportExcellEmailCell.h"
#import "ZHG_ExportExcelCell.h"
#import "ZHG_ExportCellModel.h"
#import "ZHG_ExportToolView.h"

@interface ZHG_ExportExcel_Group_VC ()
//<UITableViewDelegate,UITableViewDataSource>
{
    BOOL _beginTimeExpand;
    BOOL _endTimeExpand;
}

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) ZHG_CustomDatePickerView *datePickerBegin;
@property (nonatomic, strong) ZHG_CustomDatePickerView *datePickerEnd;
@property (nonatomic, strong) ZHG_ExportToolView *exportToolView;
@property (nonatomic, strong) NSString *emailAddress;

@end

@implementation ZHG_ExportExcel_Group_VC


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"导出";
}

#pragma mark - <UITableViewDataSource>
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;  break;
        case 1:
            return 1;  break;
        case 2:
            return _beginTimeExpand ? 2 : 1;  break;
        case 3:
            return _endTimeExpand ? 2 : 1;   break;
        case 4:
            return 1;
            break;
        default:
            break;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section != 4) {
        if (indexPath.row == 0) {
            ZHG_ExportExcelCell *cell = [ZHG_ExportExcelCell cellWithTabelView:tableView];
            cell.model = self.dataArray[indexPath.section];
            return cell;
        } else {
            return [self pickerCellWithTableView:tableView IndexPath:indexPath];
        }
    } else {
        ZHG_ExportExcellEmailCell *emailCell = [ZHG_ExportExcellEmailCell cellWithTabelView:tableView];
        WEAKSELF(weakSelf);
        emailCell.EmailAddressChangeBlock = ^(NSString *emailAddress) {
            weakSelf.emailAddress = emailAddress;
        };
        return emailCell;
    }
    return 0;
}

-(UITableViewCell *)pickerCellWithTableView:(UITableView *)tableView IndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"exportDatePickerCell";
    UITableViewCell *pickerCell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (pickerCell == nil) {
        pickerCell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellID];
    }
    if (indexPath.section == 2) {
        [pickerCell.contentView addSubview:self.datePickerBegin];
    } else {
        [pickerCell.contentView addSubview:self.datePickerEnd];
    }
    return pickerCell;
}

#pragma mark - <UITableViewDelegate>
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.row == 0 ? 55.f : 160;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return (section == 0 || section == 4) ?  10 : 0.0001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:(CGRectMake(0, 0, SCREEN_WIDTH, 10))];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 1:
            [self didselectFirstRowWithTableView:tableView];
            break;
        case 2: {
            _beginTimeExpand = !_beginTimeExpand;
            _endTimeExpand = NO;
            
            [self updateCellTypeWithSection:indexPath.section expand:_beginTimeExpand];
        }
            break;
        case 3: {
            _endTimeExpand = !_endTimeExpand;
            _beginTimeExpand = NO;
            
            [self updateCellTypeWithSection:indexPath.section expand:_endTimeExpand];
        }
            break;
        default:
            break;
    }
}


#pragma mark - SEL Actions
    
-(void)didselectFirstRowWithTableView:(UITableView *)tableView {
    
    [ZHG_AlertView alertWithMessage:@"带右箭头的是跳转"
                          leftTitle:nil
                         rightTitle:nil
                        leftHandler:^{
                            NSLog(@"点击了左边的按钮");
                        } rightHandler:^{
                            NSLog(@"点击了右边的按钮");
                        }];
    
}

//刷新其他cell的上下箭头的指向，因为此页面就两个cell需要刷新，所以index从2开始
-(void)updateCellTypeWithSection:(NSInteger)section expand:(BOOL)expand {
    for (integer_t index = 2; index < self.dataArray.count; index ++) {
        if (section == index) {
            ZHG_ExportCellModel *model = [self.dataArray objectAtIndex:index];
            model.exportExcelCellType = expand ? ZHG_ExportExcelCellTypeArrowUp : ZHG_ExportExcelCellTypeArrowDown;
            if (section == 3)
                model.isHiddenSeparator = !expand;
        } else {
            ZHG_ExportCellModel *model = [self.dataArray objectAtIndex:index];
            model.exportExcelCellType = ZHG_ExportExcelCellTypeArrowDown;
        }
    }
    [self.tableView reloadData];
}

- (void)exportExcelBtnAction {
    [self.view endEditing:YES];
    
    
    if (![NSString regexWithEmailAddress:self.emailAddress]) {
    
        [ZHG_AlertView alertWithMessage:@"对不起\n您输入的邮箱格式不正确\n请重新输入"
                              leftTitle:nil
                             rightTitle:nil
                            leftHandler:^{
                                NSLog(@"点击了左边的按钮");
                            } rightHandler:^{
                                NSLog(@"点击了右边的按钮");
                            }];
        
        return;
    }
    
    ZHG_LoadingProgressView *progressView = [[ZHG_LoadingProgressView alloc] initWithFrame:SCREEN_BOUNDS];
    [[[UIApplication sharedApplication] keyWindow] addSubview:progressView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        progressView.progressViewStyle = ZHGProgressViewStyleSuccess;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [progressView removeFromSuperview];
        });
        
    });
}

#pragma mrak - lazy views

-(ZHG_CustomDatePickerView *)datePickerBegin {
    if (!_datePickerBegin) {
        _datePickerBegin = [[ZHG_CustomDatePickerView alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 30, 160)];
        _datePickerBegin.defaultDate = [NSDate dateWithTimeIntervalSinceNow:(-30 * 60 * 60 * 24)];
        _datePickerBegin.limitMaxDateToday = YES;
        WEAKSELF(weakSelf);
        _datePickerBegin.DatePickerSelectedBlock = ^(NSString *selectString,NSDate *selectedDate) {
            ZHG_ExportCellModel *model0 = [weakSelf.dataArray objectAtIndex:2];
            model0.rightTitle = selectString;
            [weakSelf.tableView reloadData];
        };
    }
    return _datePickerBegin;
}

-(ZHG_CustomDatePickerView *)datePickerEnd {
    if (!_datePickerEnd) {
        _datePickerEnd = [[ZHG_CustomDatePickerView alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 30, 160)];
        _datePickerEnd.limitMaxDateToday = YES;
        WEAKSELF(weakSelf);
        _datePickerEnd.DatePickerSelectedBlock = ^(NSString *selectString,NSDate *selectedDate) {
            ZHG_ExportCellModel *model1 = [weakSelf.dataArray objectAtIndex:3];
            model1.rightTitle = selectString;
            [weakSelf.tableView reloadData];
        };
    }
    return _datePickerEnd;
}

-(ZHG_ExportToolView *)exportToolView {
    if (_exportToolView == nil) {
        _exportToolView = [[ZHG_ExportToolView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 180)];
        WEAKSELF(weakSelf);
        _exportToolView.ExportExcelActionBlock = ^ {
            [weakSelf exportExcelBtnAction];
        };
    }
    return _exportToolView;
}

#pragma mrak - lazy instance
-(NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        //[self.team teamName] @"这是团队名"
        ZHG_ExportCellModel *model0 = [ZHG_ExportCellModel exportCellModelWithLeftTitle:@"团队" rightTitle:@"草帽海贼团" separatorHidden:NO exportCellType:ZHG_ExportExcelCellTypeNoArrow];
        ZHG_ExportCellModel *model1 = [ZHG_ExportCellModel exportCellModelWithLeftTitle:@"范围" rightTitle:@"全员" separatorHidden:NO exportCellType:ZHG_ExportExcelCellTypeArrowRight];
        ZHG_ExportCellModel *model2 = [ZHG_ExportCellModel exportCellModelWithLeftTitle:@"开始时间" rightTitle:[self defaultBeginTime] separatorHidden:NO exportCellType:ZHG_ExportExcelCellTypeArrowDown];
        ZHG_ExportCellModel *model3 = [ZHG_ExportCellModel exportCellModelWithLeftTitle:@"结束时间" rightTitle:[self defaultEndTime] separatorHidden:YES exportCellType:ZHG_ExportExcelCellTypeArrowDown];
        _dataArray = [NSMutableArray arrayWithObjects:model0,model1,model2,model3, nil];
    }
    return _dataArray;
}

#pragma mark - private
-(NSString *)defaultBeginTime {
    NSDate *thirty = [NSDate dateWithTimeIntervalSinceNow:(-30 * 60 * 60 * 24)];
    NSString *defaultBeginTime = [NSDate stringFromDate:thirty formatter:@"yyyy-MM-dd"];

    return defaultBeginTime;
}

-(NSString *)defaultEndTime {
    NSString *defaultEndTime = [NSDate stringFromDate:[NSDate date] formatter:@"yyyy-MM-dd"];
    return defaultEndTime;
}


@end
