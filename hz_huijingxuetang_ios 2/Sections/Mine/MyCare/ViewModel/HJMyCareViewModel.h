//
//  HJMyCareViewModel.h
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/19.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "BaseTableViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HJMyCareViewModel : BaseTableViewModel

@property (nonatomic,weak) UITableView *tableView;

//获取资讯的列表的数据
@property (nonatomic,assign) NSInteger totalpage;
@property (nonatomic,assign) NSInteger currentpage;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,strong) NSMutableArray *myCareArray;

@property (nonatomic,assign) BOOL isFirstLoad;
- (void)getMyCareListWithSuccess:(void (^)(void))success;

//取消关注
- (void)careOrCancleCareWithTeacherId:(NSString *)teacherId
                          accessToken:(NSString *)accessToken
                            insterest:(NSString *)insterest
                              Success:(void (^)(void))success;

@end

NS_ASSUME_NONNULL_END
