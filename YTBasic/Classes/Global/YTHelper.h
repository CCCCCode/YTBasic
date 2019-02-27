//
//  YTHelper.h
//  YTKit
//
//  Created by HellowWorld on 2018/7/7.
//  Copyright © 2018年 YNTCode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^PostSMSResult)(BOOL result,NSString *errorMessage);

@interface YTHelper : NSObject

/**
 单例

 @return 实例
 */
+ (instancetype)shareInstance;

/**
 获取当前屏幕显示的viewcontroller

 @return viewcontroller
 */
- (UIViewController *)getTopViewController;

@end

@interface YTHelper (UIGraphic)
/**
 判断size是否超出范围

 @param size size
 */
+ (void)inspectContextSize:(CGSize)size;

/**
 context是否合法

 @param context context
 */
+ (void)inspectContextIfInvalidatedInDebugMode:(CGContextRef _Nonnull)context;

/**
 context是否合法

 @param context context
 */
+ (BOOL)inspectContextIfInvalidatedInReleaseMode:(CGContextRef _Nonnull)context;
@end
