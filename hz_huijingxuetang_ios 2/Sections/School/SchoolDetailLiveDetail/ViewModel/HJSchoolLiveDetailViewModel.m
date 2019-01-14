//
//  HJSchoolLiveDetailViewModel.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/20.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJSchoolLiveDetailViewModel.h"
#import "HJPastListModel.h"
@implementation HJSchoolLiveDetailViewModel

- (void)getLiveDetailDataWithLiveId:(NSString *)liveId  Success:(void (^)(BOOL successFlag))success {
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/livecourseroom", API_BASEURL];
    NSDictionary *para = @{@"accesstoken" : [APPUserDataIofo AccessToken],
                           @"courseid" : liveId.length > 0 ? liveId : @"",
                           @"clienttype" : @"2"
                           };
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[YJNetWorkTool sharedTool] requestWithURLString:url parameters:para method:@"POST" callBack:^(id responseObject) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
            DLog(@"获取到的直播详情的数据是:%@",[NSString convertToJsonData:dic]);
            NSInteger code = [[dic objectForKey:@"code"] integerValue];
            if (code == 200) {
                NSDictionary *dataDict = dic[@"data"];
                self.model = [HJLiveDetailModel mj_objectWithKeyValues:dataDict];
                success(YES);
            } else {
                self.liveDetailErrorCode = code;
                if(code == 29) {
                    ShowError(@"您暂无购买课程或已购课程已过期");
                    return ;
                }
                ShowError([dic objectForKey:@"msg"]);
                success(NO);
            }
        } fail:^(id error) {
            success(NO);
            ShowError(error);
        }];
    });
}

//获取往期回顾的数据
- (void)getPastCourseListDataWithSuccess:(void (^)(void))success {
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/pastcourseslist", API_BASEURL];
    NSDictionary *parameters = @{@"accesstoken" : [APPUserDataIofo AccessToken],
                           @"teacherid" : self.teacherId.length > 0 ? self.teacherId : @"",
                           @"page" : [NSString stringWithFormat:@"%ld",self.page]
                           };
    if(self.isFree) {
        parameters = @{
                       @"teacherid" : self.teacherId.length > 0 ? self.teacherId : @"",
                       @"page" : [NSString stringWithFormat:@"%ld",self.page]
                       };
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[YJNetWorkTool sharedTool] requestWithURLString:url parameters:parameters method:@"GET" callBack:^(id responseObject) {
            NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
            NSInteger code = [[dic objectForKey:@"code"]integerValue];
//            DLog(@"获取到的往期回顾的数据是:%@",[NSString convertToJsonData:dic]);
            if (code == 200) {
                NSDictionary *dataDict = dic[@"data"];
                NSArray *newsListArr = dataDict[@"pastlivelist"];
                self.totalpage = [dataDict[@"totalpage"] intValue];
                self.currentpage = [dataDict[@"currentpage"] intValue];
                NSMutableArray *marr = [NSMutableArray array];
                for(NSDictionary *daDic in newsListArr) {
                    HJPastListModel *model = [HJPastListModel mj_objectWithKeyValues:daDic];
                    [marr addObject:model];
                }
                if (self.page == 1) {
                    self.pastListArray = marr;
                } else {
                    [self.pastListArray addObjectsFromArray:marr];
                }
                if (marr.count < 10) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
                self.tableView.mj_footer.hidden = self.pastListArray.count < 10 ? YES : NO;
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

//关注取消关注的操作
- (void)careOrCancleCareWithTeacherId:(NSString *)teacherId
                          accessToken:(NSString *)accessToken
                            insterest:(NSString *)insterest
                              Success:(void (^)(void))success {
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/tointerestornot",API_BASEURL];
    NSDictionary *parameters = @{
                                 @"accesstoken" : [APPUserDataIofo AccessToken],
                                 @"teacherid" : teacherId,
                                 @"interest" :insterest
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
        //        hideHud();
        ShowError(error);
    }];
}

- (NSMutableArray *)chatListArray {
    if (!_chatListArray) {
        _chatListArray = [NSMutableArray array];
    }
    return _chatListArray;
}

- (NSMutableArray *)pastListArray {
    if (!_pastListArray) {
        _pastListArray = [NSMutableArray array];
    }
    return _pastListArray;
}

@end
