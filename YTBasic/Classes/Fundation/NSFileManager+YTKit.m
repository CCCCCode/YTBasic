//
//  NSFileManager+YTKit.m
//  YTKit
//
//  Created by HellowWorld on 2018/7/23.
//  Copyright © 2018年 YNTCode. All rights reserved.
//

#import "NSFileManager+YTKit.h"

@implementation NSFileManager (YTKit)
/**
 获取Cache文件夹缓存大小(Snapshots除外,没有权限获取)
 
 @return 文件夹总大小
 */
+ (NSString *)getCacheSize
{
    NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString *totleSize = [NSFileManager getFileSizeWithFilePath:cachesPath];
    return totleSize;
}

/**
 清除缓存(Snapshots除外,没有权限获取)
 
 @return 是否清除成功
 */
+ (BOOL)clearCache
{
    NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    BOOL isAlreadyClearCache = [NSFileManager clearFileWithFilePath:cachesPath];
    return isAlreadyClearCache;
}

/**
 计算指定路径下的缓存大小
 
 @param path 指定路径
 @return 缓存大小
 */
+ (NSString *)getFileSizeWithFilePath:(NSString *)path
{
    // 获取“path”文件夹下的所有文件
    NSArray *subPathArr = [[NSFileManager defaultManager] subpathsAtPath:path];
    NSString *filePath  = nil;
    NSInteger totleSize = 0;
    for (NSString *subPath in subPathArr){
        // 0. 把Snapshots文件夹过滤掉,没有访问权限,否则删除时操过200M会失败!!!!!!!!
        if (![subPath containsString:@"Snapshots"]) {
            // 1. 拼接每一个文件的全路径
            filePath =[path stringByAppendingPathComponent:subPath];
        }
        // 2. 是否是文件夹，默认不是
        BOOL isDirectory = NO;
        // 3. 判断文件是否存在
        BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDirectory];
        // 4. 以上判断目的是忽略不需要计算的文件
        if (!isExist || isDirectory || [filePath containsString:@".DS"]){
            // 过滤: 1. 文件夹不存在  2. 过滤文件夹  3. 隐藏文件
            continue;
        }
        // 5. 指定路径，获取这个路径的属性
        NSDictionary *dict = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
        /**
         attributesOfItemAtPath: 文件夹路径
         该方法只能获取文件的属性, 无法获取文件夹属性, 所以也是需要遍历文件夹的每一个文件的原因
         */
        // 6. 获取每一个文件的大小
        NSInteger size = [dict[@"NSFileSize"] integerValue];
        // 7. 计算总大小
        totleSize += size;
    }
    
    //8. 将文件夹大小转换为 M/KB/B
    NSString *totleStr = nil;
    if (totleSize > 1000 * 1000){
        totleStr = [NSString stringWithFormat:@"%.2fM",totleSize / 1000.00f /1000.00f];
    }else if (totleSize > 1000){
        totleStr = [NSString stringWithFormat:@"%.2fKB",totleSize / 1000.00f ];
    }else{
        totleStr = [NSString stringWithFormat:@"%.2fB",totleSize / 1.00f];
    }
    return totleStr;
}

/**
 删除指定路径下文件
 
 @param path 指定路径
 @return 是否删除成功
 */
+ (BOOL)clearFileWithFilePath:(NSString *)path
{
    //拿到path路径的下一级目录的子文件夹
    NSArray *subPathArr = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
    NSString *filePath = nil;
    NSError *error = nil;
    for (NSString *subPath in subPathArr) {
        filePath = [path stringByAppendingPathComponent:subPath];
        if (![filePath containsString:@"/Caches/Snapshots"]) {
            //删除子文件夹
            [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
        }
        if (error) {
            return NO;
        }
    }
    return YES;
}

/**
 计算WKWebView缓存大小
 
 @return 缓存大小
 */
+ (NSString *)getWKWebKitCacheSize
{
    NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString *path = [cachesPath stringByAppendingPathComponent:@"/WebKit"];
    // 获取“path”文件夹下的所有文件
    NSArray *subPathArr = [[NSFileManager defaultManager] subpathsAtPath:path];
    NSString *filePath  = nil;
    NSInteger totleSize = 0;
    for (NSString *subPath in subPathArr){
        
        // 1. 拼接每一个文件的全路径
        filePath =[path stringByAppendingPathComponent:subPath];
        // 2. 是否是文件夹，默认不是
        BOOL isDirectory = NO;
        // 3. 判断文件是否存在
        BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDirectory];
        // 4. 以上判断目的是忽略不需要计算的文件
        if (!isExist || isDirectory || [filePath containsString:@".DS"]){
            // 过滤: 1. 文件夹不存在  2. 过滤文件夹  3. 隐藏文件
            continue;
        }
        // 5. 指定路径，获取这个路径的属性
        NSDictionary *dict = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
        /**
         attributesOfItemAtPath: 文件夹路径
         该方法只能获取文件的属性, 无法获取文件夹属性, 所以也是需要遍历文件夹的每一个文件的原因
         */
        // 6. 获取每一个文件的大小
        NSInteger size = [dict[@"NSFileSize"] integerValue];
        // 7. 计算总大小
        totleSize += size;
    }
    
    //8. 将文件夹大小转换为 M/KB/B
    NSString *totleStr = nil;
    if (totleSize > 1000 * 1000){
        totleStr = [NSString stringWithFormat:@"%.2fM",totleSize / 1000.00f /1000.00f];
    }else if (totleSize > 1000){
        totleStr = [NSString stringWithFormat:@"%.2fKB",totleSize / 1000.00f ];
    }else{
        totleStr = [NSString stringWithFormat:@"%.2fB",totleSize / 1.00f];
    }
    return totleStr;
}

