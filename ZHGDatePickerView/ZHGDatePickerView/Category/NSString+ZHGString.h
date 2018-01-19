//
//  NSString+ZHGString.h
//  datePickerView
//
//  Created by DDing_Work on 2018/1/19.
//  Copyright © 2018年 DDing_Work. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ZHGString)

/** 验证邮箱
 
 @param email 邮箱地址 @return 邮箱格式是否正确 */

+(BOOL)regexWithEmailAddress:(NSString *)email;

@end
