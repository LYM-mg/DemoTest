//
//  JHHeaderTagView.h
//  StudyAbroad
/*
    @简书：http://www.jianshu.com/users/57b58a39b70e/latest_articles
    @github：https://github.com/LYM-mg

    Copyright © 2016年 ming. All rights reserved.
 */
//

#import <UIKit/UIKit.h>
#import "UIView+NE.h"

@interface JHHeaderTagView : UIView


@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, copy) void (^buttonSelected)(NSInteger index);


@end
