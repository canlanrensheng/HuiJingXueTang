//
//  HJSchoolLiveListViewModel.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/24.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJSchoolLiveListViewModel.h"
#import "HJTeacherLiveModel.h"
@implementation HJSchoolLiveListViewModel

- (void)getSchoolLiveListDataWithSuccess:(void (^)(void))success {
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/livecourseslist",API_BASEURL];
    NSDictionary *parameters = nil;
    if(MaJia) {
        parameters = @{
                       @"page" : [NSString stringWithFormat:@"%ld",self.page],
                       @"vesttype" : @"free"
                       };
    } else{
        parameters = @{
                       @"page" : [NSString stringWithFormat:@"%ld",self.page]
                       };
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[YJNetWorkTool sharedTool] requestWithURLString:url parameters:parameters method:@"GET" callBack:^(id responseObject) {
            NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
            //            DLog(@"获取到的购物车的数据是:%@",dic);
            NSInteger code = [[dic objectForKey:@"code"]integerValue];
            if (code == 200) {
                NSDictionary *dataDict = dic[@"data"];
                NSArray *newsListArr = dataDict[@"livelist"];
                self.totalpage = [dataDict[@"totalpage"] intValue];
                self.currentpage = [dataDict[@"currentpage"] intValue];
                NSMutableArray *marr = [NSMutableArray array];
                for(NSDictionary *daDic in newsListArr) {
                    HJTeacherLiveModel *model = [HJTeacherLiveModel mj_objectWithKeyValues:daDic];
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

@end
