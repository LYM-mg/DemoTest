//
//  NSObject+Check.m
//  GFun8Show
//
//  Created by 赖锦浩 on 2016/11/4.
//  Copyright © 2016年 Day tease interaction. All rights reserved.
//

#import "NSObject+Check.h"

@implementation NSObject (Check)

/**
 *  判断对象是否为空
 *
 *  @param object 对象
 *
 *  @return BOOL
 */
+ (BOOL)isNullWithObject:(NSObject *)object
{
    if (object == nil || object == NULL) {
        return YES;
    }
    if ([object isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if (object == [NSObject alloc])
    {
        return YES;
    }
    return NO;
}


/**
 *  判断Data是否为空
 *
 *  @param NSData 对象
 *
 *  @return BOOL
 */
+ (BOOL)isNullWithData:(NSData *)data
{
    if (data == nil || data == NULL) {
        return YES;
    }
    if ([data isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if (data == [NSData alloc])
    {
        return YES;
    }
    if (![data isKindOfClass:[NSData class]])
    {
        return YES;
    }
    if (data.length == 0) {
        return YES;
    }
    
    return NO;
}


/**
 *  判断字典是否为空
 *
 *  @param dict 字典对象
 *
 *  @return BOOL
 */
+ (BOOL)isNullWithDictionary:(NSDictionary *)dict
{
    if (dict == nil || dict == NULL) {
        return YES;
    }
    if ([dict isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if (dict == [NSDictionary alloc])
    {
        return YES;
    }
    if (![dict isKindOfClass:[NSDictionary class]]) {
        return YES;
    }
    if (dict.count == 0)
    {
        return YES;
    }
    
    return NO;
}


/**
 *  判断数组是否为空
 *
 *  @param array 数组对象
 *
 *  @return BOOL
 */
+ (BOOL)isNullWithArray:(NSArray *)array
{
    if (array == nil || array == NULL) {
        return YES;
    }
    if ([array isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if (array == [NSArray alloc])
    {
        return YES;
    }
    if (![array isKindOfClass:[NSArray class]]) {
        return YES;
    }
    if (array.count == 0)
    {
        return YES;
    }
    
    return NO;
}


/**
 *  判断字符串是否为空
 *
 *  @param str 字符串
 *
 *  @return BOOL
 */
+ (BOOL)isNullWithString:(NSString *)str
{
    if (str == nil || str == NULL) {
        return YES;
    }
    if ([str isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if (str == [NSString alloc]) {
        return YES;
    }
    if (![str isKindOfClass:[NSString class]]) {
        return YES;
    }
    if (str.length == 0) {
        return YES;
    }
    return NO;
}
- (BOOL)isNullWithString:(NSString *)str
{
    if (str == nil || str == NULL) {
        return YES;
    }
    if ([str isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if (str == [NSString alloc]) {
        return YES;
    }
    if (![str isKindOfClass:[NSString class]]) {
        return YES;
    }
    if (str.length == 0) {
        return YES;
    }
    return NO;
}


/**
 *  判断是否为手机号
 *
 *  @param mobile 手机号
 *
 *  @return BOOL
 */
+ (BOOL)isMobileNumberWithString:(NSString *)mobile
{
    // 空值判断
    if ([self isNullWithString:mobile]) {
        return NO;
    }
    
    // 判断是否为1开头的11为数字
    NSString *MOBILE = @"^1\\d{10}$";
    //"^((13[0-9])|(147)|(15[0-3,5-9])|(18[0,0-9])|(17[0-3,5-9]))\\d{8}$"
    //正则判断
    NSPredicate *regextestMobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    BOOL result = [regextestMobile evaluateWithObject:mobile];
    
    return result;
}

- (BOOL)isMobileNumberWithString:(NSString *)mobile
{
    // 空值判断
    if ([self isNullWithString:mobile]) {
        return NO;
    }
    
    // 判断是否为1开头的11为数字
    NSString *MOBILE = @"^1\\d{10}$";
    //"^((13[0-9])|(147)|(15[0-3,5-9])|(18[0,0-9])|(17[0-3,5-9]))\\d{8}$"
    //正则判断
    NSPredicate *regextestMobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    BOOL result = [regextestMobile evaluateWithObject:mobile];
    
    return result;
}

/**
 *  判断是否为手机号
 *
 *  @param mobile 手机号
 *
 *  @return BOOL
 */
+ (BOOL)isMobileNumberWithLong:(long long)mobile
{
    NSString *mobileStr = [NSString stringWithFormat:@"%lld",mobile];
    return [self isMobileNumberWithString:mobileStr];
}

@end
