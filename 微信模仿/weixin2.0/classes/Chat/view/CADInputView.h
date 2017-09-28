//
//  CADInputView.h
//  weixin2.0
//
//  Created by user on 17/7/21.
//  Copyright © 2017年 changandaxue. All rights reserved.
//通过自定view的方式自定义输入工具条

#import <UIKit/UIKit.h>
//输入的内容形式
typedef enum : NSUInteger {
    CADInputViewStyleText,
    CADInputViewStyleVoice,
  } CADInputViewStyle;
typedef enum : NSUInteger {
    CADVoiceStatusSpeaking,
    CADVoiceStatusSend,
    CADVoiceStatusWillCancle,
    CADVoiceStatusCancled,
} CADVoiceStatus;

@class CADInputView;
@protocol CADInputViewDelegate <NSObject>

@optional
/** 更多按钮的点击 */
- (void)cad_inputView:(CADInputView *)inputView moreBtnClickWith:(NSInteger)moreStyle;
/** 输入方式切换 文本/语音 */
- (void)cad_inputView:(CADInputView *)inputView changeInputStyle:(CADInputViewStyle)style;
/** 语音输入方式的切换 */
- (void)cad_inputView:(CADInputView *)inputView changeVoiceStatus:(CADVoiceStatus)status;

@end
@interface CADInputView : UIView
@property (weak, nonatomic) IBOutlet UITextField *textField;
+(instancetype)cad_inputView;
/** 代理 */
@property (nonatomic, weak) id<CADInputViewDelegate> delegate;
@end
