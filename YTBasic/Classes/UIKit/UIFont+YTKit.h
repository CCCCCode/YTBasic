//
//  UIFont+YTKit.h
//  YTKit
//
//  Created by HellowWorld on 2018/7/7.
//  Copyright © 2018年 YNTCode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (YTKit)

/**
 返回适配后的系统字体

 @param fontSize 字体大小
 @return 适配后的系统字体
 */
+ (UIFont *)scaleSystemFontOfSize:(CGFloat)fontSize;

/**
 返回适配后的系统细体字体

 @param fontSize 字体大小
 @return 适配后的细体字体
 */
+ (UIFont *)scaleLightFontOfSize:(CGFloat)fontSize;

/**
 返回适配后的系统粗体字体

 @param fontSize 字体大小
 @return 适配后的加粗字体
 */
+ (UIFont *)scaleBoldFontSize:(CGFloat)fontSize;

/**
 返回适配之后的字体大小

 @param fontSize 原始字体大小
 @return 适配之后的字体大小
 */
+ (float)sizeForScaled:(CGFloat)fontSize;

/**
 返回适配后的特定字体

 @param fontName 字体名
 @param fontSize 字体大小
 @return 适配后的特定字体
 */
+ (UIFont *)fontWithSpecificName:(NSString *)fontName size:(CGFloat)fontSize;

@end
