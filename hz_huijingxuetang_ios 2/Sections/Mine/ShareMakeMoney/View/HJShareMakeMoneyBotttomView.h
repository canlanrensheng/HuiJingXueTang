//
//  HJShareMakeMoneyBotttomView.h
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/23.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface HJShareMakeMoneyBotttomView : BaseView

- (instancetype)initWithFrame:(CGRect)frame titleColor:(UIColor *)titleColor selectTitleColor:(UIColor *)selectTitleColor  imges:(NSArray *)imges selectImges:(NSArray *)selectImges buttons:(NSArray *)itemButtons block:(void (^)(NSInteger index))block;

@property (nonatomic,assign) NSInteger selectIndex;

@end

NS_ASSUME_NONNULL_END
