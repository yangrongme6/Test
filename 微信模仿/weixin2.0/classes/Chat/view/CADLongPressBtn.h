//
//  CADLongPressBtn.h
//  weixin2.0
//
//  Created by user on 17/7/22.
//  Copyright © 2017年 changandaxue. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CADLongPressBtn;
typedef void(^CADLongPressBtnBlock)(CADLongPressBtn *btn);
@interface CADLongPressBtn : UIButton
@property (nonatomic, copy) CADLongPressBtnBlock longPressBlock; /**< 长按回调 */
@end
