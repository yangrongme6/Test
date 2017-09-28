//
//  CADChatViewController.m
//  weixin2.0
//
//  Created by user on 17/7/21.
//  Copyright © 2017年 changandaxue. All rights reserved.
//

#import "CADChatViewController.h"
#import "CADInputView.h"
#import "CADChatCell.h"
#import "CADChat.h"
#import "CADChatFrame.h"
#import "CADMoreInputKeyboardView.h"
#import "CADCallController.h"

#define kInputViewH 44
#define kMoreInputViewFrame CGRectMake(0, CGRectGetHeight(self.view.bounds), CGRectGetWidth(self.view.bounds), kCADMoreInputKeyboardViewH)

@interface CADChatViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,EMChatManagerDelegate,CADInputViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,IEMChatProgressDelegate,CADChatCellDelegate,MWPhotoBrowserDelegate,EMCallManagerDelegate>

@property(nonatomic,strong)UITableView *tableView;
/**输入工具条*/
@property(nonatomic,strong)CADInputView *inputView;
@property (nonatomic , strong)CADMoreInputKeyboardView *moreInputKeyboardView;
//记录聊天记录
@property (nonatomic , strong)NSMutableArray *chatMsgs;
/** 要展示的图片数组 */
@property (nonatomic , strong)NSMutableArray *chaImas;
@property (nonatomic , strong)NSMutableArray *chatThumbnailImas;

@end

@implementation CADChatViewController

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - kInputViewH);
        _tableView.backgroundColor = BackGround243Color;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}
-(UIView *)inputView{
    if (!_inputView) {
        //快速加载输入工具条
        _inputView = [CADInputView cad_inputView];
        _inputView.textField.delegate = self;
        _inputView.delegate = self;
        _inputView.frame = CGRectMake(0, self.view.bounds.size.height - kInputViewH, self.view.bounds.size.width, kInputViewH);
    }
    return _inputView;
}
- (CADMoreInputKeyboardView *)moreInputKeyboardView
{
    if (!_moreInputKeyboardView) {
        _moreInputKeyboardView = [[CADMoreInputKeyboardView alloc]init];
        _moreInputKeyboardView.frame = kMoreInputViewFrame;
        
        [[UIApplication sharedApplication].keyWindow addSubview:_moreInputKeyboardView];
        [UIApplication sharedApplication].keyWindow.backgroundColor = BackGround243Color;
        __weak typeof(self) weakSelf = self;
        self.moreInputKeyboardView.btnClickBlock = ^(UIButton *btn){
            [weakSelf.view endEditing:YES];
            [weakSelf cad_dismissMoreInputViewWithAnimation:YES];
            if ([btn.currentTitle isEqualToString:CADPhotoStr]) {
                    // 先直接做图片选择
                    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
                    ipc.delegate = weakSelf;
                    [weakSelf presentViewController:ipc animated:YES completion:nil];
            }else if ([btn.currentTitle  isEqualToString:CADVideoStr]){
                UIAlertController *ac = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
                [ac addAction:[UIAlertAction actionWithTitle:@"视频聊天" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    //弹出视频聊天的请求
                }]];
                [ac addAction:[UIAlertAction actionWithTitle:@"语音聊天" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    //弹出语音聊天的请求
                    //建立连接通道
                    EMError *error = nil;
                    [[EaseMob sharedInstance].callManager asyncMakeVoiceCall:weakSelf.username timeout:0.0 error:&error];
                    if (error) {
                        [SVProgressHUD showErrorWithStatus:error.description];
                    }
                }]];
                [ac addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    //弹出取消聊天的请求
                }]];
                [weakSelf presentViewController:ac animated:YES completion:nil];
            }
        };
        
    }
    return _moreInputKeyboardView;
    
}

