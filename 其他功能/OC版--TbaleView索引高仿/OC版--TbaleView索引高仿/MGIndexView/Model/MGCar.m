//
//  MGCar.m
//  OC版--TbaleView索引高仿
//
//  Created by i-Techsys.com on 17/4/6.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

#import "MGCar.h"

@implementation MGCar


+ (instancetype)carWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

@end
