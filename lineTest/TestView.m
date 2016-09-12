//
//  TestView.m
//  lineTest
//
//  Created by ＊上海铭诺 on 16/2/26.
//  Copyright © 2016年 ＊上海铭诺. All rights reserved.
//

#import "TestView.h"
#import <math.h>
#define PI 3.14159265358979323846

@implementation TestView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        ringWith = 5;
        lightRingBigWith = 3;
        lightRingSmallWidth = 3;
        spacing = 10;
        lineLength = 30;
        descFont = [UIFont systemFontOfSize:12];
        descWidth = 80;
        descHeight = 13;
        themeFont = [UIFont systemFontOfSize:15];
        themeWidth = 40;
        themeHeight = 40;
    }
    return self;
}

- (NSMutableArray *)startPointArr
{
    if (_startPointArr == nil) {
        _startPointArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _startPointArr;
}

-(void)drawRect:(CGRect)rect{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawCircular:context andRadius:self.radius + lightRingBigWith andColor:[UIColor colorWithWhite:0.871 alpha:1.000] andCenterPoint:self.centerPoint andStartAngle:0 andEndAngle:2 * PI andClockWise:YES];
    
    // 绘制扇形
    NSArray *drawArr = [self percentageOfData:self.dataArray andType:DrawArray];
    NSArray *angleArr = [self percentageOfData:self.dataArray andType:AngleArray];
    for (int i = 0; i < drawArr.count; i ++) {
        CGContextRef contextS = UIGraphicsGetCurrentContext();
        [self drawSector:contextS andRadius:self.radius andColor:self.colorArray[i] andCenterPoint:self.centerPoint andStartAngle:[drawArr[i] floatValue] andEndAngle:[angleArr[i] floatValue] + [drawArr[i] floatValue]  andClockWise:NO];
        [self.startPointArr addObject:[NSValue valueWithCGPoint:[self calculationOfStartPoint:[drawArr[i] floatValue] andEndAngle:[angleArr[i] floatValue] + [drawArr[i] floatValue] andCenterPoint:self.centerPoint andRadius:self.radius + lightRingBigWith]]];
    }
    // 绘制小的灰色圆
   [self drawCircular:context andRadius:self.radius - ringWith andColor:[UIColor colorWithWhite:0.871 alpha:1.000] andCenterPoint:self.centerPoint andStartAngle:0 andEndAngle:2 * PI andClockWise:YES];
    
    // 绘制白色的圆
    [self drawCircular:context andRadius:self.radius - lightRingSmallWidth - ringWith andColor:[UIColor whiteColor] andCenterPoint:self.centerPoint andStartAngle:0 andEndAngle:2 * PI andClockWise:YES];
    
    [self drawDescLine:context]; // 画线
    
    [self createTheme];  // 创建themelabel
}

- (NSArray *)percentageOfData:(NSArray *)array andType:(ArrayType)arrayType
{
    float sum = 0;
    float angleSum = 0;
    for (int i = 0; i < array.count; i ++) {
        sum += [array[i] floatValue];
    }
    NSMutableArray *angleArray = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray *drawArray = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < array.count; i ++) {
        float angle = [array[i] floatValue] / sum * 2 * PI;
        [angleArray addObject:[NSNumber numberWithFloat:angle]];
        [drawArray addObject:[NSNumber numberWithFloat:angleSum]];
        angleSum += angle;
    }
    if (arrayType == DrawArray) {
        return drawArray;
    }
    else return angleArray;
}

// 画圆
- (void)drawCircular:(CGContextRef)context andRadius:(CGFloat)radius andColor:(UIColor *)color andCenterPoint:(CGPoint)centerPoint andStartAngle:(CGFloat)startAngle andEndAngle:(CGFloat)endAngle andClockWise:(BOOL)clockWise
{
    CGContextSetFillColorWithColor(context, color.CGColor); // 填充颜色
    CGContextAddArc(context, centerPoint.x, centerPoint.y, radius, startAngle, endAngle, clockWise);  // 1 顺时针 0 逆时针
    CGContextDrawPath(context, kCGPathFill);//绘制填充
    CGContextDrawPath(context, kCGPathFillStroke); //绘制路径加填充
}

// 画扇形
- (void)drawSector:(CGContextRef)context andRadius:(CGFloat)radius andColor:(UIColor *)color andCenterPoint:(CGPoint)centerPoint andStartAngle:(CGFloat)startAngle andEndAngle:(CGFloat)endAngle andClockWise:(BOOL)clockWise
{
    CGContextMoveToPoint(context, centerPoint.x, centerPoint.y);
    CGContextAddArc(context, centerPoint.x, centerPoint.y, radius, startAngle, endAngle, clockWise);
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFill);//绘制填充
}

// 计算线条的起始点
- (CGPoint)calculationOfStartPoint:(CGFloat)startAngle andEndAngle:(CGFloat)endAngle andCenterPoint:(CGPoint)centerPoint andRadius:(CGFloat)radius
{
    CGPoint resultPoint;
    CGFloat currentAngle = (endAngle - startAngle) / 2.0;
    if (currentAngle - PI / 2 > 0) {
        currentAngle = PI - currentAngle;
    }
    NSLog(@"");
    CGFloat centerAngle =  - (startAngle + endAngle) / 2;
    if (centerAngle >= - PI / 2) {
        resultPoint.x = cos(centerAngle) * radius + centerPoint.x;
        resultPoint.y = - sin(centerAngle) * radius + centerPoint.y;
    }
    else if (centerAngle > - PI){
        resultPoint.x = centerPoint.x + cos(centerAngle) * radius;
        resultPoint.y = - sin(centerAngle) * radius + centerPoint.y;
    }
    else if (centerAngle > - PI * 1.5){
        resultPoint.x = centerPoint.x + cos(centerAngle) * radius;
        resultPoint.y = centerPoint.y - sin(centerAngle) * radius;
    }
    else{
        resultPoint.x = cos(centerAngle) * radius + centerPoint.x;
        resultPoint.y = centerPoint.y - sin(centerAngle) * radius;
    }
    return resultPoint;
}

