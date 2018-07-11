//
//  UIImage+GFun8Extension.h
//  GFun8Show
//
//  Created by ming on 2016/11/3.
//  Copyright © 2016年 会跳舞的狮子. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (GFun8Extension)

/**
 *  根据颜色生成一张尺寸为1*height的相同颜色图片
 *
 *  @param color 需要转换的颜色
 *
 *  @return 生成一张尺寸为1*height的相同颜色图片
 */
+ (UIImage *)jh_imageWithColor:(UIColor*)color height:(CGFloat)height;
/**
 *  根据颜色生成一张尺寸为1*1的相同颜色图片
 *
 *  @param color 需要转换的颜色
 *
 *  @return 生成一张尺寸为1*1的相同颜色图片
 */
+ (UIImage *)jh_imageWithColor:(UIColor *)color;


@end
