//
//  HJMessageDetailViewModel.h
//  HuiJingSchool
//
//  Created by 张金山 on 2018/12/7.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "BaseTableViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HJMessageDetailViewModel : BaseTableViewModel

@property (nonatomic,weak) UITableView *tableView;
//获取资讯的列表的数据
@property (nonatomic,assign) NSInteger totalpage;
@property (nonatomic,assign) NSInteger currentpage;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,strong) NSMutableArray *messageDetailListArray;
- (void)getFurtherMessageWithType:(NSString *)type Success:(void (^)(BOOL success))success;

//设置消息已读
//- (void)setMessageReadWithSuccess:(void (^)(void))success;

@end

NS_ASSUME_NONNULL_END
