//
//  ZHG_ExportExcellEmailCell.m
//  DingDing
//
//  Created by 王忠光 on 2017/12/3.
//  Copyright © 2017年 ChangTian. All rights reserved.
//

#import "ZHG_ExportExcellEmailCell.h"

@interface ZHG_ExportExcellEmailCell ()<UITextFieldDelegate>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextField *emailTextField;

@end

@implementation ZHG_ExportExcellEmailCell
static NSString *cellID = @"exportExcelEmailCell";

+(instancetype)cellWithTabelView:(UITableView *)tableView {
    ZHG_ExportExcellEmailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[self alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellID];
    }
    return cell;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupSubViews];
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

-(void)setupSubViews {
    [self.emailTextField addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];

    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.emailTextField];
}


-(void)layoutSubviews {
    [super layoutSubviews];
    self.titleLabel.frame = CGRectMake(15, 0, 80, self.height);
    self.emailTextField.frame = CGRectMake(CGRectGetMaxX(self.titleLabel.frame), 0, self.width - CGRectGetMaxX(self.titleLabel.frame) - 15, self.height);

}

-(UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"邮箱地址";
        _titleLabel.font = FontSize15;
        _titleLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLabel;
}

-(UITextField *)emailTextField {
    if (_emailTextField == nil) {
        _emailTextField = [[UITextField alloc] init];
        NSMutableAttributedString *attributedPlaceholder = [[NSMutableAttributedString alloc] initWithString:@"请输入邮箱地址" attributes:@{NSFontAttributeName:FontSize15,NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#CECECE"]}];
        _emailTextField.delegate = self;
        _emailTextField.attributedPlaceholder = attributedPlaceholder;
        _emailTextField.font = FontSize15;
        _emailTextField.textColor = [UIColor colorWithHexString:@"#333333"];
        _emailTextField.keyboardType = UIKeyboardTypeEmailAddress;
        _emailTextField.textAlignment = NSTextAlignmentRight;
    }
    return _emailTextField;
}

-(void)textFieldTextChange:(UITextField *)textField {
    if (self.EmailAddressChangeBlock) {
        self.EmailAddressChangeBlock(textField.text);
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField endEditing:YES];
    return NO;
}
@end
