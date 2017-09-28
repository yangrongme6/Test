//
//  CADChatCell.h
//  weixin2.0
//
//  Created by user on 17/7/22.
//  Copyright © 2017年 changandaxue. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CADChatFrame,CADChatCell;

@protocol CADChatCellDelegate <NSObject>

@optional
/**点击内容按钮后图片消息的响应事件*/
- (void)cad_chatCell:(CADChatCell *)cell contentClickWithChatFrame:(CADChatFrame *)chatFrame;
@end
@interface CADChatCell : UITableViewCell

@property (nonatomic,strong) CADChatFrame *chatFrame;
@property (nonatomic,weak) id<CADChatCellDelegate> delegate;

@end
