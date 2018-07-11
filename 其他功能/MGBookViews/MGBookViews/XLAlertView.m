//
//  XLAlertView.m
//  NewUnion
//
//  Created by newunion on 16/2/25.
//  Copyright © 2016年 NewUnion. All rights reserved.
//

#import "XLAlertView.h"
@interface XLAlertView ()
@property (weak, nonatomic) IBOutlet UIView *xBackgroundView;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UIButton *ensureButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeight;
@property (weak, nonatomic) IBOutlet UIImageView *topBackImg;

@end

@implementation XLAlertView

+(instancetype)instanceWithTitle:(NSString *)title forceUpdate:(NSString *)forceUpdate withContent:(NSString *)content withEnsureBlock:(CallBackBlock)ensureBlock withCloseBlock:(CallBackBlock)closeBlock {
    
    XLAlertView *alerView = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].lastObject;
    alerView.frame = [UIScreen mainScreen].bounds;
    alerView.contentView.layer.cornerRadius = 5;
    alerView.topBackImg.layer.cornerRadius = 5;
    alerView.topBackImg.clipsToBounds = YES;
//    alerView.contentView.clipsToBounds = YES;
    alerView.titleLabel.text = title;
    
    if ([forceUpdate isEqualToString:@"Y"]) {
        
        alerView.closeButton.hidden = YES;
        alerView.closeImgView.hidden = YES;
        
        
    }
    

    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    
    style.lineSpacing = 5;
    
    NSMutableAttributedString *contentString = [[NSMutableAttributedString alloc ]initWithString:content attributes:@{NSParagraphStyleAttributeName:style,NSForegroundColorAttributeName:[UIColor purpleColor],NSFontAttributeName:[UIFont systemFontOfSize:15]}];

    alerView.contentTextView.attributedText = contentString;

//    CGFloat contentTextViewHeight = alerView.contentViewHeight.constant - 140;
//    
//    CGSize size = [alerView.contentTextView sizeThatFits:CGSizeMake(alerView.contentViewWidth.constant - 30, contentTextViewHeight)];
//    
//    if (contentTextViewHeight > size.height) {
//        alerView.contentViewHeight.constant -= (contentTextViewHeight -  size.height);
//    }
    
    alerView.ensureButtonDidClicked = ensureBlock;
    alerView.closeButtonDidClicked = closeBlock;
    return alerView;
}

- (void)awakeFromNib {
    [super awakeFromNib];

//    self.contentViewWidth.constant = SCREEN_WIDTH*(321.0/414);
//    
//    self.contentViewHeight.constant = self.contentViewWidth.constant/(321.0/348.0);
//    
//    self.contentTextView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    self.contentView.layer.cornerRadius = 5;
    self.titleLabel.layer.cornerRadius = 13;
    
//    [Util setBtnBackImageWithColor:self.ensureButton color:[UIColor colorWithHexString:@"#f69125"] radius:5];
    
}

- (IBAction)closeButtonClicked:(id)sender {
    [self removeFromSuperview];
    if (self.closeButtonDidClicked) {
        self.closeButtonDidClicked(nil);
    }
}

- (IBAction)ensureButtonClicked:(id)sender {
    
    if (![self.forceUpdate isEqualToString:@"Y"]) {
        
        [self removeFromSuperview];
        
    }
    if (self.ensureButtonDidClicked) {
        self.ensureButtonDidClicked(nil);
    }
}

@end