// 画线
- (void)drawDescLine:(CGContextRef)context
{
    CGPoint linePoint[2]; // 细线的坐标
    CGPoint transversePoint[2]; // 横线的坐标
    
    NSArray *drawArr = [self percentageOfData:self.dataArray andType:DrawArray];
    NSArray *angleArr = [self percentageOfData:self.dataArray andType:AngleArray];
    
    for (int i = 0; i < self.startPointArr.count; i ++) {
        CGFloat centerAngle =  - ([drawArr[i] floatValue] + [angleArr[i] floatValue] + [drawArr[i] floatValue]) / 2;
        linePoint[0] = [self.startPointArr[i] CGPointValue];
        CGRect labelRect = CGRectZero;
        NSTextAlignment textAlignment = NSTextAlignmentLeft;
        NSMutableAttributedString *descStr = [[NSMutableAttributedString alloc] initWithString:@""];
        NSString *percentageData = [NSString stringWithFormat:@" %.0f%%", ([angleArr[i] floatValue] / (2 * PI)) * 100]; // 百分比数值
        descStr = [[NSMutableAttributedString alloc] initWithString:[self.descArray[i] stringByAppendingString:percentageData]]; // 拼接字符串
        [descStr addAttribute:NSForegroundColorAttributeName value:self.colorArray[i] range:NSMakeRange(descStr.length - percentageData.length, percentageData.length)]; // 设置百分比颜色
        [descStr addAttribute:NSFontAttributeName value:descFont range:NSMakeRange(0, descStr.length)];
        if (linePoint[0].x <= self.centerPoint.x && linePoint[0].y <= self.centerPoint.y) {
            linePoint[1] = CGPointMake(linePoint[0].x + spacing * cos(centerAngle), linePoint[0].y - spacing * sin(centerAngle));
            transversePoint[1] = CGPointMake(linePoint[1].x - lineLength, linePoint[1].y);
            
            labelRect = CGRectMake(transversePoint[1].x - descWidth, transversePoint[1].y, descWidth, descHeight);  // label frame
            textAlignment = NSTextAlignmentRight;  // 右对齐
        }else if (linePoint[0].x > self.centerPoint.x && linePoint[0].y < self.centerPoint.y){
            linePoint[1] = CGPointMake(linePoint[0].x + spacing * cos(centerAngle), linePoint[0].y - spacing * sin(centerAngle));
            transversePoint[1] = CGPointMake(linePoint[1].x + lineLength, linePoint[1].y);
        
            labelRect = CGRectMake(transversePoint[1].x, transversePoint[1].y, descWidth, descHeight);  // label frame
            textAlignment = NSTextAlignmentLeft;  // 左对齐
            
        }else if (linePoint[0].x < self.centerPoint.x && linePoint[0].y > self.centerPoint.y){
            linePoint[1] = CGPointMake(linePoint[0].x + spacing * cos(centerAngle), linePoint[0].y - spacing * sin(centerAngle));
            transversePoint[1] = CGPointMake(linePoint[1].x - lineLength, linePoint[1].y);
            
            labelRect = CGRectMake(transversePoint[1].x - descWidth, transversePoint[1].y - descHeight / 2, descWidth, descHeight);  // label frame
            textAlignment = NSTextAlignmentRight;  // 右对齐
            
        }else{
            linePoint[1] = CGPointMake(linePoint[0].x + spacing * cos(centerAngle), linePoint[0].y - spacing * sin(centerAngle));
            transversePoint[1] = CGPointMake(linePoint[1].x + lineLength, linePoint[1].y);
            
            labelRect = CGRectMake(transversePoint[1].x, transversePoint[1].y - descHeight / 2, descWidth, descHeight);  // label frame
            textAlignment = NSTextAlignmentLeft;  // 左对齐
            
        }
        
        transversePoint[0] = linePoint[1];
        
        
        CGContextSetFillColorWithColor(context, [self.colorArray[i] CGColor]);//填充内容颜色
        CGContextSetStrokeColorWithColor(context, [self.colorArray[i] CGColor]);  // 填充线颜色
        CGContextSetLineWidth(context, 0.5);//斜线的宽度
        CGContextAddLines(context, linePoint, 2);//添加线  2 几个点
        CGContextDrawPath(context, kCGPathStroke); //根据坐标绘制路径
        
        CGContextSetLineWidth(context, 1.0);//横线的宽度
        CGContextAddLines(context, transversePoint, 2);//添加线  2 几个点
        CGContextDrawPath(context, kCGPathStroke); //根据坐标绘制路径
        
        UILabel *descLabel = [[UILabel alloc] initWithFrame:labelRect];
        descLabel.textAlignment = textAlignment;
        descLabel.frame = labelRect;
        descLabel.attributedText = descStr;
        [self addSubview:descLabel];
        
    }
    
}

- (void)createTheme
{
    UILabel *themeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.centerPoint.x - themeWidth / 2, self.centerPoint.y - themeHeight / 2, themeWidth, themeHeight)];
    themeLabel.font = themeFont;
    themeLabel.numberOfLines = 2;
    themeLabel.text = self.themeStr;
    [self addSubview:themeLabel];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
