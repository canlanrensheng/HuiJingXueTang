//
//  HJOnLiveViewModel.m
//  HuiJingSchool
//
//  Created by 张金山 on 2019/1/11.
//  Copyright © 2019年 Junier. All rights reserved.
//

#import "HJOnLiveViewModel.h"
#import "HJHomeLiveModel.h"

@implementation HJOnLiveViewModel

- (void)getSchoolLiveListDataWithSuccess:(void (^)(void))success {
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/livecoursesindexlist",API_BASEURL];
    NSDictionary *parameters = @{
                                 @"page" : @"1"
                                 };
    if(!self.isFirstLoad) {
        [self.loadingView startAnimating];
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[YJNetWorkTool sharedTool] requestWithURLString:url parameters:parameters method:@"GET" callBack:^(id responseObject) {
            if(!self.isFirstLoad) {
                [self.loadingView stopLoadingView];
                self.isFirstLoad = YES;
            }
            NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
            NSInteger code = [[dic objectForKey:@"code"]integerValue];
            if (code == 200) {
                NSDictionary *dataDict= dic[@"data"];
                NSArray *newsListArr = dataDict[@"livelist"];
                self.totalpage = [dataDict[@"totalpage"] intValue];
                self.currentpage = [dataDict[@"currentpage"] intValue];
                NSMutableArray *marr = [NSMutableArray array];
                for(NSDictionary *daDic in newsListArr) {
                    HJHomeLiveModel *model = [HJHomeLiveModel mj_objectWithKeyValues:daDic];
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
            ShowError(error);
        }];
    });
}


@end
