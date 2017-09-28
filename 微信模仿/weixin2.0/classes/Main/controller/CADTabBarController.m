//
//  CADTabBarController.m
//  weixin2.0
//
//  Created by user on 17/7/17.
//  Copyright © 2017年 changandaxue. All rights reserved.
//

#import "CADTabBarController.h"
#import "CADContactViewController.h"

@interface CADTabBarController ()<EMChatManagerDelegate>

@end

@implementation CADTabBarController
//-(instancetype)init{
//    self = [super init];
//    if (self) {
//        self = [CADStoryboard instantiateViewControllerWithIdentifier:NSStringFromClass(self)];
//    }
//    return self;
//}
+(instancetype)cad_tabBar{
    return [CADStoryboard instantiateViewControllerWithIdentifier:NSStringFromClass(self)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIColor *selCorlor = [UIColor colorWithRed:0
                                         green:190/255.0
                                          blue:12/255.0
                                         alpha:1];
    for (UINavigationController *nav in self.childViewControllers) {
       [nav.tabBarItem setTitleTextAttributes:                                 @{NSForegroundColorAttributeName : selCorlor}
                                     forState:UIControlStateSelected];
    }
    self.tabBar.tintColor = selCorlor;
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
}
#pragma mark - 接收到好友请求
//接收到好友请求时的通知
-(void)didReceiveBuddyRequest:(NSString *)username message:(NSString *)message{
    //1.显示badgevalue改变
    [self cad_tabbarBadgeValue];
    
    //2.弹窗问是否接受，如果同意，我们就条到通讯录界面
    [self cad_askForBuddyAccpect:username message:message];


}
-(void)cad_tabbarBadgeValue{
    CADContactViewController *contact = [CADContactViewController cad_contact];
    NSString *badgeValue = contact.navigationController.tabBarItem.badgeValue;
    NSInteger badgeValueNum = badgeValue.integerValue +1;
    contact.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%zd",badgeValueNum];
    
}
-(void)cad_askForBuddyAccpect:(NSString *)username message:(NSString *)message{
     UIAlertController *alert = [UIAlertController  alertControllerWithTitle:[NSString stringWithFormat:@"%@想要加您为好友",username]
                          message:[NSString stringWithFormat:@"%@",message] preferredStyle:UIAlertControllerStyleActionSheet];
    __weak CADContactViewController *contactVc = [CADStoryboard instantiateViewControllerWithIdentifier: NSStringFromClass([CADContactViewController class])];
    [alert addAction:[UIAlertAction actionWithTitle:@"拒绝" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        //拒绝添加好友请求
        EMError *error = nil;
        [[EaseMob sharedInstance].chatManager rejectBuddyRequest:username
                        reason:@"不认识"
                         error:&error];
        if(!error){
            NSLog(@"拒绝成功");
        }
        // 1.修改badgeValue
        [contactVc.navigationController.tabBarItem setBadgeValue:nil];
    }]];
    [alert addAction:[UIAlertAction
                      actionWithTitle:@"接收"
                                style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //接收好友请求
                                    EMError *error = nil;
                                    [[EaseMob sharedInstance].chatManager acceptBuddyRequest:username error:&error];
                                    if (!error) {
                                        //跳转控制器到通讯录
                                        self.selectedViewController = self.viewControllers[1];
                                        //刷新界面
                                        
                                    }
                                    
                                }]];
    [self presentViewController:alert animated:YES completion:nil];
}
@end
