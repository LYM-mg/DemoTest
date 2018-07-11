//
//  UILabel+JHExtension.h
//  仿蘑菇街首页 - Lion
//
//  Created by ming on 16/10/19.
//  Copyright © 2016年 会跳舞的狮子. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (JHExtension)
+ (UILabel *)label;

- (instancetype)set;

- (UILabel *(^)(NSString *))jh_text;

- (UILabel *(^)(UIColor *))jh_textColor;

- (UILabel *(^)(NSTextAlignment))jh_textAlignment;

- (UILabel *(^)(UIFont *))jh_font;

- (UILabel *(^)(NSInteger))jh_numberOfLines;
@end
