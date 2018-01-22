//
//  ZHG_ExportExcel_VC.m
//  DingDing
//
//  Created by ZHGing_Work on 2017/12/13.
//  Copyright © 2017年 ChangTian. All rights reserved.
//

#import "ZHG_ExportExcel_VC.h"
#import "ZHG_CustomPickerView.h"
#import "ZHG_ExportToolView.h"
#import "ZHG_ExportCellModel.h"
#import "ZHG_ExportExcellEmailCell.h"
#import "ZHG_ExportExcelCell.h"
#import "ZHG_CustomDatePickerView.h"


@interface ZHG_ExportExcel_VC ()
//<UITableViewDelegate,UITableViewDataSource>
{
    BOOL _dataTypeExpand;
    BOOL _teamInforExpand;
    BOOL _exportTimeExpand;
}


@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSMutableArray *teamArray;
@property (nonatomic, strong) NSMutableArray *modelArray;
//@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) ZHG_CustomPickerView *dataPickerView;
@property (nonatomic, strong) ZHG_CustomPickerView *teamPickerView;
@property (nonatomic, strong) ZHG_CustomDatePickerView *datePickerView;
@property (nonatomic, strong) ZHG_ExportToolView *exportToolView;

@property (nonatomic, strong) NSString *emailAddress;

@end

@implementation ZHG_ExportExcel_VC


- (void)viewDidLoad {
    [super viewDidLoad];

    [self updateTeamArray];
    
    self.navigationItem.title = @"导出excel";
 
}

#pragma mark - <UITableViewDataSource>
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return _dataTypeExpand ? 2 : 1;  break;
        case 1:
            return _teamInforExpand ? 2 : 1;  break;
        case 2:
            return _exportTimeExpand ? 2 : 1;  break;
        case 3:
            return 1;   break;
        default:
            break;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section != 3) {
        if (indexPath.row == 0) {
            ZHG_ExportExcelCell *cell = [ZHG_ExportExcelCell cellWithTabelView:tableView];
            cell.model = self.modelArray[indexPath.section];
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
    static NSString *cellID = @"exportDataPickerCell";
    UITableViewCell *pickerCell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (pickerCell == nil) {
        pickerCell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellID];
    }
    switch (indexPath.section) {
        case 0: [pickerCell.contentView addSubview:self.dataPickerView];
            break;
        case 1: [pickerCell.contentView addSubview:self.teamPickerView];
            break;
        case 2: [pickerCell.contentView addSubview:self.datePickerView];
            break;
        default:
            break;
    }
    return pickerCell;
}

#pragma mark <UITableViewDelegate>
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section) {
        case 0: {
            _dataTypeExpand = !_dataTypeExpand;
            _teamInforExpand = NO;
            _exportTimeExpand = NO;
            
            [self updateCellTypeWithSection:indexPath.section expand:_dataTypeExpand];
        }
            break;
        case 1: {
            _teamInforExpand = !_teamInforExpand;
            _dataTypeExpand = NO;
            _exportTimeExpand = NO;
            
            [self updateCellTypeWithSection:indexPath.section expand:_teamInforExpand];
        }
            break;
        case 2: {
            _exportTimeExpand = !_exportTimeExpand;
            _teamInforExpand = NO;
            _dataTypeExpand = NO;
            
            [self updateCellTypeWithSection:indexPath.section expand:_exportTimeExpand];
        }
            break;
        default:
            break;
    }
}

-(void)updateCellTypeWithSection:(NSInteger)section expand:(BOOL)expand {
    
    for (integer_t index = 0; index < self.modelArray.count; index ++) {
        if (section == index) {
            ZHG_ExportCellModel *model = [self.modelArray objectAtIndex:index];
            model.exportExcelCellType = expand ? ZHG_ExportExcelCellTypeArrowUp : ZHG_ExportExcelCellTypeArrowDown;
            if (section == 2)
                model.isHiddenSeparator = !expand;
        } else {
            ZHG_ExportCellModel *model = [self.modelArray objectAtIndex:index];
            model.exportExcelCellType = ZHG_ExportExcelCellTypeArrowDown;
        }
    }
    [self.tableView reloadData];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return indexPath.row == 0 ? 55.f : 160;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return (section == 0 || section == 3) ? 10 : 0.00001;
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

#pragma mark - SEL Actions

- (void)exportExcelBtnAction {
    
    
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
        
        progressView.progressViewStyle = ZHGProgressViewStyleFailed;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [progressView removeFromSuperview];
        });
        
    });
}


