//
//  HJHomeViewModel.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/10/22.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJHomeViewModel.h"
#import "HJHomeStuntJudgeStockModel.h"
#import "HJHomeCourseRecommendedModel.h"
#import "HJRecommentTeacherModel.h"
#import "HJHomeLastestNewsModel.h"
#import "HJHomeLimitKillModel.h"
#import "HJExclusiveInfoModel.h"
#import "HJHomeLiveModel.h"
@implementation HJHomeViewModel

- (NSMutableArray *)headerDataArray {
    if(!_headerDataArray){
        _headerDataArray = [NSMutableArray array];
    }
    return _headerDataArray;
}

//获取推荐课程的数据
- (void)HomeRecommongCourceWithType:(NSString *)type success:(void (^)(void))success {
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/mp/indexcourselist",API_BASEURL];
    NSDictionary *para = @{@"vesttype" : type};
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[YJNetWorkTool sharedTool] requestWithURLString:url parameters:para method:@"GET" callBack:^(id responseObject) {
            NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
            NSInteger code = [[dic objectForKey:@"code"]integerValue];
            if (code == 200) {
                NSMutableArray * dataArray = dic[@"data"];
                self.recommongCourceDataArray = [HJHomeCourseRecommendedModel mj_objectArrayWithKeyValuesArray:dataArray];
                success();
            } else {
                ShowError([dic objectForKey:@"msg"]);
            }
        } fail:^(id error) {
            ShowError(error);
        }];
    });
}

//绝技诊股列表数据
- (void)stuntJudgeStockWithType:(NSString *)type page:(NSString *)page success:(void (^)(void))success {
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/stockinfolist",API_BASEURL];
    NSDictionary *parameters = @{
                                 @"type":type,
                                 @"page":page
                                 };
    if(MaJia) {
        parameters = @{
                       @"type" : type,
                       @"page" : page,
                       @"vesttype" : @"free"
                       };
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[YJNetWorkTool sharedTool]requestWithURLString:url parameters:parameters method:@"GET" callBack:^(id responseObject) {
            NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
            NSInteger code = [[dic objectForKey:@"code"]integerValue];
            if (code == 200) {
                NSDictionary *dataDict = dic[@"data"];
                NSMutableArray *stocklistArr = dataDict[@"stocklist"];
                self.stuntJudgeStockArray = [HJHomeStuntJudgeStockModel mj_objectArrayWithKeyValuesArray:stocklistArr];
                success();
            } else {
                ShowError([dic objectForKey:@"msg"]);
            }
        } fail:^(id error) {
            ShowError(error);
        }];
    });
}

//推荐老师的列表
- (void)recommentTeacherWithPage:(NSString *)page success:(void (^)(void))success {
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/recommendteacher",API_BASEURL];
    NSDictionary *parameters = @{
                                 @"page":page
                                 };
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[YJNetWorkTool sharedTool] requestWithURLString:url parameters:parameters method:@"GET" callBack:^(id responseObject) {
            NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
            NSInteger code = [[dic objectForKey:@"code"]integerValue];
            if (code == 200) {
                NSDictionary *dataDic= dic[@"data"];
                NSArray *teacherlistArr = dataDic[@"teacherlist"];
                self.recommentTeacherArray = [HJRecommentTeacherModel mj_objectArrayWithKeyValuesArray:teacherlistArr];
                success();
            } else {
                ShowError([dic objectForKey:@"msg"]);
            }
        } fail:^(id error) {
            ShowError(error);
        }];
    });
}

//获取最新资讯
- (void)getDynamicnewSuccess:(void (^)(void))success {
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/latestnews",API_BASEURL];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[YJNetWorkTool sharedTool] requestWithURLString:url parameters:nil method:@"GET" callBack:^(id responseObject) {
            NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
            NSInteger code = [[dic objectForKey:@"code"]integerValue];
            if (code == 200) {
                NSDictionary *dataDic= dic[@"data"];
                NSArray *teacherlistArr = dataDic[@"lastestNews"];
                NSMutableArray *topTitlesMarr = [NSMutableArray array];
                NSMutableArray *bottomTitlesMarr = [NSMutableArray array];
                for (NSDictionary * dic in teacherlistArr) {
                    HJHomeLastestNewsModel *model = [HJHomeLastestNewsModel mj_objectWithKeyValues:dic];
                    [topTitlesMarr addObject:[NSString stringWithFormat:@"%@刚刚购买了",model.studentName]];
                    [bottomTitlesMarr addObject:[NSString stringWithFormat:@"%@老师的《%@》",model.teacherName,model.courseName]];
                }
                self.topTitlesArray = topTitlesMarr;
                self.bottomTitlesArray = bottomTitlesMarr;
                success();
            } else {
                ShowError([dic objectForKey:@"msg"]);
            }
        } fail:^(id error) {
            ShowError(error);
        }];
    });
}

//获取限时特惠的接口
- (void)getLimitKillDataWithSuccess:(void (^)(void))success {
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/flashsale",API_BASEURL];
    NSDictionary *parameters = @{
                                 @"page" : @"1"
                                 };
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[YJNetWorkTool sharedTool] requestWithURLString:url parameters:parameters method:@"POST" callBack:^(id responseObject) {
            NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
            NSInteger code = [[dic objectForKey:@"code"]integerValue];
            if (code == 200) {
                NSDictionary *dataDic= dic[@"data"];
                NSArray *teacherlistArr = dataDic[@"courseList"];
                self.limitKillArray = [HJHomeLimitKillModel mj_objectArrayWithKeyValuesArray:teacherlistArr];
                success();
            } else {
                ShowError([dic objectForKey:@"msg"]);
            }
        } fail:^(id error) {
            ShowError(error);
        }];
    });
}

//获取独家资讯
- (void)getExclusiveInfoSuccess:(void (^)(void))success {
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/indexnewslistforwxapp?type=2",API_BASEURL];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[YJNetWorkTool sharedTool] requestWithURLString:url parameters:nil method:@"GET" callBack:^(id responseObject) {
            NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
            NSInteger code = [[dic objectForKey:@"code"]integerValue];
            if (code == 200) {
                NSArray *dataArray= dic[@"data"];
                NSMutableArray *marr = [NSMutableArray array];
                for (NSDictionary *dic in dataArray) {
                    HJExclusiveInfoModel *model = [HJExclusiveInfoModel mj_objectWithKeyValues:dic];
                    [marr addObject:model];
                }
                self.exclusiveInfoArray = marr;
                success();
            } else {
                ShowError([dic objectForKey:@"msg"]);
            }
        } fail:^(id error) {
            ShowError(error);
        }];
    });
}

//获取到直播的列表的数据
- (void)getLiveListSuccess:(void (^)(void))success {
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/livecoursesindexlist",API_BASEURL];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[YJNetWorkTool sharedTool] requestWithURLString:url parameters:nil method:@"GET" callBack:^(id responseObject) {
            NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
            NSInteger code = [[dic objectForKey:@"code"]integerValue];
            if (code == 200) {
                NSArray *dataArray= dic[@"data"];
                NSMutableArray *marr = [NSMutableArray array];
                for (NSDictionary *dic in dataArray) {
                    HJHomeLiveModel *model = [HJHomeLiveModel mj_objectWithKeyValues:dic];
                    [marr addObject:model];
                }
                self.liveListArray = marr;
                success();
            } else {
                ShowError([dic objectForKey:@"msg"]);
            }
        } fail:^(id error) {
            ShowError(error);
        }];
    });
}


@end
