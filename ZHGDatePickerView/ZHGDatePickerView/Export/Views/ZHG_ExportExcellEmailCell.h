//
//  ZHG_ExportExcellEmailCell.h
//  DingDing
//
//  Created by 王忠光 on 2017/12/3.
//  Copyright © 2017年 ChangTian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZHG_ExportExcellEmailCell : UITableViewCell

@property (nonatomic, copy) void(^EmailAddressChangeBlock)(NSString *);

+(instancetype)cellWithTabelView:(UITableView *)tableView ;
@end
