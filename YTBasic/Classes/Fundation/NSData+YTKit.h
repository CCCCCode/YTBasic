//
//  NSData+YTKit.h
//  YTKit
//
//  Created by HellowWorld on 2018/7/7.
//  Copyright © 2018年 YNTCode. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (YTKit)

#pragma mark -- 加密/解密类

/**
 md5加密

 @return 加密后的字符串
 */
- (NSString *)md5String;

/**
 md5加密

 @return 加密后的二进制数据
 */
- (NSData *)md5Data;


/**
 base64加密

 @return 加密后的字符串
 */
- (nullable NSString *)base64EncodedString;

/**
 base64解密

 @param base64EncodedString 加密后的字符串
 @return 解密后的数据
 */
+ (nullable NSData *)dataWithBase64EncodedString:(NSString *)base64EncodedString;

/**
 AES加密

 @param key key
 @param iv iv description
 @return 加密后的二进制数据
 */
- (NSData *)encryptedWithAESUsingKey:(NSString*)key andIV:(NSData*)iv;

/**
 AES解密

 @param key key
 @param iv iv
 @return 解密后的二进制数据
 */
- (NSData *)decryptedWithAESUsingKey:(NSString*)key andIV:(NSData*)iv;

@end
