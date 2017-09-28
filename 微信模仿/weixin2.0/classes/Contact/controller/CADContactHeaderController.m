//
//  CADContactHeaderController.m
//  weixin2.0
//
//  Created by user on 17/8/3.
//  Copyright © 2017年 changandaxue. All rights reserved.
//

#import "CADContactHeaderController.h"
#import "CADContactItem.h"
#import "CADContactCell.h"


@interface CADContactHeaderController ()

@property (nonatomic , strong)NSArray *headerItems;

@end

@implementation CADContactHeaderController
- (NSArray *)headerItems
{
    if (!_headerItems) {
        CADContactItem *item = [[CADContactItem alloc]init];
        item.title = @"新的朋友";
        item.iconName = @"plugins_FriendNotify";
        item.controller = [UIViewController class];
        
        CADContactItem *item1 = [[CADContactItem alloc]init];
        item1.title = @"群聊";
        item1.iconName = @"add_friend_icon_addgroup";
        item1.controller = [UIViewController class];
        
        CADContactItem *item2 = [[CADContactItem alloc]init];
        item2.title = @"标签";
        item2.iconName = @"Contact_icon_ContactTag";
        item2.controller = [UIViewController class];
        
        CADContactItem *item3 = [[CADContactItem alloc]init];
        item3.title = @"公众号";
        item3.iconName = @"add_friend_icon_offical";
        item3.controller =[UIViewController class];
        
        _headerItems = @[item,item1,item2,item3];
    }
    return _headerItems;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = 50;
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.headerItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CADContactCell *cell = [CADContactCell cad_cellWithTableView:tableView];
    
    cell.contactItem = self.headerItems[indexPath.row];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CADContactItem *item = self.headerItems[indexPath.row];
    UIViewController *controller = [[item.controller alloc]init];
    controller.view.backgroundColor = [UIColor redColor];
    [self.parentViewController.navigationController pushViewController:controller animated:YES];

}

@end
