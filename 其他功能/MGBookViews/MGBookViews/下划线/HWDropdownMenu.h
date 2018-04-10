//
//  HWDropdownMenu.h
//
//  Created by apple on 14-10-8.
//  Copyright (c) 2014年 ming. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DropdownMenuType){
    up,
    down
};

@class HWDropdownMenu;

@protocol HWDropdownMenuDelegate <NSObject>
@optional
- (void)dropdownMenuDidDismiss:(HWDropdownMenu *)menu;
- (void)dropdownMenuDidShow:(HWDropdownMenu *)menu;
@end

@interface HWDropdownMenu : UIView
@property (nonatomic, weak) id<HWDropdownMenuDelegate> delegate;

+ (instancetype)menu;

- (instancetype)initWithType:(DropdownMenuType)type;

/**
 *  显示
 */
- (void)showFrom:(UIView *)from;
/**
 *  销毁
 */
- (void)dismiss;

/**
 *  内容
 */
@property (nonatomic, strong) UIView *content;
/**
 *  内容控制器
 */
@property (nonatomic, strong) UIViewController *contentController;
@end
