//
//  JHYongHuHeaderview.h
//  StudyAbroad
//
//  Created by ming on 2018/7/2.
//  Copyright © 2018年 ming.com. All rights reserved.
//

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

@property (strong,nonatomic) JHHeaderTagView *titleView;

@end
