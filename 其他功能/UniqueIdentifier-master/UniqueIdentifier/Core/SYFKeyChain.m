//
//  SYFKeyChain.m
//  Keychain存储数据
//
//  Created by 孙云 on 16/8/2.
//  Copyright © 2016年 haidai. All rights reserved.
//

#import "SYFKeyChain.h"

@implementation SYFKeyChain

//根据service去获取他对应的在文件里面的数据字典
+ (NSMutableDictionary *)keyChainQueryDictionaryWithService:(NSString *)service{
    
    NSMutableDictionary *keyChainQueryDictaionary = [[NSMutableDictionary alloc]init];
    [keyChainQueryDictaionary setObject:(id)kSecClassGenericPassword forKey:(id)kSecClass];
    [keyChainQueryDictaionary setObject:service forKey:(id)kSecAttrService];
    [keyChainQueryDictaionary setObject:service forKey:(id)kSecAttrGeneric];
    return keyChainQueryDictaionary;
}

//往本地数据字典里面去添加自己的数据
+ (BOOL)addData:(NSString *)data forService:(NSString *)service{
    NSMutableDictionary * keychainQuery = [self keyChainQueryDictionaryWithService:service];
    SecItemDelete((__bridge_retained CFDictionaryRef)keychainQuery);
    
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(__bridge_transfer id)kSecValueData];
    
    OSStatus status = SecItemAdd((__bridge_retained CFDictionaryRef)keychainQuery, NULL);
    if (status == noErr) {
        return YES;
    }
//    NSMutableDictionary *keychainQuery = [self keyChainQueryDictionaryWithService:service];
//    SecItemDelete((CFDictionaryRef)keychainQuery);
//    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(id)kSecValueData];
//    OSStatus status= SecItemAdd((CFDictionaryRef)keychainQuery, NULL);
//    SecItemAdd((CFDictionaryRef)keychainQuery, NULL);
//    NSLog(@"%d",(int)status);
//    if (status == noErr) {
//        return YES;
//    }
    return NO;
}
//获取对应的数据
+ (id)queryDataWithService:(NSString *)service {
    id result;
    NSMutableDictionary *keyChainQuery = [self keyChainQueryDictionaryWithService:service];
    [keyChainQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    [keyChainQuery setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((CFDictionaryRef)keyChainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            result = [NSKeyedUnarchiver  unarchiveObjectWithData:(__bridge NSData *)keyData];
        }
        @catch (NSException *exception) {
            NSLog(@"不存在数据");
        }
        @finally {
            
        }
    }
    if (keyData) {
        CFRelease(keyData);
    }
    return result;
}
//更新对应的service 的数据
+ (BOOL)updateData:(NSString *)data forService:(NSString *)service{
    NSMutableDictionary *searchDictionary = [self keyChainQueryDictionaryWithService:service];
    
    if (!searchDictionary) {
        return NO;
    }
    NSMutableDictionary *updateDictionary = [[NSMutableDictionary alloc] init];
    [updateDictionary setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(id)kSecValueData];
    OSStatus status = SecItemUpdate((CFDictionaryRef)searchDictionary,
                                    (CFDictionaryRef)updateDictionary);
    if (status == errSecSuccess) {
        return YES;
    }
    return NO;
}

//删除不用的本地数据
+ (BOOL)deleteDataWithService:(NSString *)service{
    NSMutableDictionary *keyChainDictionary = [self keyChainQueryDictionaryWithService:service];
    OSStatus status = SecItemDelete((CFDictionaryRef)keyChainDictionary);
    if (status == noErr) {
        return YES;
    }
    return NO;
}

@end
