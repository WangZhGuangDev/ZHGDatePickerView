//
//  DD_CustomDatePickerView.m
//  DingDing
//
//  Created by DDing_Work on 2017/12/3.
//  Copyright © 2017年 ChangTian. All rights reserved.
//

#import "ZHG_CustomDatePickerView.h"
#import "ZHG_CustomDateModel.h"

static NSInteger MINYEAROFFSET = 10;
static NSInteger MONTHCOUNT = 12;
static NSInteger HOURCOUNT = 24;
static NSInteger MINUTECOUNT = 60;

@interface ZHG_CustomDatePickerView ()<UIPickerViewDelegate, UIPickerViewDataSource>
{
    NSInteger selectedYearIndex;
    NSInteger selectedMonthIndex;
    NSInteger selectedDayIndex;
    NSInteger selectedHourIndex;
    NSInteger selectedMinuteIndex;
    
    NSInteger daysCount;
    
    NSInteger _currentYear;
    NSInteger _currentMonth;
    NSInteger _currentDay;
    NSInteger _currentHour;
    NSInteger _currentMinute;
    
    BOOL _threeDateIsEqual;
}
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic,strong) NSString *string;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) ZHG_CustomDateModel *maxDateModel;
@property (nonatomic, strong) ZHG_CustomDateModel *minDateModel;
@property (nonatomic, strong) ZHG_CustomDateModel *defaultDateModel;

@property (nonatomic, strong) NSDate *currentDate;
@property (nonatomic, strong) NSMutableArray *yearArray;

@property (nonatomic, strong) NSMutableArray *monthArray;
@property (nonatomic, strong) NSMutableArray *minMonthArray;
@property (nonatomic, strong) NSMutableArray *maxMonthArray;

@end

@implementation ZHG_CustomDatePickerView


-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupSubViews];
    }
    return self;
}


-(void)setupSubViews {
    
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.pickerView];
    
    [self initCurrentDate];
    
    [self setupDefaultSelectRowIndex];
}

-(void)initCurrentDate {
    
    NSDate *currentDate = [NSDate date];
    self.currentDate = currentDate;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:currentDate];
    NSInteger year   = [components year];
    NSInteger month  = [components month];
    NSInteger day    = [components day];
    NSInteger hour   = [components hour];
    NSInteger minute = [components minute];
    
    selectedYearIndex   = MINYEAROFFSET;
    selectedMonthIndex  = month - 1;
    selectedDayIndex    = day - 1;
    selectedHourIndex   = hour;
    selectedMinuteIndex = minute;
    
    daysCount = [self year:year month:month];
    
    _currentYear  = year;
    _currentMonth = month;
    _currentDay   = day;
    _currentHour  = hour;
    _currentMinute = minute;
}

/**
 设置默认日期（如果有，没有的话默认日期就是当前日期）的响应的索引和相应的天数
 */
-(void)setupDefaultSelectRowIndex {
    [self defaultSelectInComponent];
    [self.pickerView reloadAllComponents];
    [self selectedDateString];
}

/**
 滚动到相应的index
 */
-(void)defaultSelectInComponent {
    
    switch (self.datePickerType) {
            
        case ZHG_CustomDatePickerView_Type_YearMonthDay: {
            [self.pickerView selectRow:selectedYearIndex   inComponent:0 animated:NO];
            [self.pickerView selectRow:selectedMonthIndex  inComponent:1 animated:NO];
            [self.pickerView selectRow:selectedDayIndex    inComponent:2 animated:NO];
        }
            break;
        case ZHG_CustomDatePickerView_Type_YearMonth: {
            [self.pickerView selectRow:selectedYearIndex   inComponent:0 animated:NO];
            [self.pickerView selectRow:selectedMonthIndex  inComponent:1 animated:NO];
        }
            break;
        case ZHG_CustomDatePickerView_Type_YearMonthDayHourMinute: {
            [self.pickerView selectRow:selectedYearIndex   inComponent:0 animated:NO];
            [self.pickerView selectRow:selectedMonthIndex  inComponent:1 animated:NO];
            [self.pickerView selectRow:selectedDayIndex    inComponent:2 animated:NO];
            [self.pickerView selectRow:selectedHourIndex   inComponent:3 animated:NO];
            [self.pickerView selectRow:selectedMinuteIndex inComponent:4 animated:NO];
        }
            break;
        case ZHG_CustomDatePickerView_Type_HourMinute: {
            [self.pickerView selectRow:selectedHourIndex   inComponent:0 animated:NO];
            [self.pickerView selectRow:selectedMinuteIndex inComponent:1 animated:NO];
        }
            break;
            
        default:
            break;
    }
}

-(void)layoutSubviews {
    [super layoutSubviews];
    self.contentView.frame = self.bounds;
    self.pickerView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}

/**
 根据年份和月份来确定每月的天数

 @param year 年份
 @param month 月份
 @return 相应年份下相应月份的天数
 */
-(int32_t)year:(NSInteger)year month:(NSInteger)month {
    int32_t days = 0;
    switch (month) {
        case 1:
        case 3:
        case 5:
        case 7:
        case 8:
        case 10:
        case 12:
            days = 31;
            break;
            
        case 4:
        case 6:
        case 9:
        case 11:
            days = 30;
            break;
        case 2: {
            /*
             1、普通情况求闰年只需除以4可除尽即可 年/4余数为0
             2、如果是100的倍数但不是400的倍数,那就不是闰年了,即末两位都是零的整除400才行
             像1700、1800、1900、2100都不是闰年,但是2000、2400是的.
             3、2100年不是闰年,闰年并不是以加4为判断闰年标准的,所以闰年有些4年一次,但是有些是8年一次的.例如：1896年是闰年,但1900年不是,到1904年才是闰年.
             */
            //公元年数可被4整除（但不可被100整除）为闰年,但整百的年数必须是可以被400整除的是闰年
            if ((year % 4 == 0 && year % 100 != 0) || (year % 400 == 0)) {
                days = 29;
            } else {
                days = 28;
            }
            break;
        }
        default:
            break;
    }
    return days;
}

#pragma mark -  UIPickerViewDataSource

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    switch (self.datePickerType) {
        case ZHG_CustomDatePickerView_Type_YearMonthDay:
            return 3; break;
        case ZHG_CustomDatePickerView_Type_YearMonth:
            return 2; break;
        case ZHG_CustomDatePickerView_Type_YearMonthDayHourMinute:
            return 5; break;
        case ZHG_CustomDatePickerView_Type_HourMinute:
            return 2; break;
            
        default: break;
    }
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    switch (component) {
        case 0: return [self numberOfRowsInFirstComponent];
            break;
        case 1: return [self numberOfRowsInSecondComponent];
            break;
        case 2: return [self numberOfRowsInThirdComponent];
            break;
        case 3: return [self numberOfRowsInFourthComponent];
            break;
        case 4: return [self numberOfRowsInFifthComponent];
            break;
            
        default:
            break;
    }
    return 0;
}

#pragma mark -  UIPickerViewDelegate
-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    switch (self.datePickerType) {
        case ZHG_CustomDatePickerView_Type_YearMonthDay:
            return pickerView.frame.size.width / 3; break;
        case ZHG_CustomDatePickerView_Type_YearMonth:
            return 100; break;
        case ZHG_CustomDatePickerView_Type_YearMonthDayHourMinute: {
            if (component==0) return 70;
            if (component==1) return 50;
            if (component==2) return 50;
            if (component==3) return 50;
            if (component==4) return 50;
        }
            break;
        case ZHG_CustomDatePickerView_Type_HourMinute:
            return 100; break;
            
        default: break;
    }
    return  0;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 35.f;
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *label = [[UILabel alloc] init];
    switch (self.datePickerType) {
            
        case ZHG_CustomDatePickerView_Type_YearMonthDay:
            label.frame = CGRectMake(0, 0, pickerView.frame.size.width / 3, 35);
            break;
        case ZHG_CustomDatePickerView_Type_YearMonth:
            label.frame = CGRectMake(0, 0, pickerView.frame.size.width / 2, 35);
            break;
        case ZHG_CustomDatePickerView_Type_YearMonthDayHourMinute:
            label.frame = CGRectMake(0, 0, pickerView.frame.size.width / 5, 35);
            break;
        case ZHG_CustomDatePickerView_Type_HourMinute:
            label.frame = CGRectMake(0, 0, pickerView.frame.size.width / 2, 35);
            break;
            
        default:
            break;
    }
    label.textColor = [UIColor darkGrayColor];
    label.font = [UIFont systemFontOfSize:17.0];
    
    switch (component) {
        case 0:
            [self firstComponentShowWithRow:row label:label];
            break;
        case 1:
            [self secondComponentShowWithRow:row label:label];
            break;
        case 2:
            [self thirdComponentShowWithRow:row label:label];
            break;
        case 3:
            [self fourthComponentShowWithRow:row label:label];
            break;
        case 4:
            [self fifthComponentShowWithRow:row label:label];
            break;
        default:
            break;
    }
    return label;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
//    [self.pickerView reloadAllComponents];
    switch (component) {
        case 0: [self firstComponentSelectWithPickerView:pickerView row:row];
            break;
        case 1: [self secondComponentSelectWithPickerView:pickerView row:row];
            break;
        case 2: [self thirdComponentSelectWithPickerView:pickerView row:row];
            break;
        case 3: [self fourthComponentSelectWithPickerView:pickerView row:row];
            break;
        case 4: [self fifthComponentSelectWithPickerView:pickerView row:row];
            break;
        default:
            break;
    }
//    [self.pickerView reloadAllComponents];
    [self selectedDateString];
}

