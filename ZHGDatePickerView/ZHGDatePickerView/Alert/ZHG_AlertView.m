//
//  ZHG_AlertView.m
//  ZHGDatePickerView
//
//  Created by DDing_Work on 2018/1/22.
//  Copyright © 2018年 DDing_Work. All rights reserved.
//

#import "ZHG_AlertView.h"

typedef void(^LeftBlockHandler)(void);
typedef void(^RightBlockHandler)(void);

static const CGFloat kContentHeight = 120;
static const CGFloat kButtonHeight = 50;
static const CGFloat kAlertHeight = 170;
static const CGFloat kAlertWith = 260;

@interface ZHG_AlertView ()

@property (nonatomic, copy) LeftBlockHandler leftBlockHandler;
@property (nonatomic, copy) RightBlockHandler rightBlockHandler;

@property (nonatomic, strong) UIView *alertBody;

/** 描述 **/
@property (nonatomic, strong) UILabel *messageLabel;
/** 横线 **/
@property (nonatomic, strong) UIView *horizontal_line;
@property (nonatomic, strong) UIView *vertical_line;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *okButton;

@end

@implementation ZHG_AlertView

#pragma mark - init
-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupSubViews];
    }
    return self;
}

-(void)setupSubViews {
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    
    [self addSubview:self.alertBody];
    [self.alertBody addSubview:self.messageLabel];
    [self.alertBody addSubview:self.horizontal_line];
    [self.alertBody addSubview:self.cancelButton];
    [self.alertBody addSubview:self.vertical_line];
    [self.alertBody addSubview:self.okButton];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    BOOL isNoHaveCancelTitle = (self.cancelButton.currentTitle.length == 0 || self.cancelButton.currentTitle == nil);
    
    self.messageLabel.frame = CGRectMake(15, 0, kAlertWith - 30, kContentHeight);
    self.horizontal_line.frame = CGRectMake(0, CGRectGetMaxY(self.messageLabel.frame), kAlertWith, 0.5);
    [self.cancelButton setFrame:isNoHaveCancelTitle ? CGRectMake(0, 0, 0 ,0) : CGRectMake(0, CGRectGetMaxY(self.horizontal_line.frame), kAlertWith / 2 - 1,kButtonHeight)];
    self.vertical_line.frame = isNoHaveCancelTitle ? CGRectMake(0, 0, 0, 0) : CGRectMake(CGRectGetMaxX(self.cancelButton.frame), CGRectGetMaxY(self.horizontal_line.frame), 0.5, CGRectGetWidth(self.cancelButton.frame));
    self.okButton.frame = isNoHaveCancelTitle ? CGRectMake(0, CGRectGetMaxY(self.horizontal_line.frame),kAlertWith, kButtonHeight) : CGRectMake(CGRectGetMaxX(self.vertical_line.frame),CGRectGetMaxY(self.horizontal_line.frame),kAlertWith / 2, kButtonHeight);
}


#pragma mark - SEL Action
-(void)cancelAction:(UIButton *)sender {

    if (self.leftBlockHandler) {
        self.leftBlockHandler();
    }
    
    [self dismissAlert];
}

-(void)okAction:(UIButton *)sender {

    if (self.rightBlockHandler) {
        self.rightBlockHandler();
    }
    [self dismissAlert];
}

#pragma mark -- lazy

-(UIView *)alertBody {
    if (!_alertBody) {
        _alertBody = [[UIView alloc] init];
        _alertBody.layer.cornerRadius = 10;
        _alertBody.layer.masksToBounds = YES;
        _alertBody.backgroundColor = [UIColor whiteColor];
    }
    return _alertBody;
}

-(UILabel *)messageLabel {
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.textColor = [UIColor colorWithHexString:@"393939"];
        _messageLabel.numberOfLines = 0;
    }
    return _messageLabel;
}

