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
    [self.backView addSubview:self.textLabel];
    [self.indicator startAnimating];
    
    self.failImageView.hidden = YES;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    self.backView.frame = CGRectMake((SCREEN_WIDTH - 130) / 2, (SCREEN_HEIGHT - 120) / 2, 130, 120);
    self.indicator.frame = CGRectMake((self.backView.width - 38) / 2, self.backView.height - 22 - 21 - 11 - 38, 38, 38);
    self.failImageView.frame = CGRectMake((self.backView.width - 38) / 2, self.backView.height - 22 - 21 - 11 - 38, 38, 38);
    self.textLabel.frame = CGRectMake(0, self.backView.height - 22 - 21, 130, 21);
}

-(void)setText:(NSString *)text {
    _text = text;
    self.textLabel.text = text;
    self.indicator.hidden = YES;
    self.failImageView.hidden = NO;
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
        _failImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"UpladFail"]];
    }
    return _failImageView;
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
