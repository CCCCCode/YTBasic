//
//  UIImage+YTKit.h
//  YTKit
//
//  Created by HellowWorld on 2018/7/7.
//  Copyright © 2018年 YNTCode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (YTKit)
/**
 是否有alpha通道

 @return 是否有alpha通道
 */
- (BOOL)hasAlpha;

/**
 设置一张图片的透明度

 @param alpha 要用于渲染透明度
 @return 设置了透明度之后的图片
 */
- (UIImage *)imageWithAlpha:(CGFloat)alpha;

/**
 获取当前图片的均色，原理是将图片绘制到1px*1px的矩形内，再从当前区域取色，得到图片的均色。
 @link http://www.bobbygeorgescu.com/2011/08/finding-average-color-of-uiimage/ @/link
 @return 代表图片平均颜色的UIColor对象
 */
- (UIColor *)averageColor;

/**
 置灰当前图片

 @return 已经置灰的图片
 */
 
- (UIImage *)grayImage;

/**
 gif转图片

 @param gifData gifData
 @return gif图片
 */
+ (UIImage *)animatedImageWithAnimatedGifData:(NSData *)gifData;

/**
 gif转图片

 @param gifUrl gif链接
 @return gif图片
 */
+ (UIImage *)animatedImageWithAnimatedGifUrl:(NSURL *)gifUrl;

/**
 按比例缩放图片

 @param image 源图片
 @param scaleSize 缩放比例
 @return 缩放之后图片
 */
+ (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize;

/**
 通过指定图片最长边，获得等比例的图片size

 @param image 原始图片
 @param imageLength 图片允许的最长宽度（高度）
 @return 获得等比例的size
 */
+ (CGSize)scaleImage:(UIImage *) image withLength:(CGFloat) imageLength;

/**
 获得指定size的图片

 @param image 原始图片
 @param newSize 指定的size
 @return 调整后的图片
 */
+ (UIImage *)resizeImage:(UIImage *) image withNewSize:(CGSize) newSize;

/**
 根据颜色生成图片

 @param color 颜色
 @param size 尺寸
 @return 图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

/**
 压缩图片到指定字节

 @param image 压缩的图片
 @param maxLength 压缩后最大字节大小
 @param maxWidth 压缩后最大字节大小
 @return 压缩后图片的二进制
 */
+ (NSData *)compressImage:(UIImage *)image toMaxLength:(NSInteger) maxLength maxWidth:(NSInteger)maxWidth;


/**
 压缩图片到指定文件大小

 @param image 图片
 @param kb 大小
 @return 压缩后图片
 */
+ (NSData *)compressOriginalImage:(UIImage *)image toMaxDataSizeKBytes:(CGFloat)kb;

/**
 用于pods中图片加载

 @param imageName 图片名字,不包括@2x
 @param bundle 当前pods的名称
 @param targetClass 与当前图片同一pods的文件
 @return image
 */
+ (UIImage *)imagePathWithName:(NSString *)imageName bundle:(NSString *)bundle targetClass:(Class)targetClass;

/**
 将原图进行旋转，只能选择上下左右四个方向

 @param orientation 旋转的方向
 @return 处理完的图片
 */
- (UIImage *)imageWithOrientation:(UIImageOrientation)orientation;
@end
