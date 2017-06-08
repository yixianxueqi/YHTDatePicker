//
//  YHTDateCalculate.h
//  DMTimePick
//
//  Created by 君若见故 on 2017/6/6.
//  Copyright © 2017年 isoftstone. All rights reserved.
//

#import <Foundation/Foundation.h>

//类型标示符
//向上取
extern int const YHTMINTYEPE;
//默认
extern int const YHTNORMALTYPE;
//向下取
extern int const YHTMAXTYPE;


@interface YHTDateScope : NSObject

@property (nonatomic, assign) NSInteger start;
@property (nonatomic, assign) NSInteger length;

- (instancetype)initWithStart:(NSInteger)start length:(NSInteger)length;

@end

@interface YHTDateCalculate : NSObject

- (YHTDateScope *)getYearListWithMinDate:(NSDate *)minDate maxDate:(NSDate *)maxDate;
- (YHTDateScope *)getMonthListWithDate:(NSDate *)date type:(NSInteger)type;
- (YHTDateScope *)getDayListWithDate:(NSDate *)date type:(NSInteger)type;
- (YHTDateScope *)getHourListWithDate:(NSDate *)date type:(NSInteger)type;
- (YHTDateScope *)getMinuteListWithDate:(NSDate *)date type:(NSInteger)type;

@end
