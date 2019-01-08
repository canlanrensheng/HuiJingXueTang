//
//  HJStuntJudgeViewModel.h
//  HuiJingSchool
//
//  Created by 张金山 on 2018/10/29.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "BaseViewModel.h"
#import "HJStuntJudgeToolView.h"
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,StuntJuageType){
    StuntJuageTypeRecommond = 0,
    StuntJuageTypeReplyed = 1,
    StuntJuageTypeWaitReply = 2
};

@interface HJStuntJudgeViewModel : BaseViewModel


@property (nonatomic,weak) UITableView *tableView;
@property (nonatomic,weak) HJStuntJudgeToolView *toolView;

@property (nonatomic,assign) StuntJuageType stuntJuageType;

@property (nonatomic,strong) NSMutableArray *stuntJuageRecommendArray;
@property (nonatomic,strong) NSMutableArray *stuntJuageReplyedArray;
@property (nonatomic,strong) NSMutableArray *stuntJuageWaitReplyArray;
@property (nonatomic,copy) NSString *type;
@property (nonatomic,copy) NSString *stuntId;
@property (nonatomic,assign) NSInteger page;
- (void)stuntJuageRecommendWithSuccess:(void (^)(void))success;
- (void)stuntJuageReplyedWithSuccess:(void (^)(void))success;
- (void)stuntJuageWaitReplyWithSuccess:(void (^)(void))success;

//调用诊股提问
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *question;
- (void)addStuntQuestionWithSuccess:(void (^)(void))success;

//删除
- (void)deleteWithId:(NSString *)stuntId Success:(void (^)(void))success;

//标记消息已读
@property (nonatomic,assign) NSInteger notreadednum;


@end

NS_ASSUME_NONNULL_END
