//
//  SchoolTableViewCell.h
//  HuiJingSchool
//
//  Created by Junier on 2018/1/30.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SchoolTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *coursename;
@property (weak, nonatomic) IBOutlet UILabel *isfreelb;
@property (weak, nonatomic) IBOutlet UIButton *shopcartbtn;
@property (weak, nonatomic) IBOutlet UILabel *thumbsupcountlb;
@property (weak, nonatomic) IBOutlet UIImageView *imgview;
@property (weak, nonatomic) IBOutlet UILabel *num;
@property (weak, nonatomic) IBOutlet UIButton *goonbtn;
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (weak, nonatomic) IBOutlet UILabel *free;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnwidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *goonbtnwidth;
@property (weak, nonatomic) IBOutlet UIButton *zanbtn;
@property (weak, nonatomic) IBOutlet UILabel *namelabel1;
@property (weak, nonatomic) IBOutlet UILabel *pricelb;

@end
