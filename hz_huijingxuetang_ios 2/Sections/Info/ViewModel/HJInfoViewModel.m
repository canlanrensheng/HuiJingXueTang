//
//  HJInfoViewModel.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/9.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJInfoViewModel.h"
#import "HJInfoItemModel.h"
#import "HJInfoListModel.h"
@interface HJInfoViewModel ()


@end

@implementation HJInfoViewModel

//获取资讯模块标题的列表的数据
- (void)getnewsItemslistWithSuccess:(void (^)(void))success {
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/newsmodellist",API_BASEURL];
    [[YJNetWorkTool sharedTool] requestWithURLString:url parameters:nil method:@"GET" callBack:^(id responseObject) {
        NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
        NSInteger code = [[dic objectForKey:@"code"]integerValue];
        if (code == 200) {
            NSArray *dataArr= dic[@"data"];
            NSMutableArray *marr = [NSMutableArray array];
            NSMutableArray *nameMarr = [NSMutableArray array];
            for (NSDictionary *dic in dataArr) {
                HJInfoItemModel *model = [HJInfoItemModel mj_objectWithKeyValues:dic];
                [marr addObject:model];
                [nameMarr addObject:model.name];
            }
            self.newsItemArray = marr;
            self.newsItemNameArray = nameMarr;
            success();
        } else {
            ShowError([dic objectForKey:@"msg"]);
        }
    } fail:^(id error) {
        ShowError(error);
    }];
}

//获取资讯的列表的数据
- (void)getListWithModelid:(NSString *)modelid Success:(void (^)(void))success {
    NSString *url = [NSString stringWithFormat:@"%@/LiveApi/app/newslist",API_BASEURL];
    NSDictionary *parameters = nil;
    parameters = @{
                   @"modelid" : modelid,
                   @"page" : [NSString stringWithFormat:@"%ld",self.page]
                   };
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[YJNetWorkTool sharedTool] requestWithURLString:url parameters:parameters method:@"GET" callBack:^(id responseObject) {
            NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
            NSInteger code = [[dic objectForKey:@"code"]integerValue];
            if (code == 200) {
                NSDictionary *dataDict = dic[@"data"];
                NSArray *newsListArr = dataDict[@"newslist"];
                self.totalpage = [dataDict[@"totalpage"] intValue];
                self.currentpage = [dataDict[@"currentpage"] intValue];
                NSMutableArray *marr = [NSMutableArray array];
                for(NSDictionary *daDic in newsListArr) {
                    HJInfoListModel *model = [HJInfoListModel mj_objectWithKeyValues:daDic];
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

- (NSMutableArray *)infoListArray {
    if(!_infoListArray){
        _infoListArray = [NSMutableArray array];
    }
    return  _infoListArray;
}

@end
