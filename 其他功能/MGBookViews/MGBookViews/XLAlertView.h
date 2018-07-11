//
//  XLAlertView.h
//  NewUnion
//
//  Created by newunion on 16/2/25.
//  Copyright © 2016年 NewUnion. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CallBackBlock)(id);

@interface XLAlertView : UIView

@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIImageView *closeImgView;
@property (nonatomic,copy) NSString *forceUpdate;
@property (nonatomic, strong) CallBackBlock ensureButtonDidClicked;
@property (nonatomic, strong) CallBackBlock closeButtonDidClicked;
+(instancetype)instanceWithTitle:(NSString *)title forceUpdate:(NSString *)forceUpdate withContent:(NSString *)content withEnsureBlock:(CallBackBlock)ensureBlock withCloseBlock:(CallBackBlock)closeBlock;

@end
