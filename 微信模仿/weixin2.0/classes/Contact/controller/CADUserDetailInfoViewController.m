//
//  CADUserDetailInfoViewController.m
//  weixin2.0
//
//  Created by user on 17/7/21.
//  Copyright © 2017年 changandaxue. All rights reserved.
//

#import "CADUserDetailInfoViewController.h"
#import "CADTabBarController.h"
#import "CADChatViewController.h"
#import "CADNavController.h"

@interface CADUserDetailInfoViewController ()
@property (weak, nonatomic) IBOutlet UILabel *username;

@end

@implementation CADUserDetailInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //0.设置标题
    self.title = @"详细资料";
    
    //1.设置用户名
    self.username.text = self.buddy.username;
    
    //2.添加发送消息按钮
    [self addBtns];
    
    
}
- (void)setBuddy:(EMBuddy *)buddy
{
    _buddy = buddy;
}
-(void)addBtns{


    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 200)];
    self.tableView.tableFooterView = footerView;
    UIButton *sendMsgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendMsgBtn setBackgroundColor:[UIColor greenColor]];
    [sendMsgBtn setTitle:@"发送消息" forState:UIControlStateNormal];
    [sendMsgBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sendMsgBtn.frame = CGRectMake(30, 20, self.view.bounds.size.width - 60, 44);
    [sendMsgBtn addTarget:self action:@selector(sendMsg) forControlEvents:UIControlEventTouchUpInside];
    
    [footerView addSubview:sendMsgBtn];

}
-(void)sendMsg{

    NSLog(@"发送消息");
    // 0.back到通讯录界面
    [self.navigationController popViewControllerAnimated: NO];
    
    // 1.切换到 微信 界面
    // 也可以通过storyboard拿到
    CADTabBarController *tabBarVc = (CADTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    tabBarVc.selectedViewController = tabBarVc.childViewControllers[0];
    
    // 2.从微信界面跳转到聊天界面
    CADChatViewController *chatVc = [[CADChatViewController alloc] init];
    chatVc.username = self.buddy.username;
    [(CADNavController *)tabBarVc.childViewControllers[0] pushViewController:chatVc animated: YES];

}
@end
