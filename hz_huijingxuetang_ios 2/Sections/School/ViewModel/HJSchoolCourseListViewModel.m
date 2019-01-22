//
//  HJSchoolCourseListViewModel.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/14.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJSchoolCourseListViewModel.h"

@implementation HJSchoolCourseListViewModel

//获取课程列表数据
- (void)getListWithSuccess:(void (^)(void))success {
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/videocourselist",API_BASEURL];
    NSDictionary *parameters = nil;
    parameters = @{
                   @"sort_price" : self.sort_price.length > 0 ? self.sort_price : @"",
                   @"sort_sales" : self.sort_sales.length > 0 ? self.sort_sales : @"",
                   @"sort_starlevel" : self.sort_starlevel.length > 0 ? self.sort_starlevel : @"",
                   @"filter_price" : self.filter_price.length > 0 ? self.filter_price : @"",
                   @"filter_preference" : self.filter_preference.length > 0 ? self.filter_preference : @"",
                   @"page" : [NSString stringWithFormat:@"%ld",self.page]
                   };
    if(!self.isFirstLoad) {
        [self.loadingView startAnimating];
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[YJNetWorkTool sharedTool] requestWithURLString:url parameters:parameters method:@"GET" callBack:^(id responseObject) {
            if(!self.isFirstLoad) {
                [self.loadingView stopLoadingView];
                self.firstLoad = YES;
            }
            NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
            NSInteger code = [[dic objectForKey:@"code"]integerValue];
            if (code == 200) {
                NSDictionary *dataDict = dic[@"data"];

                self.totalpage = [dataDict[@"totalpage"] intValue];
                self.currentpage = [dataDict[@"currentpage"] intValue];
                NSMutableArray *marr = [NSMutableArray array];
                self.model = [HJSchoolCourseListModel mj_objectWithKeyValues:dataDict];
                [marr addObjectsFromArray:self.model.courselist];
                if (self.page == 1) {
                    self.videoCourseListArray = marr;
                } else {
                    [self.videoCourseListArray addObjectsFromArray:marr];
                }
                if (marr.count < 10) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
                self.tableView.mj_footer.hidden = self.videoCourseListArray.count < 10 ? YES : NO;
                success();
            } else {
                if(!self.isFirstLoad) {
                    [self.loadingView stopLoadingView];
                    self.firstLoad = YES;
                }
                ShowError([dic objectForKey:@"msg"]);
            }
        } fail:^(id error) {
            if(!self.isFirstLoad) {
                [self.loadingView stopLoadingView];
                self.firstLoad = YES;
            }
            hideHud();
            ShowError(error);
        }];
    });
    
}

- (NSMutableArray *)videoCourseListArray {
    if(!_videoCourseListArray){
        _videoCourseListArray = [NSMutableArray array];
    }
    return  _videoCourseListArray;
}

@end
