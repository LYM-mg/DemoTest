//
//  SYFKeyChain.h
//  Keychain存储数据
//
//  Created by 孙云 on 16/8/2.
//  Copyright © 2016年 haidai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYFKeyChain : NSObject
//根据特定的Service创建一个用于操作KeyChain的Dictionary
+ (NSMutableDictionary *)keyChainQueryDictionaryWithService:(NSString *)service;
//添加数据
+ (BOOL)addData:(NSString *)data forService:(NSString *)service;
//删除数据
+ (BOOL)deleteDataWithService:(NSString *)service;
//搜索数据
+ (id)queryDataWithService:(NSString *)service;
//更新数据
+ (BOOL)updateData:(NSString *)data forService:(NSString *)service;
@end
