//
//  JHYongHuModel.h
//  StudyAbroad
//
/*
    @简书：http://www.jianshu.com/users/57b58a39b70e/latest_articles
    @github：https://github.com/LYM-mg

    Copyright © 2016年 ming. All rights reserved.
 */


#import <Foundation/Foundation.h>

@interface JHYongHuModel : NSObject

@property (nonatomic,strong) NSString *avatar;
@property (nonatomic,strong) NSString *nickname;
@property (nonatomic,strong) NSString *userId;
@property (nonatomic,strong) NSString *portrait; //背景图
@property (nonatomic,strong) NSString *note; //备注
@property (nonatomic,strong) NSString *grade;//等级
@property (nonatomic,strong) NSString *identity; //用户身份
@property (nonatomic,strong) NSString *identityText;//用户身份文本
@property (nonatomic,strong) NSString *company;//机构名称
@property (nonatomic,strong) NSString *workingAge;//从业年龄
@property (nonatomic,strong) NSString *medal; //勋章
@property (nonatomic,strong) NSString *signature;//个性签名
@property (nonatomic,strong) NSString *introduction; //简介
@property (nonatomic,strong) NSString *value1;
@property (nonatomic,strong) NSString *value2;
@property (nonatomic,strong) NSString *value3;
@property (nonatomic,strong) NSString *text1;
@property (nonatomic,strong) NSString *text2;
@property (nonatomic,strong) NSString *text3;
@property (nonatomic,strong) NSString *scholarshipSupport; //是否拥有奖学金标志
@property (nonatomic,strong) NSString *description; //描述
@property (nonatomic,strong) NSString *state;  //本人与该用户的关系
@property (nonatomic,strong) NSString *stateText; //下方文本的按钮
@property (nonatomic,strong) NSString *region;



@end
