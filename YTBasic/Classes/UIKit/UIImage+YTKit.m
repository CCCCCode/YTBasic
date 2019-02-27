//
//  UIImage+YTKit.m
//  YTKit
//
//  Created by HellowWorld on 2018/7/7.
//  Copyright © 2018年 YNTCode. All rights reserved.
//

#import "UIImage+YTKit.h"
#import <ImageIO/ImageIO.h>
#import <Accelerate/Accelerate.h>
#import "YTHelper.h"
#if __has_feature(objc_arc)
#define toCF (__bridge CFTypeRef)
#define fromCF (__bridge id)
#else
#define toCF (CFTypeRef)
#define fromCF (id)
#endif

#define AngleWithDegrees(deg) (M_PI * (deg) / 180.0)

#ifdef DEBUG
    #define CGContextInspectContext(context) [YTHelper inspectContextIfInvalidatedInDebugMode:context]
#else
    #define CGContextInspectContext(context) if(![YTHelper inspectContextIfInvalidatedInReleaseMode:context]){return nil;}
#endif

@implementation UIImage (YTKit)

static int delayCentisecondsForImageAtIndex(CGImageSourceRef const source, size_t const i) {
    int delayCentiseconds = 1;
    CFDictionaryRef const properties = CGImageSourceCopyPropertiesAtIndex(source, i, NULL);
    if (properties) {
        CFDictionaryRef const gifProperties = CFDictionaryGetValue(properties, kCGImagePropertyGIFDictionary);
        CFRelease(properties);
        if (gifProperties) {
            CFNumberRef const number = CFDictionaryGetValue(gifProperties, kCGImagePropertyGIFDelayTime);
            // Even though the GIF stores the delay as an integer number of centiseconds, ImageIO “helpfully” converts that to seconds for us.
            delayCentiseconds = (int)lrint([fromCF number doubleValue] * 100);
        }
    }
    return delayCentiseconds;
}

static void createImagesAndDelays(CGImageSourceRef source, size_t count, CGImageRef imagesOut[count], int delayCentisecondsOut[count]) {
    for (size_t i = 0; i < count; ++i) {
        imagesOut[i] = CGImageSourceCreateImageAtIndex(source, i, NULL);
        delayCentisecondsOut[i] = delayCentisecondsForImageAtIndex(source, i);
    }
}

static int sum(size_t const count, int const *const values) {
    int theSum = 0;
    for (size_t i = 0; i < count; ++i) {
        theSum += values[i];
    }
    return theSum;
}

static int pairGCD(int a, int b) {
    if (a < b)
        return pairGCD(b, a);
    while (true) {
        int const r = a % b;
        if (r == 0)
            return b;
        a = b;
        b = r;
    }
}

static int vectorGCD(size_t const count, int const *const values) {
    int gcd = values[0];
    for (size_t i = 1; i < count; ++i) {
        // Note that after I process the first few elements of the vector, `gcd` will probably be smaller than any remaining element.  By passing the smaller value as the second argument to `pairGCD`, I avoid making it swap the arguments.
        gcd = pairGCD(values[i], gcd);
    }
    return gcd;
}

static NSArray *frameArray(size_t const count, CGImageRef const images[count], int const delayCentiseconds[count], int const totalDurationCentiseconds) {
    int const gcd = vectorGCD(count, delayCentiseconds);
    size_t const frameCount = totalDurationCentiseconds / gcd;
    UIImage *frames[frameCount];
    for (size_t i = 0, f = 0; i < count; ++i) {
        UIImage *const frame = [UIImage imageWithCGImage:images[i]];
        for (size_t j = delayCentiseconds[i] / gcd; j > 0; --j) {
            frames[f++] = frame;
        }
    }
    return [NSArray arrayWithObjects:frames count:frameCount];
}

static void releaseImages(size_t const count, CGImageRef const images[count]) {
    for (size_t i = 0; i < count; ++i) {
        CGImageRelease(images[i]);
    }
}

