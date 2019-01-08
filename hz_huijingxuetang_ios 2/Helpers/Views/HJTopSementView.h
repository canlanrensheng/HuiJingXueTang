//
//  HJTopSementView.h
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/9.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface HJTopSementView : BaseView

- (instancetype)initWithFrame:(CGRect)frame titleColor:(UIColor *)titleColor selectTitleColor:(UIColor *)selectTitleColor  lineColor:(UIColor *)lineColor  buttons:(NSArray *)itemButtons block:(void (^)(NSInteger index))block;

//选中的下标
@property (nonatomic,assign) NSInteger selectIndex;

@end

NS_ASSUME_NONNULL_END
