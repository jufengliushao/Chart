//
//  UILabel+BarChartInit.m
//  BarChartTest
//
//  Created by ＊上海铭诺 on 16/2/29.
//  Copyright © 2016年 ＊上海铭诺. All rights reserved.
//

#import "UILabel+BarChartInit.h"

@implementation UILabel (BarChartInit)
- (instancetype)initWithFrame:(CGRect)frame textAlignment:(NSTextAlignment)textAlignment font:(UIFont *)font fontColor:(UIColor *)fontColor numberOfLine:(int)lines string:(NSString *)string
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.textAlignment = textAlignment;
        self.font = font;
        self.textColor = fontColor;
        self.numberOfLines = lines;
        self.text = string;
    }
    return self;
}
@end
