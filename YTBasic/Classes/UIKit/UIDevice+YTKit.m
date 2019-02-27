//
//  UIDevice+YTKit.m
//  YTKit
//
//  Created by HellowWorld on 2018/7/7.
//  Copyright © 2018年 YNTCode. All rights reserved.
//

#import "UIDevice+YTKit.h"
#import "sys/utsname.h"
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#include <sys/param.h>
#include <sys/mount.h>
#import <mach/mach.h>

@implementation UIDevice (YTKit)

static NSInteger isIPad = -1;
/**
 是否为iPad

 @return 结果
 */
+ (BOOL)isIPad {
    if (isIPad < 0) {
        // [[[UIDevice currentDevice] model] isEqualToString:@"iPad"] 无法判断模拟器，改为以下方式
        isIPad = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 1 : 0;
    }
    return isIPad > 0;
}

static NSInteger isIPadPro = -1;
/**
 是否为iPadPro

 @return 结果
 */
+ (BOOL)isIPadPro {
    if (isIPadPro < 0) {
        isIPadPro = [self isIPad] ? ([UIScreen mainScreen].bounds.size.width == 1024 && [UIScreen mainScreen].bounds.size.height == 1366 ? 1 : 0) : 0;
    }
    return isIPadPro > 0;
}

static NSInteger isIPod = -1;
/**
 是否为iPod

 @return 结果
 */
+ (BOOL)isIPod {
    if (isIPod < 0) {
        NSString *string = [[UIDevice currentDevice] model];
        isIPod = [string rangeOfString:@"iPod touch"].location != NSNotFound ? 1 : 0;
    }
    return isIPod > 0;
}

static NSInteger isIPhone = -1;
/**
 是否为iPhone

 @return 结果
 */
+ (BOOL)isIPhone {
    if (isIPhone < 0) {
        NSString *string = [[UIDevice currentDevice] model];
        isIPhone = [string rangeOfString:@"iPhone"].location != NSNotFound ? 1 : 0;
    }
    return isIPhone > 0;
}

static NSInteger isSimulator = -1;
/**
 是否为模拟器

 @return 结果
 */
+ (BOOL)isSimulator {
    if (isSimulator < 0) {
#if TARGET_OS_SIMULATOR
        isSimulator = 1;
#else
        isSimulator = 0;
#endif
    }
    return isSimulator > 0;
}

static NSInteger is58InchScreen = -1;

/**
 是否为5.8寸屏幕 (iPhoneX)

 @return 结果
 */
+ (BOOL)is58InchScreen {
    if (is58InchScreen < 0) {
        is58InchScreen = ([UIScreen mainScreen].bounds.size.width == self.screenSizeFor58Inch.width && [UIScreen mainScreen].bounds.size.height == self.screenSizeFor58Inch.height) ? 1 : 0;
    }
    return is58InchScreen > 0;
}

static NSInteger is55InchScreen = -1;
/**
 是否为5.5寸屏幕 (iPhone6/7/8 Plus)

 @return 结果
 */
+ (BOOL)is55InchScreen {
    if (is55InchScreen < 0) {
        is55InchScreen = ([UIScreen mainScreen].bounds.size.width == self.screenSizeFor55Inch.width && [UIScreen mainScreen].bounds.size.height == self.screenSizeFor55Inch.height) ? 1 : 0;
    }
    return is55InchScreen > 0;
}

static NSInteger is47InchScreen = -1;
/**
 是否为4.7寸屏幕 (iPhone6/7/8)

 @return 结果
 */
+ (BOOL)is47InchScreen {
    if (is47InchScreen < 0) {
        is47InchScreen = ([UIScreen mainScreen].bounds.size.width == self.screenSizeFor47Inch.width && [UIScreen mainScreen].bounds.size.height == self.screenSizeFor47Inch.height) ? 1 : 0;
    }
    return is47InchScreen > 0;
}

