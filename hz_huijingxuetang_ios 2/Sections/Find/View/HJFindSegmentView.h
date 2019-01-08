//
//  HJFindSegmentView.h
//  HuiJingSchool
//
//  Created by 张金山 on 2018/10/30.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface HJFindSegmentView : BaseView


@property (nonatomic,strong) RACSubject *clickSubject;

- (instancetype)initWithFrame:(CGRect)frame titleColor:(UIColor *)titleColor selectTitleColor:(UIColor *)selectTitleColor  lineColor:(UIColor *)lineColor  buttons:(NSArray *)itemButtons block:(void (^)(NSInteger index))block;

@property (nonatomic,assign) NSInteger selectIndex;

@end

NS_ASSUME_NONNULL_END