#pragma mark - PickerView Private

-(NSInteger)numberOfRowsInFirstComponent {
    
    switch (self.datePickerType) {
        case ZHG_CustomDatePickerView_Type_YearMonthDay:
        case ZHG_CustomDatePickerView_Type_YearMonth:
        case ZHG_CustomDatePickerView_Type_YearMonthDayHourMinute:
            return self.yearArray.count;
            break;
        case ZHG_CustomDatePickerView_Type_HourMinute:
            if (self.minDateModel && self.maxDateModel) {
                return self.maxDateModel.hour - self.minDateModel.hour;
            }
            return HOURCOUNT;
            break;
        default:
            break;
    }
    return 0;
}
-(NSInteger)numberOfRowsInSecondComponent {
    switch (self.datePickerType) {
        case ZHG_CustomDatePickerView_Type_YearMonthDay:
        case ZHG_CustomDatePickerView_Type_YearMonth:
        case ZHG_CustomDatePickerView_Type_YearMonthDayHourMinute: {
                if (_threeDateIsEqual)
                    return 1;
            
            if (self.maxDateModel && self.minDateModel) {
                if (selectedYearIndex == 0) {
                    return self.minMonthArray.count;
                } else if (selectedYearIndex == self.maxDateModel.year - self.minDateModel.year) {
                    return self.maxMonthArray.count;
                } else {
                    return MONTHCOUNT;
                }
            } else if (self.maxDateModel && !self.minDateModel) {
                
                if (selectedYearIndex == self.yearArray.count - 1) {
                    return self.maxMonthArray.count;
                } else {
                    return MONTHCOUNT;
                }
                
            } else if (self.minDateModel && !self.maxDateModel) {
                
                if (selectedYearIndex == 0) {
                    return self.minMonthArray.count;
                } else {
                    return MONTHCOUNT;
                }
                
            } else {
                return MONTHCOUNT;
            }
        }
            break;
        case ZHG_CustomDatePickerView_Type_HourMinute:
            if (self.minDateModel && self.maxDateModel) {
                if (selectedHourIndex == 0) {
                    return MINUTECOUNT - self.minDateModel.minute;
                } else if (selectedHourIndex == (self.maxDateModel.hour - self.minDateModel.hour - 1)) {
                    return self.maxDateModel.minute;
                } else {
                    return MINUTECOUNT;
                }
            }
            return MINUTECOUNT;
            break;
        default:
            break;
    }
    return 0;
}

-(NSInteger)numberOfRowsInThirdComponent {
    switch (self.datePickerType) {
        case ZHG_CustomDatePickerView_Type_YearMonth:
        case ZHG_CustomDatePickerView_Type_HourMinute:
            break;
        case ZHG_CustomDatePickerView_Type_YearMonthDay:
        case ZHG_CustomDatePickerView_Type_YearMonthDayHourMinute: {
                if (_threeDateIsEqual)
                    return 1;
            
            if (self.maxDateModel && self.minDateModel) {
                
                if (self.maxDateModel.year == self.minDateModel.year) {
                    if (self.maxDateModel.month == self.minDateModel.month) {
                        
                        return self.maxDateModel.day - self.minDateModel.day + 1;
                        
                    } else {
                        
                        if (selectedMonthIndex == 0) {
                            return [self year:self.minDateModel.year month:self.minDateModel.month] - self.minDateModel.day + 1;
                        } else if (selectedMonthIndex == self.maxDateModel.month - self.minDateModel.month) {
                            return self.maxDateModel.day;
                        } else {
                            return daysCount;
                        }
                    }
                    
                } else {
                    
                    if (selectedYearIndex == 0 && selectedMonthIndex == 0) {
                        return [self year:self.minDateModel.year month:self.minDateModel.month] - self.minDateModel.day + 1;
                    } else if (selectedYearIndex == self.maxDateModel.year - self.minDateModel.year && selectedMonthIndex == self.maxDateModel.month - 1) {
                        return self.maxDateModel.day;
                    } else {
                        return daysCount;
                    }
                }
                
                
            } else if (self.maxDateModel && !self.minDateModel) {
                
                if (selectedYearIndex == self.yearArray.count - 1 && selectedMonthIndex == self.maxDateModel.month - 1) {
                    return self.maxDateModel.day;
                } else {
                    return daysCount;
                }
                
            } else if (self.minDateModel && !self.maxDateModel) {
                
                if (selectedYearIndex == 0 && selectedMonthIndex == 0) {
                    return [self year:self.minDateModel.year month:self.minDateModel.month] - self.minDateModel.day + 1;
                } else {
                    return daysCount;
                }
              
            } else {
                return daysCount;
            }
  
        }
            break;
            
        default:
            break;
    }
    return 0;
}

-(NSInteger)numberOfRowsInFourthComponent {
    switch (self.datePickerType) {
        case ZHG_CustomDatePickerView_Type_YearMonthDay:
        case ZHG_CustomDatePickerView_Type_YearMonth:
        case ZHG_CustomDatePickerView_Type_HourMinute:
            break;
        case ZHG_CustomDatePickerView_Type_YearMonthDayHourMinute: {
            
            if (self.minDateModel && self.maxDateModel) {
                
                if (self.minDateModel.year == self.maxDateModel.year) {
                    if (self.minDateModel.month == self.maxDateModel.month) {
                        if (self.minDateModel.day == self.maxDateModel.day) {
                            return self.maxDateModel.hour - self.minDateModel.hour + 1;
                        } else {
                            
                            if (selectedDayIndex == 0) {
                                return HOURCOUNT - self.minDateModel.hour;
                            } else if (selectedDayIndex == self.maxDateModel.day - self.minDateModel.day) {
                                return self.maxDateModel.hour == 0 ? 1 : self.maxDateModel.hour + 1;
                            } else {
                                return HOURCOUNT;
                            }
                        }
                    } else {
                        
                        if (selectedMonthIndex == 0) {
                            
                            if (selectedDayIndex == 0) {
                                return HOURCOUNT - self.minDateModel.hour;
                            } else {
                                return HOURCOUNT;
                            }
                            
                        } else if (selectedMonthIndex == self.maxDateModel.month - self.minDateModel.month) {
                            
                            if (selectedDayIndex == self.maxDateModel.day - 1) {
                                return self.maxDateModel.hour == 0 ? 1 : self.maxDateModel.hour + 1;
                            } else {
                                return HOURCOUNT;
                            }
                            
                        } else {
                            return HOURCOUNT;
                        }
                        
                    }
                } else {
                    
                    if (selectedYearIndex == 0) {
                        
                        if (selectedMonthIndex == 0) {
                            if (selectedDayIndex == 0) {
                                return HOURCOUNT - self.minDateModel.hour;
                            } else  {
                                return HOURCOUNT;
                            }
                        } else {
                            return HOURCOUNT;
                        }
                        
                    } else if (selectedYearIndex == self.yearArray.count - 1) {
                        
                        if (selectedMonthIndex == self.maxDateModel.month - 1) {
                            if (selectedDayIndex == self.maxDateModel.day - 1) {
                                return self.maxDateModel.hour == 0 ? 1 : self.maxDateModel.hour + 1;
                            } else {
                                return HOURCOUNT;
                            }
                        } else {
                            return HOURCOUNT;
                        }
                        
                    } else {
                        return HOURCOUNT;
                    }
                }
                
            } else if (self.minDateModel && !self.maxDateModel) {
                
                if (selectedYearIndex == 0) {
                    
                    if (selectedMonthIndex == 0) {
                        if (selectedDayIndex == 0) {
                            return HOURCOUNT - self.minDateModel.hour;
                        } else {
                            return HOURCOUNT;
                        }
                    } else {
                        return HOURCOUNT;
                    }
                } else {
                    return HOURCOUNT;
                }
                
            } else if (!self.minDateModel && self.maxDateModel) {
                
                if (selectedYearIndex == self.yearArray.count - 1) {
                    if (selectedMonthIndex == self.maxDateModel.month - 1) {
                        if (selectedDayIndex == self.maxDateModel.day - 1) {
                            return self.maxDateModel.hour == 0 ? 1 : self.maxDateModel.hour + 1;
                        } else {
                            return HOURCOUNT;
                        }
                    } else {
                        return HOURCOUNT;
                    }
                } else {
                    return HOURCOUNT;
                }
            } else {
                return HOURCOUNT;
            }
        }
            break;
            
        default:
            break;
    }
    return 0;
}

