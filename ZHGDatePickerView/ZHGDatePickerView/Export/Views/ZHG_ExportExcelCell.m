//
//  ZHG_ExportCell.m
//  DingDing
//
//  Created by ZHGing_Work on 2017/12/3.
//  Copyright © 2017年 ChangTian. All rights reserved.
//

#import "ZHG_ExportExcelCell.h"
#import "ZHG_ExportCellModel.h"

@interface ZHG_ExportExcelCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *rightLabel;
@property (nonatomic, strong) UIImageView *arrowIcon;
@property (nonatomic, strong) UIView *separatorLine;

@end
@implementation ZHG_ExportExcelCell

static NSString *cellID = @"exportExcelCell";

+(instancetype)cellWithTabelView:(UITableView *)tableView {
    ZHG_ExportExcelCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
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
    self.clipsToBounds = YES; //父视图的高度比子视图的高度小时，将子视图隐藏
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.rightLabel];
    [self.contentView addSubview:self.arrowIcon];
    [self.contentView addSubview:self.separatorLine];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    self.titleLabel.frame = CGRectMake(15, 0, 100, self.height);
    if (self.model.exportExcelCellType == ZHG_ExportExcelCellTypeNoArrow) {
        self.rightLabel.frame = CGRectMake(CGRectGetMaxX(self.titleLabel.frame), 0, self.width - CGRectGetMaxX(self.titleLabel.frame) - 15, self.height);
    } else {
        self.rightLabel.frame = CGRectMake(CGRectGetMaxX(self.titleLabel.frame), 0, self.width - CGRectGetMaxX(self.titleLabel.frame) - 35, self.height);
    }
    self.arrowIcon.frame = CGRectMake(self.width - 27, self.height / 2 - 6, 12, 12);
    self.separatorLine.frame = CGRectMake(15, self.height - 0.5, self.width - 15, 0.5);
}

-(void)setModel:(ZHG_ExportCellModel *)model {
    _model = model;
    self.titleLabel.text = model.leftTitle;
    self.rightLabel.text = model.rightTitle;
    self.separatorLine.hidden = model.isHiddenSeparator;
    switch (model.exportExcelCellType) {
        case ZHG_ExportExcelCellTypeNoArrow:
            self.arrowIcon.hidden = YES;
            break;
        case ZHG_ExportExcelCellTypeArrowRight:
            self.arrowIcon.hidden = NO;
            self.arrowIcon.image = [UIImage imageNamed:@"cellRightArrow"];
            break;
        case ZHG_ExportExcelCellTypeArrowUp:
            self.arrowIcon.hidden = NO;
            self.arrowIcon.image = [UIImage imageNamed:@"exportExcel_UpArrow"];
            break;
        case ZHG_ExportExcelCellTypeArrowDown:
            self.arrowIcon.hidden = NO;
            self.arrowIcon.image = [UIImage imageNamed:@"exportExcel_PullArrow"];
            break;
        default:
            break;
    }
}

#pragma mark -
-(UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = FontSize15;
        _titleLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLabel;
}

-(UILabel *)rightLabel {
    if (_rightLabel == nil) {
        _rightLabel = [[UILabel alloc] init];
        _rightLabel.font = FontSize15;
        _rightLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _rightLabel.textAlignment = NSTextAlignmentRight;
    }
    return _rightLabel;
}

-(UIImageView *)arrowIcon {
    if (_arrowIcon == nil) {
        _arrowIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"exportExcel_PullArrow"]];
    }
    return _arrowIcon;
}

-(UIView *)separatorLine {
    if (_separatorLine == nil) {
        _separatorLine = [[UIView alloc] init];
        _separatorLine.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
    }
    return _separatorLine;
}


@end
