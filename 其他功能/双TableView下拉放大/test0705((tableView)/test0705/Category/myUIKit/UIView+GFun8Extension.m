//
//  UIView+GFun8Extension.m
//  GFun8Show
//
//  Created by 赖锦浩 on 2016/11/4.
//  Copyright © 2016年 Day tease interaction. All rights reserved.
//

#import "UIView+GFun8Extension.h"

@implementation UIView (GFun8Extension)
+ (instancetype)jh_viewWithXib
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil ] lastObject];
}

- (void)setJh_x:(CGFloat)jh_x
{
    CGRect frame = self.frame;
    frame.origin.x = jh_x;
    self.frame = frame;
}

- (CGFloat)jh_x
{
    return self.frame.origin.x;
}

- (void)setJh_y:(CGFloat)jh_y
{
    CGRect frame = self.frame;
    frame.origin.y = jh_y;
    self.frame = frame;
}

- (CGFloat)jh_y
{
    return self.frame.origin.y;
}

- (void)setJh_width:(CGFloat)jh_width
{
    CGRect frame = self.frame;
    frame.size.width = jh_width;
    self.frame = frame;
}

- (CGFloat)jh_width
{
    return self.frame.size.width;
}

- (void)setJh_height:(CGFloat)jh_height
{
    CGRect frame = self.frame;
    frame.size.height = jh_height;
    self.frame = frame;
}

- (CGFloat)jh_height
{
    return self.frame.size.height;
}

- (void)setJh_centerX:(CGFloat)jh_centerX
{
    CGPoint center = self.center;
    center.x = jh_centerX;
    self.center = center;
}

- (CGFloat)jh_centerX
{
    return self.center.x;
}

- (void)setJh_centerY:(CGFloat)jh_centerY
{
    CGPoint center = self.center;
    center.y = jh_centerY;
    self.center = center;
}

- (CGFloat)jh_centerY
{
    return self.center.y;
}

- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)size
{
    return self.frame.size;
}


- (void)setCornerRadius:(CGFloat)cornerRadius {
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = YES;
    // 栅格化 - 提高性能
    // 设置栅格化后，图层会被渲染成图片，并且缓存，再次使用时，不会重新渲染
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
    //    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.layer.shouldRasterize = YES;
}




-(void)addShadow{
    [self addShadowColor:[UIColor blackColor] offset:CGSizeMake(0, 2)];
}


- (void)addShadowColor:(UIColor *)color
{
    [self addShadowColor:color offset:CGSizeMake(0, 2)];
}

-(void)addShadowColor:(UIColor *)color offset:(CGSize)offsert
{
    UIView * shadowView= [[UIView alloc] init];
    shadowView.backgroundColor = [UIColor whiteColor];
    // 禁止将 AutoresizingMask 转换为 Constraints
    shadowView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.superview insertSubview:shadowView belowSubview:self];
    // 添加 right 约束
    NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:shadowView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
    [self.superview addConstraint:rightConstraint];
    
    // 添加 left 约束
    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:shadowView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
    [self.superview addConstraint:leftConstraint];
    // 添加 top 约束
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:shadowView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    [self.superview addConstraint:topConstraint];
    // 添加 bottom 约束
    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:shadowView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    [self.superview addConstraint:bottomConstraint];
    shadowView.layer.shadowColor = color.CGColor;
    shadowView.layer.shadowOffset = offsert;
    shadowView.layer.shadowOpacity = 0.5;
    shadowView.layer.shadowRadius = 2;
    shadowView.clipsToBounds = NO;
    
}



 
@end
