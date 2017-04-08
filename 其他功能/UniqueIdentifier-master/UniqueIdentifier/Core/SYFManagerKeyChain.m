//
//  SYFManagerKeyChain.m
//  Keychain存储数据
//
//  Created by 孙云 on 16/8/2.
//  Copyright © 2016年 haidai. All rights reserved.
//

#import "SYFManagerKeyChain.h"
#import "SYFKeyChain.h"
@implementation SYFManagerKeyChain
//增加一个
+ (void)addDataToKeyChain:(NSString *)chainKey dataString:(id)dataString{

    [SYFKeyChain addData:dataString forService:chainKey];
}
//搜索一个
+ (NSString *)queryDataToKeyChain:(NSString *)chainKey{

   return (NSString *)[SYFKeyChain queryDataWithService:chainKey];
}
//更新一个
+ (void)updateDatatKeyChain:(NSString *)chainKey dataString:(id)dataString{

    [SYFKeyChain updateData:dataString forService:chainKey];
}
//删除一个
+ (void)deleteDataKeyChain:(NSString *)chainKey{

    [SYFKeyChain deleteDataWithService:chainKey];
}
@end
