//
//  HJTeacherRecommondViewModel.h
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/15.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "BaseViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HJTeacherRecommondViewModel : BaseViewModel

@property (nonatomic,assign) NSInteger totalpage;
@property (nonatomic,assign) NSInteger currentpage;


@property (nonatomic,weak) UITableView *tableView;
@property (nonatomic,assign) NSInteger page;
//推荐老师列表
- (void)getRecommendTeacherWithSuccess:(void (^)(void))success;

@property (nonatomic,strong) NSMutableArray *recommendTeacherArray;


@end

NS_ASSUME_NONNULL_END
