//
//  YHTDatePickViewController+YHTPickViewDelegate.m
//  DMTimePick
//
//  Created by 君若见故 on 2017/6/6.
//  Copyright © 2017年 isoftstone. All rights reserved.
//

#import "YHTDatePickViewController+YHTPickViewDelegate.h"

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
            count = [[self yearList] count];
            break;
        case 1:
            count = [[self monthList] count];
            break;
        case 2:
            count = [[self dayList] count];
            break;
        case 3:
            count = [[self hourList] count];
            break;
        case 4:
            count = [[self minuteList] count];
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

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {

    NSString *title = nil;
    switch (component) {
        case 0:
            title = [self yearStrWithRow:row];
            break;
        case 1:
            title = [self monthStrWithRow:row];
            break;
        case 2:
            title = [self dayStrWithRow:row];
            break;
        case 3:
            title = [self hourStrWithRow:row];
            break;
        case 4:
            title = [self minuteStrWithRow:row];
            break;
    }
    return title;
}
- (nullable NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {

    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] init];
    NSDictionary *attribut = @{NSFontAttributeName: [UIFont systemFontOfSize:21], NSForegroundColorAttributeName: self.tintColor};
    switch (component) {
        case 0:
            [title appendAttributedString:[[NSAttributedString alloc] initWithString:[self yearStrWithRow:row] attributes:attribut]];
            break;
        case 1:
            [title appendAttributedString:[[NSAttributedString alloc] initWithString:[self monthStrWithRow:row] attributes:attribut]];
            break;
        case 2:
            [title appendAttributedString:[[NSAttributedString alloc] initWithString:[self dayStrWithRow:row] attributes:attribut]];
            break;
        case 3:
            [title appendAttributedString:[[NSAttributedString alloc] initWithString:[self hourStrWithRow:row] attributes:attribut]];
            break;
        case 4:
            [title appendAttributedString:[[NSAttributedString alloc] initWithString:[self minuteStrWithRow:row] attributes:attribut]];
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
    NSAssert([self dateCompare], @"当前时间不能小于最小时间!!");
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute fromDate:self.currentDate];
    NSUInteger yearIndex = [[self yearList] indexOfObject:[NSString stringWithFormat:@"%ld",components.year]];
    UIPickerView *pickView = [self valueForKey:@"pickView"];
    if (!pickView) {
        return;
    }
    //设置默认选中项
    NSUInteger componentCount = pickView.numberOfComponents;
    if (componentCount > 0) {
        [pickView selectRow:yearIndex inComponent:0 animated:false];
    }
    if (componentCount > 1) {
        [pickView selectRow:(components.month - 1) inComponent:1 animated:false];
    }
    if (componentCount > 2) {
        [pickView selectRow:(components.day - 1) inComponent:2 animated:false];
    }
    if (componentCount > 3) {
        [pickView selectRow:components.hour inComponent:3 animated:false];
    }
    if (componentCount > 4) {
        [pickView selectRow:components.minute inComponent:4 animated:false];
    }
}

#pragma mark - private

//--- year ---
- (NSArray *)yearList {

    if (_delegateFlags.yearFlag) {
        return [self.delegate getYearListWithMinDate:self.minDate maxDate:self.maxDate];
    } else {
        return nil;
    }
}

- (NSString *)yearStrWithRow:(NSUInteger)row {

    NSString *year = nil;
    NSArray *yearList = [self yearList];
    if (yearList.count > row) {
        return yearList[row];
    }
    return year;
}

//--- month ---
- (NSArray *)monthList {

    if (_delegateFlags.monthFlag) {
        return [self.delegate getMonthListWithDate:nil];
    } else {
        return nil;
    }
}

- (NSString *)monthStrWithRow:(NSUInteger)row {

    NSString *month = nil;
    NSArray *monthList = [self monthList];
    if (monthList.count > row) {
        month = monthList[row];
    }
    return month;
}

//--- day ---
- (NSArray *)dayList {

    UIPickerView *pickView = [self valueForKey:@"pickView"];
    if (!pickView) {
        return nil;
    }
    NSUInteger yearIndex = [pickView selectedRowInComponent:0];
    NSUInteger monthIndex = [pickView selectedRowInComponent:1];
    NSString *yearStr = [self yearList][yearIndex];
    NSString *monthStr = [self monthList][monthIndex];
    if (_delegateFlags.dayFlag) {
        return [self.delegate getDayListWithDate:[self getDateFromYear:yearStr month:monthStr]];
    }
    return nil;
}

- (NSString *)dayStrWithRow:(NSUInteger)row {

    NSString *day = nil;
    NSArray *daylist = [self dayList];
    if (daylist.count > row) {
        day = daylist[row];
    }
    return day;
}
//--- hour ---
- (NSArray *)hourList {

    if (_delegateFlags.dayFlag) {
        return [self.delegate getHourListWithDate:nil];
    } else {
        return nil;
    }
}

- (NSString *)hourStrWithRow:(NSUInteger)row {

    NSString *hour = nil;
    NSArray *hourList = [self hourList];
    if (hourList.count > row) {
        hour = hourList[row];
    }
    return hour;
}

//--- minute ---

- (NSArray *)minuteList {

    if (_delegateFlags.minuteFlag) {
        return [self.delegate getMinuteListWithDate:nil];
    } else {
        return nil;
    }
}

- (NSString *)minuteStrWithRow:(NSUInteger)row {

    NSString *min = nil;
    NSArray *minList = [self minuteList];
    if (minList.count > row) {
        min = minList[row];
    }
    return min;
}


/**
 计算component宽度
 年份算2份，其余算1份，最多共6份

 @param count 列数
 @return CGFloat
 */
- (CGFloat)calculateComponentsWithCount:(NSInteger)count {

    UIView *contentView = (UIView *)[self valueForKey:@"contentView"];
    CGFloat width = contentView.bounds.size.width;
    return width/count;
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
    formater.dateFormat = @"yyyy-MM";
    return [formater dateFromString:[NSString stringWithFormat:@"%@-%@",year, month]];
}


/**
 比较两个日期大小

 @return BOOl
 */
- (BOOL)dateCompare {

    NSTimeInterval oneTime = [self.minDate timeIntervalSince1970];
    NSTimeInterval anotherTime = [self.currentDate timeIntervalSince1970];
    if (anotherTime - oneTime > 0) {
        return true;
    } else {
        return false;
    }
}

@end



