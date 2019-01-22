//
//  HJStuntJudgeDetailViewModel.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/12/8.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJStuntJudgeDetailViewModel.h"

@implementation HJStuntJudgeDetailViewModel

- (void)getStuntJudgeDetailWithId:(NSString *)stuntId Success:(void (^)(BOOL successFlag))success {
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/stockinfo",API_BASEURL];
    NSDictionary *parameters = nil;
    parameters = @{
                   @"id" : stuntId.length > 0 ? stuntId : @""
                   };
//    if(MaJia) {
//        parameters = @{
//                       @"id" : stuntId.length > 0 ? stuntId : @"",
//                       @"vesttype" : @"free"
//                       };
//        
//    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[YJNetWorkTool sharedTool] requestWithURLString:url parameters:parameters method:@"POST" callBack:^(id responseObject) {
            NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
            NSInteger code = [[dic objectForKey:@"code"]integerValue];
            DLog(@"获取到的数据手:%@",[NSString convertToJsonData:dic]);
            if (code == 200) {
                NSDictionary *dataDict = dic[@"data"];
                NSDictionary *stockinfoDict = dataDict[@"stockinfo"];
                HJStuntJudgeListModel *model = [HJStuntJudgeListModel mj_objectWithKeyValues:stockinfoDict];
                CGFloat height = [[NSString stringWithFormat:@"%@ %@",model.questiontitle,model.questiondes] calculateSize:CGSizeMake(Screen_Width - kWidth(20), MAXFLOAT) font:BoldFont(font(15))].height;
                model.cellHeight = kHeight(140) - kHeight(35) + height;
                
                CGFloat answerHeight = [model.answer calculateSize:CGSizeMake(Screen_Width - kWidth(20), MAXFLOAT) font:MediumFont(font(13))].height;
                model.answerCellHeight = kHeight(240) - kHeight(127) + answerHeight;
                
                self.model = model;
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

- (void)stockAnsrReadsSettedWithId:(NSString *)stuntId Success:(void (^)(void))success {
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/stockansreadsetted",API_BASEURL];
    NSDictionary *parameters = @{
                                 @"id" : stuntId.length > 0 ? stuntId : @""
                                 ,@"accesstoken" : [APPUserDataIofo AccessToken]
                                 };
    [[YJNetWorkTool sharedTool] requestWithURLString:url parameters:parameters method:@"POST" callBack:^(id responseObject) {
        NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
        NSInteger code = [[dic objectForKey:@"code"]integerValue];
        if (code == 200) {
            success();
        } else {
            ShowError([dic objectForKey:@"msg"]);
        }
    } fail:^(id error) {
        ShowError(error);
    }];
}

@end
