//
//  ViewController.m
//  lineTest
//
//  Created by ＊上海铭诺 on 16/2/26.
//  Copyright © 2016年 ＊上海铭诺. All rights reserved.
//

#import "ViewController.h"
#import "TestView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    TestView *view = [[TestView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height)];
    view.backgroundColor = [UIColor whiteColor];
    view.centerPoint = CGPointMake(200, 200);
    view.radius = 60;
    view.dataArray = @[@25, @25, @26, @24];
    view.colorArray = @[[UIColor colorWithRed:1.000 green:0.351 blue:0.373 alpha:1.000], [UIColor colorWithRed:1.000 green:0.580 blue:0.090 alpha:1.000], [UIColor colorWithRed:0.056 green:0.679 blue:0.024 alpha:1.000], [UIColor colorWithRed:0.046 green:1.000 blue:0.160 alpha:0.807], [UIColor grayColor]];
    view.descArray = @[@"主力流入", @"散户流入", @"主力流出", @"散户流出", @"test"];
    view.themeStr = @"今日资金";
    [self.view addSubview:view];
       
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
