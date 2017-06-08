//
//  YHTDatePickViewController+YHTPickViewDelegate.m
//  DMTimePick
//
//  Created by 君若见故 on 2017/6/6.
//  Copyright © 2017年 isoftstone. All rights reserved.
//

#import "YHTDatePickViewController+YHTPickViewDelegate.h"
#import "YHTDateCalculate.h"

@interface YHTDatePickViewController ()

@end

@implementation YHTDatePickViewController (YHTPickViewDelegate)

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {

    NSUInteger count = [[self valueForKey:@"dateType"] integerValue];
    return count;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {

    NSUInteger count = 0;
    switch (component) {
        case 0:
            count = [self getYearList].length;
            break;
        case 1:
            count = [self getMonthList].length;
            break;
        case 2:
            count = [self getDayList].length;
            break;
        case 3:
            count = [self getHourList].length;
            break;
        case 4:
            count = [self getMinuteList].length;
            break;
    }
    return count;
}

#pragma mark - UIPickerViewDelegate

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {

    CGFloat width = pickerView.bounds.size.width / 12;
    if (component == 0) {
        return width * 3;
    } else {
        return width * 2;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {

    return 44;
}

- (nullable NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {

    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] init];
    NSDictionary *attribut = @{NSFontAttributeName: [UIFont systemFontOfSize:21], NSForegroundColorAttributeName: self.tintColor};
    switch (component) {
        case 0:
            [title appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld",[self getYearList].start + row] attributes:attribut]];
            break;
        case 1:
            [title appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld",[self getMonthList].start + row] attributes:attribut]];
            break;
        case 2:
            [title appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld",[self getDayList].start + row] attributes:attribut]];
            break;
        case 3:
            [title appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld",[self getHourList].start + row] attributes:attribut]];
            break;
        case 4:
            [title appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld",[self getMinuteList].start + row] attributes:attribut]];
            break;
    }
    return title;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {

    if ((component == 0 || component == 1) && pickerView.numberOfComponents > 2) {
        //更新年份或者月份，重新刷新天 && 存在天选择
        [pickerView reloadComponent:2];
    }
}

#pragma mark - public
/**
 设置默认选中的日期
 */
- (void)setDefaultSelectDate {

    //断言判断：当前时间不能小于设置的最小时间
    NSAssert([self dateCompare], @"当前时间不能小于最小时间且不能大于最大时间!!");
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute fromDate:self.currentDate];
    UIPickerView *pickView = [self getPickerView];
    //设置默认选中项
    NSUInteger componentCount = pickView.numberOfComponents;
    NSInteger index;
    if (componentCount > 0) {
        index = components.year - [self getYearList].start;
        [pickView selectRow:index inComponent:0 animated:false];
    }
    if (componentCount > 1) {
        index = components.month - [self getMonthList].start;
        [pickView selectRow:index inComponent:1 animated:false];
    }
    if (componentCount > 2) {
        index = components.day - [self getDayList].start;
        [pickView selectRow:index inComponent:2 animated:false];
        //解决异步bug，会导致天数不正常
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [pickView reloadComponent:2];
        });
    }
    if (componentCount > 3) {
        index = components.hour - [self getHourList].start;
        [pickView selectRow:index inComponent:3 animated:false];
    }
    if (componentCount > 4) {
        index = components.minute - [self getMinuteList].start;
        [pickView selectRow:index inComponent:4 animated:false];
    }
}

- (NSArray *)getSelectItem {

    UIPickerView *picker = [self getPickerView];
    NSUInteger componentCount = picker.numberOfComponents;
    NSString *year, *month, *day, *hour, *minute;
    NSMutableArray *list = [NSMutableArray array];
    if (componentCount > 0) {
        year = [NSString stringWithFormat:@"%ld",[picker selectedRowInComponent:0] + [self getYearList].start];
        [list addObject:year];
    }
    if (componentCount > 1) {
        month = [NSString stringWithFormat:@"%ld",[picker selectedRowInComponent:1] + [self getMonthList].start];
        [list addObject:month];
    }
    if (componentCount > 2) {
        day = [NSString stringWithFormat:@"%ld", [picker selectedRowInComponent:2] + [self getDayList].start];
        [list addObject:day];
    }
    if (componentCount > 3) {
        hour = [NSString stringWithFormat:@"%ld", [picker selectedRowInComponent:3] + [self getHourList].start];
        [list addObject:hour];
    }
    if (componentCount > 4) {
        minute = [NSString stringWithFormat:@"%ld", [picker selectedRowInComponent:4] + [self getMinuteList].start];
        [list addObject:minute];
    }
    return list;
}

#pragma mark - private

- (YHTDateScope *)getYearList {

    return [[self getDaterCalculate] getYearListWithMinDate:self.minDate maxDate:self.maxDate];
}

- (YHTDateScope *)getMonthList {

    return [[self getDaterCalculate] getMonthListWithDate:nil type:0];
}

- (YHTDateScope *)getDayList {

    UIPickerView *pickView = [self getPickerView];
    NSInteger year = [pickView selectedRowInComponent:0] + [self getYearList].start;
    NSInteger month = [pickView selectedRowInComponent:1] + [self getMonthList].start;
    NSDate *date = [self getDateFromYear:[NSString stringWithFormat:@"%ld", year] month:[NSString stringWithFormat:@"%ld",month]];
    return [[self getDaterCalculate] getDayListWithDate:date type:0];
}

- (YHTDateScope *)getHourList {

    return [[self getDaterCalculate] getHourListWithDate:nil type:0];
}

- (YHTDateScope *)getMinuteList {

    return [[self getDaterCalculate] getMinuteListWithDate:nil type:0];
}

#pragma mark - tool
/**
 获取日期对象

 @param year 年份
 @param month 月份
 @return NSDate
 */
- (NSDate *)getDateFromYear:(NSString *)year month:(NSString *)month {

    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    formater.dateFormat = @"yyyy-MM HH";
    formater.timeZone = self.timeZone;
    return [formater dateFromString:[NSString stringWithFormat:@"%@-%@ 08",year, month]];
}

/**
 比较两个日期大小

 @return BOOl
 */
- (BOOL)dateCompare {

    NSTimeInterval minTime = [self.minDate timeIntervalSince1970];
    NSTimeInterval currentTime = [self.currentDate timeIntervalSince1970];
    NSTimeInterval maxTime = [self.maxDate timeIntervalSince1970];
    if (currentTime - minTime >= 0 && maxTime - currentTime >= 0) {
        return true;
    } else {
        return false;
    }
}

#pragma mark - getter/setter

- (UIPickerView *)getPickerView {

    return [self valueForKey:@"pickView"];
}

- (YHTDateCalculate *)getDaterCalculate {

    return [self valueForKey:@"dateCalculate"];
}

@end



