//
//  HJNoDataView.h
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/22.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface HJNoDataView : BaseView

@property (nonatomic,strong) UIView *iconImageV;
@property (nonatomic,strong) UILabel *noDataLabel;
@property (nonatomic,strong) UIButton *refreshBtn;

@property (nonatomic,strong) RACSubject *backSubject;

@end

NS_ASSUME_NONNULL_END
