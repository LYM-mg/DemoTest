//
//  JHYongHuXQVC.m
//  StudyAbroad
//
//  Created by ming on 2018/7/2.
//  Copyright © 2018年 ming.com. All rights reserved.
//

#import "JHYongHuXQVC.h"
#import "JHYongHuHeaderview.h"

#import "JHYongHuModel.h"

#import "JHHeaderTagView.h"
#import "JHContentScrollView.h"
#define JHScreenW [UIScreen mainScreen].bounds.size.width
#define JHScreenH [UIScreen mainScreen].bounds.size.height
#define kStatusBarHeight                           [[UIApplication sharedApplication] statusBarFrame].size.height

//cell
//#import "JHUserAppraiseCell.h"
//#import "JHAppraiseTagCell.h"
//#import "JHSkillCell.h"
//#import "JHArticleCell.h"
//#import "JHUserPhotoCell.h"

#define NNTitleHeight 45

@interface JHYongHuXQVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) JHYongHuHeaderview *hedaerView;
@property (nonatomic,strong) UITableView *yonghuTableView;
@property (nonatomic,strong) UITableView *yonghuTableView1;

//保存数据的数组
@property (nonatomic,strong) NSDictionary *dataArray;

@property (nonatomic,strong) JHYongHuHeaderview *headerV;
@property (nonatomic,strong) UIView *tableViewHeadView;

@property (nonatomic,strong) JHContentScrollView *scrollView;
@property (nonatomic, weak) JHHeaderTagView *titleView;



@end

@implementation JHYongHuXQVC
{
    UIView *navView;
    UIButton *leftBtn;
    UIButton *rightBtn;
    UILabel *titleLab;
    UILabel * blackTip;
    CGFloat tableH;
    
}

static NSString *kUserAppraiseCellID = @"JHUserAppraiseCell";
static NSString *kAppraiseTagCellID = @"JHAppraiseTagCell";
static NSString *kSkillCellID = @"JHSkillCell";
static NSString *kArticleCellID = @"JHArticleCell";
static NSString *kUserPhotoCellID = @"JHUserPhotoCell";

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
 
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    [self setupHeaderView];
    [self setTitleBar];
    [self setupLoadData];
    self.edgesForExtendedLayout                          = UIRectEdgeNone;

}

 

- (void)setupLoadData{
    
    
    
}


- (void)setupTableView{
    
    
    JHContentScrollView *scrollView           = [[JHContentScrollView alloc] init];
   // scrollView.delaysContentTouches           = NO;
    [self.view addSubview:scrollView];
    self.scrollView                           = scrollView;
    scrollView.pagingEnabled                  = YES;
    scrollView.showsVerticalScrollIndicator   = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.delegate                       = self;
    scrollView.contentSize                    = CGSizeMake(JHScreenW * 2, 0);
    UIView *headView                          = [[UIView alloc] init];
    headView.frame                            = CGRectMake(0, 0, JHScreenW, NNHeadViewHeight + NNTitleHeight);
    self.tableViewHeadView = headView;
    
    
    UITableView *yonghuTableView = [[UITableView alloc] init];
    self.yonghuTableView = yonghuTableView;
//    yonghuTableView.frame = self.view.bounds;
    yonghuTableView.delegate = self;
    yonghuTableView.dataSource = self;
//    [self.view addSubview:yonghuTableView];
    yonghuTableView.tableHeaderView     = headView;
    [scrollView addSubview:yonghuTableView];
    [yonghuTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(scrollView);
        make.width.mas_equalTo(JHScreenW);
        make.top.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    UITableView *yonghuTableView1 = [[UITableView alloc] init];
    self.yonghuTableView1= yonghuTableView1;
    //    yonghuTableView.frame = self.view.bounds;
    yonghuTableView1.delegate = self;
    yonghuTableView1.dataSource = self;
    //    [self.view addSubview:yonghuTableView];
    yonghuTableView1.tableHeaderView     = headView;
    [scrollView addSubview:yonghuTableView1];
    [yonghuTableView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(scrollView).offset(JHScreenW);
        make.width.mas_equalTo(JHScreenW);
        make.top.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    
 
    // 头部
//    JHYongHuHeaderview *headerView =  [JHYongHuHeaderview jh_viewWithXib];
//    self.hedaerView = headerView;
//    yonghuTableView.tableHeaderView = headerView;
    
    
    //注册
   

}

/// tableView 的头部视图
- (void)setupHeaderView {
    JHYongHuHeaderview *headerView                     = [JHYongHuHeaderview jh_viewWithXib];
    headerView.frame                       = CGRectMake(0, -44, JHScreenW, NNHeadViewHeight  + NNTitleHeight);
    [self.view addSubview:headerView];
    self.headerV                        = headerView;
    
    JHHeaderTagView *titleView = [[JHHeaderTagView alloc] init];
    [headerView addSubview:titleView];
    headerView.titleView = titleView;
    self.titleView                         = titleView;
    titleView.backgroundColor              = [UIColor whiteColor];
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(headerView);
        make.bottom.equalTo(headerView.mas_bottom);
        make.height.mas_equalTo(NNTitleHeight);
    }];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.mas_equalTo(headerView.top);
    }];
    
    __weak typeof(self) weakSelf = self;
    titleView.titles             = @[@"动态", @"文章"];
    titleView.selectedIndex      = 0;
    titleView.buttonSelected     = ^(NSInteger index){
        [weakSelf.scrollView setContentOffset:CGPointMake(JHScreenW * index, 0) animated:YES];
    };
    
    [self.headerV layoutIfNeeded];
    [self.hedaerView layoutIfNeeded];
    [self.tableViewHeadView layoutIfNeeded];