-(NSMutableArray *)chatMsgs
{
    if (!_chatMsgs) {
        _chatMsgs = [NSMutableArray array];
    }
    return _chatMsgs;
}
-(NSMutableArray *)chaImas
{
    if (!_chaImas) {
        _chaImas = [NSMutableArray array];
    }
    return _chaImas;
}
-(NSMutableArray *)chatThumbnailImas
{
    if (!_chatThumbnailImas) {
        _chatThumbnailImas = [NSMutableArray array];
    }
    return _chatThumbnailImas;

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.tabBarController.tabBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.tabBarController.tabBar.hidden = NO;
    [self cad_dismissMoreInputViewWithAnimation:NO];
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self moreInputKeyboardView];
    [[[EaseMob sharedInstance].chatManager conversationForChatter:self.username conversationType:eConversationTypeChat] markAllMessagesAsRead:YES];
    [self cad_scrollToBottom];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //1.添加子控件
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.inputView];
    
    //2.设置标题
    self.title = self.username;
    
    //3.监听键盘弹出，对相应布局做修改
    [self keyboardTransform];
    
    //4.刷新聊天记录
    [self cad_loadChatMsgs];
    
    //5.注册cell
    [self.tableView registerClass:[CADChatCell class] forCellReuseIdentifier: NSStringFromClass([self class])];
    
    //6.添加代理,监听收到消息
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    
    [[EaseMob sharedInstance].callManager addDelegate:self delegateQueue:nil];
    
}

#pragma mark - 监听键盘弹出,对相应的布局做修改
- (void)keyboardTransform{

    NSLog(@"键盘的转变");
    
    __weak typeof(self) weakSelf = self;
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillChangeFrameNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        
        CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
        CGFloat endFrameY = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y;
        CGRect tempRect = weakSelf.view.frame;
        tempRect.origin.y = endFrameY  - weakSelf.view.bounds.size.height;
        
        weakSelf.view.frame = tempRect;
        [UIView animateWithDuration:duration animations:^{
            [weakSelf.view setNeedsLayout];
        }];
        
    }];
}
//刷新数据
-(void)cad_loadChatMsgs
{
    //1.移出所有的已有的对象
    [self.chatMsgs removeAllObjects];
    [self.chaImas removeAllObjects];
    [self.chatThumbnailImas removeAllObjects];
    
    //2.拿到当前的所有的会话对象
    EMConversation *conversation = [[EaseMob sharedInstance].chatManager conversationForChatter:self.username conversationType:eConversationTypeChat];
    
    //3.获取会话中的聊天记录
    NSArray *allMsg = [conversation loadAllMessages];
    long long preTime = 0;
    for (EMMessage *emsg in allMsg) {
        
        if (self.chatMsgs.count) {
            CADChatFrame *preChatFrame = self.chatMsgs.lastObject;
            preTime = preChatFrame.chat.emsg.timestamp;
            
        }
        
        CADChat *chat = [CADChat xmg_chatWith:emsg preTimestamp:preTime];
        
        CADChatFrame *chatFrame = [[CADChatFrame alloc] init];
        chatFrame.chat = chat;
        if (chat.chaType == CADChatTypeImage) {
            if (chat.contentIma) {
                [self.chaImas addObject:chat.contentIma];
            }else
            {
                [self.chaImas addObject:chat.contentImaUrl];
            }
            [self.chatThumbnailImas addObject:chat.contentThumbnailIma ? chat.contentThumbnailIma : chat.contentThumbnailImaUrl];
        }
        [self.chatMsgs addObject:chatFrame];
    }
    
    //4.刷新表格
    [self.tableView reloadData];
    
    //5.滚到最下边
    [self cad_scrollToBottom];


}

//滚到最下边
-(void)cad_scrollToBottom
{
    if (self.chatMsgs.count == 0) return;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.chatMsgs.count - 1 inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}
#pragma mark - tableview数据源
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.chatMsgs.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CADChatCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];

    cell.chatFrame = self.chatMsgs[indexPath.row];
    
    cell.delegate = self;
    
    return cell;
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.chatMsgs[indexPath.row] cellH];
}

