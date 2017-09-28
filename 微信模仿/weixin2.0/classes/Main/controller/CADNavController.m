//
//  CADNavController.m
//  weixin2.0
//
//  Created by user on 17/7/17.
//  Copyright © 2017年 changandaxue. All rights reserved.
//

#import "CADNavController.h"

@interface CADNavController ()

@end

@implementation CADNavController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航栏背景色
    self.navigationBar.backgroundColor = [UIColor blackColor];
    //设置标题的颜色
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    //设置状态栏的颜色
    self.navigationBar.tintColor = [UIColor whiteColor];
}

@end
