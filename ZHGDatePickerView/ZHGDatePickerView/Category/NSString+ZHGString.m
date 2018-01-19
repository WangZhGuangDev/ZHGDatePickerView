//
//  NSString+ZHGString.m
//  datePickerView
//
//  Created by DDing_Work on 2018/1/19.
//  Copyright © 2018年 DDing_Work. All rights reserved.
//

#import "NSString+ZHGString.h"

@implementation NSString (ZHGString)

+(BOOL)regexWithEmailAddress:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [predicate evaluateWithObject:email];
}

@end
