//
//  UIColor+YTKit.h
//  YTKit
//
//  Created by HellowWorld on 2018/7/7.
//  Copyright © 2018年 YNTCode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (YTKit)

/**
 生成随机颜色

 @return 随机颜色
 */
+ (UIColor *)randomColor;

/**
 32位色值转UIColor

 @param hex 色值
 @return 转换之后的UIColor
 */
+ (UIColor *)colorWithHex:(UInt32)hex;

/**
 32位色值转UIColor

 @param hex 色值
 @param alpha 透明度
 @return 转换之后的UIColor
 */
+ (UIColor *)colorWithHex:(UInt32)hex andAlpha:(CGFloat)alpha;

/**
 32位颜色字符串转UIColor

 @param hexString 颜色字符串
 @return 转换之后的UIColor
 */
+ (UIColor *)colorWithHexString:(NSString *)hexString;

/**
 32位颜色字符串转UIColor

 @param hexString 颜色字符串
 @param alpha 透明度
 @return 转换之后的UIColor
 */
+ (UIColor *)colorWithHexString:(NSString *)hexString andAlpha:(CGFloat)alpha;

@end
