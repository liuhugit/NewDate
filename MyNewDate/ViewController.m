//
//  ViewController.m
//  rili
//
//  Created by 刘虎 on 16/7/13.
//  Copyright © 2016年 刘虎. All rights reserved.
//

#import "ViewController.h"
#import "MyDateView.h"
@interface ViewController ()



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:213/255.0f green:177/255.0f blue:172/255.f alpha:1];
    MyDateView *my = [[MyDateView alloc]initWithFrame:self.view.bounds];
    my.backgroundColor = [UIColor colorWithRed:32/255.0f green:196/255.0f blue:138/255.f alpha:1];
    my.today = [NSDate date];
    my.date = my.today;
    [self.view addSubview:my];
}



@end







































