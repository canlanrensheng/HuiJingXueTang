//
//  HJAccountManagerViewModel.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/12/4.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJAccountManagerViewModel.h"
#import "HJAccountManagerModel.h"
@implementation HJAccountManagerViewModel

- (void)getAccountManagerListSuccess:(void (^)(void))success {
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/withdrawalsrecord",API_BASEURL];
    NSDictionary *parameters = nil;
    parameters = @{
                   @"accesstoken" : [APPUserDataIofo AccessToken]
                   };
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[YJNetWorkTool sharedTool] requestWithURLString:url parameters:parameters method:@"POST" callBack:^(id responseObject) {
            NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
            NSInteger code = [[dic objectForKey:@"code"]integerValue];
            DLog(@"获取到的数据是:%@",[NSString convertToJsonData:dic]);
            if (code == 200) {
                NSDictionary *dataDict = dic[@"data"];
                NSArray *commentArr = dataDict[@"withdrawlsrecord"];
                NSMutableArray *marr = [NSMutableArray array];
                for (NSDictionary *dic in commentArr) {
                    HJAccountManagerModel *model = [HJAccountManagerModel mj_objectWithKeyValues:dic];
                    [marr addObject:model];
                }
                self.accountManagerArray = marr;
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

//解绑的操作
- (void)removeaccountWithSuccess:(void (^)(void))success {
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/removeaccount",API_BASEURL];
    NSDictionary *parameters = nil;
    parameters = @{
                   @"accesstoken" : [APPUserDataIofo AccessToken],
                   @"id" : self.accountId.length > 0 ? self.accountId : @"",
                   @"type" : self.type.length > 0 ? self.type : @"",
                   };
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[YJNetWorkTool sharedTool] requestWithURLString:url parameters:parameters method:@"POST" callBack:^(id responseObject) {
            NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
            NSInteger code = [[dic objectForKey:@"code"]integerValue];
            DLog(@"获取到的数据是:%@",[NSString convertToJsonData:dic]);
            if (code == 200) {
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

//设置为默认的打款账户
- (void)setDefaultaccountWithSuccess:(void (^)(void))success {
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/defaultaccount",API_BASEURL];
    NSDictionary *parameters = nil;
    parameters = @{
                   @"accesstoken" : [APPUserDataIofo AccessToken],
                   @"id" : self.accountId.length > 0 ? self.accountId : @""
                   };
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[YJNetWorkTool sharedTool] requestWithURLString:url parameters:parameters method:@"POST" callBack:^(id responseObject) {
            NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
            NSInteger code = [[dic objectForKey:@"code"]integerValue];
            DLog(@"获取到的数据是:%@",[NSString convertToJsonData:dic]);
            if (code == 200) {
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
