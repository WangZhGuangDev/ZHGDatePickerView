//
//  ZHG_ExportCellModel.m
//  DingDing
//
//  Created by ZHGing_Work on 2017/12/3.
//  Copyright © 2017年 ChangTian. All rights reserved.
//

#import "ZHG_ExportCellModel.h"

@implementation ZHG_ExportCellModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

+(instancetype)exportCellModelWithLeftTitle:(NSString *)leftTitle
                                 rightTitle:(NSString *)rightTitle
                            separatorHidden:(BOOL)hidden
                             exportCellType:(ZHG_ExportExcelCellType)exportCellType {
    ZHG_ExportCellModel *model = [[self alloc] init];
    model.leftTitle = leftTitle;
    model.rightTitle = rightTitle;
    model.isHiddenSeparator = hidden;
    model.exportExcelCellType = exportCellType;
    return model;
}

@end
