//
//  ViewController.m
//  DMTimePick
//
//  Created by 君若见故 on 2017/6/6.
//  Copyright © 2017年 isoftstone. All rights reserved.
//

#import "ViewController.h"
#import "YHTDatePickViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = false;
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (IBAction)clickPickDate:(UIButton *)sender {

    YHTDatePickViewController *datePickVC = [[YHTDatePickViewController alloc] initWithTimeFormat:YHTDateType_Minute];
//    [datePickVC showType:YHTViewType_Alert parentViewController:self completion:^(NSDate *date) {
//
//        NSDateFormatter *format = [[NSDateFormatter alloc] init];
//        format.dateFormat = @"yyyy-MM-dd HH:mm";
//        NSLog(@"%@",[format stringFromDate:date]);
//    }];
    [datePickVC showType:YHTViewType_Present parentViewController:self completion:^(NSDate *date) {

        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        format.dateFormat = @"yyyy-MM-dd HH:mm";
        NSLog(@"%@",[format stringFromDate:date]);
    }];

}

@end
