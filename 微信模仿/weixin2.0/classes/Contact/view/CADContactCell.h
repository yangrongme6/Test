//
//  CADContactCell.h
//  weixin2.0
//
//  Created by user on 17/7/21.
//  Copyright © 2017年 changandaxue. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CADContactItem;

@interface CADContactCell : UITableViewCell

+(instancetype)cad_cellWithTableView:(UITableView *)tableView;

@property (nonatomic , strong)EMBuddy *buddy;

@property (nonatomic , strong)CADContactItem *contactItem;
@end
