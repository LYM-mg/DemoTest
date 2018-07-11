//
//  JHYongHuHeaderview.m
//  StudyAbroad
//
//  Created by ming on 2018/7/2.
//  Copyright © 2018年 ming.com. All rights reserved.
//

#import "JHYongHuHeaderview.h"
#import "JHYongHuModel.h"
#import "JHHeaderTagView.h"
@interface JHYongHuHeaderview()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UIImageView *userIcoImageView;

@property (weak, nonatomic) IBOutlet UILabel *noteLabel;
//jigou
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;

@property (weak, nonatomic) IBOutlet UILabel *workAgeLabel;

@property (weak, nonatomic) IBOutlet UILabel *typeStudyLabel;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@property (weak, nonatomic) IBOutlet UILabel *value1Label;
@property (weak, nonatomic) IBOutlet UILabel *value2Label;
@property (weak, nonatomic) IBOutlet UILabel *value3Label;

@property (weak, nonatomic) IBOutlet UILabel *text1Label;
@property (weak, nonatomic) IBOutlet UILabel *text2Label;
@property (weak, nonatomic) IBOutlet UILabel *text3Label;



@property (weak, nonatomic) IBOutlet UIButton *gradeLabel;

@property (weak, nonatomic) IBOutlet UIButton *jiangxuejinButton;


//view
//@property (nonatomic,strong) CWStarRateView *starRateV;

@property (nonatomic,strong) UIView *userView;
@property (nonatomic,strong) UIView *appriseView;
@property (nonatomic,strong) UIView *skillView;
@property (nonatomic,strong) UIView *ArticleView;
@property (nonatomic,strong) UIView *userPhotoView;
@property (nonatomic,strong) UIView *moneyView;

@end


@implementation JHYongHuHeaderview
CGFloat viewHeight1 = 70;
CGFloat viewHeight2 = 80;
CGFloat viewHeight3 = 79;
CGFloat viewHeight4 = 90;
CGFloat viewHeight5 = 113;
CGFloat viewHeight6 = 57;

//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
//    if (self.hidden == YES || self.alpha == 0) {
//        return nil;
//    }
//    if (CGRectContainsPoint(self.titleView.frame, point)) {
//        return self;
//    }else if ([self isPointInsideTopView:point]) {
//        return self;
//    }else {
//        return [super hitTest:point withEvent:event];
//    }
//}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if (CGRectContainsPoint(self.titleView.frame, point)) {
        return YES;
    }else if ([self isPointInsideTopView:point]) {
        return YES;
    }else {
        return NO;
    }
}

- (BOOL)isPointInsideTopView:(CGPoint)point {
    
    CGFloat valueX = point.x - (self.bounds.size.width / 2);
    CGFloat valueY = fabs(point.y - fabs(self.bounds.size.height - self.userIcoImageView.size.height / 2));
    
    CGFloat distance = sqrt((valueX * valueX) + (valueY * valueY));
    
    if (distance < self.userIcoImageView.size.height / 2) {
        return YES;
    }else {
        return NO;
    }
}

- (void)awakeFromNib{
    [super awakeFromNib];
    self.gradeLabel.font = [UIFont systemFontOfSize:10];
    self.gradeLabel.layer.cornerRadius = 2.0;//2.0是圆角的弧度，
    
    self.jiangxuejinButton.layer.borderColor = [UIColor colorWithRed:250/255.0 green:135/255.0 blue:112/255.0 alpha:1].CGColor;//设置边框颜色
    self.jiangxuejinButton.layer.borderWidth = 1.0f;//设置边框颜色
    self.jiangxuejinButton.layer.cornerRadius = 2.0;//2.0是圆角的弧度，
 
   // [self setupView];
   
   CGFloat height = viewHeight1+viewHeight2+viewHeight3+viewHeight4+viewHeight5+viewHeight6;
    NSLog(@"%f",height);
}



- (void)layoutSubviews
{
    [super layoutSubviews];
    self.userIcoImageView.cornerRadius = self.userIcoImageView.jh_height * 0.5;
    self.userIcoImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.userIcoImageView.clipsToBounds = YES;
}

