//
//  NSDate+ZHGDate.m
//  datePickerView
//
//  Created by DDing_Work on 2018/1/19.
//  Copyright © 2018年 DDing_Work. All rights reserved.
//

#import "NSDate+ZHGDate.h"

@implementation NSDate (ZHGDate)

+(NSString *)stringFromDate:(NSDate *)date formatter:(NSString *)formatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = formatter;
    return [dateFormatter stringFromDate:date];
}

+(NSDate *)dateFromString:(NSString *)dateString formatter:(NSString *)formatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = formatter;
    return [dateFormatter dateFromString:dateString];
}

@end