static NSInteger is40InchScreen = -1;
/**
 是否为4.0寸屏幕 (iPhone5/5s/SE)

 @return 结果
 */
+ (BOOL)is40InchScreen {
    if (is40InchScreen < 0) {
        is40InchScreen = ([UIScreen mainScreen].bounds.size.width == self.screenSizeFor40Inch.width && [UIScreen mainScreen].bounds.size.height == self.screenSizeFor40Inch.height) ? 1 : 0;
    }
    return is40InchScreen > 0;
}

static NSInteger is35InchScreen = -1;
/**
 是否为3.5寸屏幕 (iPhone4/4s)

 @return 结果
 */
+ (BOOL)is35InchScreen {
    if (is35InchScreen < 0) {
        is35InchScreen = ([UIScreen mainScreen].bounds.size.width == self.screenSizeFor35Inch.width && [UIScreen mainScreen].bounds.size.height == self.screenSizeFor35Inch.height) ? 1 : 0;
    }
    return is35InchScreen > 0;
}

/**
 当前系统所使用的语言

 @return 语言
 */
+ (NSString *)currentLanguage
{
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages firstObject];
    return currentLanguage;
}

/**
 获取设备名
 
 @return 设备名
 */
+ (NSString *)getDeviceName
{
    //iphoneX
    if ([self is58InchScreen]) {
        return @"iPhoneX";
    }
    
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone4";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"iPhone4";
    if ([deviceString isEqualToString:@"iPhone3,3"])    return @"iPhone4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone4S";
    if ([deviceString isEqualToString:@"iPhone5,1"])    return @"iPhone5";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone5 (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPhone5,3"])    return @"iPhone5c (GSM)";
    if ([deviceString isEqualToString:@"iPhone5,4"])    return @"iPhone5c (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPhone6,1"])    return @"iPhone5s (GSM)";
    if ([deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone5s (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iPhone6 Plus";
    if ([deviceString isEqualToString:@"iPhone7,2"])    return @"iPhone6";
    if ([deviceString isEqualToString:@"iPhone8,1"])    return @"iPhone6s";
    if ([deviceString isEqualToString:@"iPhone8,2"])    return @"iPhone6s Plus";
    if ([deviceString isEqualToString:@"iPhone8,4"])    return @"iPhoneSE";
    // 日行两款手机型号均为日本独占，可能使用索尼FeliCa支付方案而不是苹果支付
    if ([deviceString isEqualToString:@"iPhone9,1"])    return @"iPhone7 国行、日版、港行";
    if ([deviceString isEqualToString:@"iPhone9,2"])    return @"iPhone7 Plus 港行、国行";
    if ([deviceString isEqualToString:@"iPhone9,3"])    return @"iPhone7 美版、台版";
    if ([deviceString isEqualToString:@"iPhone9,4"])    return @"iPhone7 Plus 美版、台版";
    if ([deviceString isEqualToString:@"iPhone10,1"])   return @"iPhone8 国行(A1863)、日行(A1906)";
    if ([deviceString isEqualToString:@"iPhone10,4"])   return @"iPhone8 美版(Global/A1905)";
    if ([deviceString isEqualToString:@"iPhone10,2"])   return @"iPhone8 Plus  国行(A1864)、日行(A1898)";
    if ([deviceString isEqualToString:@"iPhone10,5"])   return @"iPhone8 Plus 美版(Global/A1897)";
    if ([deviceString isEqualToString:@"iPhone10,3"])   return @"iPhoneX 国行(A1865)、日行(A1902)";
    if ([deviceString isEqualToString:@"iPhone10,6"])   return @"iPhoneX 美版(Global/A1901)";
    if ([deviceString isEqualToString:@"iPhone11,2"])   return @"iPhoneXS";
    if ([deviceString isEqualToString:@"iPhone11,4"])   return @"iPhoneXS Max";
    if ([deviceString isEqualToString:@"iPhone11,6"])   return @"iPhoneXS Max";
    if ([deviceString isEqualToString:@"iPhone11,8"])   return @"iPhoneXR";
    if ([deviceString isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceString isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceString isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceString isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceString isEqualToString:@"iPod5,1"])      return @"iPod Touch (5 Gen)";
    if ([deviceString isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceString isEqualToString:@"iPad1,2"])      return @"iPad 3G";
    if ([deviceString isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,2"])      return @"iPad 2";
    if ([deviceString isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([deviceString isEqualToString:@"iPad2,4"])      return @"iPad 2";
    if ([deviceString isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,6"])      return @"iPad Mini";
    if ([deviceString isEqualToString:@"iPad2,7"])      return @"iPad Mini (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    if ([deviceString isEqualToString:@"iPad3,2"])      return @"iPad 3 (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPad3,3"])      return @"iPad 3";
    if ([deviceString isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([deviceString isEqualToString:@"iPad3,5"])      return @"iPad 4";
    if ([deviceString isEqualToString:@"iPad3,6"])      return @"iPad 4 (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPad4,1"])      return @"iPad Air (WiFi)";
    if ([deviceString isEqualToString:@"iPad4,2"])      return @"iPad Air (Cellular)";
    if ([deviceString isEqualToString:@"iPad4,4"])      return @"iPad Mini 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad4,5"])      return @"iPad Mini 2 (Cellular)";
    if ([deviceString isEqualToString:@"iPad4,6"])      return @"iPad Mini 2";
    if ([deviceString isEqualToString:@"iPad4,7"])      return @"iPad Mini 3";
    if ([deviceString isEqualToString:@"iPad4,8"])      return @"iPad Mini 3";
    if ([deviceString isEqualToString:@"iPad4,9"])      return @"iPad Mini 3";
    if ([deviceString isEqualToString:@"iPad5,1"])      return @"iPad Mini 4 (WiFi)";
    if ([deviceString isEqualToString:@"iPad5,2"])      return @"iPad Mini 4 (LTE)";
    if ([deviceString isEqualToString:@"iPad5,3"])      return @"iPad Air 2";
    if ([deviceString isEqualToString:@"iPad5,4"])      return @"iPad Air 2";
    if ([deviceString isEqualToString:@"iPad6,3"])      return @"iPad Pro 9.7";
    if ([deviceString isEqualToString:@"iPad6,4"])      return @"iPad Pro 9.7";
    if ([deviceString isEqualToString:@"iPad6,7"])      return @"iPad Pro 12.9";
    if ([deviceString isEqualToString:@"iPad6,8"])      return @"iPad Pro 12.9";
    if ([deviceString isEqualToString:@"iPad6,11"])    return @"iPad 5 (WiFi)";
    if ([deviceString isEqualToString:@"iPad6,12"])    return @"iPad 5 (Cellular)";
    if ([deviceString isEqualToString:@"iPad7,1"])     return @"iPad Pro 12.9 inch 2nd gen (WiFi)";
    if ([deviceString isEqualToString:@"iPad7,2"])     return @"iPad Pro 12.9 inch 2nd gen (Cellular)";
    if ([deviceString isEqualToString:@"iPad7,3"])     return @"iPad Pro 10.5 inch (WiFi)";
    if ([deviceString isEqualToString:@"iPad7,4"])     return @"iPad Pro 10.5 inch (Cellular)";
    if ([deviceString isEqualToString:@"AppleTV2,1"])    return @"Apple TV 2";
    if ([deviceString isEqualToString:@"AppleTV3,1"])    return @"Apple TV 3";
    if ([deviceString isEqualToString:@"AppleTV3,2"])    return @"Apple TV 3";
    if ([deviceString isEqualToString:@"AppleTV5,3"])    return @"Apple TV 4";
    if ([deviceString isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceString isEqualToString:@"x86_64"])       return @"Simulator";
    
    return deviceString;
}


/**
 获取mac地址
 
 @return mac地址
 */
+ (NSString *)getMacAddress
{
    
    int mib[6];
    size_t len;
    char *buf;
    unsigned char *ptr;
    struct if_msghdr *ifm;
    struct sockaddr_dl *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1/n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    
    NSString *outstring = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    
    return [outstring uppercaseString];
}


+ (NSString *)getImsi
{
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [info subscriberCellularProvider];
    NSString *mcc = [carrier mobileCountryCode];
    NSString *mnc = [carrier mobileNetworkCode];
    NSString *imsi = [NSString stringWithFormat:@"%@%@", mcc, mnc];
    return imsi;
}

/**
 生成uuid
 
 @return uuid
 */
+ (NSString *)createUUID
{
    CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
    CFStringRef uuid_string_ref= CFUUIDCreateString(NULL, uuid_ref);
    NSString *uuid = [NSString stringWithString:(__bridge NSString *)uuid_string_ref];
    CFRelease(uuid_ref);
    CFRelease(uuid_string_ref);
    return [uuid lowercaseString];
}

/**
 获取手机内存大小

 @return 内存大小
 */
-(long long)getTotalMemorySize
{
    return [NSProcessInfo processInfo].physicalMemory;
}

/**
 获取手机已使用内存大小

 @return 已使用内存大小
 */
- (double)getUsedMemory
{
  task_basic_info_data_t taskInfo;
  mach_msg_type_number_t infoCount = TASK_BASIC_INFO_COUNT;
  kern_return_t kernReturn = task_info(mach_task_self(),
                                       TASK_BASIC_INFO,
                                       (task_info_t)&taskInfo,
                                       &infoCount);
 
  if (kernReturn != KERN_SUCCESS
      ) {
    return NSNotFound;
  }
 
  return taskInfo.resident_size;
}


/**
 获取当前可用内存大小

 @return 可用内存大小
 */
-(long long)getAvailableMemorySize
{
    vm_statistics_data_t vmStats;
    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
    kern_return_t kernReturn = host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)&vmStats, &infoCount);
    if (kernReturn != KERN_SUCCESS)
    {
        return NSNotFound;
    }
    return ((vm_page_size * vmStats.free_count + vm_page_size * vmStats.inactive_count));
}

/**
 获取手机总磁盘大小

 @return 总磁盘大小
 */
-(long long)getTotalDiskSize
{
    struct statfs buf;
    unsigned long long freeSpace = -1;
    if (statfs("/var", &buf) >= 0)
    {
        freeSpace = (unsigned long long)(buf.f_bsize * buf.f_blocks);
    }
    return freeSpace;
}

/**
 获取手机可用磁盘大小

 @return 可用磁盘大小
 */
-(long long)getAvailableDiskSize
{
    struct statfs buf;
    unsigned long long freeSpace = -1;
    if (statfs("/var", &buf) >= 0)
    {
        freeSpace = (unsigned long long)(buf.f_bsize * buf.f_bavail);
    }
    return freeSpace;
}

/**
 是否为iphoneX / XR  /XS

 @return 结果
 */
- (BOOL)isIphoneXOrXROrXS
{
    BOOL isPhoneX = NO;
    if (@available(iOS 11.0, *)) {
        isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;
    }
    return isPhoneX;
}


#pragma mark -- private method

+ (CGSize)screenSizeFor58Inch {
    return CGSizeMake(375, 812);
}

+ (CGSize)screenSizeFor55Inch {
    return CGSizeMake(414, 736);
}

+ (CGSize)screenSizeFor47Inch {
    return CGSizeMake(375, 667);
}

+ (CGSize)screenSizeFor40Inch {
    return CGSizeMake(320, 568);
}

+ (CGSize)screenSizeFor35Inch {
    return CGSizeMake(320, 480);
}

@end
