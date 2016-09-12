//
//  BarChartView.m
//  BarChartTest
//
//  Created by ＊上海铭诺 on 16/2/29.
//  Copyright © 2016年 ＊上海铭诺. All rights reserved.
//

#import "BarChartView.h"
#import "UILabel+BarChartInit.h"
#define WidthView self.frame.size.width
#define HeightView self.frame.size.height
#define PI 3.14159265358979323846

@interface BarChartView (){
    CGFloat yBarCenterData;  // 柱状图y轴的中间值  3个
    CGFloat borderDis;  // 距离屏幕的左右是多少
    CGFloat barNumSpace; // y轴与柱状图之间的距离
    CGFloat barPerValue; // 柱状图每一分对应的数值
    CGFloat xBarSpace; // 柱状与x轴介绍之间的距离
    CGFloat barSpace; // 每个柱状图之间的间隙
    CGFloat dotRadius; // 折线图中点的半径
    UIColor *numColor; // 数字的颜色
    UIColor *lineColor; // 折线的颜色
    UIColor *barValueColor; // 柱状图值部分的颜色
    UIColor *barBackColor; // 柱状图无值部分的颜色
    UIFont *descFont; // 解释文字的字体
    int maxYCount;  // y轴最大显示多少位
}
@property (nonatomic, strong) NSMutableArray *yBarDataArray;

@end

@implementation BarChartView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        barWidth = 20;
        yDataWidth = 39;
        yDataHeight = 15;
        toolHeight = 40;
        barHeight = HeightView - toolHeight * 2 - 20;
        borderDis = 18;
        barNumSpace = 10;
        xBarSpace = 5;
        dotRadius = 3;
        numFont = [UIFont systemFontOfSize:10];
        numColor = [UIColor colorWithWhite:0.809 alpha:1.000];
        lineColor = [UIColor colorWithRed:0.384 green:0.783 blue:1.000 alpha:1.000];
        barValueColor = [UIColor colorWithRed:1.000 green:0.632 blue:0.120 alpha:1.000];
        barBackColor = [UIColor colorWithWhite:0.915 alpha:1.000];
        descFont = [UIFont systemFontOfSize:12];
        maxYCount = 5;
    }
    return self;
}

- (NSMutableArray *)yBarDataArray
{
    if (_yBarDataArray == nil) {
        _yBarDataArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _yBarDataArray;
}

- (void)drawRect:(CGRect)rect
{
    [self createBarChart];
}

// 创建柱状图
- (void)createBarChart
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self createY:LeftY]; // 创建左边的y轴
    [self drawEntiretyBarChart:context];
    
    [self createY:RightY];  // 创建右边的y轴 不能将其移到前面执行
    [self drawLines:context];
    
    [self createTopDescLabel:context];
}

// 画折线图
- (void)drawLines:(CGContextRef)context
{
    CGPoint linePoint[self.lineDataArray.count];
    for (int i = 0; i < self.lineDataArray.count; i ++) {
        CGPoint point = CGPointMake(borderDis + barNumSpace + yDataWidth + i * barWidth + i * barSpace + barWidth / 2, toolHeight + 10 + (yBarCenterData * 2 - [self.lineDataArray[i] floatValue]) * barPerValue);
        linePoint[i] = point;
        [self drawCircular:context andRadius:dotRadius andColor:lineColor andCenterPoint:point andStartAngle:0 andEndAngle:2 * PI andClockWise:NO];
    }
    
    CGContextSetStrokeColorWithColor(context, lineColor.CGColor);  // 填充线颜色
    CGContextSetLineWidth(context, 1);//斜线的宽度
    CGContextAddLines(context, linePoint, self.lineDataArray.count);//添加线  2 几个点
    CGContextDrawPath(context, kCGPathStroke); //根据坐标绘制路径
}

// 画圆
- (void)drawCircular:(CGContextRef)context andRadius:(CGFloat)radius andColor:(UIColor *)color andCenterPoint:(CGPoint)centerPoint andStartAngle:(CGFloat)startAngle andEndAngle:(CGFloat)endAngle andClockWise:(BOOL)clockWise
{
    CGContextSetFillColorWithColor(context, color.CGColor); // 填充颜色
    CGContextAddArc(context, centerPoint.x, centerPoint.y, radius, startAngle, endAngle, clockWise);  // 1 顺时针 0 逆时针
    CGContextDrawPath(context, kCGPathFill);//绘制填充
    CGContextDrawPath(context, kCGPathFillStroke); //绘制路径加填充
}

