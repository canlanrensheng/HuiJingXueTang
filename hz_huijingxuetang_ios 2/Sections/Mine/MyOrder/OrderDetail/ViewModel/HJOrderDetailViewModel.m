//
//  HJOrderDetailViewModel.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/12/10.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJOrderDetailViewModel.h"

@implementation HJOrderDetailViewModel

//获取订单详情的接口
- (void)getOrderDetailWithOrderId:(NSString *)orderId success:(void (^)(BOOL successFlag))success {
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/orderdetail",API_BASEURL];
    NSDictionary *parameters = nil;
    parameters = @{
                   @"accesstoken" : [APPUserDataIofo AccessToken],
                   @"orderno" : orderId.length > 0 ? orderId : @""
                   };
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[YJNetWorkTool sharedTool] requestWithURLString:url parameters:parameters method:@"POST" callBack:^(id responseObject) {
            NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
            DLog(@"获取到的订单详情的数据是:%@",[NSString convertToJsonData:dic]);
            NSInteger code = [[dic objectForKey:@"code"]integerValue];
            if (code == 200) {
                NSDictionary *dataDict = dic[@"data"];
                NSArray *orderListArr = dataDict[@"orderlist"];
                self.totalpage = [dataDict[@"totalpage"] intValue];
                self.currentpage = [dataDict[@"currentpage"] intValue];
                NSDictionary *orderInfoDict = orderListArr.firstObject;
                self.model = [HJMyOrderListModel mj_objectWithKeyValues:orderInfoDict];
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

//删除订单的操作
- (void)deleteOrderWithOrderId:(NSString *)orderId success:(void (^)(void))success {
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/delCourseOrder",API_BASEURL];
    NSDictionary *parameters = nil;
    parameters = @{
                   @"accesstoken" : [APPUserDataIofo AccessToken],
                   @"orderid" : orderId
                   };
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[YJNetWorkTool sharedTool] requestWithURLString:url parameters:parameters method:@"POST" callBack:^(id responseObject) {
            NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
            NSInteger code = [[dic objectForKey:@"code"]integerValue];
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
