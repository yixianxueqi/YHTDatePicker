//
//  YHTDateCalculate.h
//  DMTimePick
//
//  Created by 君若见故 on 2017/6/6.
//  Copyright © 2017年 isoftstone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YHTDateScope : NSObject

@property (nonatomic, assign) NSInteger start;
@property (nonatomic, assign) NSInteger length;

- (instancetype)initWithStart:(NSInteger)start length:(NSInteger)length;

@end

@interface YHTDateCalculate : NSObject

- (YHTDateScope *)getYearListWithMinDate:(NSDate *)minDate maxDate:(NSDate *)maxDate;
- (YHTDateScope *)getMonthListWithDate:(NSDate *)date;
- (YHTDateScope *)getDayListWithDate:(NSDate *)date;
- (YHTDateScope *)getHourListWithDate:(NSDate *)date;
- (YHTDateScope *)getMinuteListWithDate:(NSDate *)date;

@end
