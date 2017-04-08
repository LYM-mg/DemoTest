//
//  MGKeychainTool.h
//  UniqueIdentifier
//
//  Created by i-Techsys.com on 17/4/7.
//  Copyright © 2017年 ming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Security/Security.h>

@interface MGKeychainTool : NSObject
/**
 *  储存字符串到🔑钥匙串
 *
 *  @param sValue 对应的Value
 *  @param sKey   对应的Key
 *
 *  @return 返回是否储存成功
 */
+ (BOOL)saveKeychainValue:(NSString *)sValue key:(NSString *)sKey;


/**
 *  从🔑钥匙串获取字符串
 *
 *  @param sKey 对应的Key
 *
 *  @return 返回储存的Value
 */
+ (NSString *)readKeychainValue:(NSString *)sKey;


/**
 *  从🔑钥匙串删除字符串
 *
 *  @param sKey 对应的Key
 *
 *  @return 返回是否删除成功
 */
+ (BOOL)deleteKeychainValue:(NSString *)sKey;

/**
 *  从🔑钥匙串更新数据
 *
 *  @param sKey 对应的Key
 *
 *  @return 返回更新新成功
 */
+ (BOOL)updateData:(id)data forService:(NSString *)sKey;

@end
