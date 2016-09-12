//
//  UILabel+BarChartInit.h
//  BarChartTest
//
//  Created by ＊上海铭诺 on 16/2/29.
//  Copyright © 2016年 ＊上海铭诺. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (BarChartInit)
- (instancetype)initWithFrame:(CGRect)frame textAlignment:(NSTextAlignment)textAlignment font:(UIFont *)font fontColor:(UIColor *)fontColor numberOfLine:(int)lines string:(NSString *)string;
@end
