//
//  MGKeychainTool.m
//  UniqueIdentifier
//
//  Created by i-Techsys.com on 17/4/7.
//  Copyright © 2017年 ming. All rights reserved.
//

#import "MGKeychainTool.h"

@implementation MGKeychainTool
// 根据sKey去获取他对应的在文件里面的数据字典
+ (NSMutableDictionary *)getKeychainQuery:(NSString *)sKey{
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (__bridge_transfer id)kSecClassGenericPassword,
            (__bridge_transfer id)kSecClass,sKey,
            (__bridge_transfer id)kSecAttrService,sKey,
            (__bridge_transfer id)kSecAttrGeneric,
            (__bridge_transfer id)kSecAttrAccessibleAfterFirstUnlock,
            (__bridge_transfer id)kSecAttrAccessible,
            nil];
}

/**
 *  储存字符串到🔑钥匙串
 *
 *  @param sValue 对应的Value
 *  @param sKey   对应的Key
 *
 *  @return 返回是否储存成功
 */
+ (BOOL)saveKeychainValue:(NSString *)sValue key:(NSString *)sKey{
    NSMutableDictionary * keychainQuery = [self getKeychainQuery:sKey];
    SecItemDelete((__bridge_retained CFDictionaryRef)keychainQuery);
    
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:sValue] forKey:(__bridge_transfer id)kSecValueData];
    
    OSStatus status = SecItemAdd((__bridge_retained CFDictionaryRef)keychainQuery, NULL);
    return (status == noErr);
}

/**
 *  从🔑钥匙串获取字符串
 *
 *  @param sKey 对应的Key
 *
 *  @return 返回储存的Value
 */
+ (NSString *)readKeychainValue:(NSString *)sKey
{
    NSString *ret = nil;
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:sKey];
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(__bridge_transfer id)kSecReturnData];
    [keychainQuery setObject:(__bridge_transfer id)kSecMatchLimitOne forKey:(__bridge_transfer id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((__bridge CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            ret = (NSString *)[NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
        } @catch (NSException *e) {
            NSLog(@"Unarchive of %@ failed: %@", sKey, e);
        } @finally {
        }
    }
    if (keyData)
        CFRelease(keyData);
    return ret;
}

/**
 *  从🔑钥匙串更新数据
 *
 *  @param sKey 对应的Key
 *
 *  @return 返回更新新成功
 */
+ (BOOL)updateData:(id)data forService:(NSString *)sKey{
    NSMutableDictionary *searchDictionary = [self getKeychainQuery:sKey];
    
    if (!searchDictionary) {
        return NO;
    }
    NSMutableDictionary *updateDictionary = [[NSMutableDictionary alloc] init];
    [updateDictionary setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(id)kSecValueData];
    OSStatus status = SecItemUpdate((CFDictionaryRef)searchDictionary,
                                    (CFDictionaryRef)updateDictionary);
    return (status == errSecSuccess);
}

/**
 *  从🔑钥匙串删除字符串
 *
 *  @param sKey 对应的Key
 */
+ (BOOL)deleteKeychainValue:(NSString *)sKey {
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:sKey];
    OSStatus status = SecItemDelete((__bridge CFDictionaryRef)keychainQuery);
    return (status == noErr);
}

@end
