//
//  ImgLabelAndLabelTableViewCell.h
//  TennisClass
//
//  Created by Junier on 2018/1/2.
//  Copyright © 2018年 陈燕军. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImgLabelAndLabelTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgview;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *venuelabel;

@end
