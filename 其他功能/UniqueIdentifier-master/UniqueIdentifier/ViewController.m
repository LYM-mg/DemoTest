//
//  ViewController.m
//  UniqueIdentifier
//
//  Created by 孙云飞 on 2017/2/24.
//  Copyright © 2017年 孙云飞. All rights reserved.
//

#import "ViewController.h"
#import "SYFManagerKeyChain.h"
#import "MGTextViewController.h"

static NSString *UUID_KEY = @"uuidKey";

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *tinLabel;
@property (weak, nonatomic) IBOutlet UILabel *uuidLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [[NSUUID UUID] UUIDString];
    //首先去获取本地数据uuid，看是否存在
    NSString *uuid = [SYFManagerKeyChain queryDataToKeyChain:UUID_KEY];
    if ([uuid isKindOfClass:[NSNull class]] || uuid == nil || [uuid isEqualToString:@""]) {
        //说明本地没有存储uuid
        self.tinLabel.text = @"这是第一次安装本应用,😄欢迎使用";
        //获取到系统的uuid
        uuid = [[NSUUID UUID] UUIDString];
        //把uuid保存到本地数据 uuid	__NSCFString *	@"20C41126-9E10-4F87-9739-7340B98C4723"	0x0000608000263940
        [SYFManagerKeyChain addDataToKeyChain:UUID_KEY dataString:uuid];
    }else{
    
        //说明本地存储着uuid
        self.tinLabel.text = @"👏欢迎您回来继续使用,😄😄😄";
        
    }
    
    //显示uuid
    self.uuidLabel.text = uuid;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self showViewController:[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"testID"] sender:nil];
}


@end
