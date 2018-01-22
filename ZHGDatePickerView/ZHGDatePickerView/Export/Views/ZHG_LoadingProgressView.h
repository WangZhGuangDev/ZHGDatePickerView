//
//  ZHG_LoadingProgressView.h
//  ZHG
//
//  Created by ZHG on 2017/10/18.
//  Copyright © 2017年 ZHG. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ProgressViewStyle) {
    ProgressViewStyleSuccess,
    ProgressViewStyleFailed,
} NS_AVAILABLE_IPHONE(9_0);

@interface ZHG_LoadingProgressView : UIView

@property (nonatomic, assign) ProgressViewStyle progressViewStyle;
@property (nonatomic, strong) NSString *text;

@end
