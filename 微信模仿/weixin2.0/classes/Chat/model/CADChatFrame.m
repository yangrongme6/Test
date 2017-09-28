//
//  CADChatFrame.m
//  weixin2.0
//
//  Created by user on 17/7/22.
//  Copyright © 2017年 changandaxue. All rights reserved.
//

#import "CADChatFrame.h"
#import "CADChat.h"

@interface CADChatFrame ()
/** timeLab */
@property (nonatomic, assign) CGRect timeFrame;

/**< durationLab */
@property (nonatomic, assign) CGRect  durationLabFrame;

/** 头像frame */
@property (nonatomic, assign) CGRect iconFrame;

/** 内容的frame */
@property (nonatomic, assign) CGRect contentFrame;

/** cell高度 */
@property (nonatomic, assign) CGFloat cellH;

@end
@implementation CADChatFrame
- (void)setChat:(CADChat *)chat
{
    _chat = chat;
    
    CGFloat screenW = CGRectGetWidth([UIScreen mainScreen].bounds);
    CGFloat margin = 10;
    CGFloat timeX;
    CGFloat timeY = 0;
    CGFloat timeW;
    CGFloat timeH = chat.isShowTime ? 20: 0;
    
    CGSize timeStrSize = [chat.timeStr boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 20)
                                                    options:NSStringDrawingUsesLineFragmentOrigin
                                                 attributes:@{NSFontAttributeName: kTimeFont}
                                                    context: nil].size;
    timeW = timeStrSize.width + 5;
    timeX = (screenW - timeW) * 0.5;
    self.timeFrame = CGRectMake(timeX, timeH, timeW, timeH);
    
    CGFloat iconX;
    CGFloat iconY = margin + CGRectGetMaxY(self.timeFrame);
    CGFloat iconW = 44;
    CGFloat iconH = iconW;
    
    
    CGFloat contentX;
    CGFloat contentY = iconY;
    CGFloat contentW;
    CGFloat contentH;
    
    CGFloat durationX;
    CGFloat durationY = contentY;
    CGFloat durationH = iconH;
    CGFloat durationW = durationH;
    
        switch (chat.chaType) {
        case CADChatTypeText:
        {
            CGFloat contentMaxW = screenW - 2 * (margin + iconW + margin);
#warning contentMaxW写成contentW导致的错误
            CGSize contentStrSize = [chat.contentText boundingRectWithSize:CGSizeMake(contentMaxW, CGFLOAT_MAX)
                                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                                attributes:@{NSFontAttributeName: kTitleFont}
                                                                   context:nil].size;
            
            contentW = contentStrSize.width + kContentEdgeLeft + kContentEdgeRight;
            contentH = contentStrSize.height + kContentEdgeTop + kContentEdgeBottom;
        }
            break;
        case CADChatTypeImage:
                if (chat.isVertical) {
                    contentW = chat.contentThumbnailIma.size.width;
                    contentH = chat.contentThumbnailIma.size.height;
//                    contentW = 250;
//                    contentH = 150;
                }else
                {
                    contentW = chat.contentThumbnailIma.size.width;
                    contentH = chat.contentThumbnailIma.size.height;

                }

            break;
        case CADChatTypeVoice:
            {
                contentH = 44;
                contentW = [self cad_voiceLengthWithTime: chat.voiceTime];
            
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

    if (chat.isMe) {
        iconX = screenW - margin - iconW;
        contentX = iconX - margin - contentW;
        durationX = contentX - durationW;
    }else
    {
        iconX = margin;
        contentX = iconX + iconW + margin;
        durationX = contentX + contentW;
    }
        self.iconFrame = CGRectMake(iconX, iconY, iconW, iconH);
    self.contentFrame = CGRectMake(contentX, contentY, contentW, contentH);
    self.durationLabFrame = CGRectMake(durationX, durationY, durationW, durationH);
    self.cellH = (contentH > iconH) ? CGRectGetMaxY(self.contentFrame) + margin: CGRectGetMaxY(self.iconFrame) + margin;
}
-(CGFloat)cad_voiceLengthWithTime:(NSInteger)time
{
    if (time <= 5) {
        return 64.0;
    }else if (time >= 60)
    {
        return 200.0;
    }else
    {
        return 64.0 +  (time - 5)/55.0 * 136.0;
    }
}
@end
