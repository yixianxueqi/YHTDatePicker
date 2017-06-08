//
//  YHTDateCalculate.m
//  DMTimePick
//
//  Created by 君若见故 on 2017/6/6.
//  Copyright © 2017年 isoftstone. All rights reserved.
//

#import "YHTDateCalculate.h"

static NSString *const YearList = @"yearList";
static NSString *const MINMonthList = @"minmonthList";
static NSString *const MonthList = @"monthList";
static NSString *const MaxMonthList = @"maxmonthList";
static NSString *const MinHourList = @"minhourList";
static NSString *const HourList = @"hourList";
static NSString *const MaxHourList = @"maxhourList";
static NSString *const MinMinuteList = @"minminuteList";
static NSString *const MinuteList = @"minuteList";
static NSString *const MaxMinuteList = @"maxminuteList";

const int YHTMINTYEPE = 1;
const int YHTNORMALTYPE = 0;
const int YHTMAXTYPE = -1;

@implementation YHTDateScope

- (instancetype)initWithStart:(NSInteger)start length:(NSInteger)length {

    self = [super init];
    if (self) {
        _start = start;
        _length = length;
    }
    return self;
}
@end



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

- (YHTDateScope *)getYearListWithMinDate:(NSDate *)minDate maxDate:(NSDate *)maxDate {

    if (self.cacheDic[YearList]) {
        //优先从缓存取，若不存在再计算
        return self.cacheDic[YearList];
    } else {
        NSInteger minYear = [self.calendar components:NSCalendarUnitYear fromDate:minDate].year;
        NSInteger maxYar = [self.calendar components:NSCalendarUnitYear fromDate:maxDate].year;
        YHTDateScope *scope = [[YHTDateScope alloc] initWithStart:minYear length:maxYar - minYear + 1];
        //做缓存
        [self.cacheDic setValue:scope forKey:YearList];
        return scope;
    }
}

- (YHTDateScope *)getMonthListWithDate:(NSDate *)date type:(NSInteger)type {

    if (type == YHTNORMALTYPE) {
        //返回12月
        if (self.cacheDic[MonthList]) {
            return self.cacheDic[MonthList];
        } else {
            YHTDateScope *scope = [[YHTDateScope alloc] initWithStart:1 length:12];
            [self.cacheDic setValue:scope forKey:MonthList];
        }
    } else if (type == YHTMINTYEPE) {
        //向上取，即 n~12
        if (self.cacheDic[MINMonthList]) {
            return self.cacheDic[MINMonthList];
        } else {
            NSInteger minMonth = [self.calendar component:NSCalendarUnitMonth fromDate:date];
            YHTDateScope *scope = [[YHTDateScope alloc] initWithStart:minMonth length:12 - minMonth + 1];
            [self.cacheDic setValue:scope forKey:MINMonthList];
            return scope;
        }
    } else {
        //向下取，即 1~n
        if (self.cacheDic[MaxMonthList]) {
            return self.cacheDic[MaxMonthList];
        } else {
            NSInteger maxMonth = [self.calendar component:NSCalendarUnitMonth fromDate:date];
            YHTDateScope *scope = [[YHTDateScope alloc] initWithStart:1 length:maxMonth];
            [self.cacheDic setValue:scope forKey:MINMonthList];
            return scope;
        }
    }
    return nil;
}

- (YHTDateScope *)getDayListWithDate:(NSDate *)date type:(NSInteger)type {

    NSRange range = [self.calendar rangeOfUnit: NSCalendarUnitDay
                                   inUnit: NSCalendarUnitMonth
                                  forDate:date];
    if (type == YHTNORMALTYPE) {
        return [[YHTDateScope alloc] initWithStart:range.location length:range.length];
    } else if(type == YHTMINTYEPE) {
        NSInteger minDay = [self.calendar component:NSCalendarUnitDay fromDate:date];
        return [[YHTDateScope alloc] initWithStart:minDay length:range.length - minDay + 1];
    } else {
        NSInteger maxDay = [self.calendar component:NSCalendarUnitDay fromDate:date];
        return [[YHTDateScope alloc] initWithStart:1 length:maxDay];
    }
}

- (YHTDateScope *)getHourListWithDate:(NSDate *)date type:(NSInteger)type {

    if (type == YHTNORMALTYPE) {
        if (self.cacheDic[HourList]) {
            return self.cacheDic[HourList];
        } else {
            [self.cacheDic setValue:[[YHTDateScope alloc] initWithStart:0 length:24] forKey:HourList];
        }
    } else if (type == YHTMINTYEPE) {
        if (self.cacheDic[MinHourList]) {
            return self.cacheDic[MinHourList];
        } else {
            NSInteger minHour = [self.calendar component:NSCalendarUnitHour fromDate:date];
            YHTDateScope *scope = [[YHTDateScope alloc] initWithStart:minHour length:24 - minHour + 1];
            [self.cacheDic setValue:scope forKey:MinHourList];
            return scope;
        }
    } else {
        if (self.cacheDic[MaxHourList]) {
            return self.cacheDic[MaxHourList];
        } else {
            NSInteger maxHour = [self.calendar component:NSCalendarUnitHour fromDate:date];
            YHTDateScope *scope = [[YHTDateScope alloc] initWithStart:0 length:maxHour + 1];
            [self.cacheDic setValue:scope forKey:MaxHourList];
            return scope;
        }
    }
    return nil;
}

- (YHTDateScope *)getMinuteListWithDate:(NSDate *)date type:(NSInteger)type {

    if (type == YHTNORMALTYPE) {
        if (self.cacheDic[MinuteList]) {
            return self.cacheDic[MinuteList];
        } else {
            [self.cacheDic setValue:[[YHTDateScope alloc] initWithStart:0 length:60] forKey:MinuteList];
        }
    } else if (type == YHTMINTYEPE) {
        if (self.cacheDic[MinMinuteList]) {
            return self.cacheDic[MinMinuteList];
        } else {
            NSInteger minMinute = [self.calendar component:NSCalendarUnitMinute fromDate:date];
            YHTDateScope *scope = [[YHTDateScope alloc] initWithStart:minMinute length:60 - minMinute + 1];
            [self.cacheDic setValue:scope forKey:MinMinuteList];
            return scope;
        }
    } else {
        NSInteger maxMinute = [self.calendar component:NSCalendarUnitMinute fromDate:date];
        YHTDateScope *scope = [[YHTDateScope alloc] initWithStart:maxMinute length:maxMinute + 1];
        [self.cacheDic setValue:scope forKey:MaxMinuteList];
        return scope;
    }
    return nil;
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
