//
//  NSObject+Check.h
//  GFun8Show
//
//  Created by 赖锦浩 on 2016/11/4.
//  Copyright © 2016年 Day tease interaction. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Check)

/**
 *  判断对象是否为空
 *
 *  @param object 对象
 *
 *  @return BOOL
 */
+ (BOOL)isNullWithObject:(NSObject *)object;


/**
 *  判断Data是否为空
 *
 *  @param NSData 对象
 *
 *  @return BOOL
 */
+ (BOOL)isNullWithData:(NSData *)data;


/**
 *  判断字典是否为空
 *
 *  @param dict 字典对象
 *
 *  @return BOOL
 */
+ (BOOL)isNullWithDictionary:(NSDictionary *)dict;


/**
 *  判断数组是否为空
 *
 *  @param array 数组对象
 *
 *  @return BOOL
 */
+ (BOOL)isNullWithArray:(NSArray *)array;


/**
 *  判断字符串是否为空
 *
 *  @param str 字符串
 *
 *  @return BOOL
 */
+ (BOOL)isNullWithString:(NSString *)str;

- (BOOL)isNullWithString:(NSString *)str;
/**
 *  判断是否为手机号
 *
 *  @param mobile 手机号
 *
 *  @return BOOL
 */
+ (BOOL)isMobileNumberWithString:(NSString *)mobile;
- (BOOL)isMobileNumberWithString:(NSString *)mobile;

/**
 *  判断是否为手机号
 *
 *  @param mobile 手机号
 *
 *  @return BOOL
 */
+ (BOOL)isMobileNumberWithLong:(long long)mobile;



@end
