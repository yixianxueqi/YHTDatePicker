//
//  YHTDatePickViewController.m
//  DMTimePick
//
//  Created by 君若见故 on 2017/6/6.
//  Copyright © 2017年 isoftstone. All rights reserved.
//

#import "YHTDatePickViewController.h"
#import "YHTDatePickViewController+YHTPickViewDelegate.h"

//一天的秒数
static NSTimeInterval const Day_Seconds = 86400;
//未来30年的天数
static NSTimeInterval const Default_Future_Year = 10957;
//视图比例
static CGFloat const scale = 0.8;

#ifndef kScreenSize
    #define kScreenSize [UIScreen mainScreen].bounds.size
#endif

#define RGBA(r,g,b,a) [UIColor colorWithRed:(r)/256.0 green:(g)/256.0 blue:(b)/256.0 alpha:(a)]

@interface YHTDatePickViewController ()
{
    //用设置标志位，判断协议是否实现可选的方法
    struct {
        unsigned int yearFlag         :1;
        unsigned int monthFlag        :1;
        unsigned int dayFlag          :1;
        unsigned int hourFlag         :1;
        unsigned int minuteFlag       :1;
    } _delegateFlags;
}
@property (nonatomic, strong) UIPickerView *pickView;
@property (nonatomic, assign) YHTDateType dateType;
@property (nonatomic, copy) void(^completionBlock)(NSDate *date);
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong, readwrite) id<YHTDateDataSource> delegate;

@end

@implementation YHTDatePickViewController


#pragma mark - life cycle

- (instancetype)initWithTimeFormat:(YHTDateType)type {

    self = [super init];
    if (!self) {
        return self;
    }
    self.dateType = type;
    self.timeZone = [NSTimeZone defaultTimeZone];
    self.minDate = [NSDate dateWithTimeIntervalSince1970:0];
    self.maxDate = [NSDate dateWithTimeIntervalSinceNow:Day_Seconds * Default_Future_Year];
    self.delegate = [[YHTDateCalculate alloc] init];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [[UIColor clearColor] colorWithAlphaComponent:0.3];
    [self.contentView addSubview:self.pickView];
    [self.view addSubview:self.contentView];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];

    //点击事件在时间选择器外，则退出选择
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self.view];
    if (!CGRectContainsPoint(self.contentView.frame, touchPoint)) {
        [self hide];
    }
    [self.nextResponder touchesBegan:touches withEvent:event];
}

- (void)dealloc {

    NSLog(@"%@ dealloc",NSStringFromClass([self class]));
}

#pragma mark - public

- (void)showType:(YHTViewType)type parentViewController:(UIViewController *)parentViewController completion:(void(^)(NSDate *date))completionBlock {

    [parentViewController addChildViewController:self];
    [self didMoveToParentViewController:parentViewController];
    [parentViewController.view addSubview:self.view];
    self.view.frame = parentViewController.view.bounds;

    self.completionBlock = completionBlock;
    if (type == YHTViewType_Alert) {
        [self alertShow];
    } else {
        [self presentShow];
    }
}

#pragma mark - private

/**
 弹窗展示
 */
- (void)alertShow {

    [self deployAlertContentView];
    self.pickView.frame = CGRectMake(0, 0, self.contentView.bounds.size.width, self.contentView.bounds.size.height * 0.77);
    UIButton *cancelBtn = [self quickGetButtonWith:@"取 消" color:[UIColor redColor] selector:@selector(cancelBtnClick:)];
    UIButton *chooseBtn = [self quickGetButtonWith:@"确 认" color:RGBA(28, 162, 248, 1) selector:@selector(chooseBtnClick:)];
    [self.contentView addSubview:cancelBtn];
    [self.contentView addSubview:chooseBtn];
    CGFloat btnHeight = self.contentView.bounds.size.height * (1 - scale);
    CGFloat btnWidth = self.contentView.bounds.size.width * 0.5;
    CGFloat btnY = self.contentView.bounds.size.height - btnHeight;
    cancelBtn.frame = CGRectMake(0, btnY, btnWidth, btnHeight);
    chooseBtn.frame = CGRectMake(btnWidth, btnY, btnWidth, btnHeight);
}


/**
 底部弹窗展示
 */
- (void)presentShow {

}


/**
 隐藏消失
 */
- (void)hide {

    NSLog(@"%s",__func__);
    [self willMoveToParentViewController:nil];
    [self removeFromParentViewController];
    [self.view removeFromSuperview];
}

/**
 取消按钮点击事件

 @param btn UIButton
 */
- (void)cancelBtnClick:(UIButton *)btn {

    NSLog(@"%s",__func__);
    [self hide];
}


/**
 选择按钮点击事件

 @param btn UIButton
 */
- (void)chooseBtnClick:(UIButton *)btn {

    NSLog(@"%s",__func__);
}


/**
 设置视图容器
 */
- (void)deployAlertContentView {

    CGPoint parentCenter = self.parentViewController.view.center;
    CGPoint center = CGPointMake(parentCenter.x, parentCenter.y);
    CGFloat width = kScreenSize.width * scale;
    CGFloat height = width * scale;
    self.contentView.bounds = CGRectMake(0, 0, width, height);
    self.contentView.center = center;
    //设圆角，contentView只有左上和右上为圆角，其它为直角
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.contentView.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
    shapeLayer.frame = self.contentView.bounds;
    shapeLayer.path = path.CGPath;
    self.contentView.layer.mask = shapeLayer;

}

#pragma mark - tool
/**
 快速生成按钮

 @param title 标题
 @param color 背景色
 @param selector 响应方法
 @return UIButton
 */
- (UIButton *)quickGetButtonWith:(NSString *)title color:(UIColor *)color selector:(SEL)selector {

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setBackgroundColor:color];
    [btn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

#pragma mark - getter/setter

- (UIPickerView *)pickView {

    if (!_pickView) {
        _pickView = [[UIPickerView alloc] init];
        _pickView.delegate = self;
        _pickView.dataSource = self;
    }
    return _pickView;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor whiteColor];
    }
    return _contentView;
}

- (void)setDelegate:(id<YHTDateDataSource>)delegate {

    _delegate = delegate;
    //协议实现情况判断
    _delegateFlags.yearFlag = [delegate respondsToSelector:@selector(getYearListWithDate:)];
    _delegateFlags.monthFlag = [delegate respondsToSelector:@selector(getMonthListWithDate:)];
    _delegateFlags.dayFlag = [delegate respondsToSelector:@selector(getDayListWithDate:)];
    _delegateFlags.hourFlag = [delegate respondsToSelector:@selector(getHourListWithDate:)];
    _delegateFlags.minuteFlag = [delegate respondsToSelector:@selector(getMinuteListWithDate:)];
}

@end