#pragma mark - config UI
-(ZHG_CustomPickerView *)dataPickerView {
    if (_dataPickerView == nil) {
        _dataPickerView = [[ZHG_CustomPickerView alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 30, 160) withDataSource:self.dataArray isShowToolBar:NO];
        
        WEAKSELF(weakSelf);
        _dataPickerView.PikcerViewSelectBlock = ^(NSString *title, NSInteger selectIndex) {
            ZHG_ExportCellModel *model0 = [weakSelf.modelArray objectAtIndex:0];
            model0.rightTitle = title;
            [weakSelf updateTeamArray];
            [weakSelf.tableView reloadData];
        };
    }
    
    return _dataPickerView;
}

-(ZHG_CustomPickerView *)teamPickerView {
    if (_teamPickerView == nil) {
        
        _teamPickerView = [[ZHG_CustomPickerView alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 30, 160) withDataSource:self.teamArray isShowToolBar:NO];
        WEAKSELF(weakSelf);
        _teamPickerView.PikcerViewSelectBlock = ^(NSString *title, NSInteger selectIndex) {
            ZHG_ExportCellModel *model1 = [weakSelf.modelArray objectAtIndex:1];
            model1.rightTitle = title;
            [weakSelf.tableView reloadData];
        };
    }
    
    return _teamPickerView;
}

-(ZHG_CustomDatePickerView *)datePickerView {
    if (!_datePickerView) {

        _datePickerView = [[ZHG_CustomDatePickerView alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 30, 160)];
        _datePickerView.defaultDate = [self defaultExportDate];
        _datePickerView.datePickerType = ZHG_CustomDatePickerView_Type_YearMonth;
        WEAKSELF(weakSelf);
        _datePickerView.DatePickerSelectedBlock = ^(NSString *selectString,NSDate *selectedDate) {
            ZHG_ExportCellModel *model2 = [weakSelf.modelArray objectAtIndex:2];
            model2.rightTitle = selectString;
            [weakSelf.tableView reloadData];
        };
    }
    return _datePickerView;
}

//- (UITableView *)tableView {
//    if (!_tableView) {
//        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
//
//        if ([[UIDevice currentDevice].systemVersion floatValue] >= 11.0) {
//            _tableView.estimatedRowHeight = 0;
//            _tableView.estimatedSectionHeaderHeight = 0;
//            _tableView.estimatedSectionFooterHeight = 0;
//        }
//
//        _tableView.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
//        _tableView.dataSource = self;
//        _tableView.delegate = self;
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _tableView.tableFooterView = [self exportToolView];
//    }
//
//    return _tableView;
//}

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
-(NSMutableArray *)modelArray {
    if (_modelArray == nil) {
        ZHG_ExportCellModel *model0 = [ZHG_ExportCellModel exportCellModelWithLeftTitle:@"范围" rightTitle:[self.dataArray firstObject] separatorHidden:NO exportCellType:ZHG_ExportExcelCellTypeArrowDown];
        ZHG_ExportCellModel *model1 = [ZHG_ExportCellModel exportCellModelWithLeftTitle:@"团队" rightTitle:@"草帽海贼团" separatorHidden:NO exportCellType:ZHG_ExportExcelCellTypeArrowDown];
        ZHG_ExportCellModel *model2 = [ZHG_ExportCellModel exportCellModelWithLeftTitle:@"时间" rightTitle:[[self defaultDateString] substringToIndex:7] separatorHidden:YES exportCellType:ZHG_ExportExcelCellTypeArrowDown];
        _modelArray = [NSMutableArray arrayWithObjects:model0,model1,model2, nil];
    }
    return _modelArray;
}

-(NSArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = @[@"健身记录", @"打卡记录", @"吃饭记录", @"喝水记录", @"睡觉记录", @"有氧运动记录",
                       @"无氧运动记录", @"偷懒记录"];
    }
    return _dataArray;
}

-(NSMutableArray *)teamArray {
    if (_teamArray == nil) {
        _teamArray = [NSMutableArray arrayWithObjects:@"草帽海贼团",@"四皇",@"七武海",@"五老星",@"海军",nil];
    }
    return _teamArray;
}

#pragma mark - private
-(NSDate *)defaultExportDate {
    return [NSDate dateFromString:[self defaultDateString] formatter:@"yyyy-MM-dd HH:mm"];
}

-(NSString *)defaultDateString {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth) fromDate:[NSDate date]];
    NSInteger year   = [components year];
    NSInteger month  = [components month];
    NSString *dateStr;
    if (month == 1) {
        dateStr = [NSString stringWithFormat:@"%ld-%02d-01 01:00",(long)year - 1, 12];
    } else {
        dateStr = [NSString stringWithFormat:@"%ld-%02ld-01 01:00",(long)year , (long)month - 1];
        dateStr = [NSString stringWithFormat:@"%ld-%02ld-01 01:00",(long)year , (long)month - 1];
    }
    return dateStr;
}

-(void)updateTeamArray {
    self.teamPickerView.dataSource = self.teamArray;
}

@end
