//
//  AppDelegate.m
//  weixin2.0
//
//  Created by user on 17/7/17.
//  Copyright © 2017年 changandaxue. All rights reserved.
//

#import "AppDelegate.h"
#import "CADTabBarController.h"
#define kAppKey @"changandaxue#chatapp"

@interface AppDelegate ()<EMChatManagerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //registerSDKWithAppKey: 注册的AppKey，详细见下面注释。
    //apnsCertName: 推送证书名（不需要加后缀），详细见下面注释。
    // 1.展示启动图3秒
    sleep(1);
    
    // 2.注册AppKey
    [[EaseMob sharedInstance] registerSDKWithAppKey: kAppKey
                                       apnsCertName: nil
                                        otherConfig: @{kSDKConfigEnableConsoleLogger: @NO}];
    // 3.跟踪启动(4个方法中跟踪)
    [[EaseMob sharedInstance] application: application
            didFinishLaunchingWithOptions: launchOptions];
    
    // 4.设置代理,监控登录注册退出等状态
    [[EaseMob sharedInstance].chatManager addDelegate: self
                                        delegateQueue: nil];
    
    // 5.判断是否已经自动登录
    BOOL isAutoLog = [[EaseMob sharedInstance].chatManager isAutoLoginEnabled];
    if (isAutoLog) {
        NSLog(@"123");
        // 切换跟控制器
        self.window.rootViewController = [CADStoryboard instantiateViewControllerWithIdentifier: NSStringFromClass([CADTabBarController class])];
    }
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[EaseMob sharedInstance] applicationDidEnterBackground:application];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[EaseMob sharedInstance] applicationWillEnterForeground:application];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    [[EaseMob sharedInstance] applicationWillTerminate:application];
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
}
//监听加好友请求
- (void)didReceiveBuddyRequest:(NSString *)username
                       message:(NSString *)message{
    NSLog(@"%@ -- %@",username,message);


}
////自动登录的回调
//- (void)didAutoLoginWithInfo:(NSDictionary *)loginInfo error:(EMError *)error{
//    NSLog(@"自动登录");
//}
//重新连接
-(void)willAutoReconnect
{
    NSLog(@"自动重连");
}
-(void)didAutoReconnectFinishedWithError:(NSError *)error
{
    NSLog(@"自动重连成功");
}
// 被xx接收
- (void)didAcceptedByBuddy:(NSString *)username
{
    NSLog(@"%s, line = %d", __FUNCTION__, __LINE__);
}

// 被xx拒绝
- (void)didRejectedByBuddy:(NSString *)username
{
    NSLog(@"%s, line = %d", __FUNCTION__, __LINE__);
}

// 被xx移除
- (void)didRemovedByBuddy:(NSString *)username
{
    NSLog(@"%s, line = %d", __FUNCTION__, __LINE__);
    
}

@end
