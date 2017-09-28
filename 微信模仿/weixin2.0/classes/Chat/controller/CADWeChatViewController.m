//
//  CADWeChatViewController.m
//  weixin2.0
//
//  Created by user on 17/7/18.
//  Copyright © 2017年 changandaxue. All rights reserved.
//

#import "CADWeChatViewController.h"
#import "CADChatViewController.h"

NSString *const WeChatTitleNormal = @"微信";
NSString *const WeChatTitleWillConnect = @"连接中..";
NSString *const WeChatTitleDisconnect = @"微信(未连接)";
NSString *const WeChatTitleWillReceiveMsg = @"收取中..";

@interface CADWeChatViewController ()<EMChatManagerDelegate>
/*会话数组*/
@property (nonatomic , strong)NSMutableArray *conversations;
@end

@implementation CADWeChatViewController
-(NSMutableArray *)conversations
{
    if (!_conversations) {
        _conversations = [NSMutableArray array];
        //获取内存中所有会话
        NSArray *allConversation = [[EaseMob sharedInstance].chatManager conversations];
        [self.conversations addObjectsFromArray:allConversation];
    }
    return _conversations;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = WeChatTitleNormal;
    
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    
    if (!self.conversations.count) {
        [self cad_reloadChatList];
        }
    
    
    //注册cell
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([self class])];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSInteger unreadCount = [[EaseMob sharedInstance].chatManager loadTotalUnreadMessagesCountFromDatabase];
    NSString *badge = unreadCount ? [NSString stringWithFormat:@"%zd",unreadCount] : nil;
    self.navigationController.tabBarItem.badgeValue = badge;

}
-(void)cad_reloadChatList
{
    [self.conversations removeAllObjects];
    
    NSArray *conversations = [[EaseMob sharedInstance].chatManager loadAllConversationsFromDatabaseWithAppend2Chat:YES];
    [self.conversations addObjectsFromArray:conversations];
    [self.tableView reloadData];
}
#pragma mark -   会话列表信息更新时的回调
//1. 当会话列表有更改时(新添加,删除), 2. 登陆成功时, 以上两种情况都会触发此回调
//conversationList 会话列表
-(void)didUpdateConversationList:(NSArray *)conversationList
{
   // [self cad_reloadChatList];

}
//将要自动连接
-(void)willAutoReconnect{
    self.title = WeChatTitleWillConnect;
}
//自动连接结束
-(void)didAutoReconnectFinishedWithError:(NSError *)error{
    if (!error) {
        self.title = WeChatTitleNormal;
    }else{
        self.title = WeChatTitleDisconnect;
    }
}
//监听连接状态的改变
-(void)didConnectionStateChanged:(EMConnectionState)connectionState
{
    switch (connectionState) {
        case eEMConnectionConnected:
        {//连接成功
            self.title = WeChatTitleNormal;
        }
            break;
        case eEMConnectionDisconnected:
        {//连接失败
            self.title = WeChatTitleDisconnect;
            
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.conversations.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //1.通过标识到缓存池中去取cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class]) forIndexPath:indexPath];
    
    
    //2.覆盖数据
    cell.imageView.image = [UIImage imageNamed:@"iconimage"];
    cell.textLabel.text = [self.conversations[indexPath.row] chatter];
    return cell;
    
    
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"13245678");
    
    CADChatViewController *chatVC = [[CADChatViewController alloc]init];
    chatVC.username = [self.conversations[indexPath.row] chatter];
    
    [self.navigationController pushViewController:chatVC animated:YES];

}
@end
