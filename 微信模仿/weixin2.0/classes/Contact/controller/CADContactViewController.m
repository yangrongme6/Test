//
//  CADContactViewController.m
//  weixin2.0
//
//  Created by user on 17/7/18.
//  Copyright © 2017年 changandaxue. All rights reserved.
//

#import "CADContactViewController.h"
#import "CADUserDetailInfoViewController.h"
#import "CADContactCell.h"
#import "CADContactHeaderController.h"

@interface CADContactViewController ()<IChatManagerDelegate>
@property (nonatomic, strong) NSMutableArray *friends; /**< 通讯录,EMBuddy对象数组 */
@end

@implementation CADContactViewController

+(instancetype)cad_contact{
    return [CADStoryboard instantiateViewControllerWithIdentifier:NSStringFromClass(self)];
}
//懒加载
-(NSMutableArray *)friends{
    if (_friends == nil) {
        _friends = [NSMutableArray array];
        [_friends addObjectsFromArray: [[EaseMob sharedInstance].chatManager buddyList]];
    }
    return _friends;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    //1.设置标题
    self.title = @"通讯录";
    
    //2.添加导航栏右边的添加好友按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"contacts_add_friend"]
                style:UIBarButtonItemStylePlain
                target:self
                action:@selector(addFriend)];
    
    //3.设置tableView属性
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 50;
    
    //4.刷新好友列表
//    if (self.friends.count ==0) {
//        // 若本地好友列表为空,则刷新数据,从服务器取
//        [self reloadContacts];
//    }
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    
    [self cad_setContactHeader];
}
#pragma mark - 刷新
// 在登录时即可调用
- (void)reloadContacts
{
    
    NSLog(@"本地 count = %ld", [[EaseMob sharedInstance].chatManager buddyList].count);
    __weak typeof(self) weakSelf = self;
    [[EaseMob sharedInstance].chatManager asyncFetchBuddyListWithCompletion:^(NSArray *buddyList, EMError *error) {
        
        // 更新数据
        [weakSelf.friends removeAllObjects];
        [weakSelf.friends addObjectsFromArray:buddyList];
        
        NSLog(@"%s, line = %d, %@", __FUNCTION__, __LINE__, buddyList);
        ;
        NSLog(@"%@, SerbuddyList = %ld, ", [NSThread currentThread], buddyList.count);
        // 回到主线程刷新UI
        
        [weakSelf.tableView reloadData];
        
    } onQueue:nil];
}

//添加好友操作
- (void)addFriend {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"添加好友"
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"输入微信号";
    }];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * _Nonnull action) {
                                                
                                            }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //发送好友申请
        EMError *error = nil;
        BOOL isSuccess = [[EaseMob sharedInstance].chatManager addBuddy:alert.textFields.firstObject.text message:@"我想加您为好友" error:&error];
        if (isSuccess && !error) {
            NSLog(@"添加成功");
            [SVProgressHUD showSuccessWithStatus:@"发送成功"];
        }
        
    }]];
    [self presentViewController:alert animated:YES completion:nil];

}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return self.friends.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CADContactCell *cell = [CADContactCell cad_cellWithTableView:tableView];
    
    // Configure the cell...
    EMBuddy *buddy = self.friends[indexPath.row];

    cell.buddy = buddy; // 此处不确定,等有网再看
    //cell.textLabel.text = @"test-----";
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EMBuddy *buddy = self.friends[indexPath.row];
    
    CADUserDetailInfoViewController *userDetailInfoVc = [[UIStoryboard storyboardWithName:@"CADUserDetailInfoViewController" bundle:nil] instantiateViewControllerWithIdentifier: NSStringFromClass([CADUserDetailInfoViewController class])];
    userDetailInfoVc.buddy = buddy;
    
    [self.navigationController pushViewController:userDetailInfoVc animated:YES];


}
#pragma mark - 添加表头header
-(void)cad_setContactHeader
{
    CADContactHeaderController *headerController = [[CADContactHeaderController alloc]init];
    headerController.view.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), kHeaderH);
    self.tableView.tableHeaderView = headerController.view;
    [self addChildViewController:headerController];

}
#pragma mark - 开启tableview的编辑模式
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        EMBuddy *buddy = self.friends[indexPath.row];
        EMError *error = nil;
        [[EaseMob sharedInstance].chatManager removeBuddy:buddy.username removeFromRemote:YES error:&error];
        if (!error) {
            NSLog(@"移出成功");
        }
    }

}
#pragma mark - 收到好友请求
//接收到好友请求时的通知
//- (void)didReceiveBuddyRequest:(NSString *)username message:(NSString *)message
//{
//    NSLog(@"%s, line = %d", __FUNCTION__, __LINE__);
//    //self.navigationController.tabBarItem.badgeValue = [self badgeChage: YFBadgeValueChagePlus];
//}
-(void)didUpdateBuddyList:(NSArray *)buddyList changedBuddies:(NSArray *)changedBuddies isAdd:(BOOL)isAdd
{
    NSLog(@"buddyList = %@,changedBuddies = %@,isAdd = %d",buddyList,changedBuddies,isAdd);
    //添加好友刷新列表
    [self.friends removeAllObjects];
    [self.friends addObjectsFromArray:buddyList];
    [self.tableView reloadData];

}
@end
