//
//  ZHG_AlertView.h
//  ZHGDatePickerView
//
//  Created by DDing_Work on 2018/1/22.
//  Copyright © 2018年 DDing_Work. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZHG_AlertView : UIView


/**
 弹窗显示

 @param message 提示信息
 @param leftTitle 左边按钮标题，若传空，默认为“取消”
 @param rightTitle 右边按钮标题，若传空，默认为“确定”
 @param leftHandler 左边按钮点击事件
 @param rightHandler 右边按钮点击事件
 */
+(void)alertWithMessage:(NSString *)message
              leftTitle:(NSString *)leftTitle
             rightTitle:(NSString *)rightTitle
            leftHandler:(void(^)(void))leftHandler
           rightHandler:(void(^)(void))rightHandler;

@end