static UIImage *animatedImageWithAnimatedGIFImageSource(CGImageSourceRef const source) {
    size_t const count = CGImageSourceGetCount(source);
    CGImageRef images[count];
    int delayCentiseconds[count]; // in centiseconds
    createImagesAndDelays(source, count, images, delayCentiseconds);
    int const totalDurationCentiseconds = sum(count, delayCentiseconds);
    NSArray *const frames = frameArray(count, images, delayCentiseconds, totalDurationCentiseconds);
    UIImage *const animation = [UIImage animatedImageWithImages:frames duration:(NSTimeInterval)totalDurationCentiseconds / 100.0];
    releaseImages(count, images);
    return animation;
}

static UIImage *animatedImageWithAnimatedGIFReleasingImageSource(CGImageSourceRef source) {
    if (source) {
        UIImage *const image = animatedImageWithAnimatedGIFImageSource(source);
        CFRelease(source);
        return image;
    } else {
        return nil;
    }
}

CG_INLINE CGSize
CGSizeFlatSpecificScale(CGSize size, float scale) {
    return CGSizeMake(flatSpecificScale(size.width, scale), flatSpecificScale(size.height, scale));
}
CG_INLINE CGFloat
flatSpecificScale(CGFloat floatValue, CGFloat scale) {
    floatValue = removeFloatMin(floatValue);
    scale = scale == 0 ? [UIScreen mainScreen].scale : scale;
    CGFloat flattedValue = ceil(floatValue * scale) / scale;
    return flattedValue;
}

CG_INLINE CGFloat
removeFloatMin(CGFloat floatValue) {
    return floatValue == CGFLOAT_MIN ? 0 : floatValue;
}

/**
 是否有alpha通道

 @return 是否有alpha通道
 */
- (BOOL)hasAlpha
{
    CGImageAlphaInfo alpha = CGImageGetAlphaInfo(self.CGImage);
    return (alpha == kCGImageAlphaFirst ||
            alpha == kCGImageAlphaLast ||
            alpha == kCGImageAlphaPremultipliedFirst ||
            alpha == kCGImageAlphaPremultipliedLast);
}

/**
 设置一张图片的透明度

 @param alpha 要用于渲染透明度
 @return 设置了透明度之后的图片
 */
- (UIImage *)imageWithAlpha:(CGFloat)alpha
{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextInspectContext(context);
    CGRect drawingRect = CGRectMake(0, 0, self.size.width, self.size.height);
    [self drawInRect:drawingRect blendMode:kCGBlendModeNormal alpha:alpha];
    UIImage *imageOut = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imageOut;
}

/**
 *  获取当前图片的均色，原理是将图片绘制到1px*1px的矩形内，再从当前区域取色，得到图片的均色。
 *  @link http://www.bobbygeorgescu.com/2011/08/finding-average-color-of-uiimage/ @/link
 *
 *  @return 代表图片平均颜色的UIColor对象
 */
- (UIColor *)averageColor
{
    unsigned char rgba[4] = {};
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgba, 1, 1, 8, 4, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGContextInspectContext(context);
    CGContextDrawImage(context, CGRectMake(0, 0, 1, 1), self.CGImage);
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    if(rgba[3] > 0) {
        return [UIColor colorWithRed:((CGFloat)rgba[0] / rgba[3])
                               green:((CGFloat)rgba[1] / rgba[3])
                                blue:((CGFloat)rgba[2] / rgba[3])
                               alpha:((CGFloat)rgba[3] / 255.0)];
    } else {
        return [UIColor colorWithRed:((CGFloat)rgba[0]) / 255.0
                               green:((CGFloat)rgba[1]) / 255.0
                                blue:((CGFloat)rgba[2]) / 255.0
                               alpha:((CGFloat)rgba[3]) / 255.0];
    }
}

/**
 置灰当前图片

 @return 已经置灰的图片
 */
