//
//  YHTDateCalculate.h
//  DMTimePick
//
//  Created by 君若见故 on 2017/6/6.
//  Copyright © 2017年 isoftstone. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol YHTDateDataSource <NSObject>

@optional

- (NSArray *)getYearListWithDate:(NSDate *)date;
- (NSArray *)getMonthListWithDate:(NSDate *)date;
- (NSArray *)getDayListWithDate:(NSDate *)date;
- (NSArray *)getHourListWithDate:(NSDate *)date;
- (NSArray *)getMinuteListWithDate:(NSDate *)date;

@end

@interface YHTDateCalculate : NSObject<YHTDateDataSource>

@end