// 画整体柱状图
- (void)drawEntiretyBarChart:(CGContextRef)context
{
    barSpace = (WidthView - borderDis * 2 - yDataWidth * 2 - barNumSpace * 2 - self.barDataArray.count * barWidth) / (self.barDataArray.count - 1);
    for (int i = 0; i < self.barDataArray.count; i ++) {
        [self drawBarChart:context andFrame:CGRectMake(borderDis + barNumSpace + yDataWidth + i * barWidth + i * barSpace, toolHeight + 10, barWidth, barHeight) andColor:barBackColor];  // 画背景灰色柱状
        
        // 画数值柱状
        CGFloat valueHeight = barHeight - (yBarCenterData * 2 - [self.barDataArray[i] floatValue]) * barPerValue;
        [self drawBarChart:context andFrame:CGRectMake(borderDis + barNumSpace + yDataWidth + i * barWidth + i * barSpace, toolHeight + 10 + (yBarCenterData * 2 - [self.barDataArray[i] floatValue]) * barPerValue, barWidth, valueHeight) andColor:barValueColor];
        
        // 创建底部的label
        UILabel *xLabel = [[UILabel alloc] initWithFrame:CGRectMake(borderDis + barNumSpace + yDataWidth + i * barWidth + i * barSpace, barHeight + toolHeight + 10 + xBarSpace, yDataWidth, yDataHeight) textAlignment:NSTextAlignmentLeft font:numFont fontColor:numColor numberOfLine:1 string:self.barDescArray[i]];
        [self addSubview:xLabel];
    }

}

// 创建左边的y轴
- (void)createY:(YType)yType
{
    NSArray *array = [NSArray arrayWithArray:self.lineDataArray];
    NSTextAlignment textAlignment = NSTextAlignmentLeft;
    CGFloat yX = WidthView - borderDis - yDataWidth;
    if (yType == LeftY) {
        textAlignment = NSTextAlignmentRight;
        yX = borderDis;
        array = self.barDataArray;
    }
    [self processYdata:array andType:yType];
    
    CGFloat yDataDisc = (barHeight - self.yBarDataArray.count * yDataHeight + yDataHeight) / (self.yBarDataArray.count - 1);
    for (int i = 0; i < self.yBarDataArray.count; i ++) {
        UILabel *yLabel = [[UILabel alloc] initWithFrame:CGRectMake(yX, toolHeight + 10 - yDataHeight / 2 + i * yDataDisc + i * yDataHeight, yDataWidth, yDataHeight) textAlignment:textAlignment font:numFont fontColor:numColor numberOfLine:1 string:self.yBarDataArray[self.yBarDataArray.count - 1 - i]];
        [self addSubview:yLabel];
    }
    
}

// y轴数据的处理
- (void)processYdata:(NSArray *)dataArray andType:(YType)yType
{
    NSArray *dataBarSort = [self sortOfDataArray:dataArray];
    [self.yBarDataArray removeAllObjects];
    if ([dataBarSort[0] floatValue] < 0) {
        [self.yBarDataArray addObject:[[NSString stringWithFormat:@"%f", [dataBarSort[0] floatValue]] substringWithRange:NSMakeRange(0, maxYCount)]];
    }else [self.yBarDataArray addObject:[NSString stringWithFormat:@"0.00"]];

    yBarCenterData = ([dataBarSort[dataBarSort.count - 1] floatValue] + [dataBarSort[dataBarSort.count - 1] floatValue] / 9) / 2.0;
    
    [self.yBarDataArray addObject:[[NSString stringWithFormat:@"%f", yBarCenterData] substringWithRange:NSMakeRange(0, maxYCount)]];
    [self.yBarDataArray addObject:[[NSString stringWithFormat:@"%f", yBarCenterData * 2]substringWithRange:NSMakeRange(0, maxYCount)]];
    
    barPerValue = barHeight / ([self.yBarDataArray[self.yBarDataArray.count - 1] floatValue] - [self.yBarDataArray[0] floatValue]);
    
    if (yType == RightY) {
        NSMutableArray *rightY = [NSMutableArray arrayWithCapacity:0];
        for (int i= 0; i < self.yBarDataArray.count; i ++) {
            [rightY addObject:[NSString stringWithFormat:@"%@%%", self.yBarDataArray[i]]];
        }
        self.yBarDataArray = rightY;
    }
}

