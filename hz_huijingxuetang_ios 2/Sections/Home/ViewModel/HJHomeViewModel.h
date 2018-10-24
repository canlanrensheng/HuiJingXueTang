//
//  HJHomeViewModel.h
//  HuiJingSchool
//
//  Created by 张金山 on 2018/10/22.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "BaseTableViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HJHomeViewModel : BaseTableViewModel


//轮播图的数据
@property (nonatomic,strong) NSMutableArray *cycleScrollViewDataArray;
@property (nonatomic,strong) NSMutableArray *headerDataArray;

//推荐课程的数据源
@property (nonatomic,strong) NSMutableArray *recommongCourceDataArray;

//课程推荐列表
- (void)HomeRecommongCourceWithType:(NSString *)type success:(void (^)(void))success;

//绝技诊股列表数据
@property (nonatomic,strong) NSMutableArray *stuntJudgeStockArray;
- (void)stuntJudgeStockWithType:(NSString *)type page:(NSString *)page success:(void (^)(void))success;

@end

NS_ASSUME_NONNULL_END