-(NSInteger)numberOfRowsInFifthComponent {
    switch (self.datePickerType) {
        case ZHG_CustomDatePickerView_Type_YearMonthDay:
        case ZHG_CustomDatePickerView_Type_YearMonth:
        case ZHG_CustomDatePickerView_Type_HourMinute:
            break;
        case ZHG_CustomDatePickerView_Type_YearMonthDayHourMinute: {
            
            if (self.minDateModel && self.maxDateModel) {
                
                if (self.minDateModel.year == self.maxDateModel.year) {
                    
                    if (self.minDateModel.month == self.maxDateModel.month) {
                        
                        if (self.minDateModel.day == self.maxDateModel.day) {
                            
                            if (self.minDateModel.hour == self.maxDateModel.hour) {
                                
                                return self.maxDateModel.hour - self.minDateModel.hour + 1;
                                
                            } else {
                                if (selectedHourIndex == 0) {
                                    return  MINUTECOUNT - self.minDateModel.minute;
                                } else if (selectedHourIndex == self.maxDateModel.hour - self.minDateModel.hour) {
                                    return self.maxDateModel.minute == 0 ? 1 : (self.maxDateModel.minute + 1);
                                } else {
                                    return MINUTECOUNT;
                                }
                            }
                            
                        } else {
                            
                            if (selectedDayIndex == 0) {
                                
                                if (selectedHourIndex == 0) {
                                    return  MINUTECOUNT - self.minDateModel.minute;
                                } else {
                                    return MINUTECOUNT;
                                }
                                
                            } else if (selectedDayIndex == self.maxDateModel.day - self.minDateModel.day) {
                                
                                if (selectedHourIndex == self.maxDateModel.hour) {
                                    return self.maxDateModel.minute == 0 ? 1 : (self.maxDateModel.minute + 1);
                                } else {
                                    return MINUTECOUNT;
                                }
                                
                            } else {
                                return MINUTECOUNT;
                            }
                        }
                        
                    } else {
                        
                        if (selectedMonthIndex == 0) {
                            
                            if (selectedDayIndex == 0) {
                                
                                if (selectedHourIndex == 0) {
                                    return  MINUTECOUNT - self.minDateModel.minute;
                                } else {
                                    return MINUTECOUNT;
                                }
                                
                            } else {
                                return MINUTECOUNT;
                            }
                            
                        } else if (selectedMonthIndex == self.maxDateModel.month - self.minDateModel.month) {
                            
                            if (selectedDayIndex == self.maxDateModel.day - 1) {
                                
                                if (selectedHourIndex == self.maxDateModel.hour) {
                                    return self.maxDateModel.minute == 0 ? 1 : (self.maxDateModel.minute + 1);
                                } else {
                                    return MINUTECOUNT;
                                }
                                
                            } else {
                                return MINUTECOUNT;
                            }
                        } else {
                            return MINUTECOUNT;
                        }
                    }
                    
                } else {
                    
                    if (selectedYearIndex == 0) {
                        
                        if (selectedMonthIndex == 0) {
                            if (selectedDayIndex == 0) {
                                if (selectedHourIndex == 0) {
                                    return MINUTECOUNT - self.minDateModel.minute;
                                } else {
                                    return MINUTECOUNT;
                                }
                            } else {
                                return MINUTECOUNT;
                            }
                        } else {
                            return MINUTECOUNT;
                        }
                        
                    } else if (selectedYearIndex == self.yearArray.count - 1) {
                        if (selectedMonthIndex == self.maxDateModel.month - 1) {
                            if (selectedDayIndex == self.maxDateModel.day - 1) {
                                if (selectedHourIndex == self.maxDateModel.hour) {
                                    return self.maxDateModel.minute == 0 ? 1 : (self.maxDateModel.minute + 1);
                                } else {
                                    return MINUTECOUNT;
                                }
                            } else {
                                return MINUTECOUNT;
                            }
                        } else {
                            return MINUTECOUNT;
                        }
                    } else {
                        return MINUTECOUNT;
                    }
                }
                
            } else if (self.minDateModel && !self.maxDateModel) {
                
                if (selectedYearIndex == 0) {
                    if (selectedMonthIndex == 0) {
                        if (selectedDayIndex == 0) {
                            if (selectedHourIndex == 0) {
                                return MINUTECOUNT - self.minDateModel.minute;
                            } else {
                                return MINUTECOUNT;
                            }
                        } else {
                            return MINUTECOUNT;
                        }
                    } else {
                        return MINUTECOUNT;
                    }
                } else {
                    return MINUTECOUNT;
                }
                
            } else if (!self.minDateModel && self.maxDateModel) {
                
                if (selectedYearIndex == self.yearArray.count - 1) {
                    if (selectedMonthIndex == self.maxDateModel.month - 1) {
                        if (selectedDayIndex == self.maxDateModel.day -1) {
                            if (selectedHourIndex == self.maxDateModel.hour) {
                                return self.maxDateModel.minute == 0 ? 1 : (self.maxDateModel.minute + 1);
                            } else {
                                return MINUTECOUNT;
                            }
                        } else {
                            return MINUTECOUNT;
                        }
                    } else {
                        return MINUTECOUNT;
                    }
                } else {
                    return MINUTECOUNT;
                }
                
            } else {
                return MINUTECOUNT;
            }
            
        }
            break;
        default:
            break;
    }
    return 0;
}

-(void)firstComponentShowWithRow:(NSInteger)row label:(UILabel *)label {
    switch (self.datePickerType) {
            
        case ZHG_CustomDatePickerView_Type_YearMonthDay: {
            label.text = [NSString stringWithFormat:@"%@年",[self.yearArray objectAtIndex:row]];
            label.textAlignment = NSTextAlignmentRight;
        }
            break;
        case ZHG_CustomDatePickerView_Type_YearMonth: {
            label.text = [NSString stringWithFormat:@"%@年",[self.yearArray objectAtIndex:row]];
            label.textAlignment = NSTextAlignmentCenter;
        }
            break;
        case ZHG_CustomDatePickerView_Type_YearMonthDayHourMinute: {
            label.text = [NSString stringWithFormat:@"%@年",[self.yearArray objectAtIndex:row]];
            label.textAlignment = NSTextAlignmentLeft;
        }
            break;
        case ZHG_CustomDatePickerView_Type_HourMinute: {
            if (self.minDateModel && self.maxDateModel) {
                label.text = [NSString stringWithFormat:@"%02ld时",(long)(self.minDateModel.hour + row)];
            } else {
                label.text = [NSString stringWithFormat:@"%02ld时",(long)row];
            }
            label.textAlignment = NSTextAlignmentCenter;
        }
            break;
            
        default:
            break;
    }
}

-(void)secondComponentShowWithRow:(NSInteger)row label:(UILabel *)label {
    switch (self.datePickerType) {
            
        case ZHG_CustomDatePickerView_Type_YearMonthDay:
        case ZHG_CustomDatePickerView_Type_YearMonth:
        case ZHG_CustomDatePickerView_Type_YearMonthDayHourMinute: {
            
            if (selectedYearIndex == 0) {
                if (self.minDateModel) {
                    label.text = [NSString stringWithFormat:@"%02ld月",(long)[[self.minMonthArray objectAtIndex:row] integerValue]];
                } else {
                    label.text = [NSString stringWithFormat:@"%02ld月",(long)[[self.monthArray objectAtIndex:row] integerValue]];
                }
            } else if (selectedYearIndex == self.yearArray.count - 1){
                if (self.maxDateModel) {
                    label.text = [NSString stringWithFormat:@"%02ld月",(long)[[self.maxMonthArray objectAtIndex:row] integerValue]];
                } else {
                    label.text = [NSString stringWithFormat:@"%02ld月",(long)[[self.monthArray objectAtIndex:row] integerValue]];
                }
            } else {
                label.text = [NSString stringWithFormat:@"%02ld月",(long)[[self.monthArray objectAtIndex:row] integerValue]];
            }
    
            label.textAlignment = NSTextAlignmentCenter;
        }
            break;
        case ZHG_CustomDatePickerView_Type_HourMinute: {
            if (self.minDateModel && self.maxDateModel) {
                if (selectedHourIndex == 0) {
                    label.text = [NSString stringWithFormat:@"%02ld分",(long)(self.minDateModel.minute + row)];
                } else {
                    label.text = [NSString stringWithFormat:@"%02ld分",(long)row];
                }
                
            } else {
                label.text = [NSString stringWithFormat:@"%02ld分",(long)row];
            }
            label.textAlignment = NSTextAlignmentCenter;
        }
            break;
            
        default:
            break;
    }
}

-(void)thirdComponentShowWithRow:(NSInteger)row label:(UILabel *)label {
    switch (self.datePickerType) {
            
        case ZHG_CustomDatePickerView_Type_YearMonth:
        case ZHG_CustomDatePickerView_Type_HourMinute:
            break;
        case ZHG_CustomDatePickerView_Type_YearMonthDay: {
            
            if (selectedYearIndex == 0 && selectedMonthIndex == 0) {
                if (self.minDateModel) {
                    label.text = [NSString stringWithFormat:@"%02ld日",(long)(self.minDateModel.day + row)];
                } else {
                    label.text = [NSString stringWithFormat:@"%02ld日",(long)(row + 1)];
                }
            } else {
                label.text = [NSString stringWithFormat:@"%02ld日",(long)(row + 1)];
            }

            label.textAlignment = NSTextAlignmentLeft;
        }
            break;
        case ZHG_CustomDatePickerView_Type_YearMonthDayHourMinute: {
            
            if (selectedYearIndex == 0 && selectedMonthIndex == 0) {
                if (self.minDateModel) {
                    label.text = [NSString stringWithFormat:@"%02ld日",(long)(self.minDateModel.day + row)];
                } else {
                    label.text = [NSString stringWithFormat:@"%02ld日",(long)(row + 1)];
                }
            } else {
                label.text = [NSString stringWithFormat:@"%02ld日",(long)(row + 1)];
            }
            
            label.textAlignment = NSTextAlignmentCenter;
        }
            break;
        default:
            break;
    }
}

-(void)fourthComponentShowWithRow:(NSInteger)row label:(UILabel *)label {
    switch (self.datePickerType) {
            
        case ZHG_CustomDatePickerView_Type_YearMonthDay:
        case ZHG_CustomDatePickerView_Type_YearMonth:
        case ZHG_CustomDatePickerView_Type_HourMinute:
            break;
        case ZHG_CustomDatePickerView_Type_YearMonthDayHourMinute: {
            
                if (selectedYearIndex == 0 && selectedMonthIndex == 0 && selectedDayIndex == 0) {
                    if (self.minDateModel) {
                        label.text = [NSString stringWithFormat:@"%02ld时",(long)(row + self.minDateModel.hour)];
                    } else {
                        label.text = [NSString stringWithFormat:@"%02ld时",(long)(row)];
                    }
                } else {
                    label.text = [NSString stringWithFormat:@"%02ld时",(long)row];
                }

            label.textAlignment = NSTextAlignmentCenter;
        }
            break;
            
        default:
            break;
    }
}

