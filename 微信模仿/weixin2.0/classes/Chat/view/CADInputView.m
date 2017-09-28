//
//  CADInputView.m
//  weixin2.0
//
//  Created by user on 17/7/21.
//  Copyright © 2017年 changandaxue. All rights reserved.
//

#import "CADInputView.h"
@interface CADInputView()
@property (weak, nonatomic) IBOutlet UIButton *voiceBtn;
@property (weak, nonatomic) IBOutlet UIButton *inputStyleBtn;

@end
@implementation CADInputView
-(void)awakeFromNib{

    [super awakeFromNib];
    [self.voiceBtn setBackgroundImage:[UIImage yf_imageWithColor:BackGround243Color] forState:UIControlStateNormal];
    self.voiceBtn.layer.borderWidth = 0.5;
    self.voiceBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.voiceBtn.layer.cornerRadius = 5;
    
    self.voiceBtn.clipsToBounds = YES;
    
    self.voiceBtn.hidden = YES;

}
+(instancetype)cad_inputView
{
    //从xib文件中加载view
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;

}
- (IBAction)changeInputStyle:(UIButton *)sender {
    
    self.voiceBtn.hidden = sender.isSelected;
    
    sender.selected = !sender.isSelected;
    
    self.voiceBtn.hidden ? [self.textField becomeFirstResponder] : [self.textField resignFirstResponder];
    
    if ([self.delegate respondsToSelector:@selector(cad_inputView:changeInputStyle:)]) {
        [self.delegate cad_inputView:self.inputView changeInputStyle:(self.voiceBtn.hidden ? CADInputViewStyleText : CADInputViewStyleVoice)];
    }
}

//点击更多按钮
- (IBAction)moreBtnClick:(id)sender {
    //1.如果是编辑状态，则取消编辑状态
    if ([self.textField isFirstResponder]) {
        [self.textField resignFirstResponder];
    }
    //2.根据下方keyboard的高度（控制器.view的y值，来确定它的滑入滑出状态）

    if ([self.delegate respondsToSelector:@selector(cad_inputView:moreBtnClickWith:)]) {
        [self.delegate cad_inputView:self moreBtnClickWith:0];
    }
    //3.需要注意的是，涉及到textfiled是否是第一响应者时，注意其执行的先后顺序即可
    if (!self.voiceBtn.hidden) {
        [self changeInputStyle:self.inputStyleBtn];
    }
}
//点击表情按钮
- (IBAction)empressOnClick:(id)sender {
}

- (IBAction)cad_voiceTouchDown:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(cad_inputView:changeVoiceStatus:)]) {
        [self.delegate cad_inputView:self changeVoiceStatus:CADVoiceStatusSpeaking];
    }
}
- (IBAction)cad_voiceTouchUpInside {
    if ([self.delegate respondsToSelector:@selector(cad_inputView:changeVoiceStatus:)]) {
        [self.delegate cad_inputView:self changeVoiceStatus:CADVoiceStatusSend];
    }
}
- (IBAction)cad_voiceTouchDragOutside:(id)sender {
    if ([self.delegate respondsToSelector:@selector(cad_inputView:changeVoiceStatus:)]) {
        [self.delegate cad_inputView:self changeVoiceStatus:CADVoiceStatusWillCancle];
    }
}
- (IBAction)cad_voiceTouchUpOutside:(id)sender {
    if ([self.delegate respondsToSelector:@selector(cad_inputView:changeVoiceStatus:)]) {
        [self.delegate cad_inputView:self changeVoiceStatus:CADVoiceStatusCancled];
    }
}

@end
