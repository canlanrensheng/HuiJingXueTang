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
//    NSDictionary *parameters = @{
//                                 @"type":type
//                                 };
    [[YJNetWorkTool sharedTool] requestWithURLString:url parameters:nil method:@"GET" callBack:^(id responseObject) {
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
}

//绝技诊股列表数据
- (void)stuntJudgeStockWithType:(NSString *)type page:(NSString *)page success:(void (^)(void))success {
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/stockinfolist",API_BASEURL];
    NSDictionary *parameters = @{
                                 @"type":type,
                                 @"page":page
                                 };
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
}

//推荐老师的列表
- (void)recommentTeacherWithPage:(NSString *)page success:(void (^)(void))success {
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/recommendteacher",API_BASEURL];
    NSDictionary *parameters = @{
                                 @"page":page
                                 };
    [[YJNetWorkTool sharedTool]requestWithURLString:url parameters:parameters method:@"GET" callBack:^(id responseObject) {
        NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
        NSInteger code = [[dic objectForKey:@"code"]integerValue];
        if (code == 200) {
            NSMutableArray *dataArr = dic[@"data"];
            self.recommongCourceDataArray = [HJRecommentTeacherModel mj_objectArrayWithKeyValuesArray:dataArr];
            success();
        } else {
            ShowError([dic objectForKey:@"msg"]);
        }
    } fail:^(id error) {
        ShowError(error);
    }];
}

@end