-(void)fifthComponentShowWithRow:(NSInteger)row label:(UILabel *)label {
    switch (self.datePickerType) {
            
        case ZHG_CustomDatePickerView_Type_YearMonthDay:
        case ZHG_CustomDatePickerView_Type_YearMonth:
        case ZHG_CustomDatePickerView_Type_HourMinute:
            break;
        case ZHG_CustomDatePickerView_Type_YearMonthDayHourMinute: {
            
            if (selectedYearIndex == 0 && selectedMonthIndex == 0 && selectedDayIndex == 0 && selectedHourIndex == 0) {
                if (self.minDateModel) {
                    label.text = [NSString stringWithFormat:@"%02ld分",(long)(row + self.minDateModel.minute)];
                } else {
                    label.text = [NSString stringWithFormat:@"%02ld分",(long)row];
                }
            } else {
                label.text = [NSString stringWithFormat:@"%02ld分",(long)row];
            }
            
            label.textAlignment = NSTextAlignmentCenter;
        }
            break;
            
        default:
            break;
    }
}

-(void)firstComponentSelectWithPickerView:(UIPickerView *)pickerView row:(NSInteger)row {
    switch (self.datePickerType) {
            
        case ZHG_CustomDatePickerView_Type_YearMonthDay: {
            selectedYearIndex = row;
            NSInteger selectedYear = [[self.yearArray objectAtIndex:selectedYearIndex] integerValue];
            NSInteger selectedMonth = [[self.monthArray objectAtIndex:selectedMonthIndex] integerValue];
            
            if (self.isLimitMaxDateToday) {
                //判断所选年份是不是大于当前年份，如果是，强制滚动到当前年份
                if (selectedYear >= _currentYear) {
                    if (selectedMonth > _currentMonth) {
                        selectedYearIndex = _currentYear - [self.yearArray.firstObject integerValue] - 1;
                    } else {
                        if (selectedDayIndex + 1 > _currentDay) {
                            selectedYearIndex = _currentYear - [self.yearArray.firstObject integerValue];
                            if ([[self.yearArray objectAtIndex:selectedYearIndex] integerValue] == _currentYear) {
                                selectedYearIndex = selectedYearIndex - 1;
                            }
                        } else {
                            selectedYearIndex = _currentYear - [self.yearArray.firstObject integerValue];
                        }
                    }
                    [pickerView selectRow:selectedYearIndex inComponent:0 animated:YES];
                }
            }
            [self reloadYear_Month_Day_ComponentsAndSelectedIndex];
            [self updateDayComponent:pickerView];
            [self reloadYear_Month_Day_ComponentsAndSelectedIndex];
        }
            break;
        case ZHG_CustomDatePickerView_Type_YearMonth: {
            selectedYearIndex = row;
            [pickerView reloadComponent:1];
            selectedMonthIndex = [pickerView selectedRowInComponent:1];
        }
            break;
        case ZHG_CustomDatePickerView_Type_YearMonthDayHourMinute: {
            selectedYearIndex = row;
            [self reloadAllComponentsAndSelectedIndex];
            [self updateDayComponent:pickerView];
            [self reloadAllComponentsAndSelectedIndex];
        }
            break;
        case ZHG_CustomDatePickerView_Type_HourMinute: {
            selectedHourIndex = row;
            [pickerView reloadComponent:1];
            selectedMinuteIndex = [pickerView selectedRowInComponent:1];
        }
            break;
            
        default:
            break;
    }
}

-(void)secondComponentSelectWithPickerView:(UIPickerView *)pickerView row:(NSInteger)row {
    switch (self.datePickerType) {
            
        case ZHG_CustomDatePickerView_Type_YearMonthDay: {
            selectedMonthIndex = row;
            NSInteger selectedYear = [[self.yearArray objectAtIndex:selectedYearIndex] integerValue];
            NSInteger selectedMonth = [[self.monthArray objectAtIndex:selectedMonthIndex] integerValue];
            
            if (self.isLimitMaxDateToday) {
                //如果是今年，判断所选月份是不是大于当前月份，如果是，强制滚动到当前月
                if (selectedYear == _currentYear) {
                    if (selectedMonth > _currentMonth) {
                        selectedMonthIndex = _currentMonth - 1;
                        [pickerView selectRow:selectedMonthIndex inComponent:1 animated:YES];
                    }
                }
            }
            [self reloadYear_Month_Day_ComponentsAndSelectedIndex];
            [self updateDayComponent:pickerView];
            [self reloadYear_Month_Day_ComponentsAndSelectedIndex];
        }
            break;
        case ZHG_CustomDatePickerView_Type_YearMonth: {
            selectedMonthIndex = row;
        }
            break;
        case ZHG_CustomDatePickerView_Type_YearMonthDayHourMinute: {
            selectedMonthIndex = row;
            [self reloadAllComponentsAndSelectedIndex];
            [self updateDayComponent:pickerView];
            [self reloadAllComponentsAndSelectedIndex];
        }
            break;
        case ZHG_CustomDatePickerView_Type_HourMinute: {
            selectedMinuteIndex = row;
            [pickerView reloadComponent:1];
            selectedMinuteIndex = [pickerView selectedRowInComponent:1];
        }
            break;
            
        default:
            break;
    }
}

-(void)thirdComponentSelectWithPickerView:(UIPickerView *)pickerView row:(NSInteger)row {
    switch (self.datePickerType) {
            
        case ZHG_CustomDatePickerView_Type_YearMonthDay: {
            selectedDayIndex = row;
            if (self.isLimitMaxDateToday) {
                //在当前年份当前月份的前提下，判断所选的日期是不是大于今日，如果大于今日，强制滚动到今日
                if ([[self.yearArray objectAtIndex:selectedYearIndex] integerValue] == _currentYear && [[self.monthArray objectAtIndex:selectedMonthIndex] integerValue] == _currentMonth) {
                    if (selectedDayIndex + 1 > _currentDay) {
                        selectedDayIndex = _currentDay - 1;
                        [pickerView selectRow:selectedDayIndex inComponent:2 animated:YES];
                    }
                }
            }
        }
            break;
        case ZHG_CustomDatePickerView_Type_YearMonth:
            break;
        case ZHG_CustomDatePickerView_Type_YearMonthDayHourMinute: {
            selectedDayIndex = row;
            [self reloadAllComponentsAndSelectedIndex];;
        }
            break;
        case ZHG_CustomDatePickerView_Type_HourMinute:
            break;
            
        default:
            break;
    }
}

-(void)fourthComponentSelectWithPickerView:(UIPickerView *)pickerView row:(NSInteger)row {
    switch (self.datePickerType) {
            
        case ZHG_CustomDatePickerView_Type_YearMonthDay:
        case ZHG_CustomDatePickerView_Type_YearMonth:
        case ZHG_CustomDatePickerView_Type_HourMinute:
            break;
        case ZHG_CustomDatePickerView_Type_YearMonthDayHourMinute: {
            selectedHourIndex = row;
            [self reloadAllComponentsAndSelectedIndex];
        }
            break;
            
        default:
            break;
    }
}

-(void)fifthComponentSelectWithPickerView:(UIPickerView *)pickerView row:(NSInteger)row {
    switch (self.datePickerType) {
            
        case ZHG_CustomDatePickerView_Type_YearMonthDay:
        case ZHG_CustomDatePickerView_Type_YearMonth:
        case ZHG_CustomDatePickerView_Type_HourMinute:
            break;
        case ZHG_CustomDatePickerView_Type_YearMonthDayHourMinute: {
            selectedMinuteIndex = row;
            [self reloadAllComponentsAndSelectedIndex];
        }
            break;
            
        default:
            break;
    }
}

-(void)updateDayComponent:(UIPickerView *)pickerView {

    if (selectedYearIndex == 0) {
        if (self.minDateModel) {
            if (selectedMonthIndex == 0) {
                daysCount = [self year:self.minDateModel.year month:self.minDateModel.month] - self.minDateModel.day + 1;
            } else {
                daysCount = [self year:[[self.yearArray objectAtIndex:selectedYearIndex] integerValue] month:(self.minDateModel.month + selectedMonthIndex)];
            }
        } else {
            daysCount = [self year:[[self.yearArray objectAtIndex:selectedYearIndex] integerValue] month:(selectedMonthIndex + 1)];
        }

    } else if (selectedYearIndex == self.yearArray.count - 1) {
        if (self.maxDateModel) {
            if (selectedMonthIndex == self.maxMonthArray.count - 1) {
                daysCount = self.maxDateModel.day;
            } else {
                daysCount = [self year:[[self.yearArray objectAtIndex:selectedYearIndex] integerValue] month:(selectedMonthIndex + 1)];
            }
            
        } else {
             daysCount = [self year:[[self.yearArray objectAtIndex:selectedYearIndex] integerValue] month:(selectedMonthIndex + 1)];
        }
    } else {
        daysCount = [self year:[[self.yearArray objectAtIndex:selectedYearIndex] integerValue] month:(selectedMonthIndex + 1)];
    }

}

