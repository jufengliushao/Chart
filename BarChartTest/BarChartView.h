//
//  BarChartView.h
//  BarChartTest
//
//  Created by ＊上海铭诺 on 16/2/29.
//  Copyright © 2016年 ＊上海铭诺. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    LeftY = 0, // 左边y轴
    RightY,  // 右边y轴
}YType;

@interface BarChartView : UIView
{
    CGFloat barWidth; // 柱状图的宽度
    CGFloat barHeight; // 柱状图的高度
    CGFloat yDataWidth; // y轴数据的宽度
    CGFloat yDataHeight;  // y轴数据的高度
    CGFloat toolHeight;  // 顶部和底部的解释高度
    UIFont *numFont; // 数字的字体
}

@property (nonatomic, copy) NSString *barExampleStr; // 柱状图图标描述
@property (nonatomic, copy) NSString *lineExampleStr; // 折线图图标描述
@property (nonatomic, copy) NSString *totalLeftStr; // 上面左边描述
@property (nonatomic, copy) NSString *increaseRightStr; // 上面右边描述
@property (nonatomic, strong) NSArray *barDataArray;  // 柱状图的数据  number
@property (nonatomic, strong) NSArray *barDescArray; // 柱状图的描述  string
@property (nonatomic, strong) NSArray *lineDataArray; // 折线图的数据  number 百分比 不要 ％ 例如 12.3% 传入 12.3

@end
