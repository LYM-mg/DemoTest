//
//  MGCarGroup.h
//  OC版--TbaleView索引高仿
//
//  Created by i-Techsys.com on 17/4/6.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MGCarGroup : NSObject

// 属性
/**
 *  这组的标题
 */
@property (nonatomic, copy) NSString *title;
/**
 *  存放的所有的汽车品牌(里面装的都是MJCar模型)
 */
@property (nonatomic, strong) NSArray *cars;

// 方法、
/**
 *  便利构造方法
 */
+ (instancetype)groupWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;

@end
