//
//  NSDate+ZHGDate.h
//  datePickerView
//
//  Created by DDing_Work on 2018/1/19.
//  Copyright © 2018年 DDing_Work. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (ZHGDate)

+(NSString *)stringFromDate:(NSDate *)date formatter:(NSString *)formatter;

+(NSDate *)dateFromString:(NSString *)dateString formatter:(NSString *)formatter;

@end
