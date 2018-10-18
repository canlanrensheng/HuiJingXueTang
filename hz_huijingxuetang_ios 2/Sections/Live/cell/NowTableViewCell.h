//
//  NowTableViewCell.h
//  HuiJingSchool
//
//  Created by Junier on 2018/1/24.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NowTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *classname;
@property (weak, nonatomic) IBOutlet UILabel *teachername;
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (weak, nonatomic) IBOutlet UIImageView *playimg;
@property (weak, nonatomic) IBOutlet UILabel *playnum;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnwidth;

@end
