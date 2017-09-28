//
//  CADMoreInputKeyboardView.h
//  weixin2.0
//
//  Created by user on 17/8/28.
//  Copyright © 2017年 changandaxue. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kCADMoreInputKeyboardViewH 200
#define CADPhotoStr  @"照片"
#define CADVideoStr  @"视频聊天"

typedef void(^CADMoreInputBtnClick)(UIButton *btn);
@interface CADMoreInputKeyboardView : UIView
//
@property(nonatomic,copy)CADMoreInputBtnClick btnClickBlock;
@end
