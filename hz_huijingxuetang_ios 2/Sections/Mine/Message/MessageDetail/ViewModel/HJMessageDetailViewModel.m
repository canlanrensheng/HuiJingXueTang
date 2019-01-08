//
//  HJMessageDetailViewModel.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/12/7.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJMessageDetailViewModel.h"
#import "HJMessageDetailModel.h"
@implementation HJMessageDetailViewModel

- (void)getFurtherMessageWithType:(NSString *)type Success:(void (^)(BOOL success))success {
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/getfurthermessage",API_BASEURL];
    NSDictionary *parameters = nil;
    parameters = @{
                   @"type" : type,
                   @"accesstoken" : [APPUserDataIofo AccessToken],
                   @"page" : [NSString stringWithFormat:@"%ld",self.page]
                   };
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[YJNetWorkTool sharedTool] requestWithURLString:url parameters:parameters method:@"POST" callBack:^(id responseObject) {
            NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
            DLog(@"获取到的消息详情的数据是:%@",[NSString convertToJsonData:dic]);
            NSInteger code = [[dic objectForKey:@"code"]integerValue];
            if (code == 200) {
                NSDictionary *dataDict = dic[@"data"];
                NSArray *newsListArr = dataDict[@"messagelist"];
                self.totalpage = [dataDict[@"totalpage"] intValue];
                self.currentpage = [dataDict[@"currentpage"] intValue];
                NSMutableArray *marr = [NSMutableArray array];
                for(NSDictionary *daDic in newsListArr) {
                    HJMessageDetailModel *model = [HJMessageDetailModel mj_objectWithKeyValues:daDic];
                    [marr addObject:model];
                }
                if (self.page == 1) {
                    self.messageDetailListArray = marr;
                } else {
                    [self.messageDetailListArray addObjectsFromArray:marr];
                }
                if (marr.count < 10) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
                self.tableView.mj_footer.hidden = self.messageDetailListArray.count < 10 ? YES : NO;
                success(YES);
            } else {
                success(NO);
                ShowError([dic objectForKey:@"msg"]);
            }
        } fail:^(id error) {
            hideHud();
            ShowError(error);
            success(NO);
        }];
    });
    
}


////设置消息已读
//- (void)setMessageReadWithSuccess:(void (^)(void))success {
//    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/setmessageread",API_BASEURL];
//    NSDictionary *parameters = nil;
//    parameters = @{
//                   @"accesstoken" : [APPUserDataIofo AccessToken]
//                   };
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        [[YJNetWorkTool sharedTool] requestWithURLString:url parameters:parameters method:@"POST" callBack:^(id responseObject) {
//            NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
//            DLog(@"获取到的消息详情的数据是:%@",[NSString convertToJsonData:dic]);
//            NSInteger code = [[dic objectForKey:@"code"]integerValue];
//            if (code == 200) {
//                success();
//            } else {
//                ShowError([dic objectForKey:@"msg"]);
//            }
//        } fail:^(id error) {
//            ShowError(error);
//        }];
//    });
//}

@end
