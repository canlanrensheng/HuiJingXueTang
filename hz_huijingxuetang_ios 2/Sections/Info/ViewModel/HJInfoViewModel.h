//
//  HJInfoViewModel.h
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/9.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "BaseViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HJInfoViewModel : BaseViewModel

//获取资讯模块标题的列表的数据
@property (nonatomic,strong) NSMutableArray *newsItemNameArray;
@property (nonatomic,strong) NSMutableArray *newsItemArray;

//获取资讯条目的数据
- (void)getnewsItemslistWithSuccess:(void (^)(void))success;

@property (nonatomic,weak) UITableView *tableView;

//获取资讯的列表的数据
@property (nonatomic,assign) NSInteger totalpage;
@property (nonatomic,assign) NSInteger currentpage;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,strong) NSMutableArray *infoListArray;
- (void)getListWithModelid:(NSString *)modelid Success:(void (^)(void))success;

@end

NS_ASSUME_NONNULL_END
