//
//  ReceiveTableViewCell.m
//  IMTest
//
//  Created by 陈燕军 on 2017/8/31.
//  Copyright © 2017年 陈燕军. All rights reserved.
//

#import "ReceiveTableViewCell.h"

@implementation ReceiveTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


-(CGFloat)cellhight
{
    
    [self layoutIfNeeded];
    CGFloat cellhight = self.chatcellimg.frame.size.height + 30;
    return cellhight;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
