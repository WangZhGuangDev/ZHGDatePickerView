//
//  ZHG_ExportExcelBase_VC.m
//  ZHGDatePickerView
//
//  Created by DDing_Work on 2018/1/22.
//  Copyright © 2018年 DDing_Work. All rights reserved.
//

#import "ZHG_ExportExcelBase_VC.h"
#import "ZHG_ExportToolView.h"

@interface ZHG_ExportExcelBase_VC ()

@property (nonatomic, strong) ZHG_ExportToolView *exportToolView;

@end

@implementation ZHG_ExportExcelBase_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTheTableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillAppear:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillDisappear:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - 监听键盘
- (void)keyboardWillAppear:(NSNotification *)notif
{
    NSDictionary *info = [notif userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - keyboardSize.height);
}
- (void)keyboardWillDisappear:(NSNotification *)notif
{
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
}


-(void)initTheTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:(UITableViewStyleGrouped)];
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 11.0) {
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
    }
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [self exportToolView];
    [self.view addSubview:self.tableView];
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

-(void)exportExcelBtnAction {
    [self.view endEditing:YES];
}

#pragma mark - <UITableViewDataSource>
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cell_ID = @"baseVC_Cell_ID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cell_ID];
    }
    return cell;
}


@end