-(UIView *)horizontal_line {
    if (!_horizontal_line) {
        _horizontal_line = [[UIView alloc] init];
        _horizontal_line.backgroundColor = [UIColor colorWithHexString:@"C8C8C8"];
    }
    return _horizontal_line;
}
-(UIView *)vertical_line {
    if (!_vertical_line) {
        _vertical_line = [[UIView alloc] init];
        _vertical_line.backgroundColor = [UIColor colorWithHexString:@"C8C8C8"];
    }
    return _vertical_line;
}
-(UIButton *)cancelButton {
    if (!_cancelButton) {//E1E1E1
        _cancelButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:16.f];
        [_cancelButton setTitle:@"取消" forState:(UIControlStateNormal)];
        [_cancelButton setBackgroundImage:[self  imageWithColor:[UIColor colorWithHexString:@"#E1E1E1"] withFrame:(CGRectMake(0, 0, 1, 1))] forState:(UIControlStateHighlighted)];
        [_cancelButton addTarget:self action:@selector(cancelAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [_cancelButton setTitleColor:[UIColor colorWithHexString:@"#8a8a8a"] forState:(UIControlStateNormal)];
    }
    return _cancelButton;
}

-(UIButton *)okButton {
    if (!_okButton) {
        _okButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _okButton.titleLabel.font = [UIFont systemFontOfSize:16.f];
        [_okButton setTitle:@"确定" forState:(UIControlStateNormal)];
        [_okButton setBackgroundImage:[self  imageWithColor:[UIColor colorWithHexString:@"#E1E1E1"] withFrame:(CGRectMake(0, 0, 1, 1))] forState:(UIControlStateHighlighted)];
        [_okButton addTarget:self action:@selector(okAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [_okButton setTitleColor:[UIColor colorWithHexString:@"#DB0000"] forState:(UIControlStateNormal)];
    }
    return _okButton;
}

#pragma mark - public
+(void)alertWithMessage:(NSString *)message
              leftTitle:(NSString *)leftTitle
             rightTitle:(NSString *)rightTitle
            leftHandler:(void(^)(void))leftHandler
           rightHandler:(void(^)(void))rightHandler {
    
    ZHG_AlertView *alertView = [[self alloc] initWithFrame:SCREEN_BOUNDS];
    alertView.messageLabel.text = message;
    if (leftTitle) {
        [alertView.cancelButton setTitle:leftTitle forState:(UIControlStateNormal)];
    }
    if (rightTitle) {
        [alertView.okButton setTitle:rightTitle forState:(UIControlStateNormal)];
    }
    alertView.leftBlockHandler = leftHandler;
    alertView.rightBlockHandler = rightHandler;
    [alertView showAlertWithAnimation:[UIApplication sharedApplication].keyWindow];
}

#pragma mark -- private

-(void)showAlertWithAnimation:(UIView *)view {
    
    CGFloat marginX = (SCREEN_WIDTH - kAlertWith) / 2;
    
    self.alertBody.frame = CGRectMake(marginX, self.center.y - kAlertHeight / 2, kAlertWith, kAlertHeight);
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionPush;
    animation.duration = 0.3;
    animation.subtype = kCATransitionFromTop;
    [self.alertBody.layer addAnimation:animation forKey:nil];
    self.alertBody.alpha = 0.0f;
    
    WEAKSELF(weakSelf);
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.alertBody.alpha = 1.0;
        
        view.alpha = 1.0f;
        weakSelf.alertBody.frame = CGRectMake(marginX, (weakSelf.height - kAlertHeight) / 2 - 15, kAlertWith, kAlertHeight);
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.2 animations:^{
            weakSelf.alertBody.frame = CGRectMake(marginX, (weakSelf.height - 170) / 2, kAlertWith, kAlertHeight);
        }];
    }];
    [view addSubview:self];
}

-(void)dismissAlert {
    self.alertBody.alpha = 1.0f;
    
    CGFloat marginX = (SCREEN_WIDTH - kAlertWith) / 2;
    self.alertBody.frame = CGRectMake(marginX, (self.height - kAlertHeight) / 2, kAlertWith, kAlertHeight);
    WEAKSELF(weakSelf);
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.alertBody.alpha = 0.f;
        
        weakSelf.alertBody.frame = CGRectMake(marginX, weakSelf.height- 180, kAlertWith, kAlertHeight);
    } completion:^(BOOL finished) {
        weakSelf.alertBody.frame = CGRectMake(marginX, weakSelf.height - 150, kAlertWith, kAlertHeight);
        [weakSelf removeFromSuperview];
        weakSelf.alertBody = nil;
    }];
}

- (UIImage *)imageWithColor:(UIColor *)aColor withFrame:(CGRect)aFrame
{
    UIGraphicsBeginImageContext(aFrame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [aColor CGColor]);
    CGContextFillRect(context, aFrame);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

@end
