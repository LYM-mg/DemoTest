//
//  UIImage+GFun8Extension.m
//  GFun8Show
//
//  Created by 赖锦浩 on 2016/11/3.
//  Copyright © 2016年 会跳舞的狮子. All rights reserved.
//

#import "UIImage+GFun8Extension.h"

@implementation UIImage (GFun8Extension)
#pragma mark - 颜色生成图片
+ (UIImage *)jh_imageWithColor:(UIColor *)color {
    
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    // 获取当前位图上下文
    UIGraphicsBeginImageContext(rect.size);
    
    // 获取当前上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(ctx, color.CGColor);
    
    CGContextFillRect(ctx, rect);
    
    // 从上下文获取图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    // 关闭上下文
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)jh_imageWithColor:(UIColor*)color height:(CGFloat)height {
    
    CGRect r= CGRectMake(0.0f, 0.0f, 1.0f, height);
    UIGraphicsBeginImageContext(r.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, r);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


@end
