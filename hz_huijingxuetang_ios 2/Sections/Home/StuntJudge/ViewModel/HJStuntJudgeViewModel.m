//
//  HJStuntJudgeViewModel.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/10/29.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJStuntJudgeViewModel.h"
#import "HJStuntJudgeListModel.h"

@interface HJStuntJudgeViewModel ()

@property (nonatomic,assign) NSInteger totalpage;
@property (nonatomic,assign) NSInteger currentpage;

@end

@implementation HJStuntJudgeViewModel

- (void)stuntJuageRecommendWithSuccess:(void (^)(void))success {
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/stockinfolist",API_BASEURL];
    NSDictionary *parameters = nil;
    parameters = @{
                       @"type" : @"1",
                       @"page" : [NSString stringWithFormat:@"%ld",(long)(self.page == 0 ? self.page = 1 : self.page)]
                       };
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[YJNetWorkTool sharedTool] requestWithURLString:url parameters:parameters method:@"GET" callBack:^(id responseObject) {
            NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
            NSInteger code = [[dic objectForKey:@"code"]integerValue];
            if (code == 200) {
                NSDictionary *dataDict = dic[@"data"];
                NSArray *stocklistArr = dataDict[@"stocklist"];
                self.totalpage = [dataDict[@"totalpage"] intValue];
                self.currentpage = [dataDict[@"currentpage"] intValue];
                NSMutableArray *marr = [NSMutableArray array];
                for(NSDictionary *daDic in stocklistArr) {
                    HJStuntJudgeListModel *model = [HJStuntJudgeListModel mj_objectWithKeyValues:daDic];
                    CGFloat height = [[NSString stringWithFormat:@"%@ %@",model.questiontitle,model.questiondes] calculateSize:CGSizeMake(Screen_Width - kWidth(20), MAXFLOAT) font:BoldFont(font(15))].height;
                    model.cellHeight = kHeight(140) - kHeight(35) + height;
                    
                    CGFloat answerHeight = [model.answer calculateSize:CGSizeMake(Screen_Width - kWidth(20), MAXFLOAT) font:MediumFont(font(13))].height;
                    model.answerCellHeight = kHeight(240) - kHeight(127) + answerHeight;
                    [marr addObject:model];
                }
                if(self.page == 1) {
                    self.stuntJuageRecommendArray = marr;
                } else {
                    [self.stuntJuageRecommendArray addObjectsFromArray:marr];
                }
                if (marr.count < 10) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
                self.tableView.mj_footer.hidden = self.stuntJuageWaitReplyArray.count < 10 ? YES : NO;
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

- (void)stuntJuageReplyedWithSuccess:(void (^)(void))success {
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/stockinfolist",API_BASEURL];
    NSDictionary *parameters = nil;
    parameters = @{
                       @"type" : @"1",
                       @"page" : [NSString stringWithFormat:@"%ld",(long)(self.page == 0 ? self.page = 1 : self.page)],
                       @"accesstoken" : [APPUserDataIofo AccessToken]
                       };
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[YJNetWorkTool sharedTool] requestWithURLString:url parameters:parameters method:@"GET" callBack:^(id responseObject) {
//            hideHud();
            NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
            NSInteger code = [[dic objectForKey:@"code"]integerValue];
            if (code == 200) {
                NSDictionary *dataDict = dic[@"data"];
                self.notreadednum = [dataDict[@"notreadednum"] intValue];
                NSArray *stocklistArr = dataDict[@"stocklist"];
                self.totalpage = [dataDict[@"totalpage"] intValue];
                self.currentpage = [dataDict[@"currentpage"] intValue];
                NSMutableArray *marr = [NSMutableArray array];
                for(NSDictionary *daDic in stocklistArr) {
                    HJStuntJudgeListModel *model = [HJStuntJudgeListModel mj_objectWithKeyValues:daDic];
                    CGFloat height = [[NSString stringWithFormat:@"%@ %@",model.questiontitle,model.questiondes] calculateSize:CGSizeMake(Screen_Width - kWidth(20), MAXFLOAT) font:BoldFont(font(15))].height;
                    model.cellHeight = kHeight(140) - kHeight(35) + height;
                    
                    CGFloat answerHeight = [model.answer calculateSize:CGSizeMake(Screen_Width - kWidth(20), MAXFLOAT) font:MediumFont(font(13))].height;
                    model.answerCellHeight = kHeight(240) - kHeight(127) + answerHeight;
                    [marr addObject:model];
                }
                if(self.page == 1) {
                    self.stuntJuageReplyedArray = marr;
                } else {
                    [self.stuntJuageReplyedArray addObjectsFromArray:marr];
                }
                if (marr.count < 10) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
                self.tableView.mj_footer.hidden =  self.stuntJuageReplyedArray.count < 10 ? YES : NO;
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

- (void)stuntJuageWaitReplyWithSuccess:(void (^)(void))success {
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/stockinfolist",API_BASEURL];
    
    NSDictionary *parameters = nil;

    parameters = @{
                   @"type" : @"0",
                   @"page" : [NSString stringWithFormat:@"%ld",(long)(self.page == 0 ? self.page = 1 : self.page)],
                   @"accesstoken" : [APPUserDataIofo AccessToken]
                   };
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[YJNetWorkTool sharedTool] requestWithURLString:url parameters:parameters method:@"GET" callBack:^(id responseObject) {
            hideHud();
            NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
            NSInteger code = [[dic objectForKey:@"code"]integerValue];
            if (code == 200) {
                NSDictionary *dataDict = dic[@"data"];
                NSArray *stocklistArr = dataDict[@"stocklist"];
                self.totalpage = [dataDict[@"totalpage"] intValue];
                self.currentpage = [dataDict[@"currentpage"] intValue];
                NSMutableArray *marr = [NSMutableArray array];
                for(NSDictionary *daDic in stocklistArr) {
                    HJStuntJudgeListModel *model = [HJStuntJudgeListModel mj_objectWithKeyValues:daDic];
                    CGFloat height = [[NSString stringWithFormat:@"%@ %@",model.questiontitle,model.questiondes] calculateSize:CGSizeMake(Screen_Width - kWidth(20), MAXFLOAT) font:BoldFont(font(15))].height;
                    model.cellHeight = kHeight(140) - kHeight(35) + height;
                    
                    CGFloat answerHeight = [model.answer calculateSize:CGSizeMake(Screen_Width - kWidth(20), MAXFLOAT) font:MediumFont(font(13))].height;
                    model.answerCellHeight = kHeight(240) - kHeight(127) + answerHeight;
                    [marr addObject:model];
                }
                if(self.page == 1) {
                    self.stuntJuageWaitReplyArray = marr;
                } else {
                    [self.stuntJuageWaitReplyArray addObjectsFromArray:marr];
                }
                if (marr.count < 10) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
                self.tableView.mj_footer.hidden = self.stuntJuageWaitReplyArray.count < 10 ? YES : NO;
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

- (void)addStuntQuestionWithSuccess:(void (^)(void))success {
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/stockquestion",API_BASEURL];
    NSDictionary *parameters = @{
                                 @"accesstoken" : [APPUserDataIofo AccessToken],
                                 @"title" : self.title ,
                                 @"des" :self.question
                                 };
    ShowHint(@"");
    [[YJNetWorkTool sharedTool] requestWithURLString:url parameters:parameters method:@"POST" callBack:^(id responseObject) {
        hideHud();
        [MBProgressHUD showMessage:@"提交成功" view:[UIApplication sharedApplication].keyWindow];
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
}

- (void)deleteWithId:(NSString *)stuntId Success:(void (^)(void))success {
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/delstock",API_BASEURL];
    NSDictionary *parameters = @{
                                 @"id" : stuntId
                                 ,@"accesstoken" : [APPUserDataIofo AccessToken]
                                 };
    ShowHint(@"");
    [[YJNetWorkTool sharedTool] requestWithURLString:url parameters:parameters method:@"POST" callBack:^(id responseObject) {
        hideHud();
        [MBProgressHUD showMessage:@"删除成功" view:[UIApplication sharedApplication].keyWindow];
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
}



@end
