//
//  UIFont+YTKit.m
//  YTKit
//
//  Created by HellowWorld on 2018/7/7.
//  Copyright © 2018年 YNTCode. All rights reserved.
//

#import "UIFont+YTKit.h"

@implementation UIFont (YTKit)
/**
 返回适配后的系统字体

 @param fontSize 字体大小
 @return 适配后的系统字体
 */
+ (UIFont *)scaleSystemFontOfSize:(CGFloat)fontSize
{
    fontSize = [self sizeForScaled:fontSize];
    return [UIFont systemFontOfSize:fontSize];
}

/**
 返回适配后的系统细体字体

 @param fontSize 字体大小
 @return 适配后的加粗字体
 */
+ (UIFont *)scaleLightFontOfSize:(CGFloat)fontSize
{
    fontSize = [self sizeForScaled:fontSize];
    return [UIFont fontWithName:([[[UIDevice currentDevice] systemVersion] doubleValue]) >= 9.0 ? @".SFUIText-Light" : @"HelveticaNeue-Light" size:fontSize];
}

/**
 返回适配后的系统粗体字体

 @param fontSize 字体大小
 @return 适配后的加粗字体
 */
+(UIFont *)scaleBoldFontSize:(CGFloat)fontSize
{
    fontSize  = [self sizeForScaled:fontSize];
    return [UIFont boldSystemFontOfSize:fontSize];
}

/**
 返回适配后的特定字体

 @param fontName 字体名
 @param fontSize 字体大小
 @return 适配后的特定字体
 */
+ (UIFont *)fontWithSpecificName:(NSString *)fontName size:(CGFloat)fontSize
{
    fontSize=[self sizeForScaled:fontSize];
    return [UIFont fontWithName:fontName size:fontSize];
}

/**
 返回适配之后的字体大小

 @param fontSize 原始字体大小
 @return 适配之后的字体大小
 */
+ (float)sizeForScaled:(CGFloat)fontSize{
    
    CGRect rect_screen = [[UIScreen mainScreen] bounds];
    CGSize size_screen = rect_screen.size;
    CGFloat scale_screen = [UIScreen mainScreen].scale;
    CGFloat screenWidth = size_screen.width * scale_screen;
    float _fontScale = 1.0f;
    if (UI_USER_INTERFACE_IDIOM() ==UIUserInterfaceIdiomPad) {
        _fontScale = 1.5f;
    }else if((int)screenWidth == 1242 && (int)screenWidth == 1125){
        _fontScale = 1.1f;
    }else if((int)screenWidth == 750){
        _fontScale = 1.0f;
    }else if((int)screenWidth < 750){
        _fontScale = screenWidth/750;
    }
    return _fontScale * fontSize;
}
@end
