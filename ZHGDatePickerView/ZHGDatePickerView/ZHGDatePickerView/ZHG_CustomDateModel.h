//
//  DD_CustomDateModel.h
//  datePickerView
//
//  Created by DDing_Work on 2018/1/12.
//  Copyright © 2018年 DDing_Work. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZHG_CustomDateModel : NSObject

@property (nonatomic, assign) NSInteger year;
@property (nonatomic, assign) NSInteger month;
@property (nonatomic, assign) NSInteger day;
@property (nonatomic, assign) NSInteger hour;
@property (nonatomic, assign) NSInteger minute;

+(instancetype)modelWithDate:(NSDate *)date isMaxDate:(BOOL)isMaxDate;

@end