-(void)selectedDateString {
    NSString *year, *month, *day, *hour, *minute, *selectString, *dateString;
    NSDate *selectDate;
    switch (self.datePickerType) {
            
        case ZHG_CustomDatePickerView_Type_YearMonthDay: {
            year = [NSString stringWithFormat:@"%@",[self.yearArray objectAtIndex:selectedYearIndex]];
            
            if (selectedYearIndex == 0) {
                if (self.minDateModel) {
                    if (selectedMonthIndex == 0) {
                        day = [NSString stringWithFormat:@"%02ld",(long)(self.minDateModel.day + selectedDayIndex)];
                    } else {
                        day = [NSString stringWithFormat:@"%02ld",(long)(selectedDayIndex + 1)];
                    }
                    month = [NSString stringWithFormat:@"%02ld",(long)[[self.minMonthArray objectAtIndex:selectedMonthIndex] integerValue]];
                } else {
                    month = [NSString stringWithFormat:@"%02ld",(long)[[self.monthArray objectAtIndex:selectedMonthIndex] integerValue]];
                    day = [NSString stringWithFormat:@"%02ld",(long)(selectedDayIndex + 1)];
                }
            } else {
                month = [NSString stringWithFormat:@"%02ld",(long)[[self.monthArray objectAtIndex:selectedMonthIndex] integerValue]];
                day = [NSString stringWithFormat:@"%02ld",(long)(selectedDayIndex + 1)];
            }
            
            selectString = [NSString stringWithFormat:@"%@-%@-%@",year,month,day];
            dateString = [NSString stringWithFormat:@"%@-%@-%@ 12:00:00",year,month,day];
            selectDate = [self stringToDate:dateString format:@"yyyy-MM-dd HH:mm:ss"];
        }
            break;
        case ZHG_CustomDatePickerView_Type_YearMonth: {
            year = [NSString stringWithFormat:@"%@",[self.yearArray objectAtIndex:selectedYearIndex]];
            
            if (selectedYearIndex == 0) {
                if (self.minDateModel) {
                    month = [NSString stringWithFormat:@"%02ld",(long)[[self.minMonthArray objectAtIndex:selectedMonthIndex] integerValue]];
                } else {
                    month = [NSString stringWithFormat:@"%02ld",(long)[[self.monthArray objectAtIndex:selectedMonthIndex] integerValue]];
                }
            } else {
                month = [NSString stringWithFormat:@"%02ld",(long)[[self.monthArray objectAtIndex:selectedMonthIndex] integerValue]];
            }
            
            selectString = [NSString stringWithFormat:@"%@-%@",year,month];
            dateString = [NSString stringWithFormat:@"%@-%@-01 12:00:00",year,month];
            selectDate = [self stringToDate:dateString format:@"yyyy-MM-dd HH:mm:ss"];
        }
            break;
        case ZHG_CustomDatePickerView_Type_YearMonthDayHourMinute: {
            year = [NSString stringWithFormat:@"%@",[self.yearArray objectAtIndex:selectedYearIndex]];
            
            if (selectedYearIndex == 0) {
                
                if (self.minDateModel) {
                    if (selectedMonthIndex == 0) {
                        
                        if (selectedDayIndex == 0) {
                            
                            if (selectedHourIndex == 0) {
                                minute = [NSString stringWithFormat:@"%02ld",(long)(self.minDateModel.minute + selectedMinuteIndex)];
                            } else {
                                minute = [NSString stringWithFormat:@"%02ld",(long)selectedMinuteIndex];
                            }
                            
                            hour = [NSString stringWithFormat:@"%02ld",(long)(self.minDateModel.hour + selectedHourIndex)];
                        } else {
                            hour = [NSString stringWithFormat:@"%02ld",(long)selectedHourIndex];
                            minute = [NSString stringWithFormat:@"%02ld",(long)selectedMinuteIndex];
                        }
                        
                        day = [NSString stringWithFormat:@"%02ld",(long)(self.minDateModel.day + selectedDayIndex)];
                    } else {
                        day = [NSString stringWithFormat:@"%02ld",(long)(selectedDayIndex + 1)];
                        hour = [NSString stringWithFormat:@"%02ld",(long)selectedHourIndex];
                        minute = [NSString stringWithFormat:@"%02ld",(long)selectedMinuteIndex];
                    }
                    month = [NSString stringWithFormat:@"%02ld",(long)[[self.minMonthArray objectAtIndex:selectedMonthIndex] integerValue]];
                } else {
                    month = [NSString stringWithFormat:@"%02ld",(long)[[self.monthArray objectAtIndex:selectedMonthIndex] integerValue]];
                    day = [NSString stringWithFormat:@"%02ld",(long)(selectedDayIndex + 1)];
                    hour = [NSString stringWithFormat:@"%02ld",(long)selectedHourIndex];
                    minute = [NSString stringWithFormat:@"%02ld",(long)selectedMinuteIndex];
                }
                
            } else {
                month = [NSString stringWithFormat:@"%02ld",(long)[[self.monthArray objectAtIndex:selectedMonthIndex] integerValue]];
                day = [NSString stringWithFormat:@"%02ld",(long)(selectedDayIndex + 1)];
                hour = [NSString stringWithFormat:@"%02ld",(long)selectedHourIndex];
                minute = [NSString stringWithFormat:@"%02ld",(long)selectedMinuteIndex];
            }
            
            selectString = [NSString stringWithFormat:@"%@-%@-%@ %@:%@:00",year,month,day,hour,minute];
            selectDate = [self stringToDate:selectString format:@"yyyy-MM-dd HH:mm:00"];
        }
            break;
        case ZHG_CustomDatePickerView_Type_HourMinute: {
            hour = [NSString stringWithFormat:@"%02ld",(long)selectedHourIndex];
            minute = [NSString stringWithFormat:@"%02ld",(long)selectedMinuteIndex];
            selectString = [NSString stringWithFormat:@"%@:%@",hour,minute];
        }
            break;
            
        default:
            break;
    }
    if (self.DatePickerSelectedBlock) {
        self.DatePickerSelectedBlock(selectString, selectDate);
    }
}

-(NSDate *)stringToDate:(NSString *)string format:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = format;
    NSDate *date = [formatter dateFromString:string];
    return date;
}

-(NSString *)dateToString:(NSDate *)date format:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = format;
    NSString *dateString = [formatter stringFromDate:date];
    return dateString;
}

#pragma mark - lazy instance & views
-(UIView *)contentView {
    if (_contentView == nil) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor whiteColor];
    }
    return _contentView;
}

-(UIPickerView *)pickerView {
    if (_pickerView == nil) {
        _pickerView = [[UIPickerView alloc] init];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        _pickerView.backgroundColor = [UIColor whiteColor];
    }
    return _pickerView;
}

-(NSMutableArray *)yearArray {
    if (_yearArray == nil) {
        NSMutableArray *tempArray = [NSMutableArray array];
        for (NSInteger i = _currentYear - MINYEAROFFSET ; i <= _currentYear + MINYEAROFFSET; i++) {
            [tempArray addObject:@(i)];
        }
        _yearArray = tempArray;
    }
    return _yearArray;
}

-(NSMutableArray *)monthArray {
    if (_monthArray == nil) {
        NSMutableArray *tempArray = [NSMutableArray array];
        for (int32_t i = 1 ; i <= MONTHCOUNT; i++) {
            [tempArray addObject:@(i)];
        }
        _monthArray = tempArray;
    }
    return _monthArray;
}

#pragma mark - Private
-(NSException *)throwExceptionWithReson:(NSString *)reason {
    NSException *exception = [NSException exceptionWithName:@"Date is not reasonable" reason:reason userInfo:nil];
    return exception;
}

-(void)reloadYear_Month_Day_ComponentsAndSelectedIndex {
    [self.pickerView reloadComponent:0];
    selectedYearIndex = [self.pickerView selectedRowInComponent:0];
    [self.pickerView reloadComponent:1];
    selectedMonthIndex = [self.pickerView selectedRowInComponent:1];
    [self.pickerView reloadComponent:2];
    selectedDayIndex = [self.pickerView selectedRowInComponent:2];
}

/**
 因为最大最小等好多联动，老是有问题，所以在这里所有的都强制刷新一遍（仅针对DD_CustomDatePickerView_Type_YearMonthDayHourMinute）
 */
-(void)reloadAllComponentsAndSelectedIndex {
    [self.pickerView reloadComponent:0];
    selectedYearIndex = [self.pickerView selectedRowInComponent:0];
    [self.pickerView reloadComponent:1];
    selectedMonthIndex = [self.pickerView selectedRowInComponent:1];
    [self.pickerView reloadComponent:2];
    selectedDayIndex = [self.pickerView selectedRowInComponent:2];
    [self.pickerView reloadComponent:3];
    selectedHourIndex = [self.pickerView selectedRowInComponent:3];
    [self.pickerView reloadComponent:4];
    selectedMinuteIndex = [self.pickerView selectedRowInComponent:4];
    [self reloadAllComponents];
}

-(void)reloadAllComponents {
    [self.pickerView reloadAllComponents];
    [self defaultSelectInComponent];
    [self selectedDateString];
}

