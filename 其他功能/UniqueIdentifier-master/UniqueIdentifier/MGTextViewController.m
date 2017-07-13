//
//  MGTextViewController.m
//  UniqueIdentifier
//
//  Created by i-Techsys.com on 17/4/7.
//  Copyright © 2017年 ming. All rights reserved.
//

#import "MGTextViewController.h"
#import "MGKeychainTool.h"

@interface MGTextViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *password;
@end

@implementation MGTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor orangeColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// MARK: - Action
- (IBAction)read:(id)sender {
    self.userName.text = [NSString stringWithFormat:@"读取到用户名:%@",[MGKeychainTool readKeychainValue:@"userName"]];
    self.password.text = [NSString stringWithFormat:@"读取到用户密码:%@",[MGKeychainTool readKeychainValue:@"password"]];
    
}
- (IBAction)save:(id)sender {
    [MGKeychainTool saveKeychainValue:self.userName.text key:@"userName"];
    [MGKeychainTool saveKeychainValue:self.password.text key:@"password"];
}

- (IBAction)delete:(id)sender {
    [MGKeychainTool deleteKeychainValue:@"userName"];
    [MGKeychainTool deleteKeychainValue:@"password"];
}

- (IBAction)update:(id)sender {
    [MGKeychainTool updateData:@"许同志" key:@"userName"];
    [MGKeychainTool updateData:@"副会长" key:@"password"];
}

@end
