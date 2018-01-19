//
//  DD_ExportCellModel.h
//  DingDing
//
//  Created by DDing_Work on 2017/12/3.
//  Copyright © 2017年 ChangTian. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 通过model控制cell的显示类型

 - DD_ExportExcelCellTypeNoArrow: 右侧无箭头的cell
 - DD_ExportExcelCellTypeArrowRight: 右侧有向右指的箭头
 - DD_ExportExcelCellTypeArrowUp: 右侧有向上指的箭头
 - DD_ExportExcelCellTypeArrowDown: 右侧有向下指的箭头
 */
typedef NS_ENUM(NSInteger,ZHG_ExportExcelCellType) {
    ZHG_ExportExcelCellTypeNoArrow,
    ZHG_ExportExcelCellTypeArrowRight,
    ZHG_ExportExcelCellTypeArrowUp,
    ZHG_ExportExcelCellTypeArrowDown,
} NS_ENUM_AVAILABLE_IOS(9_0);

@interface ZHG_ExportCellModel : NSObject

//cell左边显示的内容
@property (nonatomic, strong) NSString *leftTitle;
//cell右边显示的内容
@property (nonatomic, strong) NSString *rightTitle;
//是否隐藏分割线
@property (nonatomic, assign) BOOL isHiddenSeparator;

@property (nonatomic, assign) ZHG_ExportExcelCellType exportExcelCellType;

+(instancetype)exportCellModelWithLeftTitle:(NSString *)leftTitle
                                 rightTitle:(NSString *)rightTitle
                            separatorHidden:(BOOL)hidden
                             exportCellType:(ZHG_ExportExcelCellType)exportCellType;

@end
