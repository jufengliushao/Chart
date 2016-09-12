//
//  TestView.h
//  lineTest
//
//  Created by ＊上海铭诺 on 16/2/26.
//  Copyright © 2016年 ＊上海铭诺. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    AngleArray,
    DrawArray,
}ArrayType;

@interface TestView : UIView{
    CGFloat ringWith; // 颜色圆环的宽度
    CGFloat lightRingBigWith; // 最大灰色圆环的宽度
    CGFloat lightRingSmallWidth; // 最小的灰色的圆环宽度
    CGFloat spacing; // 说明线斜线断间距
    CGFloat lineLength; // 说明横线的长度
    CGFloat descWidth; // 描述文字label的宽度
    CGFloat descHeight; // 描述文字label的高度
    CGFloat themeWidth; // 主题label的宽度
    CGFloat themeHeight; // 主题label的高度
    UIFont *descFont;  // 描述文字的字体
    UIFont *themeFont;  // 主题的字体
}

@property (nonatomic, strong) NSMutableArray *startPointArr; // 每个扇形的中心点
@property (nonatomic, strong) NSArray *colorArray; // 颜色数组
@property (nonatomic, strong) NSArray *dataArray;  // 数据数组
@property (nonatomic, strong) NSArray *descArray; // 介绍数组
@property (nonatomic, assign) CGFloat radius; // 半径
@property (nonatomic, assign) CGPoint centerPoint;  // 圆心坐标
@property (nonatomic, strong) NSString *themeStr; // 圆心中的主题

@end
