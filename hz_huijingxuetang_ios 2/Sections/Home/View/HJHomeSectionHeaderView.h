//
//  HJHomeSectionHeaderView.h
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/26.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HJHomeSectionHeaderView : UITableViewHeaderFooterView

@property (nonatomic,strong) UILabel *titleTextLabel;
@property (nonatomic,strong) UIButton *moreBtn;
@property (nonatomic,strong) RACSubject *backSubject;


@end

NS_ASSUME_NONNULL_END
