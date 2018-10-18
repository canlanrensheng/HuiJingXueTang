//
//  OrderListCell.h
//  HuiJingSchool
//
//  Created by 陈燕军 on 2018/6/1.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "orderModel.h"
@interface OrderListCell : UITableViewCell
@property (nonatomic,strong)UIImageView *imgview;
@property (nonatomic,strong)UILabel *textview;
@property (nonatomic,strong)UILabel *pricelabel;
@property (nonatomic,strong)UILabel *timelabel;
@property (nonatomic,strong)UIButton *paybtn;
@property (nonatomic,strong)UIButton *infobtn;
@property (nonatomic,strong)UIButton *delbtn;

@property (nonatomic,strong) orderModel *model;
@end
