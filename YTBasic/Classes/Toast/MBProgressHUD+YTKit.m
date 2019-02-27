//
//  MBProgressHUD+YTKit.m
//  YTKit
//
//  Created by HellowWorld on 2018/7/23.
//  Copyright © 2018年 YNTCode. All rights reserved.
//

#import "MBProgressHUD+YTKit.h"
#import "UIColor+YTKit.h"

@implementation MBProgressHUD (YTKit)

static NSTimeInterval dissmissTime = 1.5;
static CGFloat FONT_SIZE = 13.0f;
static CGFloat OPACITY = 1;
/**
 显示一个带文字的toast,默认1.5秒后消失
 
 @param title 文字
 @return 实例
 */
+ (MBProgressHUD *)toast_showTitle:(NSString *)title
{
    UIWindow *keyWindow = [[[UIApplication sharedApplication] delegate] window];
    if (keyWindow) {
        return [self toast_showTitle:title toView:keyWindow hideAfter:dissmissTime];
    }else{
        return nil;
    }
}

/**
 显示一个带文字的toast
 
 @param title 文字
 @param view 父view
 @param afterSecond afterSecond秒后消失
 @return 实例
 */
+ (MBProgressHUD *)toast_showTitle:(NSString *)title
                            toView:(UIView *)view
                         hideAfter:(NSTimeInterval)afterSecond
{
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    HUD.mode = MBProgressHUDModeText;
    HUD.label.font = [UIFont systemFontOfSize:FONT_SIZE];
    HUD.detailsLabel.text = title;
    HUD.bezelView.alpha = OPACITY;
    HUD.bezelView.color = [UIColor colorWithHexString:@"#575655"];
    HUD.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    HUD.bezelView.layer.cornerRadius = 2;
    HUD.margin = 13.f;
    HUD.offset = CGPointMake(0.f, 220.f);
    HUD.contentColor = [UIColor whiteColor];
    [HUD hideAnimated:YES  afterDelay:afterSecond];
    return HUD;
}


/**
 显示一个带圈圈带文字的toast
 
 @param title 文字
 @param view 父view
 @return 实例
 */
+ (MBProgressHUD *)toast_showActivityIndicatorWithTitle:(NSString *)title toView:(UIView *)view
{
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = title;
    hud.label.font = [UIFont systemFontOfSize:15];
    
    // bezelView.color 自定义progress背景色（默认为白色）
    hud.bezelView.color = [UIColor blackColor];
    // 内容的颜色
    hud.contentColor = [UIColor whiteColor];
    
    [hud hideAnimated:YES afterDelay:5];
    // 隐藏时从父控件上移除
    hud.removeFromSuperViewOnHide = YES;
    return hud;
}

/** 隐藏 MBProgressHUD */
+ (void)toast_hideHUDForView:(UIView *)view {
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    [self hideHUDForView:view animated:YES];
}

/**
 显示一个带文字的toast,显示在屏幕中间
 
 @param title 文字
 @param view 父view
 @param afterSecond afterSecond秒后消失
 @return 实例
 */
+ (MBProgressHUD *)toast_showTitle:(NSString *)title
                            toViewInMiddle:(UIView *)view
                         hideAfter:(NSTimeInterval)afterSecond
{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:[[[UIApplication sharedApplication] delegate] window]] ;
    hud.mode = MBProgressHUDModeText;
    hud.label.text = title;
    hud.label.font = [UIFont systemFontOfSize:15.0];
    hud.removeFromSuperViewOnHide = YES;
    hud.bezelView.color = [UIColor blackColor];
    hud.contentColor = [UIColor whiteColor];
    [hud showAnimated:YES];
    [[[[UIApplication sharedApplication] delegate] window] addSubview:hud];
    
    [hud hideAnimated:YES afterDelay:afterSecond];
    return hud;
}

@end
