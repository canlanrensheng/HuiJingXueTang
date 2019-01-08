//
//  HJMyShareCommunityViewModel.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/12/3.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJMyShareCommunityViewModel.h"
#import "HJPromoteInfoModel.h"
@implementation HJMyShareCommunityViewModel

- (void)getPromoteInfoSuccess:(void (^)(void))success {
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/getcomminfor",API_BASEURL];
    NSDictionary *parameters = nil;
    parameters = @{
                   @"accesstoken" : [APPUserDataIofo AccessToken],
                   @"page" : [NSString stringWithFormat:@"%ld",self.page]
                   };
    if(!self.isFirstLoad){
        [self.loadingView startAnimating];
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[YJNetWorkTool sharedTool] requestWithURLString:url parameters:parameters method:@"POST" callBack:^(id responseObject) {
            NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
            NSInteger code = [[dic objectForKey:@"code"]integerValue];
            if(!self.isFirstLoad){
                [self.loadingView stopLoadingView];
                self.isFirstLoad = YES;
            }
            if (code == 200) {
                NSDictionary *dataDict = dic[@"data"];
                DLog(@"获取的数据是:%@",[NSString convertToJsonData:dic]);
                NSArray *commentArr = dataDict[@"promoteinfor"];
                self.totalpage = [dataDict[@"totalpage"] intValue];
                self.currentpage = [dataDict[@"currentpage"] intValue];
                NSMutableArray *marr = [NSMutableArray array];
                for (NSDictionary *dic in commentArr) {
                    HJPromoteInfoModel *model = [HJPromoteInfoModel mj_objectWithKeyValues:dic];
                    [marr addObject:model];
                }
                if (self.page == 1) {
                    self.promoteInfoArray = marr;
                } else {
                    [self.promoteInfoArray addObjectsFromArray:marr];
                }
                if (marr.count < 10) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
                self.tableView.mj_footer.hidden = self.promoteInfoArray.count < 10 ? YES : NO;
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
