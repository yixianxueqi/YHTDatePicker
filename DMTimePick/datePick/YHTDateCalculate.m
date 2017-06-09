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

- (YHTDateScope *)getMonthListWithDate:(NSDate *)date {

    //返回12月
    if (self.cacheDic[MonthList]) {
        return self.cacheDic[MonthList];
    } else {
        YHTDateScope *scope = [[YHTDateScope alloc] initWithStart:1 length:12];
        [self.cacheDic setValue:scope forKey:MonthList];
        return scope;
    }
}

- (YHTDateScope *)getDayListWithDate:(NSDate *)date {

    NSRange range = [self.calendar rangeOfUnit: NSCalendarUnitDay
                                        inUnit: NSCalendarUnitMonth
                                       forDate:date];
    return [[YHTDateScope alloc] initWithStart:range.location length:range.length];

}

- (YHTDateScope *)getHourListWithDate:(NSDate *)date {

    if (self.cacheDic[HourList]) {
        return self.cacheDic[HourList];
    } else {
        YHTDateScope *scope = [[YHTDateScope alloc] initWithStart:0 length:24];
        [self.cacheDic setValue:scope forKey:HourList];
        return scope;
    }

}

- (YHTDateScope *)getMinuteListWithDate:(NSDate *)date {

    if (self.cacheDic[MinuteList]) {
        return self.cacheDic[MinuteList];
    } else {
        YHTDateScope *scope = [[YHTDateScope alloc] initWithStart:0 length:60];
        [self.cacheDic setValue:scope forKey:MinuteList];
        return scope;
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