-(void)defaultBetweenMinAndMax {
    
    selectedYearIndex = self.defaultDateModel.year - self.minDateModel.year;
    
    if (self.maxDateModel.year == self.minDateModel.year) {
        
        selectedMonthIndex = self.defaultDateModel.month - self.minDateModel.month;
        
        if (self.maxDateModel.month == self.minDateModel.month) {
            
            selectedDayIndex = self.defaultDateModel.day - self.minDateModel.day;
            
            if (self.maxDateModel.day == self.minDateModel.day) {
                
                selectedHourIndex = self.defaultDateModel.hour - self.minDateModel.hour;
                
                if (self.maxDateModel.hour == self.minDateModel.hour) {
                    
                    selectedMinuteIndex = self.defaultDateModel.minute - self.minDateModel.minute;
                } else {
                    //年月日相等，小时不等
                    if (selectedHourIndex == 0) {
                        selectedMinuteIndex = self.defaultDateModel.minute - self.minDateModel.minute;
                    } else {
                        selectedMinuteIndex = self.defaultDateModel.minute;
                    }
                }
                
            } else {
                //年月相等，月份相等，天数不等
                if (selectedDayIndex == 0) {
                    
                    selectedHourIndex = self.defaultDateModel.hour - self.minDateModel.hour;
                    
                    if (selectedHourIndex == 0) {
                        selectedMinuteIndex = self.defaultDateModel.minute - self.minDateModel.minute;
                    } else {
                        selectedMinuteIndex = self.defaultDateModel.minute;
                    }
                    
                } else {
                    selectedHourIndex = self.defaultDateModel.hour;
                    selectedMinuteIndex = self.defaultDateModel.minute;
                }
            }
            
        } else {
            
            //最大年 = 最小年，最大月 ！= 最小月
            if (selectedMonthIndex == 0) {
                
                selectedDayIndex = self.defaultDateModel.day - self.minDateModel.day;
                
                if (selectedDayIndex == 0) {
                    selectedHourIndex = self.defaultDateModel.hour - self.minDateModel.hour;
                    if (selectedHourIndex == 0) {
                        selectedMinuteIndex = self.defaultDateModel.minute - self.minDateModel.minute;
                    } else {
                        selectedMinuteIndex = self.defaultDateModel.minute;
                    }
                } else {
                    selectedHourIndex = self.defaultDateModel.hour;
                    selectedMinuteIndex = self.defaultDateModel.minute;
                }
                
            } else {
                [self setupDefaultDay_hour_minute_index];
            }
        }
        
    } else {
        //年份不相等
        if (selectedYearIndex == 0) {
            
            selectedMonthIndex = self.defaultDateModel.month - self.minDateModel.month;
            
            if (selectedMonthIndex == 0) {
                
                selectedDayIndex = self.defaultDateModel.day - self.minDateModel.day;
                
                if (selectedDayIndex == 0) {
                    
                    selectedHourIndex = self.defaultDateModel.hour - self.minDateModel.hour;
                    
                    if (selectedHourIndex == 0) {
                        selectedMinuteIndex = self.defaultDateModel.minute - self.minDateModel.minute;
                    } else {
                        selectedMinuteIndex = self.defaultDateModel.minute;
                    }
                    
                } else {
                    selectedHourIndex = self.defaultDateModel.hour;
                    selectedMinuteIndex = self.defaultDateModel.minute;
                }
                
            } else {
                //年份不相等，选中的最小年份
                [self setupDefaultDay_hour_minute_index];
            }
        } else {
            [self setupDefaultMonth_day_hour_minute_index];
        }
    }
}

-(void)currentBetweenMaxAndMin {
    selectedYearIndex = _currentYear - self.minDateModel.year;
    
    if (selectedYearIndex == 0) {
        
        selectedMonthIndex = _currentMonth - self.minDateModel.month;
        
        if (selectedMonthIndex == 0) {
            
            selectedDayIndex = _currentDay - self.minDateModel.day;
            
            if (selectedDayIndex == 0) {
                
                selectedHourIndex = _currentHour - self.minDateModel.hour;
                
                if (selectedHourIndex == 0) {
                    selectedMinuteIndex = _currentMinute - self.minDateModel.minute;
                } else {
                    selectedMinuteIndex = _currentMinute;
                }
                
            } else {
                selectedHourIndex = _currentHour;
                selectedMinuteIndex = _currentMinute;
            }
            
        } else {
            [self setupCurrentDay_hour_minute_index];
        }
        
    } else {
        [self setupCurrentMonth_day_hour_minute_index];
    }
}

-(void)currentEqualMaxAndLargeThanMin {
    selectedYearIndex = self.maxDateModel.year - self.minDateModel.year;
    
    if (self.minDateModel.year == self.maxDateModel.year) {
        
        selectedMonthIndex = self.maxDateModel.month - self.minDateModel.month;
        
        if (self.minDateModel.month == self.maxDateModel.month) {
            
            selectedDayIndex = self.maxDateModel.day - self.minDateModel.day;
            
            if (self.minDateModel.day == self.maxDateModel.day) {
                
                selectedHourIndex = self.maxDateModel.hour - self.minDateModel.hour;
                
                if (self.minDateModel.hour == self.maxDateModel.hour) {
                    
                    selectedMinuteIndex = self.maxDateModel.minute - self.minDateModel.minute;
                    
                } else {
                    selectedMinuteIndex = self.maxDateModel.minute;
                }
                
            } else {
                selectedHourIndex = self.maxDateModel.hour;
                selectedMinuteIndex = self.maxDateModel.minute;
            }
            
        } else {
            selectedDayIndex = self.maxDateModel.day - 1;
            selectedHourIndex = self.maxDateModel.hour;
            selectedMinuteIndex = self.maxDateModel.minute;
        }
        
    } else {
        //最大年大于最小年
        selectedMonthIndex = self.maxDateModel.month - 1;
        selectedDayIndex = self.maxDateModel.day - 1;
        selectedHourIndex = self.maxDateModel.hour;
        selectedMinuteIndex = self.maxDateModel.minute;
    }
}

-(void)defaultLargeOrEqualMin {
    selectedYearIndex = self.defaultDateModel.year - self.minDateModel.year;
    
    if (self.defaultDateModel.year == self.minDateModel.year) {
        
        selectedMonthIndex = self.defaultDateModel.month - self.minDateModel.month;
        
        if (selectedMonthIndex == 0) {
            
            selectedDayIndex = self.defaultDateModel.day - self.minDateModel.day;
            
            if (selectedDayIndex == 0) {
                
                selectedHourIndex = self.defaultDateModel.hour - self.minDateModel.hour;
                if (selectedHourIndex == 0) {
                    selectedMinuteIndex = self.defaultDateModel.minute - self.minDateModel.minute;
                } else {
                    selectedMinuteIndex = self.defaultDateModel.minute;
                }
            } else {
                
                selectedHourIndex = self.defaultDateModel.hour;
                selectedMinuteIndex = self.defaultDateModel.minute;
            }
            
        } else {
            [self setupDefaultDay_hour_minute_index];
        }
    } else {  //两者年份不等
        [self setupDefaultMonth_day_hour_minute_index];
    }
}

-(void)defalut_Min_Max_Equal {
    
    [self setupAllIndexToZero];
    
    for (NSInteger i = self.minDateModel.year; i <= self.minDateModel.year; i++) {
        [self.yearArray addObject:@(i)];
    }
    
    self.minMonthArray = [NSMutableArray array];
    self.maxMonthArray = [NSMutableArray array];
    for (NSInteger i = self.minDateModel.month; i <= self.minDateModel.month; i++) {
        [self.minMonthArray addObject:@(i)];
        [self.maxMonthArray addObject:@(i)];
    }
    
    _threeDateIsEqual = YES;
    [self reloadAllComponents];
}

-(void)setupAllIndexToZero {
    selectedYearIndex = 0;
    selectedMonthIndex = 0;
    selectedDayIndex = 0;
    selectedHourIndex = 0;
    selectedMinuteIndex = 0;
}

-(void)setupCurrentMonth_day_hour_minute_index {
    selectedMonthIndex = _currentMonth - 1;
    [self setupCurrentDay_hour_minute_index];
}

-(void)setupCurrentDay_hour_minute_index {
    selectedDayIndex = _currentDay - 1;
    selectedHourIndex = _currentHour;
    selectedMinuteIndex = _currentMinute;
}

-(void)setupDefaultMonth_day_hour_minute_index {
    selectedMonthIndex = self.defaultDateModel.month - 1;
    [self setupDefaultDay_hour_minute_index];
}

-(void)setupDefaultDay_hour_minute_index {
    selectedDayIndex = self.defaultDateModel.day - 1;
    selectedHourIndex = self.defaultDateModel.hour;
    selectedMinuteIndex = self.defaultDateModel.minute;
}

-(void)setupMinAndMaxYearSource {
    for (NSInteger i = self.minDateModel.year; i <= self.maxDateModel.year; i++) {
        [self.yearArray addObject:@(i)];
    }
}

-(void)setupMinMonthSourceWithMinAndMaxYearEqual {
    for (NSInteger i = self.minDateModel.month; i <= self.maxDateModel.month; i++) {
        [self.minMonthArray addObject:@(i)];
    }
}

-(void)setupMinMonthSourceWithMin {
    for (NSInteger i = self.minDateModel.month; i <= MONTHCOUNT; i++) {
        [self.minMonthArray addObject:@(i)];
    }
}

-(void)setupMaxMonthSourceWithMinAndMaxYearEqual {
    for (NSInteger i = self.minDateModel.month; i <= self.maxDateModel.month; i++) {
        [self.maxMonthArray addObject:@(i)];
    }
}

-(void)setupMaxMonthSourceWithMax {
    for (NSInteger i = 1; i <= self.maxDateModel.month; i++) {
        [self.maxMonthArray addObject:@(i)];
    }
}

#pragma mark - setter

