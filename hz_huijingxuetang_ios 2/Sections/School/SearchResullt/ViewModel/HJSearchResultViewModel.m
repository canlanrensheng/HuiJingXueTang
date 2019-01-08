//
//  HJSearchResultViewModel.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/16.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJSearchResultViewModel.h"

@implementation HJSearchResultViewModel

- (void)getSearchResultListDataWithSearchParam:(NSString *)searchParam success:(void (^)(void))success {
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/search",API_BASEURL];
    NSDictionary *parameters = @{
                                 @"searchParam" : searchParam.length > 0 ? searchParam : @"",
                                 @"type" : @(self.searchResultType)
                                 };
    self.searchParam = searchParam;
    [[YJNetWorkTool sharedTool]requestWithURLString:url parameters:parameters method:@"POST" callBack:^(id responseObject) {
        NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
        NSInteger code = [[dic objectForKey:@"code"]integerValue];
        DLog(@"获取到的数据是:%@",dic);
        if (code == 200) {
            NSDictionary *dataDict = dic[@"data"];
            
            self.model = [HJSearchResultModel mj_objectWithKeyValues:dataDict];
            if (self.searchResultType == SearchResultTypeAll) {
                if (self.model.courseResponses.count <= 0 && self.model.teacherResponses.count <= 0 && self.model.informationResponses.count <= 0 && self.model.courseLiveResponses.count <= 0) {
                    self.isEmptyData = YES;
                } else {
                    self.isEmptyData = NO;
                }
            } else if (self.searchResultType == SearchResultTypeCourse) {
                if (self.model.courseResponses.count <= 0 && self.model.teacherResponses.count <= 0 ) {
                    self.isEmptyData = YES;
                } else {
                    self.isEmptyData = NO;
                }
            } else if (self.searchResultType == SearchResultTypeLive) {
                if (self.model.teacherResponses.count <= 0  && self.model.courseLiveResponses.count <= 0) {
                    self.isEmptyData = YES;
                } else {
                    self.isEmptyData = NO;
                }
            }
            success();
        } else {
            ShowError([dic objectForKey:@"msg"]);
        }
    } fail:^(id error) {
         DLog(@"获取到的数据是:%@",error);
        ShowError(error);
    }];
}

