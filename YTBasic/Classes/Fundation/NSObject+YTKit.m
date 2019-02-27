//
//  NSObject+YTKit.m
//  YTKit
//
//  Created by HellowWorld on 2018/7/14.
//  Copyright © 2018年 YNTCode. All rights reserved.
//

#import "NSObject+YTKit.h"
#import <objc/runtime.h>

@implementation NSObject (YTKit)
BOOL method_swizzle(Class klass, SEL origSel, SEL altSel)
{
    if (!klass)
        return NO;
    
    Method __block origMethod, __block altMethod;
    
    void (^find_methods)() = ^
    {
        unsigned methodCount = 0;
        Method *methodList = class_copyMethodList(klass, &methodCount);
        
        origMethod = altMethod = NULL;
        
        if (methodList)
            for (unsigned i = 0; i < methodCount; ++i)
            {
                if (method_getName(methodList[i]) == origSel)
                    origMethod = methodList[i];
                
                if (method_getName(methodList[i]) == altSel)
                    altMethod = methodList[i];
            }
        
        free(methodList);
    };
    
    find_methods();
    
    if (!origMethod)
    {
        origMethod = class_getInstanceMethod(klass, origSel);
        
        if (!origMethod)
            return NO;
        
        if (!class_addMethod(klass, method_getName(origMethod), method_getImplementation(origMethod), method_getTypeEncoding(origMethod)))
            return NO;
    }
    
    if (!altMethod)
    {
        altMethod = class_getInstanceMethod(klass, altSel);
        
        if (!altMethod)
            return NO;
        
        if (!class_addMethod(klass, method_getName(altMethod), method_getImplementation(altMethod), method_getTypeEncoding(altMethod)))
            return NO;
    }
    
    find_methods();
    
    if (!origMethod || !altMethod)
        return NO;
    
    method_exchangeImplementations(origMethod, altMethod);
    
    return YES;
}

void method_append(Class toClass, Class fromClass, SEL selector)
{
    if (!toClass || !fromClass || !selector)
        return;
    
    Method method = class_getInstanceMethod(fromClass, selector);
    
    if (!method)
        return;
    
    class_addMethod(toClass, method_getName(method), method_getImplementation(method), method_getTypeEncoding(method));
}

void method_replace(Class toClass, Class fromClass, SEL selector)
{
    if (!toClass || !fromClass || ! selector)
        return;
    
    Method method = class_getInstanceMethod(fromClass, selector);
    
    if (!method)
        return;
    
    class_replaceMethod(toClass, method_getName(method), method_getImplementation(method), method_getTypeEncoding(method));
}

/**
 获取当前类类名字符串
 
 @return 类名
 */
- (NSString *)className
{
    return NSStringFromClass([self class]);
}
/**
 获取当前类父类名字符串
 
 @return 父类名
 */
- (NSString *)superClassName
{
    return NSStringFromClass([self superclass]);
}
/**
 获取当前类类名字符串
 
 @return 类名
 */
+ (NSString *)className
{
    return NSStringFromClass([self class]);
}
/**
 获取当前类父类名字符串
 
 @return 父类名
 */
+ (NSString *)superClassName
{
    return NSStringFromClass([self superclass]);
}

/**
 实例属性字典

 @return 属性字典
 */
- (NSDictionary *)propertyDictionary
{
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    unsigned int outCount;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (int i = 0; i < outCount; i++) {
        objc_property_t prop = properties[i];
        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(prop) encoding:NSUTF8StringEncoding];
        id propertyValue = [self valueForKey:propertyName];
        [dict setObject:propertyValue forKey:propertyName];
    }
    free(properties);
    return dict;
}

/**
 获取所有属性名

 @return 属性名列表
 */
- (NSArray *)propertyList
{
    NSMutableArray *array = [NSMutableArray array];
    unsigned int outCount;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (int i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        const char *name = property_getName(property);
        [array addObject:[NSString stringWithUTF8String:name]];
    }
    free(properties);
    return array;
}

/**
 获取所有方法名

 @return 方法列表
 */
- (NSArray *)methodList
{
    NSMutableArray *array = [NSMutableArray array];
    u_int count;
    Method *methods = class_copyMethodList([self class], &count);
    for (int i = 0; i < count; i++) {
        SEL name = method_getName(methods[i]);
        NSString *methodName = [NSString stringWithCString:sel_getName(name) encoding:NSUTF8StringEncoding];
        [array addObject:methodName];
    }
    free(methods);
    return array;
}

/**
 替换方法

 @param originalMethod 源方法
 @param newMethod 替换方法
 */
+ (void)swizzleMethod:(SEL)originalMethod withMethod:(SEL)newMethod
{
    method_swizzle(self.class, originalMethod, newMethod);
}

+ (void)appendMethod:(SEL)newMethod fromClass:(Class)klass
{
    method_append(self.class, klass, newMethod);
}

+ (void)replaceMethod:(SEL)method fromClass:(Class)klass
{
    method_replace(self.class, klass, method);
}

+ (NSDictionary *)dictionaryWithJson:(id)json {
    if (!json) return nil;
    NSDictionary *dic = nil;
    NSData *jsonData = nil;
    if ([json isKindOfClass:[NSDictionary class]]) {
        dic = json;
    } else if ([json isKindOfClass:[NSString class]]) {
        jsonData = [(NSString *)json dataUsingEncoding : NSUTF8StringEncoding];
    } else if ([json isKindOfClass:[NSData class]]) {
        jsonData = json;
    }
    if (jsonData) {
        dic = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:NULL];
        if (![dic isKindOfClass:[NSDictionary class]]) dic = nil;
    }
    return dic;
}

/**
 字典转jsonstring
 */
- (NSString *)jsonStringWithDic:(NSDictionary *)dic
                      withError:(NSError *)error
{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;
    if (!jsonData) {
        NSLog(@"%@",error);
    }else{
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

- (NSDictionary *)classLogMessages
{
    return @{
             @"className": NSStringFromClass([self class]),
             @"threadName": [[NSThread currentThread] name]
             };
}


@end
