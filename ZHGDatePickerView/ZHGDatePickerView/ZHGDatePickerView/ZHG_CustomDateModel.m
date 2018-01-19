//
//  DD_CustomDateModel.m
//  datePickerView
//
//  Created by DDing_Work on 2018/1/12.
//  Copyright © 2018年 DDing_Work. All rights reserved.
//

#import "ZHG_CustomDateModel.h"

@implementation ZHG_CustomDateModel


+(instancetype)modelWithDate:(NSDate *)date isMaxDate:(BOOL)isMaxDate{
    ZHG_CustomDateModel *model = [[self alloc] init];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *dateString = [formatter stringFromDate:date];
    
    model.year   = [[dateString substringWithRange:NSMakeRange(0, 4)] integerValue];
    model.month  = [[dateString substringWithRange:NSMakeRange(5, 2)] integerValue];
    model.day    = [[dateString substringWithRange:NSMakeRange(8, 2)] integerValue];
    model.hour   = [[dateString substringWithRange:NSMakeRange(11, 2)] integerValue];
    model.minute = [[dateString substringWithRange:NSMakeRange(14, 2)] integerValue];
    
    return model;
}

@end
