//
//  NSDictionary+Check.h
//  GFun8Show
//
//  Created by 赖锦浩 on 2016/11/4.
//  Copyright © 2016年 Day tease interaction. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Check)

/**
 *  判断字典是否为空
 *
 *  @param dict 字典对象
 *
 *  @return BOOL
 */
+ (BOOL)isNull:(NSDictionary *)dict;

@end
