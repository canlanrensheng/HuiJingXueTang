//
//  HJCheckUserVipTool.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/13.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJCheckUserVipTool.h"

@implementation HJCheckUserVipTool

+ (instancetype)shareInstance {
    static HJCheckUserVipTool *object = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        object = [[HJCheckUserVipTool alloc]init];
    });
    return object;
}

- (instancetype)init{
    if (self = [super init]) {
       
    }
    return self;
}

- (void)checkUserVipWithSuccess:(void (^)(int vipNum))success {
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/checkuservip",API_BASEURL];
    NSDictionary *parameters = nil;
    parameters = @{
                   @"accesstoken" : [APPUserDataIofo AccessToken]
                   };
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[YJNetWorkTool sharedTool] requestWithURLString:url parameters:parameters method:@"POST" callBack:^(id responseObject) {
            NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
            NSInteger code = [[dic objectForKey:@"code"]integerValue];
            if (code == 200) {
                NSString *dataString = dic[@"data"];
//                DLog(@"获取到的VIP的数据是:%@",dataString);
                success(dataString.integerValue);
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
