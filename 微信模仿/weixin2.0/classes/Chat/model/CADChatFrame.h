//
//  CADChatFrame.h
//  weixin2.0
//
//  Created by user on 17/7/22.
//  Copyright © 2017年 changandaxue. All rights reserved.
// 布局模型

#import <Foundation/Foundation.h>
#define kContentEdgeTop 15
#define kContentEdgeLeft 20
#define kContentEdgeBottom 25
#define kContentEdgeRight 20
@class CADChat;

@interface CADChatFrame : NSObject

@property(nonatomic,strong)CADChat *chat;
/**>>>>>下面都是布局属性>>>>>>*/
/** timeLab */
@property (nonatomic, assign, readonly) CGRect timeFrame;

/**< durationLab */
@property (nonatomic, assign,readonly) CGRect durationLabFrame;

/** 头像frame */
@property (nonatomic, assign, readonly) CGRect iconFrame;

/** 内容的frame */
@property (nonatomic, assign, readonly) CGRect contentFrame;

/** cell高度 */
@property (nonatomic, assign, readonly) CGFloat cellH;
@end
