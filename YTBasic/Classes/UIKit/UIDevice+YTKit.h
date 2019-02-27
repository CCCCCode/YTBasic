//
//  UIDevice+YTKit.h
//  YTKit
//
//  Created by HellowWorld on 2018/7/7.
//  Copyright © 2018年 YNTCode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (YTKit)

/**
 是否为iPad

 @return 结果
 */
+ (BOOL)isIPad;

/**
 是否为iPadPro

 @return 结果
 */
+ (BOOL)isIPadPro;

/**
 是否为iPod

 @return 结果
 */
+ (BOOL)isIPod;

/**
 是否为iPhone

 @return 结果
 */
+ (BOOL)isIPhone;

/**
 是否为模拟器

 @return 结果
 */
+ (BOOL)isSimulator;

/**
 是否为5.8寸屏幕 (iPhoneX)

 @return 结果
 */
+ (BOOL)is58InchScreen;

/**
 是否为5.5寸屏幕 (iPhone6/7/8 Plus)

 @return 结果
 */
+ (BOOL)is55InchScreen;

/**
 是否为4.7寸屏幕 (iPhone6/7/8)

 @return 结果
 */
+ (BOOL)is47InchScreen;

/**
 是否为4.0寸屏幕 (iPhone5/5s/SE)

 @return 结果
 */
+ (BOOL)is40InchScreen;

/**
 是否为3.5寸屏幕 (iPhone4/4s)

 @return 结果
 */
+ (BOOL)is35InchScreen;

/**
 当前系统所使用的语言

 @return 语言
 */
+ (NSString *)currentLanguage;

/**
 获取设备名

 @return 设备名
 */
+ (NSString *)getDeviceName;


/**
 获取mac地址

 @return mac地址
 */
+ (NSString *)getMacAddress;


/**
 获取设备的国际移动设备身份码

 @return 国际移动设备身份码
 */
+ (NSString *)getImsi;

/**
 生成uuid
 
 @return uuid
 */
+ (NSString *)createUUID;

/**
 获取手机内存大小

 @return 内存大小
 */
-(long long)getTotalMemorySize;

/**
 获取手机已使用内存大小

 @return 已使用内存大小
 */
- (double)getUsedMemory;

/**
 获取当前可用内存大小

 @return 可用内存大小
 */
-(long long)getAvailableMemorySize;

/**
 获取手机总磁盘大小

 @return 总磁盘大小
 */
-(long long)getTotalDiskSize;

/**
 获取手机可用磁盘大小

 @return 可用磁盘大小
 */
-(long long)getAvailableDiskSize;


/**
 是否为iphoneX / XR  /XS

 @return 结果
 */
- (BOOL)isIphoneXOrXROrXS;

@end
