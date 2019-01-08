//
//  HJMyShareCommunityDetailViewModel.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/12/28.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJMyShareCommunityDetailViewModel.h"
#import "HJMyShareCommunityDetailModel.h"
@implementation HJMyShareCommunityDetailViewModel

- (void)getCommunityDetailModelSuccess:(void (^)(void))success {
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/getcommunityorderinfor",API_BASEURL];
    NSDictionary *parameters = nil;
    parameters = @{
                   @"accesstoken" : [APPUserDataIofo AccessToken],
                   @"page" : [NSString stringWithFormat:@"%ld",self.page],
                   @"dataParam" : self.dataParam.length > 0 ? self.dataParam : @"",
                   @"datadaterange" : self.datadaterange.length > 0 ? self.datadaterange : @""
                   };
    if(!self.isFirstLoad){
        [self.loadingView startAnimating];
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[YJNetWorkTool sharedTool] requestWithURLString:url parameters:parameters method:@"POST" callBack:^(id responseObject) {
            NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
            DLog(@"获取到的佣金明细的数据是:%@",[NSString convertToJsonData:dic]);
            if(!self.isFirstLoad){
                [self.loadingView stopLoadingView];
                self.isFirstLoad = YES;
            }
            NSInteger code = [[dic objectForKey:@"code"]integerValue];
            if (code == 200) {
                NSDictionary *dataDict = dic[@"data"];
                NSArray *commentArr = dataDict[@"communityorderinfor"];
                self.totalpage = [dataDict[@"totalpage"] intValue];
                self.currentpage = [dataDict[@"currentpage"] intValue];
                NSMutableArray *marr = [NSMutableArray array];
                for (NSDictionary *dic in commentArr) {
                    HJMyShareCommunityDetailModel *model = [HJMyShareCommunityDetailModel mj_objectWithKeyValues:dic];
                    [marr addObject:model];
                }
                if (self.page == 1) {
                    self.communityDetailDataArray = marr;
                } else {
                    [self.communityDetailDataArray addObjectsFromArray:marr];
                }
                if (marr.count < 10) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
                self.tableView.mj_footer.hidden = self.communityDetailDataArray.count < 10 ? YES : NO;
                success();
            } else {
                if(!self.isFirstLoad){
                    [self.loadingView stopLoadingView];
                    self.isFirstLoad = YES;
                }
                ShowError([dic objectForKey:@"msg"]);
            }
        } fail:^(id error) {
            if(!self.isFirstLoad){
                [self.loadingView stopLoadingView];
                self.isFirstLoad = YES;
            }
            hideHud();
            ShowError(error);
        }];
    });
}

@end