//获取更多课程
- (void)getMoreCourseWithSuccess:(void (^)(void))success {
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/searchMoreCourse",API_BASEURL];
    NSDictionary *parameters = nil;
    parameters = @{
                   @"searchParam" : self.searchParam.length > 0 ? self.searchParam : @"",
                   @"page" : [NSString stringWithFormat:@"%ld",self.page]
                   };
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[YJNetWorkTool sharedTool] requestWithURLString:url parameters:parameters method:@"POST" callBack:^(id responseObject) {
            NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
            NSInteger code = [[dic objectForKey:@"code"]integerValue];
            if (code == 200) {
                NSDictionary *dataDict = dic[@"data"];
                NSArray *commentArr = dataDict[@"courseList"];
                self.totalpage = [dataDict[@"totalpage"] intValue];
                self.currentpage = [dataDict[@"currentpage"] intValue];
                NSMutableArray *marr = [NSMutableArray array];
                for (NSDictionary *dic in commentArr) {
                    CourseResponses *model = [CourseResponses mj_objectWithKeyValues:dic];
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

- (void)getMoreTeacherWithSuccess:(void (^)(void))success {
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/searchMoreTeacher",API_BASEURL];
    NSDictionary *parameters = nil;
    parameters = @{
                   @"searchParam" : self.searchParam.length > 0 ? self.searchParam : @"",
                   @"page" : [NSString stringWithFormat:@"%ld",self.page]
                   };
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[YJNetWorkTool sharedTool] requestWithURLString:url parameters:parameters method:@"POST" callBack:^(id responseObject) {
            NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
            NSInteger code = [[dic objectForKey:@"code"]integerValue];
            if (code == 200) {
                NSDictionary *dataDict = dic[@"data"];
                NSArray *commentArr = dataDict[@"teacherList"];
                self.totalpage = [dataDict[@"totalpage"] intValue];
                self.currentpage = [dataDict[@"currentpage"] intValue];
                NSMutableArray *marr = [NSMutableArray array];
                for (NSDictionary *dic in commentArr) {
                    TeacherResponses *model = [TeacherResponses mj_objectWithKeyValues:dic];
                    [marr addObject:model];
                }
                if (self.page == 1) {
                    self.teacherListArray = marr;
                } else {
                    [self.teacherListArray addObjectsFromArray:marr];
                }
                if (marr.count < 10) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
                self.tableView.mj_footer.hidden = self.teacherListArray.count < 10 ? YES : NO;
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

//获取更多资讯
- (void)getMoreInfoWithSuccess:(void (^)(void))success {
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/searchMoreInfor",API_BASEURL];
    NSDictionary *parameters = nil;
    parameters = @{
                   @"searchParam" : self.searchParam.length > 0 ? self.searchParam : @"",
                   @"page" : [NSString stringWithFormat:@"%ld",self.page]
                   };
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[YJNetWorkTool sharedTool] requestWithURLString:url parameters:parameters method:@"POST" callBack:^(id responseObject) {
            NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
            NSInteger code = [[dic objectForKey:@"code"]integerValue];
            if (code == 200) {
                NSDictionary *dataDict = dic[@"data"];
                NSArray *commentArr = dataDict[@"informationList"];
                self.totalpage = [dataDict[@"totalpage"] intValue];
                self.currentpage = [dataDict[@"currentpage"] intValue];
                NSMutableArray *marr = [NSMutableArray array];
                for (NSDictionary *dic in commentArr) {
                    InformationResponses *model = [InformationResponses mj_objectWithKeyValues:dic];
                    [marr addObject:model];
                }
                if (self.page == 1) {
                    self.infoListArray = marr;
                } else {
                    [self.infoListArray addObjectsFromArray:marr];
                }
                if (marr.count < 10) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
                self.tableView.mj_footer.hidden = self.infoListArray.count < 10 ? YES : NO;
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

//更多直播的列表
- (void)getMoreLiveWithSuccess:(void (^)(void))success {
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/searchmorecourselive",API_BASEURL];
    NSDictionary *parameters = nil;
    parameters = @{
                   @"searchParam" : self.searchParam.length > 0 ? self.searchParam : @"",
                   @"page" : [NSString stringWithFormat:@"%ld",self.page]
                   };
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[YJNetWorkTool sharedTool] requestWithURLString:url parameters:parameters method:@"POST" callBack:^(id responseObject) {
            NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
            NSInteger code = [[dic objectForKey:@"code"]integerValue];
            if (code == 200) {
                NSDictionary *dataDict = dic[@"data"];
                NSArray *commentArr = dataDict[@"courseLiveList"];
                self.totalpage = [dataDict[@"totalpage"] intValue];
                self.currentpage = [dataDict[@"currentpage"] intValue];
                NSMutableArray *marr = [NSMutableArray array];
                for (NSDictionary *dic in commentArr) {
                    CourseLiveModel *model = [CourseLiveModel mj_objectWithKeyValues:dic];
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

- (NSMutableArray *)courseListArray {
    if(!_courseListArray) {
        _courseListArray = [NSMutableArray array];
    }
    return  _courseListArray;
}

- (NSMutableArray *)teacherListArray {
    if(!_teacherListArray) {
        _teacherListArray = [NSMutableArray array];
    }
    return  _teacherListArray;
}

- (NSMutableArray *)infoListArray {
    if(!_infoListArray) {
        _infoListArray = [NSMutableArray array];
    }
    return  _infoListArray;
}

- (NSMutableArray *)liveListArray {
    if(!_liveListArray) {
        _liveListArray = [NSMutableArray array];
    }
    return  _liveListArray;
}


@end
