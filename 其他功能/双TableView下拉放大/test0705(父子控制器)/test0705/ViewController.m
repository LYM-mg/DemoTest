//
//  ViewController.m
//  test0705

//  Copyright © 2018年 lion. All rights reserved.
//

#import "ViewController.h"
#import "JHYongHuXQVC.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)click:(id)sender {

    JHYongHuXQVC *vc = [[JHYongHuXQVC alloc] init];
    
    [self presentViewController:vc animated:YES completion:nil];
    
//    [self.navigationController pushViewController:<#(nonnull UIViewController *)#> animated:<#(BOOL)#>]
    
    
}

@end