#pragma maek - scrollview代理方法
//当开始拖拉scrollview时结束编辑模式
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self cad_dismissMoreInputViewWithAnimation:YES];

    [self.view endEditing:YES];
}
#pragma maek - textField代理方法
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //1.在此处发送消息
    EMChatText *chatText = [[EMChatText alloc]initWithText:textField.text];
    EMTextMessageBody *body = [[EMTextMessageBody alloc]initWithChatObject:chatText];
    EMMessage *message = [[EMMessage alloc]initWithReceiver:self.username bodies:@[body]];
    
    [[EaseMob sharedInstance].chatManager asyncSendMessage:message
                                                  progress:nil
                                                   prepare:^(EMMessage *message, EMError *error) {
        //准备发送
    }
                                                   onQueue:nil
                                                completion:^(EMMessage *message, EMError *error) {
        //发送完成后
        
                                                    if (!error) {
            
                                                        NSLog(@"message : %@",message);                                                        textField.text = nil;
                                                        [textField resignFirstResponder];
                                                        
                                        [self cad_loadChatMsgs];
                                                    }
                                                }
                                                   onQueue:nil];
    //2. 成功之后刷新列表
    
    return YES;

}
#pragma mark - 收到消息后刷新
// 收到消息时的回调
- (void)didReceiveMessage:(EMMessage *)message
{
    [self cad_loadChatMsgs];
}
// 接收到离线非透传消息的回调
- (void)didReceiveOfflineMessages:(NSArray *)offlineMessages
{
    [self cad_loadChatMsgs];
}
#pragma mark - CADInputViewDelegate
-(void)cad_inputView:(CADInputView *)inputView changeInputStyle:(CADInputViewStyle)style
{
    switch (style) {
        case CADInputViewStyleText:
        {
        }
            break;
        case CADInputViewStyleVoice:
        {
            //将moreinputview回复原样
            [self cad_dismissMoreInputViewWithAnimation:YES];
        }
            break;
        default:
            break;
    }

}
-(void)cad_inputView:(CADInputView *)inputView moreBtnClickWith:(NSInteger)moreStyle
{
    if (self.view.frame.origin.y == 0) {
        [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            CGRect tempRect = CGRectMake(0, -kCADMoreInputKeyboardViewH, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds));
        self.view.frame = tempRect;
        
        self.moreInputKeyboardView.frame = CGRectMake( 0, CGRectGetHeight(self.view.bounds) - kCADMoreInputKeyboardViewH, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds));
        } completion:^(BOOL finished) {
            
        }];
    }else{
        [self cad_dismissMoreInputViewWithAnimation:YES];
        [self.inputView.textField becomeFirstResponder];
        
    }
    
//    // 先直接做图片选择
//    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
//    ipc.delegate = self;
//    [self presentViewController:ipc animated:YES completion:nil];

}
-(void)cad_inputView:(CADInputView *)inputView changeVoiceStatus:(CADVoiceStatus)status
{
    switch (status) {
        case CADVoiceStatusSpeaking:
        {//
            // 开始录音
            // 1.确定一个文件name(保证它不会重名)
            // 使用当前聊天对象的名字+时间+ 随机数
            NSInteger now = (NSInteger)[[NSDate date] timeIntervalSince1970];
            NSInteger randomNum = arc4random() % 100000; // 0-99999
            NSString *fileName = [NSString stringWithFormat:@"%@%zd%zd", self.username, now, randomNum];
            NSLog(@"CADVoiceStatusSpeaking");
            [[EMCDDeviceManager sharedInstance] asyncStartRecordingWithFileName:fileName completion:^(NSError *error) {
                if (!error) {
                    NSLog(@"正在录制");
                    // 在窗口显示正在录制的状态
                }
            }];
            
        }
            break;
        case CADVoiceStatusSend:
        {
            //拿到语音数据，构造语音信息并发送
            [[EMCDDeviceManager sharedInstance]asyncStopRecordingWithCompletion:^(NSString *recordPath, NSInteger aDuration, NSError *error) {
                if (!error) {
                    EMChatVoice *chatVoice = [[EMChatVoice alloc]initWithFile:recordPath displayName:@"voiceD"];
                    chatVoice.duration = aDuration;
                    EMVoiceMessageBody *body = [[EMVoiceMessageBody alloc]initWithChatObject:chatVoice];
                    EMMessage *message = [[EMMessage alloc]initWithReceiver:self.username bodies:@[body]];
                   [[EaseMob sharedInstance].chatManager
                asyncSendMessage:message
                progress:self
                prepare:^(EMMessage *message, EMError *error) {
                    if (!error) {
                        [self cad_loadChatMsgs];
                    }
                }
                onQueue:nil
                completion:^(EMMessage *message, EMError *error) {
                    if (!error) {
                        [self cad_loadChatMsgs];
                    }                }
                onQueue:nil];

                }
            }];
            
            
            NSLog(@"CADVoiceStatusSend");
        }
            break;
        case CADVoiceStatusWillCancle:
            //
            NSLog(@"CADVoiceStatusWillCancle");
            break;
        case CADVoiceStatusCancled:
            //
            NSLog(@"CADVoiceStatusCancled");
            break;
        default:
            break;
    }
}
#pragma mark - UINavigationControllerDelegate, UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    EMImageMessageBody *body = [[EMImageMessageBody alloc]initWithChatObject:[[EMChatImage alloc] initWithUIImage:image displayName:@"展示的图片名"]];
    EMMessage *message = [[EMMessage alloc]initWithReceiver:self.username bodies:@[body]];
    
     __weak typeof(self) weakSelf = self;
    [[EaseMob sharedInstance].chatManager asyncSendMessage:message
                                                 progress:self
                                                 prepare:^(EMMessage *message, EMError *error) {
                                                     //
                                                 } onQueue:nil completion:^(EMMessage *message, EMError *error) {
                                                     //
                                                     if (!error) {
                                                         NSLog(@"%s, line = %d", __FUNCTION__, __LINE__);
                                                         [weakSelf cad_loadChatMsgs];
                                                     }

                                                 } onQueue:nil];

}
#pragma mark - IEMChatProgressDelegate
- (void)setProgress:(float)progress
{
    
    NSLog(@"%s, line = %d", __FUNCTION__, __LINE__);
}

