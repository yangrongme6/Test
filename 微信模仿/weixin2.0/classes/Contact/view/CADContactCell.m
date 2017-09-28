//
//  CADContactCell.m
//  weixin2.0
//
//  Created by user on 17/7/21.
//  Copyright © 2017年 changandaxue. All rights reserved.
//

#import "CADContactCell.h"
#import "CADContactItem.h"

@interface CADContactCell()
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UIImageView *userIcon;

@end
@implementation CADContactCell

+(instancetype)cad_cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = nil;
    if (!ID) {
        ID = [NSString stringWithFormat:@"%@ID",NSStringFromClass(self)];
    }
    static UITableView *tableV = nil;
    if (![tableView isEqual:tableV]) {
        tableV = tableView;
    }
    id cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
    }
    return cell;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setBuddy:(EMBuddy *)buddy
{
    _buddy = buddy;
    self.userName.text = buddy.username;
    self.userIcon.image = [UIImage imageNamed:@"iconimage"];

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setContactItem:(CADContactItem *)contactItem
{
    _contactItem = contactItem;
    
    self.userName.text = contactItem.title;
    
    self.userIcon.image = [UIImage imageNamed:contactItem.iconName];


}
@end
