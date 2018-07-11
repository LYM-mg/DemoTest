//
//  NSDictionary+string.m
//  GFun8Show
//
//  Created by ming on 2016/11/4.
//  Copyright © 2016年 Day tease interaction. All rights reserved.
//

#import "NSDictionary+string.h"
#import "NSObject+Check.h"

@implementation NSDictionary (string)

/**
 *  将字典转换为Json字符串
 *
 *  @return Json字符串
 */
- (NSString *)converToString
{
    return [NSDictionary converToStringWithDictionary:self];
}



/**
 *  将字典转换为Json字符串
 *
 *  @param dict 字典对象
 *
 *  @return Json字符串
 */
+ (NSString *)converToStringWithDictionary:(NSDictionary *)dict
{
    // 空值判断
    if ([NSObject isNullWithDictionary:dict]) {
         return nil;
    }
    
    // 将字典转换为NSData, 并打印错误消息
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    if(error) {
     }
    
    // 将NSData转字符串
    NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    jsonStr = [jsonStr stringByReplacingOccurrencesOfString:@"\n  " withString:@""];
    jsonStr = [jsonStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    jsonStr = [jsonStr stringByReplacingOccurrencesOfString:@" : " withString:@":"];
    
    return jsonStr;
}



@end
