//
//  JHHeaderTagView.h
//  StudyAbroad
//
//  Created by ming on 2018/7/5.
//  Copyright © 2018年 ming.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+NE.h"

@interface JHHeaderTagView : UIView


@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, copy) void (^buttonSelected)(NSInteger index);


@end
