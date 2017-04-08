//
//  SYFManagerKeyChain.h
//  Keychain存储数据
//
//  Created by 孙云 on 16/8/2.
//  Copyright © 2016年 haidai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYFManagerKeyChain : NSObject
+ (void)addDataToKeyChain:(NSString *)chainKey dataString:(id)dataString;
+ (NSString *)queryDataToKeyChain:(NSString *)chainKey;
+ (void)updateDatatKeyChain:(NSString *)chainKey dataString:(id)dataString;
+ (void)deleteDataKeyChain:(NSString *)chainKey;
@end
