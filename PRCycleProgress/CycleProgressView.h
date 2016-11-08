//
//  CycleProgress.h
//  PRCycleProgress
//
//  Created by weixu on 16/11/4.
//  Copyright © 2016年 weixu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CycleProgressView : UIView
@property (nonatomic, assign) BOOL showText ;   //用来控制是否显示中间的百分比文字

@property (nonatomic, strong) UIColor *textColor ; //用来显示字体的颜色，默认为黑色
@property (nonatomic, strong) UIFont *textfont ;   //设置字体的颜色，当给的文字过大，以能显示下的最大的值，为正确显示的值

@property (nonatomic, strong) UIColor *progressFillColor ;  // 圆形进度条的颜色，默认为黑色。
@property (nonatomic, assign) BOOL isGradual ;  //是否进行渐变，下面的的两个颜色，就是进行渐变的颜色
@property (nonatomic, strong) UIColor *progressTopGradientColor ;  //顶部的颜色
@property (nonatomic, strong) UIColor *progressBottomGradientColor ; // 底部的颜色
@property (nonatomic, assign) CGFloat circleWidth; //设置进度条的宽度，默认为4px
@property (nonatomic, assign) CGFloat beginAngle;  //开始的起点的角度，单位为度，默认为-90度
@property (nonatomic, assign) BOOL clockwise; // 用来设置，进度的方向，当设置为yes时，顺时针，No为逆时针，默认为yes

// 取值范围为0~1，1代表100%
- (void)setProgressRatio:(CGFloat)aProgress;
@end
