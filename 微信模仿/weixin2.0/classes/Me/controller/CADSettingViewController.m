//
//  CADSettingViewController.m
//  weixin2.0
//
//  Created by user on 17/7/17.
//  Copyright © 2017年 changandaxue. All rights reserved.
//

#import "CADSettingViewController.h"
#import "EaseMob.h"
#import "CADLoginController.h"

@interface CADSettingViewController ()

@end

@implementation CADSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)loginOff:(id)sender {
    [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES completion:^(NSDictionary *info, EMError *error) {
        if (error == nil) {
            NSLog(@"退出登陆");
            //1.记录退出账号
            //2.切换根控制器
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            window.rootViewController = [CADLoginController cad_logReg];
        }
    } onQueue:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
