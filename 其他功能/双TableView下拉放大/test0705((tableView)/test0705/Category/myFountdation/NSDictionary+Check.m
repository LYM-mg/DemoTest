//
//  NSDictionary+Check.m
//  GFun8Show
//
//  Created by 赖锦浩 on 2016/11/4.
//  Copyright © 2016年 Day tease interaction. All rights reserved.
//

#import "NSDictionary+Check.h"

@implementation NSDictionary (Check)

/**
 *  判断字典是否为空
 *
 *  @param dict 字典对象
 *
 *  @return BOOL
 */
+ (BOOL)isNull:(NSDictionary *)dict
{
    if (dict == nil || dict == NULL) {
        return YES;
    }
    if ([dict isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if (dict == [NSDictionary alloc])
    {
        return YES;
    }
    if (![dict isKindOfClass:[NSDictionary class]]) {
        return YES;
    }
    if (dict.count == 0)
    {
        return YES;
    }
    
    return NO;
}

@end
