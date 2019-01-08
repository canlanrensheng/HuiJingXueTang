//
//  HJTeachBestViewModel.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/13.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJTeachBestViewModel.h"
#import "HJTeachBestListModel.h"
@implementation HJTeachBestViewModel

//获取资讯的列表的数据
- (void)getListWithSuccess:(void (^)(BOOL successFlag))success {
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/vipnewslist",API_BASEURL];
    NSDictionary *parameters = nil;
    parameters = @{
                   @"accesstoken" : [APPUserDataIofo AccessToken],
                   @"page" : [NSString stringWithFormat:@"%ld",self.page]
                   };
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[YJNetWorkTool sharedTool] requestWithURLString:url parameters:parameters method:@"POST" callBack:^(id responseObject) {
            NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
            NSInteger code = [[dic objectForKey:@"code"]integerValue];
            if (code == 200) {
                NSDictionary *dataDict = dic[@"data"];
                NSArray *newsListArr = dataDict[@"vipnews"];
                self.totalpage = [dataDict[@"totalpage"] intValue];
                self.currentpage = [dataDict[@"currentpage"] intValue];
                NSMutableArray *marr = [NSMutableArray array];
                for(NSDictionary *daDic in newsListArr) {
                    HJTeachBestListModel *model = [HJTeachBestListModel mj_objectWithKeyValues:daDic];
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
                success(YES);
            } else {
                success(NO);
                ShowError([dic objectForKey:@"msg"]);
            }
        } fail:^(id error) {
            success(NO);
            hideHud();
            ShowError(error);
        }];
    });
    
}

- (NSMutableArray *)infoListArray {
    if(!_infoListArray){
        _infoListArray = [NSMutableArray array];
    }
    return  _infoListArray;
}

@end
