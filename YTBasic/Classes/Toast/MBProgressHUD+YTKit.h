//
//  MBProgressHUD+YTKit.h
//  YTKit
//
//  Created by HellowWorld on 2018/7/23.
//  Copyright © 2018年 YNTCode. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (YTKit)


/**
 显示一个带文字的toast,默认1.5秒后消失,并显示到key window上

 @param title 文字
 @return 实例
 */
+ (MBProgressHUD *)toast_showTitle:(NSString *)title;

/**
 显示一个带文字的toast

 @param title 文字
 @param view 父view
 @param afterSecond afterSecond秒后消失
 @return 实例
 */
+ (MBProgressHUD *)toast_showTitle:(NSString *)title
                            toView:(UIView *)view
                         hideAfter:(NSTimeInterval)afterSecond;

/**
 显示一个带圈圈带文字的toast
 
 @param title 文字
 @param view 父view
 @return 实例
 */
+ (MBProgressHUD *)toast_showActivityIndicatorWithTitle:(NSString *)title toView:(UIView *)view;
/** 隐藏MBProgressHUD 要与添加的view保持一致 */
+ (void)toast_hideHUDForView:(UIView *)view;

/**
 显示一个带文字的toast,显示在屏幕中间
 
 @param title 文字
 @param view 父view
 @param afterSecond afterSecond秒后消失
 @return 实例
 */
+ (MBProgressHUD *)toast_showTitle:(NSString *)title
                    toViewInMiddle:(UIView *)view
                         hideAfter:(NSTimeInterval)afterSecond;

@end
