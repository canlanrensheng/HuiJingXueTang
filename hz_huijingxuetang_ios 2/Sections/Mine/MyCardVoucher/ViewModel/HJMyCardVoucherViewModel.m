//
//  HJMyCardVoucherViewModel.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/26.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJMyCardVoucherViewModel.h"
#import "HJMyCardVoucherModel.h"
@implementation HJMyCardVoucherViewModel

- (void)getMyCardVoucherSuccess:(void (^)(void))success {
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/mycouponapp",API_BASEURL];
    NSDictionary *parameters = nil;
    parameters = @{
                   @"accesstoken" : [APPUserDataIofo AccessToken],
                   @"status" : [NSString stringWithFormat:@"%ld",self.myCardVoucherType],
                   @"page" : [NSString stringWithFormat:@"%ld",self.page]
                   };
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[YJNetWorkTool sharedTool] requestWithURLString:url parameters:parameters method:@"POST" callBack:^(id responseObject) {
            NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
            NSInteger code = [[dic objectForKey:@"code"]integerValue];
            DLog(@"获取到的优惠券的信息是:%@ %d",[NSString convertToJsonData:dic],self.myCardVoucherType);
            if (code == 200) {
                NSDictionary *dataDict = dic[@"data"];
                NSArray *commentArr = dataDict[@"mycouponlist"];
                self.totalpage = [dataDict[@"totalpage"] intValue];
                self.currentpage = [dataDict[@"currentpage"] intValue];
                NSMutableArray *marr = [NSMutableArray array];
                for (NSDictionary *dic in commentArr) {
                    HJMyCardVoucherModel *model = [HJMyCardVoucherModel mj_objectWithKeyValues:dic];
                    [marr addObject:model];
                }
                if (self.page == 1) {
                    if(self.myCardVoucherType == MyCardVoucherTypeValid) {
                        self.validVoucherArray = marr;
                    } else if (self.myCardVoucherType == MyCardVoucherTypeUsed) {
                        self.usedVoucherArray = marr;
                    } else {
                        self.invalidVoucherArray = marr;
                    }
                } else {
                    if(self.myCardVoucherType == MyCardVoucherTypeValid) {
                        [self.validVoucherArray addObjectsFromArray:marr];
                    } else if (self.myCardVoucherType == MyCardVoucherTypeUsed) {
                        [self.usedVoucherArray addObjectsFromArray:marr];
                    } else {
                        [self.invalidVoucherArray addObjectsFromArray:marr];
                    }
                }
                if (marr.count < 10) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
                if(self.myCardVoucherType == MyCardVoucherTypeValid) {
                    self.tableView.mj_footer.hidden = self.validVoucherArray.count < 10 ? YES : NO;
                } else if (self.myCardVoucherType == MyCardVoucherTypeUsed) {
                    self.tableView.mj_footer.hidden = self.usedVoucherArray.count < 10 ? YES : NO;
                } else {
                    self.tableView.mj_footer.hidden = self.invalidVoucherArray.count < 10 ? YES : NO;
                }
                
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
