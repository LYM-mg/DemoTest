//
//  MGIndexView.h
//  OC版--TbaleView索引高仿
//
//  Created by i-Techsys.com on 17/4/6.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MGIndexView,MGIndexViewDelegate;

// MARK: - MGIndexViewDelegate
@protocol MGIndexViewDelegate <NSObject>
// 手指触摸的时候调用
- (int)indexView:(MGIndexView *)indexView sectionForSectionIndexTitle:(NSString *)title at:(NSInteger)index;

@optional  // 不是必须实现的方法
// 返回数据源
- (NSArray *)indexViewSectionIndexTitles:(MGIndexView *)indexView;

// 手指离开的时候调用
- (void)indexView:(MGIndexView *)indexView  cancelTouch:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event;

@end


#pragma mark - MGIndexView
@interface MGIndexView : UIView
/** 代理 */
@property (nonatomic,weak) id<MGIndexViewDelegate> deleagte;

/** 默认false，选中的标题不需要放 */
@property (nonatomic,assign) BOOL selectedScaleAnimation;

/**  存放字母数组 */
@property (nonatomic,strong) NSMutableArray *letters;
/**  选中颜色 */
@property (nonatomic,strong) UIColor *selectTitleColor;
/**  正常颜色 */
@property (nonatomic,strong) UIColor *normalTitleColor;


// 便利构造方法
- (instancetype)initWithDelegate:(id<MGIndexViewDelegate>)delegate;

@end
