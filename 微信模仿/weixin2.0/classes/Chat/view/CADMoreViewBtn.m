//
//  CADMoreViewBtn.m
//  weixin2.0
//
//  Created by user on 17/8/28.
//  Copyright © 2017年 changandaxue. All rights reserved.
//

#import "CADMoreViewBtn.h"

#define kImageRatio 0.6
@implementation CADMoreViewBtn

-(id )initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if(self)
    {
        //1.设置文字属性
        self.titleLabel.textAlignment=NSTextAlignmentCenter;
        
        self.titleLabel.font=[UIFont systemFontOfSize:13.0];
        
        //2.设置图片属性
        self.imageView.contentMode=UIViewContentModeScaleAspectFit;
        self.adjustsImageWhenHighlighted=NO;
        //设置选中时的背景
       // [self setBackgroundImage:[UIImage imageNamed:@"tabbar_slider.png"] forState:UIControlStateSelected];
        
    }
    return self;
}

#pragma mark 返回的是按钮内部UILable的边框
-(CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleY =contentRect.size.height *kImageRatio-5;
    CGFloat titleHeight=contentRect.size.height-titleY;
    return CGRectMake(0, titleY, contentRect.size.width, titleHeight);
}
#pragma mark 返回的是按钮内部imageview的边框
-(CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(0, 0, contentRect.size.width,contentRect.size.height *kImageRatio);
 }


@end