/**
 清除WKWebview缓存
 
 @return 是否清除成功
 */
+ (BOOL)clearWKWebKitCache
{
    NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString *path = [cachesPath stringByAppendingPathComponent:@"/WebKit"];
    //拿到path路径的下一级目录的子文件夹
    NSArray *subPathArr = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
    NSString *filePath = nil;
    NSError *error = nil;
    for (NSString *subPath in subPathArr) {
        filePath = [path stringByAppendingPathComponent:subPath];
        if (![filePath containsString:@"/Caches/Snapshots"]) {
            //删除子文件夹
            [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
        }
        if (error) {
            return NO;
        }
    }
    return YES;
}

/**
 计算SDWebImage-default文件夹大小
 
 @return 文件夹大小
 */
+ (NSString *)getSDImageDefaultCacheSize
{
    NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString *path = [cachesPath stringByAppendingPathComponent:@"/default"];
    // 获取“path”文件夹下的所有文件
    NSArray *subPathArr = [[NSFileManager defaultManager] subpathsAtPath:path];
    NSString *filePath  = nil;
    NSInteger totleSize = 0;
    for (NSString *subPath in subPathArr){
        
        // 1. 拼接每一个文件的全路径
        filePath =[path stringByAppendingPathComponent:subPath];
        // 2. 是否是文件夹，默认不是
        BOOL isDirectory = NO;
        // 3. 判断文件是否存在
        BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDirectory];
        // 4. 以上判断目的是忽略不需要计算的文件
        if (!isExist || isDirectory || [filePath containsString:@".DS"]){
            // 过滤: 1. 文件夹不存在  2. 过滤文件夹  3. 隐藏文件
            continue;
        }
        // 5. 指定路径，获取这个路径的属性
        NSDictionary *dict = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
        /**
         attributesOfItemAtPath: 文件夹路径
         该方法只能获取文件的属性, 无法获取文件夹属性, 所以也是需要遍历文件夹的每一个文件的原因
         */
        // 6. 获取每一个文件的大小
        NSInteger size = [dict[@"NSFileSize"] integerValue];
        // 7. 计算总大小
        totleSize += size;
    }
    
    //8. 将文件夹大小转换为 M/KB/B
    NSString *totleStr = nil;
    if (totleSize > 1000 * 1000){
        totleStr = [NSString stringWithFormat:@"%.2fM",totleSize / 1000.00f /1000.00f];
    }else if (totleSize > 1000){
        totleStr = [NSString stringWithFormat:@"%.2fKB",totleSize / 1000.00f ];
    }else{
        totleStr = [NSString stringWithFormat:@"%.2fB",totleSize / 1.00f];
    }
    return totleStr;
}

/**
 清除SDWebImage缓存文件
 
 @return 是否清除成功
 */
+ (BOOL)clearSDImageDefaultCache
{
    NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString *path = [cachesPath stringByAppendingPathComponent:@"/default"];
    //拿到path路径的下一级目录的子文件夹
    NSArray *subPathArr = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
    NSString *filePath = nil;
    NSError *error = nil;
    for (NSString *subPath in subPathArr) {
        filePath = [path stringByAppendingPathComponent:subPath];
        if (![filePath containsString:@"/Caches/Snapshots"]) {
            //删除子文件夹
            [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
        }
        if (error) {
            return NO;
        }
    }
    return YES;
}

/**
 创建文件夹

 @param path 路径
 @return 是否创建成功
 */
+ (BOOL)createFileWithPath:(NSString *)path
{
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:path isDirectory:&isDir];
    NSError *error;
    if ( !(isDir == YES && existed == YES) )
    {
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
    }
    if (error) {
        return NO;
    }else{
        return YES;
    }
}


/**
 创建文件

 @param path 路径
 @return 是否成功
 */
+ (BOOL)createRealFileAtPath:(NSString *)path
{
    BOOL flag;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:path]) {
        flag = [fileManager createFileAtPath:path contents:nil attributes:nil];
    }else{
        flag = YES;
    }
    return flag;
}

/**
 保存文件

 @param fileName 文件名
 @return 是否存储成功
 */
+ (BOOL)saveFileToTempFilePath:(NSString *)fileName
{
    return YES;
}

/**
 文件夹下是否存在文件

 @param path 文件夹路径
 @return 结果
 */
+ (BOOL)hasFileAtPath:(NSString *)path
{
    // 获取“path”文件夹下的所有文件
    NSArray *subPathArr = [[NSFileManager defaultManager] subpathsAtPath:path];
    return subPathArr.count > 0;
}


@end
