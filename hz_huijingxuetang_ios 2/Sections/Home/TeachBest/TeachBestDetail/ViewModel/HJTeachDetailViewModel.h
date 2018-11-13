//
//  HJTeachDetailViewModel.h
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/12.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "BaseTableViewModel.h"
#import "HJTeachDetailModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HJTeachDetailViewModel : BaseTableViewModel

@property (nonatomic,strong) HJTeachDetailModel *model;
- (void)getInfoDetailWithInfoid:(NSString *)infoid Success:(void (^)(void))success;

//获取评论的数据
@property (nonatomic,weak) UITableView *tableView;
//获取资讯的列表的数据
@property (nonatomic,assign) NSInteger totalpage;
@property (nonatomic,assign) NSInteger currentpage;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,strong) NSMutableArray *infoCommondArray;
- (void)getInfoDetailCommondWithInfoid:(NSString *)infoid Success:(void (^)(void))success;

//添加评论
- (void)addNewsCommentWithInfoId:(NSString *)infoId  content:(NSString *)content Success:(void (^)(void))success;

//校验资讯密码
- (void)verifyInfoPwdWithInfoPwd:(NSString *)infoid Success:(void (^)(void))success;

@end

NS_ASSUME_NONNULL_END
