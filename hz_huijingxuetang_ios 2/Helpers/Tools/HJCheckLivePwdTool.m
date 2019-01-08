//
//  HJCheckLivePwd.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/30.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJCheckLivePwdTool.h"

@implementation HJCheckLivePwdTool

+ (instancetype)shareInstance {
    static HJCheckLivePwdTool *object = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        object = [[HJCheckLivePwdTool alloc]init];
    });
    return object;
}

- (void)checkLivePwdWithPwd:(NSString *)pwd courseId:(NSString *)courseId success:(void (^)(BOOL isSetPwd))success error:(void (^)(void))error {
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/checkroompwd",API_BASEURL];
    NSDictionary *parameters = nil;
    parameters = @{
                   @"courseid" : courseId.length > 0 ? courseId : @"",
                   @"roompwd" : pwd
                   };
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[YJNetWorkTool sharedTool] requestWithURLString:url parameters:parameters method:@"POST" callBack:^(id responseObject) {
            NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
            NSInteger code = [[dic objectForKey:@"code"]integerValue];
            NSInteger successPwd = [[dic objectForKey:@"data"] intValue];
            DLog(@"获取到的校验密码的数据是:%@",[NSString convertToJsonData:dic]);
            if (code == 200) {
                if(successPwd == 1) {
                    success(YES);
                } else {
                    success(NO);
                }
            } else {
                error();
                ShowError([dic objectForKey:@"msg"]);
            }
        } fail:^(id error) {
            ShowError(error);
        }];
    });
}

@end
