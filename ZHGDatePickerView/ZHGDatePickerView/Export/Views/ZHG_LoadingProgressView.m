//
//  ZHG_LoadingProgressView.m
//  ZHG
//
//  Created by ZHG on 2017/10/18.
//  Copyright © 2017年 ZHG. All rights reserved.
//

#import "ZHG_LoadingProgressView.h"

@interface ZHG_LoadingProgressView ()

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIActivityIndicatorView *indicator;
@property (nonatomic, strong) UIImageView *failImageView;
@property (nonatomic, strong) UIImageView *successImageView;
@property (nonatomic, strong) UILabel *textLabel;

@end

@implementation ZHG_LoadingProgressView

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupSubViews];
    }
    return self;
}

-(void)setupSubViews {
    self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1];
    
    [self addSubview:self.backView];
    [self.backView addSubview:self.indicator];
    [self.backView addSubview:self.failImageView];
    [self.backView addSubview:self.successImageView];
    [self.backView addSubview:self.textLabel];
    [self.indicator startAnimating];
    
    self.failImageView.hidden = YES;
    self.successImageView.hidden = YES;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    CGFloat backViewWidth = 130;
    CGFloat backViewHeight = 120;
    self.backView.frame = CGRectMake((SCREEN_WIDTH - backViewWidth) / 2, (SCREEN_HEIGHT - backViewHeight) / 2, backViewWidth, backViewHeight);
    self.indicator.frame = CGRectMake((backViewWidth - 38) / 2, backViewHeight - 22 - 21 - 11 - 38, 38, 38);
    self.failImageView.frame = CGRectMake((backViewWidth - 38) / 2, backViewHeight - 22 - 21 - 11 - 38, 38, 38);
    self.successImageView.frame = CGRectMake((backViewWidth - 35) / 2, backViewHeight - 22 - 21 - 11 - 25, 35, 25);
    self.textLabel.frame = CGRectMake(0, backViewHeight - 22 - 21, backViewWidth, 21);
}

-(void)setProgressViewStyle:(ZHGProgressViewStyle)progressViewStyle {
    _progressViewStyle = progressViewStyle;
    switch (progressViewStyle) {
        case ZHGProgressViewStyleSuccess: {
            self.textLabel.text = @"导出成功";
            self.indicator.hidden = YES;
            self.failImageView.hidden = YES;
            self.successImageView.hidden = NO;
        }
            break;
        case ZHGProgressViewStyleFailed: {
            self.textLabel.text = @"导出失败";
            self.indicator.hidden = YES;
            self.failImageView.hidden = NO;
            self.successImageView.hidden = YES;
        }
            break;
        default:
            break;
    }
}

-(UIView *)backView {
    if (_backView == nil) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.65];
        _backView.layer.cornerRadius = 12.f;
        _backView.layer.masksToBounds = YES;
    }
    return _backView;
}

-(UIActivityIndicatorView *)indicator {
    if (_indicator == nil) {
        _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleWhiteLarge)];
    }
    return _indicator;
}

-(UIImageView *)failImageView {
    if (_failImageView == nil) {
        _failImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"exportExcel_Fail"]];
    }
    return _failImageView;
}

-(UIImageView *)successImageView {
    if (_successImageView == nil) {
        _successImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"exportExcel_Success"]];
    }
    return _successImageView;
}

-(UILabel *)textLabel {
    if (_textLabel == nil) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.font = FontSize15;
        _textLabel.textColor = [UIColor colorWithHexString:@"FFFFFF"];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.text = @"正在导出...";
    }
    return _textLabel;
}
@end
