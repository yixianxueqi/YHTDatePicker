//
//  ViewController.m
//  YHTDatePicker
//
//  Created by 君若见故 on 2017/6/9.
//  Copyright © 2017年 isoftstone. All rights reserved.
//

#import "ViewController.h"
#import "YHTDatePickViewController.h"
#import "DemoViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *alertTextField;
@property (weak, nonatomic) IBOutlet UITextField *presentTextField;

@property (nonatomic, strong) NSDate *minDate;
@property (nonatomic, strong) NSDate *maxDate;

@end

@implementation ViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = false;
    self.edgesForExtendedLayout = UIRectEdgeNone;

    //initialize
    self.minDate = [self getDateFromDateStr:@"2000-08-31 23:59"];
    self.maxDate = [self getDateFromDateStr:@"2020-12-30 00:00"];

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if([segue.identifier isEqualToString:@"push"]) {
        DemoViewController *demoVC = segue.destinationViewController;
        demoVC.hidesBottomBarWhenPushed = true;
    }
}

#pragma mark - click
// 弹窗选择时间
- (IBAction)clickPickDateAlert:(UIButton *)sender {

    YHTDatePickViewController *datePickVC = [[YHTDatePickViewController alloc] initWithTimeFormat:YHTDateType_Minute];
    __weak typeof(self) weakSelf = self;
    [datePickVC showType:YHTViewType_Alert parentViewController:self completion:^(NSDate *date) {

        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        format.dateFormat = @"yyyy-MM-dd HH:mm";
        NSString *dateStr = [format stringFromDate:date];
        NSLog(@"alertDatePick: %@",dateStr);
        weakSelf.alertTextField.text = dateStr;
    }];
}

//底部弹窗选择时间
- (IBAction)clickDatePresent:(UIButton *)sender {

    YHTDatePickViewController *datePickVC = [[YHTDatePickViewController alloc] initWithTimeFormat:YHTDateType_Day];
    //配置项
    datePickVC.minDate = self.minDate;
    datePickVC.maxDate = self.maxDate;
    datePickVC.tintColor = [UIColor orangeColor];

    __weak typeof(self) weakSelf = self;
    [datePickVC showType:YHTViewType_Present parentViewController:self completion:^(NSDate *date) {

        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        format.dateFormat = @"yyyy-MM-dd HH:mm";
        NSLog(@"presentDatePick: %@",[format stringFromDate:date]);
        NSString *dateStr = [format stringFromDate:date];
        weakSelf.presentTextField.text = dateStr;
    }];
}

#pragma mark - private


/**
 根据时间字符串获取NSDate对象

 @param dateStr 时间字符串
 @return NSDate
 */
- (NSDate *)getDateFromDateStr:(NSString *)dateStr {

    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"yyyy-MM-dd HH:mm";
    return [format dateFromString:dateStr];
}



@end
