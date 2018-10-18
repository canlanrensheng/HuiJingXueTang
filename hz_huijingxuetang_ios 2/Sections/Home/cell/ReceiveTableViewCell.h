//
//  ReceiveTableViewCell.h
//  IMTest
//
//  Created by 陈燕军 on 2017/8/31.
//  Copyright © 2017年 陈燕军. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface ReceiveTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *chatcellimg;
@property (weak, nonatomic) IBOutlet UILabel *chatlable;
@property (weak, nonatomic) IBOutlet UIImageView *iconimg;

-(CGFloat)cellhight;
@end
