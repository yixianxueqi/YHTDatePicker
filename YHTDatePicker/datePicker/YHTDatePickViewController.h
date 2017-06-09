//
//  YHTDatePickViewController.h
//  DMTimePick
//
//  Created by 君若见故 on 2017/6/6.
//  Copyright © 2017年 isoftstone. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 日期选择精度

 - YHTDateType_Year: 精确到年
 - YHTDateType_Month: 精确到月
 - YHTDateType_Day: 精确到日
 - YHTDateType_Hour: 精确到时
 - YHTDateType_Minute: 精确到分
 */
typedef NS_ENUM(NSUInteger, YHTDateType) {

    YHTDateType_Year = 1,
    YHTDateType_Month,
    YHTDateType_Day,
    YHTDateType_Hour,
    YHTDateType_Minute
};


/**
  弹窗方式

 - YHTViewType_Alert: 视图中央弹窗方法
 - YHTViewType_Present: 底部弹出方式
 */
typedef NS_ENUM(NSUInteger, YHTViewType) {

    YHTViewType_Alert = 1,
    YHTViewType_Present = 2
};

@interface YHTDatePickViewController : UIViewController

//时区
@property (nonatomic, strong) NSTimeZone *timeZone;
//最小选择时间，不设置则最小1970年
@property (nonatomic, strong) NSDate *minDate;
//最大选择时间，不设置则当今年份+30年
@property (nonatomic, strong) NSDate *maxDate;
//设置当前选择的默认时间，不设则默认此刻, 满足大于等于最小时间&&小于等于最大时间
@property (nonatomic, strong) NSDate *currentDate;
//设置日期选项颜色
@property (nonatomic, strong) UIColor *tintColor;

/**
 禁用掉默认的初始化方法

 @return nil
 */
- (instancetype)init __attribute__((unavailable("init方法不可用，请用initWithTimeFormat:")));

/**
 初始化控制器

 @param type 设置时间精度
 @return YHTDatePickViewController
 */
- (instancetype)initWithTimeFormat:(YHTDateType)type;


/**
 展示时间选择器，完成时间选择返回NSDate对象

 @param type 选择视图展示方式
 @param parentViewController 展示的父视图
 @param completionBlock 完成回调
 */
- (void)showType:(YHTViewType)type parentViewController:(UIViewController *)parentViewController completion:(void(^)(NSDate *date))completionBlock;

@end
