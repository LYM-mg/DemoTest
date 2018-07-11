//
//  MGTableViewController.m
//  test0705
//
/*
 @简书：http://www.jianshu.com/users/57b58a39b70e/latest_articles
 @github：https://github.com/LYM-mg
 
 Copyright © 2016年 ming. All rights reserved.
 */

#import "MGTableViewController.h"

@interface MGTableViewController ()

@end

@implementation MGTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - <UITableViewDataSource ,UITableViewDelegate>
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  100;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KBankFundsFlowTableViewCellID"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KBankFundsFlowTableViewCellID"];
    }
    
    cell.textLabel.text = @"111111111";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"当前点击了" message:[NSString stringWithFormat:@"%ld",(long)indexPath.item] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:nil];
    [vc addAction:cancel];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.mg_delegate) {
        [self.mg_delegate mg_scrollViewDidScroll:scrollView];
    }
}


@end
