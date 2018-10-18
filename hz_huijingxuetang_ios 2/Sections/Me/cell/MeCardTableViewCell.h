//
//  MeCardTableViewCell.h
//  HuiJingSchool
//
//  Created by Junier on 2018/2/7.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MeCardTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (weak, nonatomic) IBOutlet UILabel *timelb;
@property (weak, nonatomic) IBOutlet UILabel *datelab;
@property (weak, nonatomic) IBOutlet UILabel *rplb;
@property (weak, nonatomic) IBOutlet UILabel *cardname;

@end
