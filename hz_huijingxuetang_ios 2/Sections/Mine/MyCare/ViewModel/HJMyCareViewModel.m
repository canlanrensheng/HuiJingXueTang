//
//  HJMyCareViewModel.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/19.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJMyCareViewModel.h"
#import "HJMyCareListModle.h"
@implementation HJMyCareViewModel

- (void)getMyCareListWithSuccess:(void (^)(void))success {
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/myInterect",API_BASEURL];
    NSDictionary *parameters = nil;
    parameters = @{
                   @"accesstoken" : [APPUserDataIofo AccessToken],
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
            NSInteger code = [[dic objectForKey:@"code"]integerValue];
            if (code == 200) {
                NSDictionary *dataDict = dic[@"data"];
                NSArray *newsListArr = dataDict[@"interectList"];
                self.totalpage = [dataDict[@"totalpage"] intValue];
                self.currentpage = [dataDict[@"currentpage"] intValue];
                NSMutableArray *marr = [NSMutableArray array];
                for(NSDictionary *daDic in newsListArr) {
                    HJMyCareListModle *model = [HJMyCareListModle mj_objectWithKeyValues:daDic];
                    [marr addObject:model];
                }
                if (self.page == 1) {
                    self.myCareArray = marr;
                } else {
                    [self.myCareArray addObjectsFromArray:marr];
                }
                if (marr.count < 10) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
                self.tableView.mj_footer.hidden = self.myCareArray.count < 10 ? YES : NO;
                success();
            } else {
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

- (void)careOrCancleCareWithTeacherId:(NSString *)teacherId
                          accessToken:(NSString *)accessToken
                            insterest:(NSString *)insterest
                              Success:(void (^)(void))success {
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/tointerestornot",API_BASEURL];
    NSDictionary *parameters = @{
                                 @"accesstoken" : [APPUserDataIofo AccessToken],
                                 @"teacherid" : teacherId,
                                 @"interest" :insterest
                                 };
//    ShowHint(@"");
    [[YJNetWorkTool sharedTool] requestWithURLString:url parameters:parameters method:@"POST" callBack:^(id responseObject) {
//        hideHud();
        NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
        NSInteger code = [[dic objectForKey:@"code"]integerValue];
        if (code == 200) {
            success();
        } else {
            ShowError([dic objectForKey:@"msg"]);
        }
    } fail:^(id error) {
//        hideHud();
        ShowError(error);
    }];
}

- (NSMutableArray *)myCareArray {
    if(!_myCareArray) {
        _myCareArray = [NSMutableArray array];
    }
    return  _myCareArray;
}

@end
