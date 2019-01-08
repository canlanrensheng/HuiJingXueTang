//
//  HJTeacherDetailViewModel.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/15.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJTeacherDetailViewModel.h"
#import "HJTeacherCourseModel.h"
#import "HJTeacherInfoModel.h"
#import "HJTeacherLiveModel.h"
@implementation HJTeacherDetailViewModel

//获取老师详情的数据
- (void)getTeacherDetailWithTeacherId:(NSString *)teacherid Success:(void (^)(void))success{
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/teacherdetail",API_BASEURL];
    NSDictionary *parameters = nil;
    parameters = @{
                   @"teacherid" : teacherid.length > 0 ? teacherid : @"",
                   @"accesstoken" : [APPUserDataIofo AccessToken]
                   };
//    [self.loadingView startAnimating];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[YJNetWorkTool sharedTool] requestWithURLString:url parameters:parameters method:@"GET" callBack:^(id responseObject) {
//            [self.loadingView stopLoadingView];
            NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
            NSInteger code = [[dic objectForKey:@"code"]integerValue];
            if (code == 200) {
                NSDictionary *dataDict = dic[@"data"];
                self.model = [HJTeacherDetailModel mj_objectWithKeyValues:dataDict];
                success();
            } else {
                ShowError([dic objectForKey:@"msg"]);
            }
        } fail:^(id error) {
//            [self.loadingView stopLoadingView];
            hideHud();
            ShowError(error);
        }];
    });
}

//关注和取消关注
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
//    ShowHint(@"");
    [[YJNetWorkTool sharedTool] requestWithURLString:url parameters:parameters method:@"POST" callBack:^(id responseObject) {
//        hideHud();
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

- (void)getTeachercCourseListWithTeacherid:(NSString *)teacherid  Success:(void (^)(void))success {
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/teachercourselist",API_BASEURL];
    NSDictionary *parameters = nil;
    parameters = @{
                   @"page" : [NSString stringWithFormat:@"%ld",self.page],
                   @"teacherid" : teacherid.length > 0 ? teacherid : @""
                   };
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[YJNetWorkTool sharedTool] requestWithURLString:url parameters:parameters method:@"GET" callBack:^(id responseObject) {
            NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
            NSInteger code = [[dic objectForKey:@"code"]integerValue];
            if (code == 200) {
                NSDictionary *dataDict = dic[@"data"];
                NSArray *commentArr = dataDict[@"courselist"];
                self.totalpage = [dataDict[@"totalpage"] intValue];
                self.currentpage = [dataDict[@"currentpage"] intValue];
                NSMutableArray *marr = [NSMutableArray array];
                for (NSDictionary *dic in commentArr) {
                    HJTeacherCourseModel *model = [HJTeacherCourseModel mj_objectWithKeyValues:dic];
                    [marr addObject:model];
                }
                if (self.page == 1) {
                    self.teachercCourseArray = marr;
                } else {
                    [self.teachercCourseArray addObjectsFromArray:marr];
                }
                if (marr.count < 10) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
                self.tableView.mj_footer.hidden = self.teachercCourseArray.count < 10 ? YES : NO;
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

- (void)getTeachercInfoListWithTeacherid:(NSString *)teacherid  Success:(void (^)(void))success {
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/teachernewslist",API_BASEURL];
    NSDictionary *parameters = nil;
    parameters = @{
                   @"page" : [NSString stringWithFormat:@"%ld",self.page],
                   @"teacherid" : teacherid
                   };
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[YJNetWorkTool sharedTool] requestWithURLString:url parameters:parameters method:@"GET" callBack:^(id responseObject) {
            NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
            NSInteger code = [[dic objectForKey:@"code"]integerValue];
            DLog(@"获取到的文章列表的数据是:%@",[NSString convertToJsonData:dic]);
            if (code == 200) {
                NSDictionary *dataDict = dic[@"data"];
                NSArray *commentArr = dataDict[@"newslist"];
                self.totalpage = [dataDict[@"totalpage"] intValue];
                self.currentpage = [dataDict[@"currentpage"] intValue];
                NSMutableArray *marr = [NSMutableArray array];
                for (NSDictionary *dic in commentArr) {
                    HJTeacherInfoModel *model = [HJTeacherInfoModel mj_objectWithKeyValues:dic];
                    [marr addObject:model];
                }
                if (self.page == 1) {
                    self.teacherInfoArray = marr;
                } else {
                    [self.teacherInfoArray addObjectsFromArray:marr];
                }
                if (marr.count < 10) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
                self.tableView.mj_footer.hidden = self.teacherInfoArray.count < 10 ? YES : NO;
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

//获取老师直播列表
- (void)getTeachercLiveListWithTeacherid:(NSString *)teacherid  Success:(void (^)(void))success {
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/teacherlivelist",API_BASEURL];
    NSDictionary *parameters = nil;
    parameters = @{
                   @"page" : [NSString stringWithFormat:@"%ld",self.page],
                   @"teacherid" : teacherid
                   };
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[YJNetWorkTool sharedTool] requestWithURLString:url parameters:parameters method:@"GET" callBack:^(id responseObject) {
            NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
            NSInteger code = [[dic objectForKey:@"code"]integerValue];
            if (code == 200) {
                NSDictionary *dataDict = dic[@"data"];
                NSArray *commentArr = dataDict[@"livelist"];
                self.totalpage = [dataDict[@"totalpage"] intValue];
                self.currentpage = [dataDict[@"currentpage"] intValue];
                NSMutableArray *marr = [NSMutableArray array];
                for (NSDictionary *dic in commentArr) {
                    HJTeacherLiveModel *model = [HJTeacherLiveModel mj_objectWithKeyValues:dic];
                    [marr addObject:model];
                }
                if (self.page == 1) {
                    self.liveListArray = marr;
                } else {
                    [self.liveListArray addObjectsFromArray:marr];
                }
                if (marr.count < 10) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
                self.tableView.mj_footer.hidden = self.liveListArray.count < 10 ? YES : NO;
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

- (NSMutableArray *)teachercCourseArray {
    if (!_teachercCourseArray){
        _teachercCourseArray = [NSMutableArray array];
    }
    return  _teachercCourseArray;
}

- (NSMutableArray *)teacherInfoArray {
    if (!_teacherInfoArray){
        _teacherInfoArray = [NSMutableArray array];
    }
    return  _teacherInfoArray;
}

- (NSMutableArray *)liveListArray {
    if(!_liveListArray) {
        _liveListArray = [NSMutableArray array];
    }
    return _liveListArray;
}

@end