- (UIImage *)grayImage
{
    // CGBitmapContextCreate 是无倍数的，所以要自己换算成1倍
    NSInteger width = self.size.width * self.scale;
    NSInteger height = self.size.height * self.scale;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef context = CGBitmapContextCreate(NULL, width, height, 8, 0, colorSpace, kCGBitmapByteOrderDefault);
    CGContextInspectContext(context);
    CGColorSpaceRelease(colorSpace);
    if (context == NULL) {
        return nil;
    }
    CGRect imageRect = CGRectMake(0, 0, width, height);
    CGContextDrawImage(context, imageRect, self.CGImage);
    
    UIImage *grayImage = nil;
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    if (self.hasAlpha) {
        grayImage = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
    } else {
        CGContextRef alphaContext = CGBitmapContextCreate(NULL, width, height, 8, 0, nil, kCGImageAlphaOnly);
        CGContextDrawImage(alphaContext, imageRect, self.CGImage);
        CGImageRef mask = CGBitmapContextCreateImage(alphaContext);
        CGImageRef maskedGrayImageRef = CGImageCreateWithMask(imageRef, mask);
        grayImage = [UIImage imageWithCGImage:maskedGrayImageRef scale:self.scale orientation:self.imageOrientation];
        CGImageRelease(mask);
        CGImageRelease(maskedGrayImageRef);
        CGContextRelease(alphaContext);
        
        // 用 CGBitmapContextCreateImage 方式创建出来的图片，CGImageAlphaInfo 总是为 CGImageAlphaInfoNone，导致 alpha 与原图不一致，所以这里再做多一步
        UIGraphicsBeginImageContextWithOptions(grayImage.size, NO, grayImage.scale);
        [grayImage drawInRect:imageRect];
        grayImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    CGContextRelease(context);
    CGImageRelease(imageRef);
    return grayImage;
}

/**
 gif转图片

 @param gifData gifData
 @return gif图片
 */
+ (UIImage *)animatedImageWithAnimatedGifData:(NSData *)gifData
{
    return animatedImageWithAnimatedGIFReleasingImageSource(CGImageSourceCreateWithData(toCF gifData, NULL));
}

/**
 gif转图片

 @param gifUrl gif链接
 @return gif图片
 */
+ (UIImage *)animatedImageWithAnimatedGifUrl:(NSURL *)gifUrl
{
    return animatedImageWithAnimatedGIFReleasingImageSource(CGImageSourceCreateWithURL(toCF gifUrl, NULL));
}


/**
 按比例缩放图片

 @param image 源图片
 @param scaleSize 缩放比例
 @return 缩放之后图片
 */
+ (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize {
    UIGraphicsBeginImageContext(CGSizeMake([UIScreen mainScreen].bounds.size.width * scaleSize, image.size.height * scaleSize));
    [image drawInRect:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width * scaleSize, image.size.height * scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

/**
 通过指定图片最长边，获得等比例的图片size

 @param image 原始图片
 @param imageLength 图片允许的最长宽度（高度）
 @return 获得等比例的size
 */
+ (CGSize)scaleImage:(UIImage *) image withLength:(CGFloat) imageLength
{
    CGFloat newWidth = 0.0f;
    CGFloat newHeight = 0.0f;
    CGFloat width = image.size.width;
    CGFloat height = image.size.height;
    if (width > imageLength || height > imageLength){
        if (width > height) {
            newWidth = imageLength;
            newHeight = newWidth * height / width;
        }else if(height > width){
            newHeight = imageLength;
            newWidth = newHeight * width / height;
        }else{
            newWidth = imageLength;
            newHeight = imageLength;
        }
    }else{
        return CGSizeMake(width, height);
    }
    return CGSizeMake(newWidth, newHeight);
}

/**
 获得指定size的图片

 @param image 原始图片
 @param newSize 指定的size
 @return 调整后的图片
 */
+ (UIImage *)resizeImage:(UIImage *) image withNewSize:(CGSize) newSize
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

/**
 根据颜色生成图片

 @param color 颜色
 @param size 尺寸
 @return 图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    if (!color || size.width <= 0 || size.height <= 0) return nil;
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width + 1, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

/**
 用于pods中图片加载

 @param imageName 图片名字,不包括@2x
 @param bundle 当前pods的名称
 @param targetClass 与当前图片同一pods的文件
 @return image
 */
+ (UIImage *)imagePathWithName:(NSString *)imageName bundle:(NSString *)bundle targetClass:(Class)targetClass {
    NSInteger scale = [[UIScreen mainScreen] scale];
    NSString *name = [NSString stringWithFormat:@"%@@%ldx.png",imageName,(long)scale];
    NSString *bundlePath = [[NSBundle bundleForClass:targetClass].resourcePath
                            stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@.bundle",bundle]];
    NSBundle *resource_bundle = [NSBundle bundleWithPath:bundlePath];
    UIImage *image = [UIImage imageNamed:name
                                inBundle:resource_bundle
           compatibleWithTraitCollection:nil];
    return image;
}


/**
 压缩图片到指定字节

 @param image 压缩的图片
 @param maxLength 压缩后最大字节大小
 @param maxWidth 压缩后最大字节大小
 @return 压缩后图片的二进制
 */
+ (NSData *)compressImage:(UIImage *)image toMaxLength:(NSInteger) maxLength maxWidth:(NSInteger)maxWidth
{
    NSAssert(maxLength > 0, @"图片的大小必须大于 0");
    NSAssert(maxWidth > 0, @"图片的最大边长必须大于 0");
    CGSize newSize = [self scaleImage:image withLength:maxWidth];
    UIImage *newImage = [self resizeImage:image withNewSize:newSize];
    CGFloat compress = 0.9f;
    NSData *data = UIImageJPEGRepresentation(newImage, compress);
    while (data.length > maxLength && compress > 0.01) {
        compress -= 0.02f;
        data = UIImageJPEGRepresentation(newImage, compress);
    }
    return data;
}

/**
 压缩图片到指定文件大小

 @param image 图片
 @param kb 大小
 @return 压缩后图片
 */
+ (NSData *)compressOriginalImage:(UIImage *)image toMaxDataSizeKBytes:(CGFloat)kb{
    if (!image) {
        return nil;
    }
    if (kb<1) {
        return UIImageJPEGRepresentation(image, 1.0);
    }
    kb*=1024;
    CGFloat compression = 0.9f;
    CGFloat maxCompression = 0.1f;
    NSData *imageData = UIImageJPEGRepresentation(image, compression);
    while ([imageData length] > kb && compression > maxCompression) {
        compression -= 0.1;
        imageData = UIImageJPEGRepresentation(image, compression);
    }
     NSLog(@"当前大小:%fkb",(float)[imageData length]/1024.0f);
    return imageData;
}

/**
 将原图进行旋转，只能选择上下左右四个方向

 @param orientation 旋转的方向
 @return 处理完的图片
 */
- (UIImage *)imageWithOrientation:(UIImageOrientation)orientation
{
    if (orientation == UIImageOrientationUp) {
        return self;
    }
    
    CGSize contextSize = self.size;
    if (orientation == UIImageOrientationLeft || orientation == UIImageOrientationRight) {
        contextSize = CGSizeMake(contextSize.height, contextSize.width);
    }
    
    contextSize = CGSizeFlatSpecificScale(contextSize, self.scale);
    
    UIGraphicsBeginImageContextWithOptions(contextSize, NO, self.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextInspectContext(context);
    
    // 画布的原点在左上角，旋转后可能图片就飞到画布外了，所以旋转前先把图片摆到特定位置再旋转，图片刚好就落在画布里
    switch (orientation) {
        case UIImageOrientationUp:
            // 上
            break;
        case UIImageOrientationDown:
            // 下
            CGContextTranslateCTM(context, contextSize.width, contextSize.height);
            CGContextRotateCTM(context, AngleWithDegrees(180));
            break;
        case UIImageOrientationLeft:
            // 左
            CGContextTranslateCTM(context, 0, contextSize.height);
            CGContextRotateCTM(context, AngleWithDegrees(-90));
            break;
        case UIImageOrientationRight:
            // 右
            CGContextTranslateCTM(context, contextSize.width, 0);
            CGContextRotateCTM(context, AngleWithDegrees(90));
            break;
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            // 向上、向下翻转是一样的
            CGContextTranslateCTM(context, 0, contextSize.height);
            CGContextScaleCTM(context, 1, -1);
            break;
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            // 向左、向右翻转是一样的
            CGContextTranslateCTM(context, contextSize.width, 0);
            CGContextScaleCTM(context, -1, 1);
            break;
    }
    
    // 在前面画布的旋转、移动的结果上绘制自身即可，这里不用考虑旋转带来的宽高置换的问题
    [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    
    UIImage *imageOut = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imageOut;
}

@end
