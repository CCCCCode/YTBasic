//
//  NSObject+YTKit.h
//  YTKit
//
//  Created by HellowWorld on 2018/7/14.
//  Copyright © 2018年 YNTCode. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (YTKit)

/**
 获取当前类类名字符串
 
 @return 类名
 */
- (NSString *)className;

/**
 获取当前类父类名字符串
 
 @return 父类名
 */
- (NSString *)superClassName;

/**
 获取当前类类名字符串
 
 @return 类名
 */
+ (NSString *)className;

/**
 获取当前类父类名字符串
 
 @return 父类名
 */
+ (NSString *)superClassName;

/**
 实例属性字典

 @return 属性字典
 */
- (NSDictionary *)propertyDictionary;

/**
 获取所有属性名

 @return 属性名列表
 */
- (NSArray *)propertyList;

/**
 获取所有方法名

 @return 方法列表
 */
- (NSArray *)methodList;

/**
 替换方法

 @param originalMethod 源方法
 @param newMethod 替换方法
 */
+ (void)swizzleMethod:(SEL)originalMethod withMethod:(SEL)newMethod;

/**
 添加方法

 @param newMethod 新方法
 @param klass 类
 */
+ (void)appendMethod:(SEL)newMethod fromClass:(Class)klass;

/**
 替换方法

 @param method 替换方法
 @param klass 类
 */
+ (void)replaceMethod:(SEL)method fromClass:(Class)klass;

/**
 json 转 字典
 
 @param json jsonstring,jsondic,jsondata
 @return jsondic
 */
+ (NSDictionary *)dictionaryWithJson:(id)json;

/**
 字典转jsonstring
 */
- (NSString *)jsonStringWithDic:(NSDictionary *)dic
                      withError:(NSError *)error;

- (NSDictionary *)classLogMessages;
@end
