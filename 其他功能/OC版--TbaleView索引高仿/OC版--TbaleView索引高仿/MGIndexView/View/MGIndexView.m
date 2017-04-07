//
//  MGIndexView.m
//  OC版--TbaleView索引高仿
//
//  Created by i-Techsys.com on 17/4/6.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

#import "MGIndexView.h"

@class MGIndexViewDelegate;

@interface MGIndexView()
/**  存放字母按钮数组 */
@property (nonatomic,strong) NSMutableArray *letterButtons;
/**  当选中按钮 */
@property (nonatomic,strong) UIButton *selectedButton;
@end

@implementation MGIndexView

#pragma mark - Lazy
- (NSMutableArray *)letterButtons {
    if (!_letterButtons) {
        _letterButtons = [[NSMutableArray alloc] init];
    }
    return _letterButtons;
}

#pragma mark - 重写setter
- (void)setLetters:(NSMutableArray *)letters {
    _letters = letters;
    [self setUpUI];
}

- (void)setNormalTitleColor:(UIColor *)normalTitleColor {
    _normalTitleColor = normalTitleColor;
}
- (void)setSelectTitleColor:(UIColor *)selectTitleColor{
    _selectTitleColor = selectTitleColor;
}


#pragma mark - 系统方法
- (instancetype)initWithDelegate:(id<MGIndexViewDelegate>)delegate {
    if (self = [super init]) {
        self.deleagte = delegate;
        // 1.代理
        if (_deleagte != nil && [_deleagte respondsToSelector:@selector(indexViewSectionIndexTitles:)]) {
            self.letters = [NSMutableArray arrayWithArray:[_deleagte indexViewSectionIndexTitles:self]];
        }
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.frame = CGRectMake(MGScreenW - 20, 0, 18, MGScreenH);
        _selectedScaleAnimation = NO;
        _normalTitleColor = [UIColor grayColor];
        _selectTitleColor = [UIColor orangeColor];
        
        // 1.通知
        [MGNotificationCenter addObserver:self selector:@selector(scrollViewSelectButtonTitleColor:) name:MGWillDisplayHeaderViewNotification object:nil];
        [MGNotificationCenter addObserver:self selector:@selector(scrollViewSelectButtonTitleColor:) name:MGDidEndDisplayingHeaderViewNotification object:nil];
    }
    return self;
}

- (void)scrollViewSelectButtonTitleColor:(NSNotification *)noti {
    NSLog(@"section === %@", noti.userInfo[@"section"]);
    NSNumber *number = noti.userInfo[@"section"];
    int section = number.intValue;
    if (section >= self.letterButtons.count) { return; }
    UIButton *btn = self.letterButtons[section];

    [UIView animateWithDuration:1.0 animations:^{
        [self.selectedButton setTitleColor:self.normalTitleColor forState:UIControlStateNormal];
        self.selectedButton = btn;
        [self.selectedButton setTitleColor:self.selectTitleColor forState:UIControlStateNormal];
    }];
    
    if (self.selectedScaleAnimation) {
        btn.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1.5);
        [UIView animateWithDuration:1.0 animations:^{
            btn.layer.transform = CATransform3DIdentity;
        }];
    }
}

- (void)dealloc {
    NSLog(@"MGIndexView--dealloc"); // 释放观察者
    [MGNotificationCenter removeObserver:self];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self touchesMoved:touches withEvent:event];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = touches.anyObject;
    // 获取当前的触摸点
    CGPoint curP = [touch locationInView:self];
    
    for (UIButton *btn in _letterButtons) {
        // 把btn的转化为坐标
        CGPoint btnP = [self convertPoint:curP toView:btn];
        // 判断当前点是否点在按钮上
        if ([btn pointInside:btnP withEvent:event]) {
            self.selectedButton = btn;
            [btn setTitleColor:self.selectTitleColor forState:UIControlStateNormal];
            NSInteger i = [self.letterButtons indexOfObject:btn];
            NSString *letter = btn.currentTitle;
            
            if ([_deleagte respondsToSelector:@selector(indexView:sectionForSectionIndexTitle:at:)]) {
                [_deleagte indexView:self sectionForSectionIndexTitle:letter at:i];
            }
                        
            if (_selectedScaleAnimation) { // 是否需要放大效果
                btn.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1.5);
                [UIView animateWithDuration:1.0 animations:^{
                    btn.layer.transform = CATransform3DIdentity;
                }];
            }

        }else {
            [btn setTitleColor:self.normalTitleColor forState:UIControlStateNormal];
            btn.layer.transform = CATransform3DIdentity;
        }
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.selectedButton setTitleColor:self.selectTitleColor forState:UIControlStateNormal];
    if ([_deleagte respondsToSelector:@selector(indexView:cancelTouch:withEvent:)]) {
        [_deleagte indexView:self cancelTouch:touches withEvent:event];
    }
}

#pragma mark - 内部初始化方法
- (void)setUpUI {
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    [self.letterButtons removeAllObjects];
    
    
    CGFloat h = (MGScreenH == 480) ? 15 : 18;
    CGFloat x = 0;
    [self.letters enumerateObjectsUsingBlock:^(NSString*  _Nonnull letter, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat y = idx*(h);
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(x, y, self.frame.size.width, h)];
        [btn setTitle:letter forState:UIControlStateNormal];
        [btn setTitleColor:self.normalTitleColor forState:UIControlStateNormal];
        if (MGScreenH == 480) {
             btn.titleLabel.font = [UIFont systemFontOfSize:11];
        }else {
             btn.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
        }
       
        btn.userInteractionEnabled = NO;
        [self addSubview:btn];
        [self.letterButtons addObject:btn];
        
        if (idx == 0) {
            [btn setTitleColor:self.selectTitleColor forState:UIControlStateNormal];
            self.selectedButton = btn;
        }
    }];

    [self layoutIfNeeded];
    self.height = _letterButtons.count * h;
    self.center = CGPointMake(MGScreenW-10, MGScreenH*0.5);
}

@end
