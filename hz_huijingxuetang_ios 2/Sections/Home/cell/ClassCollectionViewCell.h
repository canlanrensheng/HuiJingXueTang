//
//  ClassCollectionViewCell.h
//  HuiJingSchool
//
//  Created by 陈燕军 on 2018/5/9.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClassCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *titlelb;
@property (weak, nonatomic) IBOutlet UILabel *freelb;
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *numlb;

@end
