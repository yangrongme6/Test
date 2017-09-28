//
//  CADCallController.m
//  weixin2.0
//
//  Created by user on 17/8/28.
//  Copyright © 2017年 changandaxue. All rights reserved.
//

#import "CADCallController.h"

@interface CADCallController ()
@property (weak, nonatomic) IBOutlet UILabel *usernameLab;
@property (weak, nonatomic) IBOutlet UILabel *statusLab;
@property (weak, nonatomic) IBOutlet UIButton *cancleBtn;

@end

@implementation CADCallController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
//取消连接处理
- (IBAction)cancle:(UIButton *)sender {
    [[EaseMob sharedInstance].callManager asyncEndCall:self.session.sessionId reason:eCallReason_Reject];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)agreeBtnClick:(id)sender {
    [[EaseMob sharedInstance].callManager asyncAnswerCall:self.session.sessionId];
}

@end
