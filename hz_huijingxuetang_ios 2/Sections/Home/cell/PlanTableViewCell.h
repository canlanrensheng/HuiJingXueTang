//
//  PlanTableViewCell.h
//  HuiJingSchool
//
//  Created by Junier on 2018/2/5.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlanTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *titlelb;
@property (weak, nonatomic) IBOutlet UILabel *timelb;
@property (weak, nonatomic) IBOutlet UIButton *goonbtn;

@end