//- (void)setYongHuModel:(JHYongHuModel *)yongHuModel
//{
//    _yongHuModel = yongHuModel;
//
//    NSLog(@"%@",yongHuModel.nickname);
//    self.nameLabel.text = yongHuModel.nickname;
//    [self.userIcoImageView sd_setImageWithURL:[NSURL URLWithString:yongHuModel.avatar]];
//    [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:yongHuModel.portrait]];
//
////    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
////    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
////    effectView.frame = CGRectMake(0, 0, _bgImageView.frame.size.width, _bgImageView.frame.size.height);
////    self.effectView = effectView;
////    [self.bgImageView addSubview:effectView];
//
//    self.noteLabel.text = yongHuModel.note;
//    if ([yongHuModel.company isEqualToString:@""]) {
//        self.companyLabel.text = @"暂无机构认证";
//
//    }else{
//
//        self.companyLabel.text = [NSString stringWithFormat:@"· %@",yongHuModel.company];
//    }
//    self.workAgeLabel.text = yongHuModel.workingAge;
//    //self.typeStudyLabel.text =  yongHuModel.medal; // 机构认证 yongHuModel.identityText;
//    self.descriptionLabel.text = yongHuModel.signature;
//    self.addressLabel.text = [NSString stringWithFormat:@"· %@",yongHuModel.region];
//
//    //等级
//    if ([yongHuModel.grade isEqualToString:@"1"]) {
//
//        [self.gradeLabel setTitle:@"新手" forState:UIControlStateNormal];
//        [self.gradeLabel setTitleColor:[UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1] forState:UIControlStateNormal];
//        self.gradeLabel.layer.borderColor = [UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1].CGColor;//设置边框颜色
//        self.gradeLabel.layer.borderWidth = 1.0f;//设置边框颜色
//
//    }else if ([yongHuModel.grade isEqualToString:@"2"]){
//
//        [self.gradeLabel setTitle:@"铜牌" forState:UIControlStateNormal];
//        [self.gradeLabel setTitleColor:[UIColor colorWithRed:207/255.0 green:111/255.0 blue:27/255.0 alpha:1] forState:UIControlStateNormal];
//        self.gradeLabel.layer.borderColor = [UIColor colorWithRed:207/255.0 green:111/255.0 blue:27/255.0 alpha:1].CGColor;//设置边框颜色
//        self.gradeLabel.layer.borderWidth = 1.0f;//设置边框颜色
//
//    }else if ([yongHuModel.grade isEqualToString:@"3"]){
//        [self.gradeLabel setTitle:@"银牌" forState:UIControlStateNormal];
//        [self.gradeLabel setTitleColor:[UIColor colorWithRed:227/255.0 green:248/255.0 blue:255/255.0 alpha:1] forState:UIControlStateNormal];
//        self.gradeLabel.layer.borderColor = [UIColor colorWithRed:227/255.0 green:248/255.0 blue:255/255.0 alpha:1].CGColor;//设置边框颜色
//        self.gradeLabel.layer.borderWidth = 1.0f;//设置边框宽度
//
//    }else if ([yongHuModel.grade isEqualToString:@"4"]){
//        [self.gradeLabel setTitle:@"金牌" forState:UIControlStateNormal];
//        [self.gradeLabel setTitleColor:[UIColor colorWithRed:251/255.0 green:201/255.0 blue:3/255.0 alpha:1] forState:UIControlStateNormal];
//        self.gradeLabel.layer.borderColor = [UIColor colorWithRed:251/255.0 green:201/255.0 blue:3/255.0 alpha:1].CGColor;//设置边框颜色
//        self.gradeLabel.layer.borderWidth = 1.0f;//设置边框颜色
//
//    }
//
//    if ([yongHuModel.scholarshipSupport integerValue]) {
//        self.jiangxuejinButton.hidden = NO;
//     }else{
//        self.jiangxuejinButton.hidden = YES;
//
//    }
//
//    if (yongHuModel.medal == 0) {
//        self.typeStudyLabel.text = @" ";
//        //self.medalLabel.text = [NSString stringWithFormat:@"%zd",wddModel.medal];
//    }else{
//        YYCache *yyCache=[YYCache cacheWithName:@"badgeName"];
//        NSDictionary *dic= [yyCache objectForKey:@"badgeName"] ;
//
//        [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
//            if ([key isEqualToString:[NSString stringWithFormat:@"%zd",yongHuModel.medal]]) {
//                self.typeStudyLabel.text =[NSString stringWithFormat:@"%@",obj];
//            }
//
//        }];
//
//    }
//
//    //text
//    self.text1Label.text = yongHuModel.text1;
//    self.text2Label.text = yongHuModel.text2;
//    self.text3Label.text = yongHuModel.text3;
//
//    self.value1Label.text = yongHuModel.value1;
//    self.value2Label.text = yongHuModel.value2;
//    self.value3Label.text = yongHuModel.value3;
//
//
//
//}



@end