/** 最大日期、最小日期、默认日期和当前日期相互之间的判断应该有重合的逻辑，脑子已混乱，已无力再梳理 */
-(void)setMinDate:(NSDate *)minDate {
    
    _minDate = minDate;
   
    ZHG_CustomDateModel *minDateModel = [ZHG_CustomDateModel modelWithDate:minDate isMaxDate:NO];
    self.minDateModel = minDateModel;

    [self.yearArray removeAllObjects];
    
    if (self.defaultDate) {
        NSComparisonResult defauMinRes = [self.defaultDate compare:self.minDate];
        BOOL defauLessMin = defauMinRes == NSOrderedAscending;   //默认小于最小
        BOOL defauEqualMin = defauMinRes == NSOrderedSame;       //默认等于最小
        
        if (defauLessMin) {
            @throw [self throwExceptionWithReson:@"您设置的最小日期大于您设置的默认日期，日期不合理"];
            return;
        } else if (defauEqualMin) {
            [self setupAllIndexToZero];
        }
        
        if (self.maxDateModel) {
            
            NSComparisonResult minMaxRes = [self.minDate compare:self.maxDate];
            BOOL minLargeMax = minMaxRes == NSOrderedDescending; //最小大于最大
            BOOL minEqualMax = minMaxRes == NSOrderedSame;       //最小等于最大
            
            if (minLargeMax) {
                @throw [self throwExceptionWithReson:@"您设置的最小日期大于您设置的最大日期，日期不合理"];
            }
            NSComparisonResult defauMaxRes = [self.defaultDate compare:self.maxDate];
            BOOL defauLargeMax = defauMaxRes == NSOrderedDescending;  //默认大于最大
            
            if (defauLargeMax) {
                @throw [self throwExceptionWithReson:@"您设置的默认日期大于您设置的最大日期，日期不合理"];
            }
            
            //default = min = max 三者相等
            if (minEqualMax && defauEqualMin) {
                [self defalut_Min_Max_Equal];
                return;
            }
            //能走到这，说明 默认 >= 最小 && 最大 >= 最小 && 默认 <= 最大，即默认一定在最大最小之间
            
            [self defaultBetweenMinAndMax];
            
        } else {
            //有默认，没有最大   //走到这，说明 默认 >= 最小
            [self defaultLargeOrEqualMin];
        }
    } else {
        
        NSComparisonResult currMinRes = [self.currentDate compare:self.minDate];
        BOOL currLargeMin = currMinRes == NSOrderedDescending;  //当前大于最小
        BOOL currLessMin = currMinRes == NSOrderedAscending;    //当前小于最小
        BOOL currEqualMin = currMinRes == NSOrderedSame;        //当前等于最小
        
        //没有默认
        if (self.maxDateModel) {

            //没有默认，有最大
            NSComparisonResult currMaxRes = [self.currentDate compare:self.maxDate];
            BOOL currLargeMax = currMaxRes == NSOrderedDescending;  //当前大于最大
            BOOL currLessMax = currMaxRes == NSOrderedAscending;    //当前小于最大
            BOOL currEqualMax = currMaxRes == NSOrderedSame;        //当前等于最大
            
            NSComparisonResult minMaxRes = [self.minDate compare:self.maxDate];
            BOOL minLargeMax = minMaxRes == NSOrderedDescending; //最小大于最大
            
            if (minLargeMax) {
                @throw [self throwExceptionWithReson:@"您设置的最小日期大于您设置的最大日期，日期不合理"];
            }
            
            //最大大于或等于最小
            if (currLargeMin) { //当前大于最小
                if (currLargeMax) {
                    //当前大于最小，大于最大，即不考虑当前日期的影响
                    [self setupAllIndexToZero];
                } else if (currLessMax) {
                    //当前大于最小，小于最大， 即当前日期在最大和最小之间
                    [self currentBetweenMaxAndMin];
                } else if (currEqualMax) {
                    //当前大于最小，等于最大，意味着最大一定是大于最小的，
                    [self currentEqualMaxAndLargeThanMin];
                } else {
                    NSLog(@"另外的情况，有？");
                }
                
            } else if (currLessMin || currEqualMin) {
                //当前小于最小，能走到这说明最大大于或等于最小，那当前肯定也是小于最大的
                //当前等于最小，应该也可以，也是只有最大和最小的相互比较，当前不产生任何影响，默认索引全都是零

                [self setupAllIndexToZero];
            }

        } else {
            //没有默认，没有最大 over
            if (currLargeMin || currEqualMin) {
                
                selectedYearIndex = _currentYear - minDateModel.year;
                
                if (_currentYear == minDateModel.year) {
                    
                    selectedMonthIndex = _currentMonth - minDateModel.month;
                    
                    if (_currentMonth == minDateModel.month) {
            
                        selectedDayIndex = _currentDay - minDateModel.day;
                        
                        if (_currentDay == minDateModel.day) {
                 
                            selectedHourIndex = _currentHour - minDateModel.hour;
                            
                            if (_currentHour == minDateModel.hour) {
                                selectedMinuteIndex = _currentMinute - minDateModel.minute;
                            } else {
                                selectedMinuteIndex = _currentMinute;
                            }
                            
                        } else {
                            selectedHourIndex = _currentHour;
                            selectedMinuteIndex = _currentMinute;
                        }
                        
                    } else {
                        [self setupCurrentDay_hour_minute_index];
                    }
                } else {
                    [self setupCurrentMonth_day_hour_minute_index];
                }
            } else if (currLessMin) {
                //over
                [self setupAllIndexToZero];
            }
        }
    }

    self.minMonthArray = [NSMutableArray array];
    
    if (self.defaultDate) {
        
        if (self.maxDateModel) {

            [self setupMinAndMaxYearSource];
            
            if (minDateModel.year == self.maxDateModel.year) {
                [self setupMinMonthSourceWithMinAndMaxYearEqual];
            } else {
                [self setupMinMonthSourceWithMin];
            }
        } else {
            
            if (self.defaultDateModel.year >= _currentYear) {
                for (NSInteger i = self.minDateModel.year; i <= self.defaultDateModel.year + MINYEAROFFSET; i++) {
                    [self.yearArray addObject:@(i)];
                }
            } else {
                for (NSInteger i = self.minDateModel.year; i <= _currentYear + MINYEAROFFSET; i++) {
                    [self.yearArray addObject:@(i)];
                }
            }
            [self setupMinMonthSourceWithMin];
        }
    } else {
        //无默认
        if (self.maxDateModel) {
            
           [self setupMinAndMaxYearSource];
            
            if (minDateModel.year == self.maxDateModel.year) {
                [self setupMinMonthSourceWithMinAndMaxYearEqual];
            } else {
                [self setupMinMonthSourceWithMin];
            }
        } else {
            //无默认，无最大
            
            if (_currentYear - minDateModel.year >= 0) {
                for (NSInteger i = minDateModel.year; i <= _currentYear + MINYEAROFFSET; i++) {
                    [self.yearArray addObject:@(i)];
                }
            } else {
                //当前比最小还小
                for (NSInteger i = minDateModel.year; i <= minDateModel.year + MINYEAROFFSET; i++) {
                    [self.yearArray addObject:@(i)];
                }
            }
            
            [self setupMinMonthSourceWithMin];
        }
    }
    
    [self reloadAllComponents];
}

