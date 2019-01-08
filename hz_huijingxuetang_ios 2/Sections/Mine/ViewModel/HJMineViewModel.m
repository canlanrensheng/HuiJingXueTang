//
//  HJMineViewModel.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/7.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJMineViewModel.h"

@implementation HJMineViewModel

- (void)getUserInfoWithSuccess:(void (^)(void))success {
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/mybaseinfo",API_BASEURL];
    NSDictionary *parameters = @{
                                 @"accesstoken":[APPUserDataIofo AccessToken]
                                 };
    [[YJNetWorkTool sharedTool] requestWithURLString:url parameters:parameters method:@"GET" callBack:^(id responseObject) {
        NSDictionary*dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
        NSInteger code = [[dict objectForKey:@"code"] integerValue];
        if (code == 200) {
            NSDictionary *dic = dict[@"data"];
            if ([HJDealNullTool isNotNULL:[dic objectForKey:@"avator"]]) {
                [APPUserDataIofo getUserIcon:[dic objectForKey:@"avator"]];
            } else {
                [APPUserDataIofo getUserIcon:@""];
            }
            if ([HJDealNullTool isNotNULL:[dic objectForKey:@"nickname"]]) {
                [APPUserDataIofo getUserName:[dic objectForKey:@"nickname"]];
            }else{
                [APPUserDataIofo getUserName:@""];
            }
            if ([HJDealNullTool isNotNULL:[dic objectForKey:@"phone"]]) {
                [APPUserDataIofo getUserPhone:[dic objectForKey:@"phone"]];
            } else {
                [APPUserDataIofo getUserPhone:@""];
            }
            if ([HJDealNullTool isNotNULL:[dic objectForKey:@"sex"]]) {
                NSNumber *sex = [dic objectForKey:@"sex"];
                if (sex.intValue == 1) {
                    [APPUserDataIofo getSex:@"男"];
                } else if (sex.intValue == 2){
                    [APPUserDataIofo getSex:@"女"];
                } else {
                    [APPUserDataIofo getSex:@""];
                }
            } else {
                [APPUserDataIofo getSex:@""];
            }
            if ([HJDealNullTool isNotNULL:[dic objectForKey:@"prov"]]) {
                [APPUserDataIofo getCityname:[dic objectForKey:@"prov"]];
            } else {
                [APPUserDataIofo getCityname:@""];
            }
            
            if ([HJDealNullTool isNotNULL:[dic objectForKey:@"contact"]]) {
                [APPUserDataIofo getContact:[dic objectForKey:@"contact"]];
            } else {
                [APPUserDataIofo getContact:@""];
            }
            if ([HJDealNullTool isNotNULL:[dic objectForKey:@"problembacktime"]]) {
                [APPUserDataIofo getProblemBacktTime:[dic objectForKey:@"problembacktime"]];
            } else {
                [APPUserDataIofo getProblemBacktTime:@""];
            }
            
            if ([HJDealNullTool isNotNULL:[dic objectForKey:@"partner"]]) {
                [APPUserDataIofo getPartner:[dic objectForKey:@"partner"]];
            } else {
                [APPUserDataIofo getPartner:@""];
            }
            
            success();
        } else {
//            ShowError([dict objectForKey:@"msg"]);
        }
    } fail:^(id error) {
        hideHud();
//        ShowError(error);
    }];
}




@end
