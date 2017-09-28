//
//  CADMoreInputKeyboardView.m
//  weixin2.0
//
//  Created by user on 17/8/28.
//  Copyright © 2017年 changandaxue. All rights reserved.
//

#import "CADMoreInputKeyboardView.h"
#import "CADMoreViewBtn.h"

@interface CADMoreInputKeyboardView()
@property(nonatomic,strong)NSMutableArray *btns;
@property(nonatomic,strong)NSArray *btnTitles;
@end

@implementation CADMoreInputKeyboardView
- (NSArray *)btnTitles
{
    if (!_btnTitles) {
        _btnTitles = @[CADPhotoStr,CADVideoStr];
    }
    return _btnTitles;
    
}
- (NSMutableArray *)btns
{
    if (!_btns) {
        _btns = [NSMutableArray array];
    }
    return _btns;
    
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = BackGround243Color;
        //添加控件
        for (NSString *title in self.btnTitles) {
            [self cad_setBtnWithTitle:title image:title];
        }
    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat btnW = 60;
    CGFloat btnH = btnW;
    CGFloat orgx = 10;
    CGFloat orgy = 10;
    
    NSInteger maxRowCount = 2;
    NSInteger maxColCount = 4;
    
    CGFloat rowMargin = (CGRectGetHeight(self.bounds) - 2 * orgy - maxRowCount * btnH)/(maxColCount + 1);
    
    CGFloat colMargin = (CGRectGetWidth(self.bounds) - 2 * orgx- maxColCount * btnW)/(maxColCount + 1);
    
    NSInteger index = 0;
    NSLog(@"打印 %lu",(unsigned long)self.btns.count);

    for (UIButton *btn in self.btns) {
                 if (index < (maxRowCount *  maxColCount)) {
            
        NSInteger col = index % maxColCount;
        NSInteger row = index / maxColCount;
        btn.frame = CGRectMake(orgx +  col * (btnW + colMargin), (orgy + row * (btnH + rowMargin)), btnW, btnH);
        }
        
        index ++;
       
    }
}
-(void)cad_setBtnWithTitle:(NSString *)title image:(NSString *)imageStr
{
    CADMoreViewBtn *btn = [CADMoreViewBtn buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:imageStr] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(cad_moreInputBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    [self.btns addObject:btn];

}
-(void)cad_moreInputBtnClick:(UIButton *)btn
{
    if(self.btnClickBlock){
        self.btnClickBlock(btn);
    }
    NSLog(@"更多洁面");
}

@end
