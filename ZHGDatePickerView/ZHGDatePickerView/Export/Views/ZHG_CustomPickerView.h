//
//  ZHG_CustomPickerView.h
//  ZHG
//
//  Created by ZHG on 2017/12/2.
//  Copyright © 2017年 ZHG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZHG_CustomPickerView : UIView

@property (nonatomic, strong) NSString *instruTitle;
@property (nonatomic, assign) NSInteger selectIndex;

@property (nonatomic, copy) void(^PikcerViewSelectBlock)(NSString *,NSInteger);
@property (nonatomic, copy) void(^SureButtonActionBlock)(NSString *,NSInteger);
@property (nonatomic, strong) NSArray *dataSource;

-(instancetype)initWithFrame:(CGRect)frame
              withDataSource:(NSArray *)dataSource
               isShowToolBar:(BOOL)isShowToolBar;

-(void)show;

@end
