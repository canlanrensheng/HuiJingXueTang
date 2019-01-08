//
//  HJPostEvaluationViewModel.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/14.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJPostEvaluationViewModel.h"

@implementation HJPostEvaluationViewModel

- (void)addCommentWithSuccess:(void (^)(void))success {
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/writecomment",API_BASEURL];
    NSDictionary *parameters = @{
                                 @"accesstoken" : [APPUserDataIofo AccessToken],
                                 @"courseid" : self.courseid ,
                                 @"content" : self.content,
                                 @"star" :  self.star
                                 };
    ShowHint(@"");
    [[YJNetWorkTool sharedTool] requestWithURLString:url parameters:parameters method:@"POST" callBack:^(id responseObject) {
        hideHud();
        [MBProgressHUD showMessage:@"评价成功" view:[UIApplication sharedApplication].keyWindow];
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
}

@end
