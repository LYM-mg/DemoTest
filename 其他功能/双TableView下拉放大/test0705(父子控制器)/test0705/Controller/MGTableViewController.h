//
//  MGTableViewController.h
//  test0705
//
/*
 @简书：http://www.jianshu.com/users/57b58a39b70e/latest_articles
 @github：https://github.com/LYM-mg
 
 Copyright © 2016年 ming. All rights reserved.
 */

#import <UIKit/UIKit.h>
#import "MGScrollViewProtocl.h"

@interface MGTableViewController : UITableViewController
@property (weak,nonatomic) id<MGScrollViewProtocl> mg_delegate;
@end
