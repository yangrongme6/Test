//
//  CADChat.h
//  weixin2.0
//
//  Created by user on 17/7/22.
//  Copyright © 2017年 changandaxue. All rights reserved.
//数据模型

#import <Foundation/Foundation.h>

@interface CADChat : NSObject
typedef enum : NSUInteger {
    CADChatFromMe = 0,
    CADChatFromOther = 1,
} CADChatFrom;
typedef enum : NSUInteger {
    CADChatTypeText = eMessageBodyType_Text,
    CADChatTypeImage = eMessageBodyType_Image,
    CADChatTypeLocation = eMessageBodyType_Location,
    CADChatTypeVoice = eMessageBodyType_Voice,
    CADChatTypeVideo = eMessageBodyType_Video,
    CADChatTypeFile = eMessageBodyType_File,
} CADChatType;

+ (instancetype)xmg_chatWith:(EMMessage *)emsg preTimestamp:(long long)preTimestamp;

/** 友盟聊天消息对象 */
@property (nonatomic, strong) EMMessage *emsg;
/** 聊天的类型 */
@property (nonatomic , assign ,readonly) CADChatType chaType;
/** 是我还是他 */
@property (nonatomic, assign, getter=isMe, readonly) BOOL me;
/** 头像urlStr */
@property (nonatomic, copy, readonly) NSString *userIcon;
/** timeStr */
@property (nonatomic, copy, readonly) NSString *timeStr;
/** 是否显示时间 */
@property (nonatomic, assign, getter=isShowTime, readonly) BOOL showTime;
/** 上一条聊天记录的时间 */
@property (nonatomic, assign) long long preTimestamp;

/** 文字聊天内容 */
@property (nonatomic, copy, readonly) NSString *contentText;
/** 文字聊天的背景图 */
@property (nonatomic, strong, readonly) UIImage *contectTextBackgroundIma;
@property (nonatomic, strong, readonly) UIImage *contectTextBackgroundHLIma;

/*>>>>>>>图片聊天的内容>>>>>>>>>>*/
/** 详细大图 */
@property (nonatomic, strong,readonly) UIImage *contentIma;
/** 预览图 */
@property (nonatomic, strong,readonly) UIImage *contentThumbnailIma;
/** 详细大图url */
@property (nonatomic, strong,readonly) NSURL *contentImaUrl;
/** 预览图url */
@property (nonatomic, strong,readonly) NSURL *contentThumbnailImaUrl;
/** 是否横预览,如果是YES就是横显示 */
@property (nonatomic, assign, getter=isVertical,readonly) BOOL vertical;

/*>>>>>>>语音聊天的内容>>>>>>>>>>*/
@property (nonatomic,assign,readonly)NSInteger voiceTime;
@property (nonatomic,copy,readonly)NSString *voicePath;

@end
