//
//  HJKillPriceCourseViewModel.m
//  HuiJingSchool
//
//  Created by 张金山 on 2019/1/11.
//  Copyright © 2019年 Junier. All rights reserved.
//

#import "HJKillPriceCourseViewModel.h"
#import "HJKillPriceModel.h"
@implementation HJKillPriceCourseViewModel

//获取课程列表数据
- (void)getListWithSuccess:(void (^)(void))success {
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/getbargincourse",API_BASEURL];
    NSDictionary *parameters = nil;
    parameters = @{
                   @"page" : [NSString stringWithFormat:@"%ld",self.page]
                   };
    if(!self.isFirstLoad) {
        [self.loadingView startAnimating];
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[YJNetWorkTool sharedTool] requestWithURLString:url parameters:parameters method:@"POST" callBack:^(id responseObject) {
            if(!self.isFirstLoad) {
                [self.loadingView stopLoadingView];
                self.isFirstLoad = YES;
            }
            NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
            DLog(@"获取到的砍价抢课的数据是:%@",[NSString convertToJsonData:dic]);
            NSInteger code = [[dic objectForKey:@"code"]integerValue];
            if (code == 200) {
                NSDictionary *dataDict = dic[@"data"];
                self.totalpage = [dataDict[@"totalpage"] intValue];
                self.currentpage = [dataDict[@"currentpage"] intValue];
                NSArray *courseListArray = dataDict[@"courseList"];
                NSMutableArray *marr = [NSMutableArray array];
                for(NSDictionary *dic in courseListArray) {
                    HJKillPriceModel *model = [HJKillPriceModel mj_objectWithKeyValues:dic];
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
                if(!self.isFirstLoad) {
                    [self.loadingView stopLoadingView];
                    self.isFirstLoad = YES;
                }
                ShowError([dic objectForKey:@"msg"]);
            }
        } fail:^(id error) {
            if(!self.isFirstLoad) {
                [self.loadingView stopLoadingView];
                self.isFirstLoad = YES;
            }
            hideHud();
            ShowError(error);
        }];
    });
    
}

- (NSMutableArray *)courseListArray {
    if(!_courseListArray){
        _courseListArray = [NSMutableArray array];
    }
    return  _courseListArray;
}


@end