-(void)setMaxDate:(NSDate *)maxDate {
    _maxDate = maxDate;
    
    ZHG_CustomDateModel *maxDateModel = [ZHG_CustomDateModel modelWithDate:maxDate isMaxDate:YES];
    self.maxDateModel = maxDateModel;

    [self.yearArray removeAllObjects];

    if (self.defaultDate) {
        
        NSComparisonResult defauMaxRes = [self.defaultDate compare:self.maxDate];
        BOOL defauLargeMax = defauMaxRes == NSOrderedDescending;  //默认大于最大
        BOOL defauEqualMax = defauMaxRes == NSOrderedSame;        //默认等于最大
        
        if (defauLargeMax) {
            @throw [self throwExceptionWithReson:@"您设置的最大日期小于您设置的默认日期，日期不合理"];
            return;
        }
        
        if (self.minDate) {
            
            NSComparisonResult minMaxRes = [self.minDate compare:self.maxDate];
            BOOL minLargeMax = minMaxRes == NSOrderedDescending; //最小大于最大
            
            if (minLargeMax) {
                @throw [self throwExceptionWithReson:@"您设置的最大日期小于您设置的最小日期，日期不合理"];
            }
            NSComparisonResult defauMinRes = [self.defaultDate compare:self.minDate];
            BOOL defauLessMin = defauMinRes == NSOrderedAscending;   //默认小于最小
            BOOL defauEqualMin = defauMinRes == NSOrderedSame;       //默认等于最小
            
            if (defauLessMin) {
                @throw [self throwExceptionWithReson:@"您设置的默认日期小于您设置的最小日期，日期不合理"];
            }
            if (defauEqualMax && defauEqualMin) {
                [self defalut_Min_Max_Equal];
                return;
            }
            //有默认，有最小
            //走到这，说明默认一定在最大和最小之间 ---------
            [self defaultBetweenMinAndMax];
            
        } else {
            //有默认，无最小 ，走到这，说明 默认 <= 最大
            //over
            if (self.defaultDateModel.year < _currentYear) {
                selectedYearIndex = MINYEAROFFSET;
            } else {
                selectedYearIndex = self.defaultDateModel.year - _currentYear + MINYEAROFFSET;
            }
        
            [self setupDefaultMonth_day_hour_minute_index];
        }
        
    } else {
        
        NSComparisonResult currMinRes = [self.currentDate compare:self.minDate];
        
        BOOL currLargeMin = currMinRes == NSOrderedDescending;  //当前大于最小
        BOOL currLessMin = currMinRes == NSOrderedAscending;    //当前小于最小
        BOOL currEqualMin = currMinRes == NSOrderedSame;        //当前等于最小
        
        NSComparisonResult currMaxRes = [self.currentDate compare:self.maxDate];
        
        BOOL currLargeMax = currMaxRes == NSOrderedDescending;  //当前大于最大
        BOOL currLessMax = currMaxRes == NSOrderedAscending;    //当前小于最大
        BOOL currEqualMax = currMaxRes == NSOrderedSame;        //当前等于最大
        
        
        if (self.minDate) {
            //无默认，有最小
            NSComparisonResult minMaxRes = [self.minDate compare:self.maxDate];
            BOOL minLargeMax = minMaxRes == NSOrderedDescending; //最小大于最大
            if (minLargeMax) {
                @throw [self throwExceptionWithReson:@"您设置的最大日期小于您设置的最小日期，日期不合理"];
                return;
            }
            
            //走到这说明 max >= min
            
            if (currLargeMax) {
                
                if (currLargeMin) {
                    //当前大于最大，当前大于最小，全置零，不考虑当前日期的影响
                    [self setupAllIndexToZero];
                } else if (currLessMin) {
                    @throw [self throwExceptionWithReson:@"最大 >= 最小，当前大于最大，小于最小，不存在的"];
                } else if (currEqualMin) {
                    //当前等于最小
                    @throw [self throwExceptionWithReson:@"最大 >= 最小，当前大于最大，等于最小，不存在的"];
                }
                
            } else if (currLessMax) {
                //当前小于最大
                if (currLargeMin) {
                    //当前小于最大，当前大于最小，即当前日期在最大和最小之间
                    [self currentBetweenMaxAndMin];
                } else if (currLessMin || currEqualMin) {
                    //当前小于最大，当前小于最小，
                    [self setupAllIndexToZero];
                }
            } else if (currEqualMax) {
                
                if (currLargeMin) {
                    //当前等于最大，当前大于最小，意味着最大一定大于最小
                    [self currentEqualMaxAndLargeThanMin];
                } else if (currLessMin) {
                    //当前小于最大，当前小于最小，
                    @throw [self throwExceptionWithReson:@"最大 >= 最小，当前等于最大，小于最小，不存在的"];
                } else if (currEqualMin) {
                    [self setupAllIndexToZero];
                }
            }
        } else {
            //无默认，无最小，仅最大
            if (currLargeMax) {
                [self setupAllIndexToZero];
            } else if (currLessMax || currEqualMax) {
                //当前小于最大
                selectedYearIndex = MINYEAROFFSET;
                [self setupCurrentMonth_day_hour_minute_index];
            } else {
                NSLog(@"其他情况，有？");
            }
        }
    }
    
    self.maxMonthArray = [NSMutableArray array];
    
    if (self.defaultDateModel) {
        
        if (self.minDateModel) {
            
            [self setupMinAndMaxYearSource];
            
            if (self.minDateModel.year == self.maxDateModel.year) {
                [self setupMaxMonthSourceWithMinAndMaxYearEqual];
            } else {
                [self setupMaxMonthSourceWithMax];
            }
            
        } else {
            
            //有默认，再有最大
            // max >= default
            if (self.defaultDateModel.year < _currentYear) {
                
                for (NSInteger i = self.defaultDateModel.year - MINYEAROFFSET; i <= self.maxDateModel.year; i++) {
                    [self.yearArray addObject:@(i)];
                }
            } else {
                for (NSInteger i = _currentYear - MINYEAROFFSET; i <= self.maxDateModel.year; i++) {
                    [self.yearArray addObject:@(i)];
                }
            }
            [self setupMaxMonthSourceWithMax];
        }
    } else {
        if (self.minDateModel) {
            //先有最小，再有最大
            [self setupMinAndMaxYearSource];
            
            if (self.minDateModel.year == self.maxDateModel.year) {
                [self setupMaxMonthSourceWithMinAndMaxYearEqual];
            } else {
                [self setupMaxMonthSourceWithMax];
            }
            
        } else {   //无最小，无默认
            
            if (self.maxDateModel.year - _currentYear > 0) {
                for (NSInteger i = _currentYear - MINYEAROFFSET; i <= self.maxDateModel.year; i++) {
                    [self.yearArray addObject:@(i)];
                }
            } else {
                for (NSInteger i = self.maxDateModel.year - MINYEAROFFSET; i <= self.maxDateModel.year; i++) {
                    [self.yearArray addObject:@(i)];
                }
            }
            [self setupMaxMonthSourceWithMax];
        }
    }
    
    [self reloadAllComponents];
}

-(void)setDefaultDate:(NSDate *)defaultDate {
    _defaultDate = defaultDate;
    
    self.defaultDateModel = [ZHG_CustomDateModel modelWithDate:self.defaultDate isMaxDate:NO];
    
    [self.yearArray removeAllObjects];
    
    if (self.minDate) {
        
        NSComparisonResult defauMinRes = [self.defaultDate compare:self.minDate];
        
        BOOL defauLessMin = defauMinRes == NSOrderedAscending;
        BOOL defauEqualMin = defauMinRes == NSOrderedSame;
        
        if (defauLessMin) {
            @throw [self throwExceptionWithReson:@"您设置的默认日期小于您设置的最小日期，日期不合理"];
        }
        
        if (self.maxDate) {
            //既有最小，也有最大
            NSComparisonResult defauMaxRes = [self.defaultDate compare:self.maxDate];
            
            BOOL defauLargeMax = defauMaxRes == NSOrderedDescending;
            BOOL defauEqualMax = defauMaxRes == NSOrderedSame;
            
            if (defauLargeMax) {
                @throw [self throwExceptionWithReson:@"您设置的默认日期大于您设置的最大日期，日期不合理"];
            }
            if (defauEqualMax && defauEqualMin) {
                [self defalut_Min_Max_Equal];
                return;
            }
            //走到这，说明默认日期是在最大和最小之间的日期
            [self defaultBetweenMinAndMax];
        } else {
            //有最小，没有最大   默认 >= 最小
            [self defaultLargeOrEqualMin];
        }
        
    } else {
        
        // 没有最小

        NSComparisonResult defauMaxRes = [self.defaultDate compare:self.maxDate];
        
        BOOL defauLargeMax = defauMaxRes == NSOrderedDescending;
        
        if (defauLargeMax) {
            @throw [self throwExceptionWithReson:@"您设置的默认日期大于您设置的最大日期，日期不合理"];
        }
        
        if (self.maxDate) {
            //有最大，没有最小  //走到这说明 最大 >= 默认
            
            if (self.defaultDateModel.year < _currentYear) {
                selectedYearIndex = MINYEAROFFSET;
            } else {
                selectedYearIndex = self.defaultDateModel.year - _currentYear + MINYEAROFFSET;
            }
            [self setupDefaultMonth_day_hour_minute_index];
            
        } else {
            //没有最小，没有最大，仅有默认
            
            NSComparisonResult defauCurrentRes = [self.defaultDate compare:self.currentDate];
            
            BOOL defauLargeCurrent = defauCurrentRes == NSOrderedDescending; //默认大于最小
            BOOL defauLessCurrent = defauCurrentRes == NSOrderedAscending;   //默认小于最小
            BOOL defauEqualCurrent = defauCurrentRes == NSOrderedSame;       //默认等于最小
            
            if (defauLargeCurrent) {
                selectedYearIndex = self.defaultDateModel.year - _currentYear + MINYEAROFFSET;
            } else if (defauLessCurrent || defauEqualCurrent) {
                selectedYearIndex = MINYEAROFFSET;
            } else {
                NSLog(@"有？？？？？？？？");
            }
            [self setupDefaultMonth_day_hour_minute_index];
        }
    }
    
    if (self.minDate) {
        if (self.maxDate) {
            [self setupMinAndMaxYearSource];
        } else {
            //现有最小，再有默认  //default >= min
            if (self.defaultDateModel.year > _currentYear) {
                for (NSInteger i = self.minDateModel.year; i <= self.defaultDateModel.year + MINYEAROFFSET; i++) {
                    [self.yearArray addObject:@(i)];
                }
            } else {
                for (NSInteger i = self.minDateModel.year; i <= _currentYear + MINYEAROFFSET; i++) {
                    [self.yearArray addObject:@(i)];
                }
            }
        }
    } else {
        
        if (self.maxDate) {
            //先有最大，再有默认  // default <= max
            
            if (self.defaultDateModel.year < _currentYear) {
                
                for (NSInteger i = self.defaultDateModel.year - MINYEAROFFSET; i <= self.maxDateModel.year; i++) {
                    [self.yearArray addObject:@(i)];
                }
                
            } else {
                for (NSInteger i = _currentYear - MINYEAROFFSET; i <= self.maxDateModel.year; i++) {
                    [self.yearArray addObject:@(i)];
                }
            }
            
        } else {
            //无最大和最小
            if (self.defaultDateModel.year <= _currentYear) {
                for (NSInteger i = self.defaultDateModel.year - MINYEAROFFSET; i <= _currentYear +  MINYEAROFFSET; i++) {
                    [self.yearArray addObject:@(i)];
                }
                
            } else {
                for (NSInteger i = _currentYear - MINYEAROFFSET; i <= self.defaultDateModel.year + MINYEAROFFSET; i++) {
                    [self.yearArray addObject:@(i)];
                }
            }
        }
    }
    daysCount = [self year:self.defaultDateModel.year month:self.defaultDateModel.month];
    [self reloadAllComponents];
}

-(void)setDatePickerType:(ZHG_CustomDatePickerView_Type)datePickerType {
    _datePickerType = datePickerType;
    
    [self reloadAllComponents];
}

-(void)setLimitMaxDateToday:(BOOL)limitMaxDateToday {
    _limitMaxDateToday = limitMaxDateToday;
    [self setupDefaultSelectRowIndex];
}

@end
