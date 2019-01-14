//
//  HJRiskEvaluationViewModel.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/27.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJRiskEvaluationViewModel.h"
#import "HJRiskEvaluationModel.h"
@implementation HJRiskEvaluationViewModel

- (void)getRiskEvaluationListWithSuccess:(void (^)(BOOL successFlag))success {
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/evaluate/question",API_BASEURL];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[YJNetWorkTool sharedTool] requestWithURLString:url parameters:nil method:@"GET" callBack:^(id responseObject) {
            NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
            NSInteger code = [[dic objectForKey:@"code"]integerValue];
            if (code == 200) {
                NSArray *dataArray = dic[@"data"];
                NSMutableArray *marr = [NSMutableArray array];
                for (NSDictionary *dataDic in dataArray) {
                    for (NSDictionary *questionDic in dataDic[@"question"]) {
                        Question *questionModel = [Question mj_objectWithKeyValues:questionDic];
                        questionModel.classname = [dataDic valueForKey:@"classname"];
                        for (Answer *answerModel in questionModel.answer) {
                            NSString *anwerDes = [NSString stringWithFormat:@"%@",answerModel.answername];
                            CGFloat cellHeight = [anwerDes calculateSize:CGSizeMake(Screen_Width - kWidth(40), MAXFLOAT)  font:MediumFont(font(11))].height;
                            answerModel.answerCellHeight = kHeight(28.0) + cellHeight;
                        }
                        //计算问题的cell的高度
                        NSString *questionDes = [NSString stringWithFormat:@"%@：%@",questionModel.classname,questionModel.questionname];
                        CGFloat cellHeight = [questionDes calculateSize:CGSizeMake(Screen_Width - kWidth(20), MAXFLOAT) font:BoldFont(font(14))].height;
                        DLog(@"获取到的高度是:%lf",cellHeight);
                        questionModel.questionCellHeight = cellHeight + kHeight(15.0);
                        [marr addObject:questionModel];
                    }
                }
                self.riskEvaluationListArray = marr;
                success(YES);
            } else {
                success(NO);
                ShowError([dic objectForKey:@"msg"]);
            }
        } fail:^(id error) {
            success(NO);
            hideHud();
            ShowError(error);
        }];
    });
}

//提交风险评估的数据
- (void)submmitRiskEvaluationDataWithAnserids:(NSString *)answerIds Success:(void (^)(void))success {
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/evaluate/userRiskEvaluate",API_BASEURL];
    NSDictionary *parameters = @{
                                 @"accesstoken" : [APPUserDataIofo AccessToken],
                                 @"ids" : answerIds.length > 0 ? answerIds : @""
                                 };
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[YJNetWorkTool sharedTool] requestWithURLString:url parameters:parameters method:@"POST" callBack:^(id responseObject) {
            NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
            NSInteger code = [[dic objectForKey:@"code"]integerValue];
            if (code == 200) {
                
                success();
            } else {
                ShowError([dic objectForKey:@"msg"]);
            }
        } fail:^(id error) {
            hideHud();
            ShowError(error);
        }];
    });
}

@end