// 画柱状
- (void)drawBarChart:(CGContextRef)context andFrame:(CGRect)barFrame andColor:(UIColor *)barColor
{
    /*画矩形*/
    //矩形，并填弃颜色
    CGContextSetLineWidth(context, 0);//线的宽度
    CGContextSetFillColorWithColor(context, barColor.CGColor);//填充颜色
    CGContextAddRect(context,barFrame);//画方框
    CGContextDrawPath(context, kCGPathFillStroke);//绘画路径
}

// 创建顶上的介绍label
- (void)createTopDescLabel:(CGContextRef)context
{
    // 上部左边描述
    UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(borderDis + yDataWidth / 3 * 2, 10, [self lengthOfDesc:self.totalLeftStr], 20) textAlignment:NSTextAlignmentLeft font:descFont fontColor:numColor numberOfLine:1 string:self.totalLeftStr];
    [self addSubview:leftLabel];
    
    // 上部右边描述
    UILabel *rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(WidthView - borderDis - yDataWidth / 2 - [self lengthOfDesc:self.increaseRightStr], 10, [self lengthOfDesc:self.increaseRightStr], 20) textAlignment:NSTextAlignmentLeft font:descFont fontColor:numColor numberOfLine:1 string:self.increaseRightStr];
    [self addSubview:rightLabel];
    
    // 图例
    [self drawCircular:context andRadius:dotRadius andColor:barValueColor andCenterPoint:CGPointMake(borderDis + yDataWidth + barNumSpace, HeightView - 15) andStartAngle:0 andEndAngle:2 * PI andClockWise:NO];
    [self drawCircular:context andRadius:dotRadius andColor:lineColor andCenterPoint:CGPointMake(WidthView - borderDis - yDataWidth - barNumSpace - [self lengthOfDesc:self.lineExampleStr] - dotRadius * 2, HeightView - 15) andStartAngle:0 andEndAngle:2 * PI andClockWise:NO];
    
    UILabel *barExampleLabel = [[UILabel alloc] initWithFrame:CGRectMake(borderDis + yDataWidth + barNumSpace + dotRadius * 2, HeightView - 25, [self lengthOfDesc:self.barExampleStr], 20) textAlignment:NSTextAlignmentLeft font:descFont fontColor:numColor numberOfLine:1 string:self.barExampleStr];
    [self addSubview:barExampleLabel];
    
    UILabel *lineExampleLabel = [[UILabel alloc] initWithFrame:CGRectMake(WidthView - borderDis - yDataWidth - barNumSpace - [self lengthOfDesc:self.lineExampleStr] + dotRadius * 2 , HeightView - 25, [self lengthOfDesc:self.lineExampleStr], 20) textAlignment:NSTextAlignmentLeft font:descFont fontColor:numColor numberOfLine:1 string:self.lineExampleStr];
    [self addSubview:lineExampleLabel];
}

- (CGFloat)lengthOfDesc:(NSString *)string
{
    NSDictionary *dict = [NSDictionary dictionaryWithObject:descFont forKey:NSFontAttributeName];
    CGRect bounds = [string boundingRectWithSize:CGSizeMake(0, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    return bounds.size.width;
}

// 排序 从小到大
- (NSArray *)sortOfDataArray:(NSArray *)array
{
    NSMutableArray *sortBarArr = [NSMutableArray arrayWithArray:array];
    for (int i = 0; i < sortBarArr.count - 1; i ++) {
        for (int j = 0; j < sortBarArr.count - 1 - i; j ++) {
            if ([sortBarArr[j] floatValue] > [sortBarArr[j + 1] floatValue]) {
                [sortBarArr exchangeObjectAtIndex:j withObjectAtIndex:j + 1];
            }
        }
    }
    return sortBarArr;
}

@end
