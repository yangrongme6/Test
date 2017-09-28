//
//  CADChatCell.m
//  weixin2.0
//
//  Created by user on 17/7/22.
//  Copyright © 2017年 changandaxue. All rights reserved.
//

#import "CADChatCell.h"
#import "CADLongPressBtn.h"
#import "CADChat.h"
#import "CADChatFrame.h"


@interface CADChatCell ()
/**< 时间 */
@property (nonatomic, weak) UILabel  *timeLab;
/**< durationLab */
@property (nonatomic, weak) UILabel  *durationLab;
/**< 头像 */
@property (nonatomic, weak) CADLongPressBtn *userIconBtn;
/**< 聊天内容 */
@property (nonatomic, weak) CADLongPressBtn *msg;
@end
@implementation CADChatCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = BackGround243Color;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        // 此处添加子控件
        //1.显示时间的label
        UILabel *timeLab = [[UILabel alloc] init];
        timeLab.backgroundColor = [UIColor grayColor];
        timeLab.textColor = [UIColor whiteColor];
        timeLab.textAlignment = NSTextAlignmentCenter;
        timeLab.font = kTimeFont;
        timeLab.layer.cornerRadius = 5;
        timeLab.clipsToBounds = YES;
        [self.contentView addSubview:timeLab];
        self.timeLab = timeLab;
        
        //2.图像按钮
        CADLongPressBtn *userIconBtn = [[CADLongPressBtn alloc] init];
        userIconBtn.longPressBlock = ^(CADLongPressBtn *btn){
            // 长按时的业务逻辑处理
        };
        [userIconBtn addTarget:self action:@selector(cad_showDetailUserInfo) forControlEvents: UIControlEventTouchUpInside];
        [self.contentView addSubview: userIconBtn];
        self.userIconBtn = userIconBtn;
        
        //3.内容控件
        CADLongPressBtn *contentTextBtn = [[CADLongPressBtn alloc] init];
        contentTextBtn.longPressBlock = ^(CADLongPressBtn *btn){
            // 长按时的业务逻辑处理
        };
        
        contentTextBtn.titleLabel.font = kTitleFont;
        contentTextBtn.titleLabel.numberOfLines = 0;
        
        [contentTextBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [contentTextBtn addTarget:self action:@selector(cad_contentChatTouchUpInside) forControlEvents: UIControlEventTouchUpInside];
        [self.contentView addSubview: contentTextBtn];
        self.msg = contentTextBtn;
        
        //4.显示duration的label
        UILabel *durationLab = [[UILabel alloc] init];
        durationLab.textColor = [UIColor lightGrayColor];
        durationLab.textAlignment = NSTextAlignmentRight;
        durationLab.font = [UIFont systemFontOfSize:15.0];
        [self.contentView addSubview:durationLab];
        self.durationLab.hidden = YES;
        self.durationLab = durationLab;
    }
    
    return self;
}

//这里面给子控件赋值
-(void)setChatFrame:(CADChatFrame *)chatFrame
{
    _chatFrame = chatFrame;
    
    CADChat *chat = chatFrame.chat;
    
    self.timeLab.text = chat.timeStr;
    
    [self.userIconBtn setImage: [UIImage imageNamed:chat.userIcon] forState:UIControlStateNormal];
    
    [self.msg setBackgroundImage:[UIImage yf_resizingWithIma:chat.contectTextBackgroundIma] forState:UIControlStateNormal];
    [self.msg setBackgroundImage:[UIImage yf_resizingWithIma:chat.contectTextBackgroundHLIma] forState:UIControlStateHighlighted];
    
    self.durationLab.hidden = (chat.chaType != CADChatTypeVoice);
    switch (chat.chaType) {
        case CADChatTypeText:
        {
            self.msg.contentEdgeInsets = UIEdgeInsetsMake(kContentEdgeTop, kContentEdgeLeft, kContentEdgeBottom, kContentEdgeRight);
            [self.msg setTitle:chat.contentText forState:UIControlStateNormal];
            [self.msg setImage:nil forState:UIControlStateNormal];
        
        }
            break;
        case CADChatTypeImage:
        {
            self.msg.contentEdgeInsets = UIEdgeInsetsZero;
            [self.msg setTitle:nil forState:UIControlStateNormal];
            if (chat.contentThumbnailIma) {
                [self.msg setImage:chat.contentThumbnailIma forState:UIControlStateNormal];
            }else
            {
                // 用SDWebImage进行btn的赋值
                [self.msg sd_setImageWithURL:chat.contentThumbnailImaUrl forState:UIControlStateNormal];
            }
                }
            break;
        case CADChatTypeVoice:
        {
            self.msg.contentEdgeInsets = UIEdgeInsetsZero;
            [self.msg setImage: [UIImage imageNamed: @"SenderVoiceNodePlaying"] forState:UIControlStateNormal];
            
            self.durationLab.text = [NSString stringWithFormat:@"%zd\"",chat.voiceTime];
            [self.msg setTitle:nil forState:UIControlStateNormal];
        
        }
            break;
        case CADChatTypeVideo:
            
            break;
        case CADChatTypeFile:
            
            break;
        case CADChatTypeLocation:
            
            break;
            
        default:
            break;
    }
    
}
//这里对子控件布局
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.timeLab.frame = self.chatFrame.timeFrame;
    self.userIconBtn.frame = self.chatFrame.iconFrame;
    self.msg.frame = self.chatFrame.contentFrame;
    self.durationLab.frame = self.chatFrame.durationLabFrame;
    if (self.chatFrame.chat.chaType == CADChatTypeVoice) {
        NSLog(@"%@",NSStringFromCGRect(self.msg.frame));
    }
}
-(void)cad_showDetailUserInfo
{

}
#pragma mark - 点击内容按钮的响应事件
-(void)cad_contentChatTouchUpInside
{
    switch (self.chatFrame.chat.chaType) {
        case CADChatTypeText:
            
            break;
        case CADChatTypeImage:
        {
            if ([self.delegate respondsToSelector:@selector(cad_chatCell:contentClickWithChatFrame:)]) {
                [self.delegate cad_chatCell:self contentClickWithChatFrame:self.chatFrame];
            }
        
        
        }
            break;
        case CADChatTypeVoice:
        {
            if ([[EMCDDeviceManager sharedInstance] isPlaying]) {
                [[EMCDDeviceManager sharedInstance] stopPlaying];
            }else {
            [[EMCDDeviceManager sharedInstance] asyncPlayingWithPath:self.chatFrame.chat.voicePath completion:^(NSError *error) {
                if (!error) {
                    NSLog(@"正在播放.........");
                }
            }];
            }
        }
            break;
        case CADChatTypeVideo:
            
            break;
        case CADChatTypeFile:
            
            break;
        case CADChatTypeLocation:
            
            break;
            
        default:
            break;
    }

}
@end
