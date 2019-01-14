//
//  HJShareViewModel.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/12/3.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJShareViewModel.h"
#import "HJShareCourseModel.h"
@implementation HJShareViewModel

- (void)getCurrentMonthMessageWithSuccess:(void (^)(void))success {
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/getpromotedata",API_BASEURL];
    NSDictionary *parameters = @{
                                 @"accesstoken":[APPUserDataIofo AccessToken]
                                 };
    [[YJNetWorkTool sharedTool] requestWithURLString:url parameters:parameters method:@"POST" callBack:^(id responseObject) {
        NSDictionary*dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
        NSInteger code = [[dict objectForKey:@"code"] integerValue];
        if (code == 200) {
            NSDictionary *dic = dict[@"data"];
            self.model = [HJCurrentMonthMessageModel mj_objectWithKeyValues:dic];
            success();
        } else {
            ShowError([dict objectForKey:@"msg"]);
        }
    } fail:^(id error) {
        hideHud();
        ShowError(error);
    }];
}

//获取推广课程列表
- (void)getShareCourceListSuccess:(void (^)(BOOL successFlag))success {
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/getpromcourlist",API_BASEURL];
    NSDictionary *parameters = nil;
    parameters = @{
                    @"page" : [NSString stringWithFormat:@"%ld",self.page],
                    @"accesstoken" : [APPUserDataIofo AccessToken]
                   };
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[YJNetWorkTool sharedTool] requestWithURLString:url parameters:parameters method:@"POST" callBack:^(id responseObject) {
            NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
            NSInteger code = [[dic objectForKey:@"code"]integerValue];
            DLog(@"获取到的推广课程列表的数据是:%@",[NSString convertToJsonData:dic]);
            if (code == 200) {
                NSDictionary *dataDict = dic[@"data"];
                NSArray *commentArr = dataDict[@"courseList"];
                self.totalpage = [dataDict[@"totalpage"] intValue];
                self.currentpage = [dataDict[@"currentpage"] intValue];
                if([dataDict objectForKey:@"overdueInvitationStatus"]) {
                    self.overdueInvitationStatus = [dataDict[@"overdueInvitationStatus"] intValue];
                }
                NSMutableArray *marr = [NSMutableArray array];
                for (NSDictionary *dic in commentArr) {
                    HJShareCourseModel *model = [HJShareCourseModel mj_objectWithKeyValues:dic];
                    [marr addObject:model];
                }
                if (self.page == 1) {
                    self.courseListArray = marr;
                } else {
                    [self.courseListArray addObjectsFromArray:marr];
                }
                if (marr.count < 10) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
                self.tableView.mj_footer.hidden = self.courseListArray.count < 10 ? YES : NO;
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

//获取推广收益信息
- (void)getPromoteProfitMessageSuccess:(void (^)(void))success {
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/getpromoteincomeindex",API_BASEURL];
    NSDictionary *parameters = @{
                                 @"accesstoken":[APPUserDataIofo AccessToken]
                                 };
    [[YJNetWorkTool sharedTool] requestWithURLString:url parameters:parameters method:@"POST" callBack:^(id responseObject) {
        NSDictionary*dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
        NSInteger code = [[dict objectForKey:@"code"] integerValue];
        DLog(@"获取推广收益信息的数据是:%@",[NSString convertToJsonData:dict]);
        if (code == 200) {
            NSDictionary *dic = dict[@"data"];
            self.profitModel = [HJPromoteProfitModel mj_objectWithKeyValues:dic];
            success();
        } else {
            ShowError([dict objectForKey:@"msg"]);
        }
    } fail:^(id error) {
        hideHud();
        ShowError(error);
    }];
}

@end