//    self.headerV.userInteractionEnabled = NO;
//    [self.scrollView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)]];
}

//- (void)pan:(UIPanGestureRecognizer *)pan {
//    switch (pan.state) {
//        case UIGestureRecognizerStateBegan:
//            self.headerV.userInteractionEnabled = YES;
//            break;
//        case UIGestureRecognizerStateChanged:
//            self.headerV.userInteractionEnabled = NO;
//            break;
//        case UIGestureRecognizerStateEnded:
//            self.headerV.userInteractionEnabled = YES;
//            break;
//        default:
//            break;
//    }
//}

-(void)setTitleBar{
    
//    bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, DivceWidth, 180)];
//    bgImageView.contentMode = UIViewContentModeScaleAspectFill;
//    bgImageView.clipsToBounds = YES;
//    UITapGestureRecognizer *Tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTap:)];
//    [bgImageView addGestureRecognizer:Tap];
//    [self.view addSubview:bgImageView];
//
//
//    //模糊头像
//    [self.view insertSubview:bgImageView belowSubview:tableview];
//    
    UIView *navBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, JHScreenW, 44 + kStatusBarHeight)];
    [self.view addSubview:navBgView];
    //    navBgView.userInteractionEnabled = YES;
    
    navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, navBgView.width, navBgView.height)];
    navView.backgroundColor = [UIColor whiteColor];//mainColor;
    navView.alpha = 0;
    [navBgView addSubview:navView];
    
    UIButton *b = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, JHScreenW, 44)];
  //  [b addTarget:self action:@selector(toptapClick:) forControlEvents:UIControlEventTouchUpInside];
    [navBgView addSubview:b];
    
    
    leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, kStatusBarHeight, 44, 44)];
    [leftBtn setImage:[UIImage imageNamed:@"Icon_back-1"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    leftBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    [navBgView addSubview:leftBtn];
    
    rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(JHScreenW - 50, kStatusBarHeight, 44, 44)];
    [rightBtn setImage:[UIImage imageNamed:@"menu_icon-1"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [navBgView addSubview:rightBtn];
    
    titleLab = [[UILabel alloc]initWithFrame:CGRectMake(60, kStatusBarHeight, JHScreenW - 120, 44)];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.text = @"";
    titleLab.textColor = [UIColor colorWithRed:38/255.0 green:48/255.0 blue:53/255.0 alpha:1];
    titleLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];//[UIFont systemFontOfSize:TbarSize];
    [navBgView addSubview:titleLab];
    
    
}

#pragma mark- buttonClick

- (void)leftButtonClick:(UIButton *)sender
{
//    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - scrollView
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.scrollView) {
        CGFloat contentOffsetX       = scrollView.contentOffset.x;
        NSInteger pageNum            = contentOffsetX / JHScreenW + 0.5;
        self.titleView.selectedIndex = pageNum;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    
    
    
    if (scrollView == self.scrollView || !scrollView.window) {
        return;
    }
    CGFloat originY      = 0;
    CGFloat otherOffsetY = 0;
    if (offsetY <= NNHeadViewHeight -64) {
        originY              = -offsetY;
        if (offsetY < 0) {
            otherOffsetY         = 0;
        } else {
            otherOffsetY         = offsetY;
        }
    } else {
        originY              = -NNHeadViewHeight+64;
        otherOffsetY         = NNHeadViewHeight;
    }
    self.headerV.frame = CGRectMake(0, originY, JHScreenW, NNHeadViewHeight + NNTitleHeight);
    for ( int i = 0; i < self.titleView.titles.count; i++ ) {
        if (i != self.titleView.selectedIndex) {
            UITableView *contentView = self.scrollView.subviews[i];
            CGPoint offset = CGPointMake(0, otherOffsetY);
            if ([contentView isKindOfClass:[UITableView class]]) {
                if (contentView.contentOffset.y < NNHeadViewHeight-64 || offset.y < NNHeadViewHeight-64) {
                    [contentView setContentOffset:offset animated:NO];
                    self.scrollView.offset = offset;
                }
            }
        }
    }
    
    //---
    
    // 计算下当前最新的偏移量与最初的偏移量的差值
    CGFloat dealt = offsetY + 360;
    //    NSLog(@"%f-%f=%f",offsetY,_orignOffsetY,dealt);
    CGFloat pp = 360 - dealt;
    self.headerV.BGView.constant = 360+pp;
    self.headerV.bgHUDView.jh_height = 360+pp;

    if (pp <= 1.0) {
        self.headerV.BGView.constant = 360;
        self.headerV.bgHUDView.jh_height = 360;

    }
    NSLog(@"嘿嘿 = %f",self.headerV.contentView1.height);
    
    // 处理导航栏的透明度
    if (offsetY<0) {
        offsetY = 0;
    }
    CGFloat alpha = (offsetY) / (296-64  );
//    if (alpha >= 1.0) {
//        alpha = 0.99;
//    }
//    
   
    if (scrollView.contentOffset.y <= 0) {
        alpha = 0;
    }
    
    navView.alpha = alpha;
    titleLab.alpha = alpha;
    titleLab.text = @"用户详情";
    if (alpha >0.5){
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;

    }else{
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

    }
    if (alpha > 1) {
        leftBtn.frame = CGRectMake(10, kStatusBarHeight, 44, 44);
        [leftBtn setImage:[UIImage imageNamed:@"Icon _ Keyboard Arrow - Left _ Rounded"] forState:UIControlStateNormal];
        //[rightBtn setTitle:@"更多" forState:UIControlStateNormal];
        
        //rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(JHScreenW - 50, kStatusBarHeight, 44, 44)];
        [rightBtn setImage:[UIImage imageNamed:@"menu_icon-2"] forState:UIControlStateNormal];

        //[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }
    else
    {
        leftBtn.frame = CGRectMake(10, kStatusBarHeight, 44, 44);
        [leftBtn setImage:[UIImage imageNamed:@"Icon_back-1"] forState:UIControlStateNormal];
       // rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(JHScreenW - 50, kStatusBarHeight, 44, 44)];
        [rightBtn setImage:[UIImage imageNamed:@"menu_icon-1"] forState:UIControlStateNormal];
       // [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

    }
    //毛玻璃放大
    if (offsetY <= 0) {
//        self.hedaerView.effectView.transform = CGAffineTransformMakeScale(1 + ABS(offsetY) / 200.0, 1 + ABS(offsetY) / 200.0);
    }
    ///////
   
    
}

#pragma mark - dataSoure
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 9;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [UITableViewCell new];
    cell.textLabel.text = [NSString stringWithFormat:@"%zd",indexPath.row];
    return cell;
    
 
 
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 60;
    }
    return 118;
}

 
@end
