//
//  NSFileManager+YTKit.h
//  YTKit
//
//  Created by HellowWorld on 2018/7/23.
//  Copyright © 2018年 YNTCode. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileManager (YTKit)

/**
 获取Cache文件夹缓存大小(Snapshots除外,没有权限获取)

 @return 文件夹总大小
 */
+ (NSString *)getCacheSize;


/**
 清除Cache文件夹缓存(Snapshots除外,没有权限获取)

 @return 是否清除成功
 */
+ (BOOL)clearCache;

/**
 计算指定路径下的文件大小

 @param path 指定路径
 @return 缓存大小
 */
+ (NSString *)getFileSizeWithFilePath:(NSString *)path;

/**
 删除指定路径下文件

 @param path 指定路径
 @return 是否删除成功
 */
+ (BOOL)clearFileWithFilePath:(NSString *)path;

/**
 计算WKWebView缓存大小

 @return 缓存大小
 */
+ (NSString *)getWKWebKitCacheSize;

/**
 清除WKWebview缓存

 @return 是否清除成功
 */
+ (BOOL)clearWKWebKitCache;

/**
 计算SDWebImage-default文件夹大小

 @return 文件夹大小
 */
+ (NSString *)getSDImageDefaultCacheSize;

/**
 清除SDWebImage缓存文件

 @return 是否清除成功
 */
+ (BOOL)clearSDImageDefaultCache;

/**
 创建文件夹

 @param path 路径
 @return 是否创建成功
 */
+ (BOOL)createFileWithPath:(NSString *)path;


/**
 创建文件

 @param path 路径
 @return 是否成功
 */
+ (BOOL)createRealFileAtPath:(NSString *)path;

/**
 保存文件

 @param fileName 文件名
 @return 是否存储成功
 */
+ (BOOL)saveFileToTempFilePath:(NSString *)fileName;


/**
 文件夹下是否存在文件

 @param path 文件夹路径
 @return 结果
 */
+ (BOOL)hasFileAtPath:(NSString *)path;



@end
