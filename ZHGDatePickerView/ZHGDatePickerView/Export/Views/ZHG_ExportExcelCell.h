//
//  DD_ExportCell.h
//  DingDing
//
//  Created by DDing_Work on 2017/12/3.
//  Copyright © 2017年 ChangTian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZHG_ExportCellModel;

@interface ZHG_ExportExcelCell : UITableViewCell

@property (nonatomic, strong) ZHG_ExportCellModel *model;

+(instancetype)cellWithTabelView:(UITableView *)tableView;

@end
