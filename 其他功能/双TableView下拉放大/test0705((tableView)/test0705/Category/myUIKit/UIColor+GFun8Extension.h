//
//  UIColor+GFun8Extension.h
//  GFun8Show
//
//  Created by 赖锦浩 on 2016/11/3.
//  Copyright © 2016年 会跳舞的狮子. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (GFun8Extension)
/**
 *  十六进制转颜色
 *
 *  @param hex 进制
 *
 *  @return RGB颜色
 */
+ (UIColor *)jh_colorFromHex:(NSInteger)hex;
/**
 *  十六进制转颜色
 *
 *  @param hex   十六进制数字
 *  @param alpha 透明度
 *
 *  @return RGB颜色
 */
+ (UIColor *)jh_colorFromHex:(NSInteger)hex alpha:(CGFloat)alpha;
/**
 *  十六进制转颜色
 *
 *   
 *
 *  @return RGB颜色
 */
+ (UIColor *)jh_colorWithHexString: (NSString *)color;


@end
