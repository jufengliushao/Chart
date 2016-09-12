//
//  RootViewController.m
//  BarChartTest
//
//  Created by ＊上海铭诺 on 16/2/29.
//  Copyright © 2016年 ＊上海铭诺. All rights reserved.
//

#import "RootViewController.h"
#import "BarChartView.h"
@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    BarChartView *barView = [[BarChartView alloc] initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, 220)];
    barView.backgroundColor = [UIColor whiteColor];
    barView.barDataArray = @[@15, @15.2, @48, @26, @50];
    barView.barDescArray = @[@"2010", @"2011", @"2012", @"2013", @"2014"];
    barView.lineDataArray = @[@-38, @47.5, @60.8, @117.42, @14.2];
    barView.totalLeftStr = @"12.36亿元";
    barView.increaseRightStr = @"同比增长率60.00%";
    barView.lineExampleStr = @"同比增长%";
    barView.barExampleStr = @"营业收入";
    [self.view addSubview:barView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
