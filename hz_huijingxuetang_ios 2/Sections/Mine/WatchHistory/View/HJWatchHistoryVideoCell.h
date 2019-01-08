//
//  HJWatchHistoryVideoCell.h
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/9.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "BaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface HJWatchHistoryVideoCell : BaseTableViewCell

@property (nonatomic,strong) UIImageView *imaV;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *totalTimeLabel;
@property (nonatomic,strong) UILabel *teacherNameLabel;
@property (nonatomic,strong) UILabel *timeLabel;

@end

NS_ASSUME_NONNULL_END
