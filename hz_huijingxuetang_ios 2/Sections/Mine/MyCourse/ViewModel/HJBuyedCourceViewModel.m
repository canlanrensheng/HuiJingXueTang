//
//  HJBuyedCourceViewModel.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/26.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJBuyedCourceViewModel.h"
#import "HJMyCourseModel.h"
@implementation HJBuyedCourceViewModel

//获取裂成列表
- (void)getMyCourceListSuccess:(void (^)(void))success {
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/mycourse",API_BASEURL];
    NSDictionary *parameters = nil;
    parameters = @{
                   @"accesstoken" : [APPUserDataIofo AccessToken],
                   @"type" : @"1",
                   @"page" : [NSString stringWithFormat:@"%ld",self.page]
                   };
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[YJNetWorkTool sharedTool] requestWithURLString:url parameters:parameters method:@"POST" callBack:^(id responseObject) {
            NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
            NSInteger code = [[dic objectForKey:@"code"]integerValue];
            if (code == 200) {
                NSDictionary *dataDict = dic[@"data"];
                NSArray *commentArr = dataDict[@"courselist"];
                self.totalpage = [dataDict[@"totalpage"] intValue];
                self.currentpage = [dataDict[@"currentpage"] intValue];
                NSMutableArray *marr = [NSMutableArray array];
                for (NSDictionary *dic in commentArr) {
                    HJMyCourseModel *model = [HJMyCourseModel mj_objectWithKeyValues:dic];
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

@end
