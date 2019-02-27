//
//  NSString+YTKit.h
//  YTKit
//
//  Created by HellowWorld on 2018/7/7.
//  Copyright © 2018年 YNTCode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (YTKit)

#pragma mark -- 加密/解密类

/**
 md5加密

 @return 加密后的字符串
 */
- (nullable NSString *)md5String;

/**
 base64加密
 
 @return 加密后的字符串
 */
- (nullable NSString *)base64EncodedString;

/**
 base64 解密

 @param base64EncodedString 加密的字符串
 @return 解密后的字符串
 */
+ (nullable NSString *)stringWithBase64EncodedString:(NSString *)base64EncodedString;

/**
 AES加密

 @param key key 长度一般为16（AES算法所能支持的密钥长度可以为128,192,256位（也即16，24，32个字节））
 @param iv iv
 @return 加密后的字符串
 */
- (NSString*)encryptedWithAESUsingKey:(NSString*)key andIV:(NSData*)iv;

/**
 AES解密

 @param key key
 @param iv iv
 @return 解密后的字符串
 */
- (NSString*)decryptedWithAESUsingKey:(NSString*)key andIV:(NSData*)iv;

/**
 url encode

 @return encode之后字符串
 */
- (NSString *)stringByURLEncode;

/**
 url decode
 
 @return decode之后字符串
 */
- (NSString *)stringByURLDecode;

#pragma mark -- 校验类

/**
 nil 或者 length = 0

 @return YES :为空 NO: 不为空
 */
- (BOOL)isEmpty;

/**
 是否为电话号码

 @return 结果
 */
- (BOOL)isValidPhoneNumber;

/**
 是否是身份证号

 @return 结果
 */
- (BOOL)isValidIdentify;

/**
 是否是邮箱账号
 
 @return 结果
 */
- (BOOL)isValidEmail;

/**
 是否是车牌号
 
 @return 结果
 */
- (BOOL)isValidCarNumber;

/**
 是否是银行卡号
 
 @return 结果
 */
- (BOOL)isValidBankCard;

/**
 是否是邮政编码
 
 @return 结果
 */
- (BOOL)isValidPostalCode;

/**
 是否是链接
 
 @return 结果
 */
- (BOOL)isValidUrl;

/**
 是否全是数字
 
 @return 结果
 */
- (BOOL)isOnlyNumber;

/**
 是否包含数字

 @return 结果
 */
- (BOOL)isContainNumber;

/**
 是否全是中文
 
 @return 结果
 */
- (BOOL)isOnlyChinese;

/**
 是否包含空格
 
 @return 结果
 */
- (BOOL)isContainBlank;

/**
 是否包含中文
 
 @return 结果
 */
- (BOOL)isIncludeChinese;

#pragma mark -- 工具类
/**
 返回一个毫秒级时间戳,例:1443066826371

 @return 时间戳
 */
+ (NSString *)timestamp;

/**
 去除空格

 @return 去除空格后的字符串
 */
- (NSString *)trimmingWhitespace;

/**
 计算字符串尺寸

 @param font 字体
 @param size 显示范围
 @param lineBreakMode 分行模式
 @return 尺寸
 */
- (CGSize)sizeForFont:(UIFont *)font size:(CGSize)size mode:(NSLineBreakMode)lineBreakMode;

/**
 计算字符串长度

 @param font 字体
 @return 长度
 */
- (CGFloat)widthForFont:(UIFont *)font;


/**
 反转字符串

 @param strSrc 被反转字符串
 @return 反转后字符串
 */
+ (NSString *)everseString:(NSString *)strSrc;

/**
 隐藏手机号中间4位

 @param account 手机号
 @return string
 */
+ (NSString *)hideMiddleFourDigitsOfPhoneNumberWithAccount:(NSString *)account;


@end
