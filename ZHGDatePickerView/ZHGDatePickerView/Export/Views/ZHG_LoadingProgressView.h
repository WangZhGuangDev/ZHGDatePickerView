//
//  ZHG_LoadingProgressView.h
//  ZHG
//
//  Created by ZHG on 2017/10/18.
//  Copyright © 2017年 ZHG. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ZHGProgressViewStyle) {
    ZHGProgressViewStyleSuccess,
    ZHGProgressViewStyleFailed,
} NS_AVAILABLE_IPHONE(9_0);

@interface ZHG_LoadingProgressView : UIView

@property (nonatomic, assign) ZHGProgressViewStyle progressViewStyle;

@end
