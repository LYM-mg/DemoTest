//
//  MGCar.h
//  OC版--TbaleView索引高仿
//
//  Created by i-Techsys.com on 17/4/6.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MGCar : NSObject

/**
 *  图标
 */
@property (nonatomic, copy) NSString *icon;
/**
 *  名称
 */
@property (nonatomic, copy) NSString *name;


/**
 *  便利构造方法
 */
+ (instancetype)carWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;

@end
