//
//  ViewController.m
//  weixin2.0
//
//  Created by user on 17/7/17.
//  Copyright © 2017年 changandaxue. All rights reserved.
//

#import "CADLoginController.h"
#import "CADTabBarController.h"

@interface CADLoginController ()
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *pwd;

@end

@implementation CADLoginController
+(instancetype)cad_logReg{
    return [CADStoryboard instantiateViewControllerWithIdentifier:NSStringFromClass(self)];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"456");
  
}
- (IBAction)testReguster:(id)sender {
    [SVProgressHUD showWithStatus:@"注册中.."];
    [[EaseMob sharedInstance].chatManager asyncRegisterNewAccount:self.username.text password:self.pwd.text withCompletion:^(NSString *username, NSString *password, EMError *error) {
        if (error == nil) {
            NSLog(@"注册成功");
            [JDStatusBarNotification showWithStatus:@"注册成功，请点击查看"
                                       dismissAfter:1.5
                                          styleName:JDStatusBarStyleSuccess];
        }
    } onQueue:nil];

}
- (IBAction)login:(id)sender {
    [SVProgressHUD showWithStatus: @"loging..."];
    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername: self.username.text
                                                        password: self.pwd.text
                                                      completion:^(NSDictionary *loginInfo, EMError *error) {
                                                          [SVProgressHUD dismiss];
                                                          if (!self.username.text || !self.pwd.text) {
                                                              NSLog(@"用户名or密码不能为空");
                                                              return;
                                                          }
                                                          
                                                          NSLog(@"loginInfo = %@, error = %@", loginInfo, error);
                                                          
                                                          if (!error) {
                                                              [JDStatusBarNotification
                                                               showWithStatus:@"登录成功"
                                                               dismissAfter: 1.5
                                                               styleName: JDStatusBarStyleSuccess];
                                                              dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                                  //
                                                                  // 1.设置下次自动登录
                                                                  [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled: YES];
                                                                  // 2.切换根控制器
                                                                  UIWindow *window = [UIApplication sharedApplication].keyWindow;
                                                                  
                                                                  
                                                                  CADTabBarController *tabbarVc = [CADStoryboard instantiateViewControllerWithIdentifier: NSStringFromClass([CADTabBarController class])];
                                                                  
                                                                  window.rootViewController = tabbarVc;
                                                              });
                                                          }else
                                                          {
                                                              [JDStatusBarNotification showWithStatus: error.description
                                                                                         dismissAfter: 1.5
                                                                                            styleName: JDStatusBarStyleError];
                                                          }
                                                      }
                                                         onQueue: nil];
    
}

- (IBAction)loginOff:(id)sender {
    [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES completion:^(NSDictionary *info, EMError *error) {
        if (error == nil) {
            NSLog(@"退出登陆");
        }
    } onQueue:nil];
}

@end
