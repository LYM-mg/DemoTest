//
//  MGIndexViewController.m
//  OC版--TbaleView索引高仿
//
//  Created by i-Techsys.com on 17/4/6.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

#import "MGIndexViewController.h"
#import "MGIndexView.h"
#import "MGCar.h"
#import "MGCarGroup.h"


@interface MGIndexViewController () <UITableViewDataSource,UITableViewDelegate,MGIndexViewDelegate>
/* 数据源 **/
@property (nonatomic,strong)NSArray *groups;
@property (nonatomic,strong)NSMutableArray *letters;
@property (nonatomic,strong) UITableView *tabelView;
@property (nonatomic,strong) MGIndexView *indexView;
/** 记录右边边TableView是否滚动到的位置的Y坐标 */
@property (nonatomic,assign) CGFloat lastOffsetY;
/** 记录tableView是否向下滚动 */
@property (nonatomic,assign) BOOL isScrollDown;
// MARK: - 提示字母
@property (nonatomic,strong) UILabel *tipLetterlabel;

@end

@implementation MGIndexViewController

#pragma mark - Lazy
- (UILabel *)tipLetterlabel {
    if (!_tipLetterlabel) {
        _tipLetterlabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        _tipLetterlabel.center = self.view.center;
        _tipLetterlabel.textColor = [UIColor whiteColor];
        _tipLetterlabel.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
        _tipLetterlabel.font = [UIFont systemFontOfSize:32];
        _tipLetterlabel.textAlignment = NSTextAlignmentCenter;
        _tipLetterlabel.hidden = YES;
        [self.view addSubview:_tipLetterlabel];
    }
    return _tipLetterlabel;
}

- (NSMutableArray *)letters {
    if (!_letters) {
        _letters = [NSMutableArray new];
    }
    return _letters;
}

- (NSArray *)groups {
    if (_groups == nil) {
        // 初始化
        // 1.获得plist的全路径
        NSString *path = [[NSBundle mainBundle] pathForResource:@"cars_total.plist" ofType:nil];
        
        // 2.加载数组
        NSArray *dictArray = [NSArray arrayWithContentsOfFile:path];
        
        // 3.将dictArray里面的所有字典转成模型对象,放到新的数组中
        NSMutableArray *groupArray = [NSMutableArray array];
        for (NSDictionary *dict in dictArray) {
            // 3.1.创建模型对象
            MGCarGroup *group = [MGCarGroup groupWithDict:dict];
            
            // 3.2.添加模型对象到数组中
            [groupArray addObject:group];
        }
        
        // 4.赋值/以及给indexView赋值数据源
        _groups = groupArray;
    }
    return _groups;
}

- (UITableView *)tabelView {
    if (!_tabelView) {
        _tabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MGScreenW, MGScreenH)];
        _tabelView.backgroundColor = [UIColor orangeColor];
        _tabelView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _tabelView.dataSource = self;
        _tabelView.delegate = self;
    }
    
    return _tabelView;
}

- (MGIndexView *)indexView {
    if (!_indexView) {
        _indexView = [[MGIndexView alloc] initWithDelegate:self];
//        _indexView.deleagte = self;
//        _indexView.selectTitleColor = [UIColor redColor];
//        _indexView.normalTitleColor = [UIColor greenColor];
    }
    return _indexView;
}

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tabelView];
    self.indexView.selectedScaleAnimation = YES;
    [self.view addSubview:self.indexView];
    [self.view bringSubviewToFront:self.indexView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 数据源方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.groups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    MGCarGroup *group = self.groups[section];
    
    return group.cars.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 1.定义一个循环标识
    static NSString *ID = @"car";
    
    // 2.从缓存池中取出可循环利用cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    // 3.缓存池中没有可循环利用的cell
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    // 4.设置数据
    MGCarGroup *group = self.groups[indexPath.section];
    MGCar *car = group.cars[indexPath.row];
    
    cell.imageView.image = [UIImage imageNamed:car.icon];
    cell.textLabel.text = car.name;
    
    return cell;
}

/**
 *  第section组显示的头部标题
 */
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    MGCarGroup *group = self.groups[section];
    return group.title;
}

/**
 *  返回右边索引条显示的字符串数据
 */
//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
//    return [self.groups valueForKeyPath:@"title"];
//}

- (BOOL)prefersStatusBarHidden {
    return YES;
}



#pragma mark - UITableViewDelegate
#pragma mark - =============== 以下方法用来滚动 滚动  滚动 =================
// 头部即将消失
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    if ((tableView.isDragging)  && (!self.isScrollDown)) { // 手动拖拽并且是向上滚
        [MGNotificationCenter postNotificationName:MGWillDisplayHeaderViewNotification object:nil userInfo: @{@"section":@(section)}];
    }
}
// 头部完全消失
- (void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section {
    if (tableView.isDragging && self.isScrollDown) {
        [MGNotificationCenter postNotificationName:MGDidEndDisplayingHeaderViewNotification object:nil userInfo: @{@"section":@(section+1)}];
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.isScrollDown = (self.lastOffsetY < scrollView.contentOffset.y);
    self.lastOffsetY = scrollView.contentOffset.y;
}

#pragma mark - MGIndexViewDelegate
- (NSArray *)indexViewSectionIndexTitles:(MGIndexView *)indexView {
    for (MGCarGroup *group in self.groups) {
        [self.letters addObject:group.title];
    }
    return _letters;
}

- (int)indexView:(MGIndexView *)indexView sectionForSectionIndexTitle:(NSString *)title at:(NSInteger)index {
    [self.tabelView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    // 弹出首字母提示
    [self showLetter:title];
    return (int)index;
}

- (void)indexView:(MGIndexView *)indexView cancelTouch:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [UIView animateWithDuration:1.0 animations:^{
        self.tipLetterlabel.hidden = YES;
    }];
}

// 弹出首字母提示
- (void)showLetter:(NSString *)title {
    self.tipLetterlabel.hidden = NO;
    self.tipLetterlabel.text = title;
}

@end
