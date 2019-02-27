//
//  YTGlobal.h
//  CRFMarket
//
//  Created by HellowWorld on 2018/8/10.
//  Copyright © 2018年 CCCode. All rights reserved.
//

#ifndef YTGlobal_h
#define YTGlobal_h

/** 带函数名和行数Log */
#ifdef DEBUG

#define DLog(fmt, ...) NSLog((@"%s," "[lineNum:%d]" fmt) , __FUNCTION__, __LINE__, ##__VA_ARGS__);
#else

#define DLog(...)

#endif


#pragma mark -- 尺寸相关
/** 屏幕高 */
#define SCREEN_HEIGHT      [[UIScreen mainScreen] bounds].size.height

/** 屏幕宽 */
#define SCREEN_WIDTH       [[UIScreen mainScreen] bounds].size.width

/** 屏幕bounds */
#define SCREEN_BOUNDS [[UIScreen mainScreen] bounds]

/** 屏幕bounds */
#define SCREEN_SCALE [[UIScreen mainScreen] scale]

/** 状态栏高度 */
#define kStatusBarHeight  ((kIsIphoneX) ? 44 : 20)

/** NavBar高度 */
#define kNavigationBarHeight  44

/** 状态栏 ＋ 导航栏 高度 */
#define kTopBarHeight  ((kStatusBarHeight) + (kNavigationBarHeight))

/** tabBar高度 */
#define kTabBarHeight  ((kIsIphoneX) ? 83 : 49)

/** 以375x667为基准,返回比例之后的宽度 */
#define fixwn(p) (((SCREEN_WIDTH/375.0)*p) < ((SCREEN_HEIGHT/375.0)*p) ? ((SCREEN_WIDTH/375.0)*p) : ((SCREEN_HEIGHT/375.0)*p))

#define kViewBounds CGRectMake(0, kTopBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT - kTopBarHeight)


#pragma mark -- 公共定义

/** 是否为Ipad */
#define kIsIpad UI_USER_INTERFACE_IDIOM() ==UIUserInterfaceIdiomPad

/** 是否为iphonex */
#define kIsIphoneX \
({BOOL isPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
}\
(isPhoneX);})

/** 系统版本 */
#define kSYSTEM_VERSION [UIDevice currentDevice] systemVersion]

/** 大于等于7.0的ios版本 */
#define iOS7_OR_LATER SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")

/** 大于等于8.0的ios版本 */
#define iOS8_OR_LATER SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")

/** 大于等于9.0的ios版本 */
#define iOS9_OR_LATER SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0")

/** 大于等于10.0的ios版本 */
#define iOS10_OR_LATER SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"10.0")

/** 大于等于11.0的ios版本 */
#define iOS11_OR_LATER SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11.0")


/** 是否等于v版本 */
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)

/** 是否大于v版本 */
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)

/** 是否大于或者等于v版本 */
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

/** 是否小于版本 */
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

/** 是否小于或者等于v版本 */
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

/** 获取系统时间戳 */
#define kGetCurentTime [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]]

/** 断言 */
#define kNSAssert(condition, description, ...) NSAssert((condition), (description), ##__VA_ARGS__)

/** BundleId */
#define kBundleID   ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"])

/** APP发布版本 */
#define kAppVersion ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"])

/** APPbuild版本 */
#define kAppBuildVersion ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"])

/** APP名称 */
#define kAppName ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"])

/** 获取设备uuid */
#define kGetDeviceUUID [[[UIDevice currentDevice] identifierForVendor] UUIDString]

/** 主window */
#define kWindow [[[UIApplication sharedApplication] delegate] window]

/** 释放第一响应者,主要用于收键盘 */
#define kResignFirstResponder [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil]

/** 产生随机颜色 */
#define kRandomColor [UIColor colorWithHue: (arc4random() % 256 / 256.0) saturation:((arc4random()% 128 / 256.0 ) + 0.5) brightness:(( arc4random() % 128 / 256.0 ) + 0.5) alpha:1]

/** 是否是模拟器 */
#define kIsSimulator TARGET_IPHONE_SIMULATOR

/** 是否是真机 */
#define kIsPhone TARGET_OS_IPHONE

#ifndef    weakify
#if __has_feature(objc_arc)

#define weakify( x ) \\
_Pragma("clang diagnostic push") \\
_Pragma("clang diagnostic ignored \\"-Wshadow\\"") \\
autoreleasepool{} __weak __typeof__(x) __weak_##x##__ = x; \\
_Pragma("clang diagnostic pop")

#else

#define weakify( x ) \\
_Pragma("clang diagnostic push") \\
_Pragma("clang diagnostic ignored \\"-Wshadow\\"") \\
autoreleasepool{} __block __typeof__(x) __block_##x##__ = x; \\
_Pragma("clang diagnostic pop")

#endif
#endif

#ifndef    strongify
#if __has_feature(objc_arc)

#define strongify( x ) \\
_Pragma("clang diagnostic push") \\
_Pragma("clang diagnostic ignored \\"-Wshadow\\"") \\
try{} @finally{} __typeof__(x) x = __weak_##x##__; \\
_Pragma("clang diagnostic pop")

#else

#define strongify( x ) \\
_Pragma("clang diagnostic push") \\
_Pragma("clang diagnostic ignored \\"-Wshadow\\"") \\
try{} @finally{} __typeof__(x) x = __block_##x##__; \\
_Pragma("clang diagnostic pop")

#endif
#endif

/** 判断字符串是否为空 */
#define kIsEmptyString(string) ((string == nil || (([string isKindOfClass:[NSString class]]) && (string.length == 0))) ? YES : NO)

/** 判断字符串是否为空 */
#define kNilSafe(a) ((a) ? (a) : (@""))

/** 主线程同步队列 */
#define dispatch_main_sync_safe(block)\
    if ([NSThread isMainThread]) {\
        block();\
    } else {\
        dispatch_sync(dispatch_get_main_queue(), block);\
    }
/** 主线程异步队列 */
#define dispatch_main_async_safe(block)\
    if ([NSThread isMainThread]) {\
        block();\
    } else {\
        dispatch_async(dispatch_get_main_queue(), block);\
    }\
    dispatch_main_async_safe(^{\
                });\



/** temp文件目录 */
#define kTempPath                   NSTemporaryDirectory()

/** 沙盒目录 */
#define kDocumentPath               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

/** cache目录 */
#define kCachePath                 [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]

#endif /* YTGlobal_h */
