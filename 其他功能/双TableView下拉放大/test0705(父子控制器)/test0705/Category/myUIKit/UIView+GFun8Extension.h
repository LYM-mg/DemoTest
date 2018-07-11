//
//  UIView+GFun8Extension.h
//  GFun8Show
//
//  Created by ming on 2016/11/4.
//  Copyright © 2016年 Day tease interaction. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (GFun8Extension)
@property (nonatomic, assign) CGFloat jh_x;
@property (nonatomic, assign) CGFloat jh_y;
@property (nonatomic, assign) CGFloat jh_width;
@property (nonatomic, assign) CGFloat jh_height;
@property (nonatomic, assign) CGFloat jh_centerX;
@property (nonatomic, assign) CGFloat jh_centerY;
@property (nonatomic, assign)CGSize size;

//从xib里面加载View
+ (instancetype)jh_viewWithXib;
/// 圆角半径
@property (nonatomic, assign) IBInspectable CGFloat cornerRadius;
-(void)addShadowColor:(UIColor *)color offset:(CGSize)offsert;

@end
