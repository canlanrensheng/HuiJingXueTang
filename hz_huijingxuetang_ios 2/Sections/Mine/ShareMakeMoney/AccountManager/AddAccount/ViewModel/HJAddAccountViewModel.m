//
//  HJAddAccountViewModel.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/23.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJAddAccountViewModel.h"

@implementation HJAddAccountViewModel

- (void)addAccountWithSuccess:(void (^)(void))success {
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/addaccount",API_BASEURL];
    NSDictionary *parameters = nil;
    parameters = @{
                   @"accesstoken" : [APPUserDataIofo AccessToken],
                   @"teln" : self.phoneNum.length > 0 ? self.phoneNum : @"",
                   @"name" : self.name.length > 0 ? self.name : @"",
                   @"type" : self.type.length > 0 ? self.type : @"",
                   @"accountname" : self.accountname.length > 0 ? self.accountname : @""
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
