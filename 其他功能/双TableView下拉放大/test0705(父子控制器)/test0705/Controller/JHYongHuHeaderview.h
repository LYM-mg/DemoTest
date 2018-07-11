//
//  JHYongHuHeaderview.h
//  StudyAbroad
/*
    @简书：http://www.jianshu.com/users/57b58a39b70e/latest_articles
    @github：https://github.com/LYM-mg

    Copyright © 2016年 ming. All rights reserved.
 */


#import <UIKit/UIKit.h>
@class JHYongHuModel,JHHeaderTagView;
#import "UIView+GFun8Extension.h"
@interface JHYongHuHeaderview : UIView
@property (weak, nonatomic) IBOutlet UIView *contentView1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *BGView;

@property(nonatomic,strong) JHYongHuModel *yongHuModel;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (nonatomic,strong)UIVisualEffectView *effectView;
@property (weak, nonatomic) IBOutlet UIView *bgHUDView;

@property (weak,nonatomic) JHHeaderTagView *titleView;

@end
