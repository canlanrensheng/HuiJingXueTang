//
//  HJAccountManagerCell.h
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/23.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "BaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface HJAccountManagerCell : BaseTableViewCell

@property (nonatomic,strong) UIImageView *payImageV;
@property (nonatomic,strong) UILabel *payTypeLabel;
@property (nonatomic,strong) UILabel *payNameLabel;
@property (nonatomic,strong) UIButton *unBindBtn;

@property (nonatomic,strong) RACSubject *backSub;

@end

NS_ASSUME_NONNULL_END
