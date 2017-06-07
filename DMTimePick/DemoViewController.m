//
//  DemoViewController.m
//  DMTimePick
//
//  Created by 君若见故 on 2017/6/7.
//  Copyright © 2017年 isoftstone. All rights reserved.
//

#import "DemoViewController.h"
#import "YHTDatePickViewController.h"

@interface DemoViewController ()

@property (weak, nonatomic) IBOutlet UITextField *alertTextField;
@property (weak, nonatomic) IBOutlet UITextField *presentTextField;


@end

@implementation DemoViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = false;
    self.edgesForExtendedLayout = UIRectEdgeNone;
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

    YHTDatePickViewController *datePickVC = [[YHTDatePickViewController alloc] initWithTimeFormat:YHTDateType_Minute];
    __weak typeof(self) weakSelf = self;
    [datePickVC showType:YHTViewType_Present parentViewController:self completion:^(NSDate *date) {

        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        format.dateFormat = @"yyyy-MM-dd HH:mm";
        NSLog(@"presentDatePick: %@",[format stringFromDate:date]);
        NSString *dateStr = [format stringFromDate:date];
        weakSelf.presentTextField.text = dateStr;
    }];
}


@end
