//
//  UILabel+JHExtension.m
//  仿蘑菇街首页 - Lion
//
//  Created by ming on 16/10/19.
//  Copyright © 2016年 会跳舞的狮子. All rights reserved.
//

#import "UILabel+JHExtension.h"

@implementation UILabel (JHExtension)
+ (UILabel *)label {
    return [[self alloc]init];
}

- (instancetype)set {
    return self;
}

- (UILabel *(^)(NSString *))jh_text {
    return ^(NSString * text) {
        self.text = text;
        return self;
    };
}

- (UILabel *(^)(UIColor *))jh_textColor {
    return ^(UIColor * textColor) {
        self.textColor = textColor;
        return self;
    };
}

- (UILabel *(^)(NSTextAlignment))jh_textAlignment {
    return ^(NSTextAlignment alignment) {
        self.textAlignment = alignment;
        return self;
    };
}

- (UILabel *(^)(UIFont *))jh_font {
    return ^(UIFont * font) {
        self.font = font;
        return self;
    };
}

- (UILabel *(^)(NSInteger))jh_numberOfLines {
    return ^(NSInteger numberOfLines) {
        self.numberOfLines = numberOfLines;
        return self;
    };
}

- (void)setAttributes {
    
}
@end
