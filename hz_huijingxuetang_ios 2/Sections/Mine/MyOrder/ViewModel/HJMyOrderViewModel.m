//
//  HJMyOrderViewModel.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/12/7.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJMyOrderViewModel.h"
#import "HJMyOrderListModel.h"
@implementation HJMyOrderViewModel

- (void)getOrderListWithType:(NSInteger)type success:(void (^)(void))success {
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/mycourseorderapp",API_BASEURL];
    NSDictionary *parameters = nil;
    parameters = @{
                   @"accesstoken" : [APPUserDataIofo AccessToken],
                   @"type" : @(type),
                   @"page" : @(self.page)
                   };
    if(self.isAllOrderListFirstLoad == NO && type == MyOrderTypeAll) {
        [self.loadingView startAnimating];
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[YJNetWorkTool sharedTool] requestWithURLString:url parameters:parameters method:@"POST" callBack:^(id responseObject) {
            if(self.isAllOrderListFirstLoad == NO && type == MyOrderTypeAll) {
                [self.loadingView stopLoadingView];
                self.isAllOrderListFirstLoad = YES;
            }
            NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
            DLog(@"获取到的数据是:%@ 类型是：%ld",[NSString convertToJsonData:dic],type);
            NSInteger code = [[dic objectForKey:@"code"]integerValue];
            if (code == 200) {
                NSDictionary *dataDict = dic[@"data"];
                NSArray *commentArr = dataDict[@"orderlist"];
                self.totalpage = [dataDict[@"totalpage"] intValue];
                self.currentpage = [dataDict[@"currentpage"] intValue];
                NSMutableArray *marr = [NSMutableArray array];
                for (NSDictionary *dic in commentArr) {
                    HJMyOrderListModel *model = [HJMyOrderListModel mj_objectWithKeyValues:dic];
                    [marr addObject:model];
                    CourseResponsesModel *fistModel = model.courseResponses.lastObject;
                    if(fistModel.canbargainstatus == 1) {
                        //砍价订单
                        model.cellType = 2;
                        model.cellHeight = kHeight(216 + 10);;
                    } else {
                        //普通订单
                        model.cellType = 1;
                        model.cellHeight = kHeight(136 + 10) + kHeight(80.0) * model.courseResponses.count;
                    }
                }
                if (self.page == 1) {
                    self.orderListArray = marr;
                } else {
                    [self.orderListArray addObjectsFromArray:marr];
                }
                if (marr.count < 10) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
                self.tableView.mj_footer.hidden = self.orderListArray.count < 10 ? YES : NO;
                success();
            } else {
                if(self.isAllOrderListFirstLoad == NO && type == MyOrderTypeAll) {
                    [self.loadingView stopLoadingView];
                    self.isAllOrderListFirstLoad = YES;
                }
                ShowError([dic objectForKey:@"msg"]);
            }
        } fail:^(id error) {
            if(self.isAllOrderListFirstLoad == NO && type == MyOrderTypeAll) {
                [self.loadingView stopLoadingView];
                self.isAllOrderListFirstLoad = YES;
            }
            hideHud();
            ShowError(error);
        }];
    });
}

- (NSMutableArray *)orderListArray {
    if(!_orderListArray) {
        _orderListArray = [NSMutableArray array];
    }
    return _orderListArray;
}

//删除订单的操作
- (void)deleteOrderWithOrderId:(NSString *)orderId success:(void (^)(void))success {
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/delcourseorder",API_BASEURL];
    NSDictionary *parameters = nil;
    parameters = @{
                   @"accesstoken" : [APPUserDataIofo AccessToken],
                   @"orderid" : orderId
                   };
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[YJNetWorkTool sharedTool] requestWithURLString:url parameters:parameters method:@"POST" callBack:^(id responseObject) {
            NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
            NSInteger code = [[dic objectForKey:@"code"] integerValue];
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