- (void)setProgress:(float)progress forMessage:(EMMessage *)message forMessageBody:(id<IEMMessageBody>)messageBody
{
    NSLog(@"%s, line = %d", __FUNCTION__, __LINE__);
}
#pragma mark - CADChatCellDelegate
/**点击内容按钮后图片消息的响应事件*/
-(void)cad_chatCell:(CADChatCell *)cell contentClickWithChatFrame:(CADChatFrame *)chatFrame
{
    //此处创建浏览图片的界面
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc]initWithDelegate:self];
    
    NSUInteger index = 0;
    if (chatFrame.chat.contentThumbnailIma) {
        index = [self.chatThumbnailImas indexOfObject:chatFrame.chat.contentThumbnailIma];
    }else
    {
        index = [self.chatThumbnailImas indexOfObject:chatFrame.chat.contentThumbnailImaUrl];
    }

    [browser setCurrentPhotoIndex:index];
    
    // Present
    [self.navigationController pushViewController:browser animated:YES];


}
#pragma mark - MWPhotoBrowserDelegate

// 一共展示多少图片
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser
{
    return self.chatThumbnailImas.count;
}
// 返回展示的详细图片MWPhoto对象
- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index
{
    id image = self.chaImas[index];
    MWPhoto *photo = ([image isKindOfClass:[UIImage class]]) ? [MWPhoto photoWithImage: image]: [MWPhoto photoWithURL: image];
    
    return photo;
}
// 返回展示的预览图MWPhoto对象
- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index
{
    id image = self.chatThumbnailImas[index];
    MWPhoto *photo = ([image isKindOfClass:[UIImage class]]) ? [MWPhoto photoWithImage: image]: [MWPhoto photoWithURL: image];
    
    return photo;
}
-(void)cad_dismissMoreInputViewWithAnimation:(BOOL)hasAnimation
{
    if (hasAnimation) {
        [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.view.frame = self.view.bounds;
        self.moreInputKeyboardView.frame = kMoreInputViewFrame;
    } completion:^(BOOL finished) {
        
    }];

    }
    self.view.frame = self.view.bounds;
    self.moreInputKeyboardView.frame = kMoreInputViewFrame;
}
#pragma mark - EMCallManagerDelegate
/**
 @constant eCallSessionStatusDisconnected 通话没开始
 @constant eCallSessionStatusRinging 通话响铃
 @constant eCallSessionStatusAnswering 通话双方正在协商
 @constant eCallSessionStatusPausing 通话暂停
 @constant eCallSessionStatusConnecting 通话已经准备好，等待接听
 @constant eCallSessionStatusConnected 通话已连接
 @constant eCallSessionStatusAccepted 通话双方同意协商
 */
-(void)callSessionStatusChanged:(EMCallSession *)callSession changeReason:(EMCallStatusChangedReason)reason error:(EMError *)error
{
    if(callSession.status == eCallSessionStatusConnected){
        //（modal）跳转到通话界面
        CADCallController *callController = [[CADCallController alloc]init];
        callController.session = callSession;
        [self presentViewController:callController animated:YES completion:nil];
    }
}
@end
