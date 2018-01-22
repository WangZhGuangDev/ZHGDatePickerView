//
//  ZHG_ExportToolView.m
//  DingDing
//
//  Created by 王忠光 on 2017/12/3.
//  Copyright © 2017年 ChangTian. All rights reserved.
//

#import "ZHG_ExportToolView.h"

@implementation ZHG_ExportToolView

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
        [self setupSubViewsWithFrame:frame];
    }
    return self;
}

-(void)setupSubViewsWithFrame:(CGRect)frame {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, frame.size.width - 30, 17)];
    label.text = @"选中的内容将以Excel表格的形式发送至您的邮箱,请注意查收";
    label.numberOfLines = 0;
    label.font = FontSize12;
    label.textColor = [UIColor colorWithHexString:@"#999999"];
    [label sizeToFit];
    [self addSubview:label];
    
    UIButton *exportButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [exportButton setTitle:@"导出" forState:(UIControlStateNormal)];
    [exportButton setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:(UIControlStateNormal)];
    [exportButton addTarget:self action:@selector(exportExcel:) forControlEvents:(UIControlEventTouchUpInside)];
    exportButton.backgroundColor = [UIColor colorWithHexString:@"#DB0000"];
    [exportButton.layer setCornerRadius:2.f];
    exportButton.layer.masksToBounds = YES;
    [exportButton setBackgroundImage:[self imageWithColor:[UIColor colorWithHexString:@"#9F0000"]] forState:(UIControlStateHighlighted)];
    exportButton.titleLabel.font = FontSize18;
    [exportButton setFrame:CGRectMake(15, CGRectGetMaxY(label.frame) + 40, frame.size.width - 40, 47)];
    [self addSubview:exportButton];
    
}

- (UIImage *)imageWithColor:(UIColor *)aColor
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [aColor CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}


-(void)exportExcel:(UIButton *)sender {
    
    if (self.ExportExcelActionBlock) {
        self.ExportExcelActionBlock();
    }
}


@end
