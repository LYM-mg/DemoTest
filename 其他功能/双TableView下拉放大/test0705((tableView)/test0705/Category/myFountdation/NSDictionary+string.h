//
//  NSDictionary+string.h
//  GFun8Show
//
//  Created by 赖锦浩 on 2016/11/4.
//  Copyright © 2016年 Day tease interaction. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (string)


/**
 *  将字典转换为Json字符串
 *
 *  @return Json字符串
 */
- (NSString *)converToString;



/**
 *  将字典转换为Json字符串
 *
 *  @param dict 字典对象
 *
 *  @return Json字符串
 */
+ (NSString *)converToStringWithDictionary:(NSDictionary *)dict;


@end
