//
//  HJShopCarViewModel.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/23.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJShopCarViewModel.h"
#import "HJShopCarListModel.h"
@implementation HJShopCarViewModel

- (void)getShopCarListDataWithSuccess:(void (^)(void))success {
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/myshopcat",API_BASEURL];
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
            DLog(@"获取到的购物车的数据是:%@",[NSString convertToJsonData:dic]);
            NSInteger code = [[dic objectForKey:@"code"]integerValue];
            if (code == 200) {
                NSDictionary *dataDict = dic[@"data"];
                NSArray *newsListArr = dataDict[@"cartlist"];
                self.totalpage = [dataDict[@"totalpage"] intValue];
                self.currentpage = [dataDict[@"currentpage"] intValue];
                NSMutableArray *marr = [NSMutableArray array];
                for(NSDictionary *daDic in newsListArr) {
                    HJShopCarListModel *model = [HJShopCarListModel mj_objectWithKeyValues:daDic];
                    [marr addObject:model];
                }
                if (self.page == 1) {
                    self.shopCarListArray = marr;
                } else {
                    [self.shopCarListArray addObjectsFromArray:marr];
                }
                if (marr.count < 10) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
                self.tableView.mj_footer.hidden = self.shopCarListArray.count < 10 ? YES : NO;
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

- (NSMutableArray *)shopCarListArray {
    if(!_shopCarListArray){
        _shopCarListArray = [NSMutableArray array];
    }
    return  _shopCarListArray;
}

//创建待支付订单
- (void)createWaitPayOrderWithCids:(NSString *)cids Success:(void (^)(void))success {
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/createcourseorder",API_BASEURL];
    NSDictionary *para = @{@"accesstoken": [APPUserDataIofo AccessToken],
                           @"cids" : cids .length > 0 ? cids : @""
                           };
    [[YJNetWorkTool sharedTool] requestWithURLString:url parameters:para method:@"POST" callBack:^(id responseObject) {
        NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
        NSInteger code = [[dic objectForKey:@"code"]integerValue];
        if (code == 200) {
            success();
        } else {
            ShowError([dic objectForKey:@"msg"]);
        }
    } fail:^(id error) {
        ShowError(error);
    }];
}

//删除购物车数据
- (void)deleteShopListWithCourseid:(NSString *)courseId Success:(void (^)(void))success {
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/delshopcatcourse",API_BASEURL];
    NSDictionary *para = @{@"accesstoken": [APPUserDataIofo AccessToken] ,
                           @"courseid" : courseId .length > 0 ? courseId : @""
                           };
    [[YJNetWorkTool sharedTool] requestWithURLString:url parameters:para method:@"POST" callBack:^(id responseObject) {
        NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
        NSInteger code = [[dic objectForKey:@"code"]integerValue];
        if (code == 200) {
            success();
        } else {
            ShowError([dic objectForKey:@"msg"]);
        }
    } fail:^(id error) {
        ShowError(error);
    }];
}


@end
