//
//  CADLongPressBtn.m
//  weixin2.0
//
//  Created by user on 17/7/22.
//  Copyright © 2017年 changandaxue. All rights reserved.
//

#import "CADLongPressBtn.h"

@implementation CADLongPressBtn

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UILongPressGestureRecognizer *longPressBtn = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress)];
        longPressBtn.minimumPressDuration = 0.5;
        [self addGestureRecognizer:longPressBtn];
    }
    return self;

}
-(void)longPress
{
    if (self.longPressBlock) {
        self.longPressBlock(self);
    }


}
@end
