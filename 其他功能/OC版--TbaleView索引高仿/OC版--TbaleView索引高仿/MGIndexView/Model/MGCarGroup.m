//
//  MGCarGroup.m
//  OC版--TbaleView索引高仿
//
//  Created by i-Techsys.com on 17/4/6.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

#import "MGCarGroup.h"
#import "MGCar.h"

@implementation MGCarGroup

+ (instancetype)groupWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        // 赋值标题
        self.title = dict[@"title"];
        
        //        [self setValue:_title forKey:@"title"];
        
        // 取出原来的字典数组
        NSArray *dictArray = dict[@"cars"];
        NSMutableArray *carArray = [NSMutableArray array];
        for (NSDictionary *dict in dictArray) {
            MGCar *car = [MGCar carWithDict:dict];
            [carArray addObject:car];
        }
        self.cars = carArray;
    }
    return self;
}

@end
