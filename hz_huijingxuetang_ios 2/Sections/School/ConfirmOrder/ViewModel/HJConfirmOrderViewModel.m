//
//  HJConfirmOrderViewModel.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/24.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJConfirmOrderViewModel.h"

@implementation HJConfirmOrderViewModel

- (void)getConfirmOrderListDataWithOrderId:(NSString *)orderId Success:(void (^)(void))success {
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/courseorderdetailforpay",API_BASEURL];
    NSDictionary *parameters = @{
                                 @"accesstoken" : [APPUserDataIofo AccessToken],
                                 @"orderid" : orderId.length > 0 ? orderId : @""
                                 };
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[YJNetWorkTool sharedTool] requestWithURLString:url parameters:parameters method:@"POST" callBack:^(id responseObject) {
            NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
            DLog(@"获取到的数据是:%@",[NSString convertToJsonData:dic]);
            NSInteger code = [[dic objectForKey:@"code"]integerValue];
            if (code == 200) {
                NSDictionary *dataDict = dic[@"data"];
                self.model = [HJConfirmOrderModel mj_objectWithKeyValues:dataDict];
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
