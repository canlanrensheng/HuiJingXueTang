//
//  HJLimitKillMoreViewModel.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/22.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJLimitKillMoreViewModel.h"
#import "HJHomeLimitKillModel.h"
@implementation HJLimitKillMoreViewModel

- (void)getLimitKillMoreListDataSuccess:(void (^)(void))success {
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/flashsale",API_BASEURL];
    NSDictionary *parameters = nil;
    parameters = @{
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
                    HJHomeLimitKillModel *model = [HJHomeLimitKillModel mj_objectWithKeyValues:dic];
                    [marr addObject:model];
                }
                if (self.page == 1) {
                    self.limitKillMoreArray = marr;
                } else {
                    [self.limitKillMoreArray addObjectsFromArray:marr];
                }
                if (marr.count < 10) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
                self.tableView.mj_footer.hidden = self.limitKillMoreArray.count < 10 ? YES : NO;
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

- (NSMutableArray *)limitKillMoreArray {
    if (!_limitKillMoreArray) {
        _limitKillMoreArray = [NSMutableArray array];
    }
    return _limitKillMoreArray;
}

@end
