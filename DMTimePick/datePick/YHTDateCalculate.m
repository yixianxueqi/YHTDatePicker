//
//  YHTDateCalculate.m
//  DMTimePick
//
//  Created by 君若见故 on 2017/6/6.
//  Copyright © 2017年 isoftstone. All rights reserved.
//

#import "YHTDateCalculate.h"

static NSString *const YearList = @"yearList";
static NSString *const MonthList = @"monthList";
static NSString *const HourList = @"hourList";
static NSString *const MinuteList = @"minuteList";

@interface YHTDateCalculate ()

@property (nonatomic, strong) NSCalendar *calendar;
@property (nonatomic, strong) NSMutableDictionary *cacheDic;

@end

@implementation YHTDateCalculate

#pragma mark - life cycle

- (void)dealloc {

    NSLog(@"%@ dealloc", NSStringFromClass([self class]));
}

#pragma mark - YHTDateDataSource

- (NSArray *)getYearListWithMinDate:(NSDate *)minDate maxDate:(NSDate *)maxDate {

    if (self.cacheDic[YearList]) {
        //优先从缓存取，若不存在再计算
        return self.cacheDic[YearList];
    } else {
        NSInteger minYear = [self.calendar components:NSCalendarUnitYear fromDate:minDate].year;
        NSInteger maxYar = [self.calendar components:NSCalendarUnitYear fromDate:maxDate].year;
        NSMutableArray *yearList = [NSMutableArray array];
        for (int i = (int)minYear; i<=maxYar; i++) {
            [yearList addObject:[NSString stringWithFormat:@"%d",i]];
        }
        //做缓存
        [self.cacheDic setValue:yearList forKey:YearList];
        return yearList;
    }
}

- (NSArray *)getMonthListWithDate:(NSDate *)date {

    if (self.cacheDic[MonthList]) {
        return self.cacheDic[MonthList];
    } else {
        NSMutableArray *monthList = [NSMutableArray array];
        for (int i = 1; i < 13; i++) {
            [monthList addObject:[NSString stringWithFormat:@"%d",i]];
        }
        [self.cacheDic setValue:monthList forKey:MonthList];
        return monthList;
    }
}

- (NSArray *)getDayListWithDate:(NSDate *)date {

    NSRange range = [self.calendar rangeOfUnit: NSCalendarUnitDay
                                   inUnit: NSCalendarUnitMonth
                                  forDate:date];
    NSMutableArray *dayList = [NSMutableArray array];
    for (int i = 1 ; i <= range.length; i++) {
        [dayList addObject:[NSString stringWithFormat:@"%d",i]];
    }
    return dayList;
}

- (NSArray *)getHourListWithDate:(NSDate *)date {

    if (self.cacheDic[HourList]) {
        return self.cacheDic[HourList];
    } else {
        NSMutableArray *hourList = [NSMutableArray array];
        for (int i = 0; i < 24; i++) {
            [hourList addObject:[NSString stringWithFormat:@"%d",i]];
        }
        [self.cacheDic setValue:hourList forKey:HourList];
        return hourList;
    }
}

- (NSArray *)getMinuteListWithDate:(NSDate *)date {

    if (self.cacheDic[MinuteList]) {
        return self.cacheDic[MinuteList];
    } else {
        NSMutableArray *minuteList = [NSMutableArray array];
        for (int i = 0; i < 60; i++) {
            [minuteList addObject:[NSString stringWithFormat:@"%d",i]];
        }
        [self.cacheDic setValue:minuteList forKey:MinuteList];
        return minuteList;
    }
}

#pragma Mark - private


#pragma mark - getter/setter 

- (NSCalendar *)calendar {

    if (!_calendar) {
        _calendar = [NSCalendar currentCalendar];
    }
    return _calendar;
}

- (NSMutableDictionary *)cacheDic {

    if (!_cacheDic) {
        _cacheDic = [NSMutableDictionary dictionary];
    }
    return _cacheDic;
}

@end
