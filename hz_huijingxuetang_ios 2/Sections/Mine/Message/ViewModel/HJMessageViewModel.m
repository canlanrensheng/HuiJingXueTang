//
//  HJMessageViewModel.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/12/7.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJMessageViewModel.h"
#import "HJMessageModel.h"
@implementation HJMessageViewModel

- (void)getMessageWithSuccess:(void (^)(void))success {
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/getmessage",API_BASEURL];
    NSDictionary *para = @{@"accesstoken" : [APPUserDataIofo AccessToken]};
    [[YJNetWorkTool sharedTool] requestWithURLString:url parameters:para method:@"POST" callBack:^(id responseObject) {
        NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
        DLog(@"获取到的数据是:%@",[NSString convertToJsonData:dic]);
        NSInteger code = [[dic objectForKey:@"code"]integerValue];
        if (code == 200) {
            NSDictionary *dataDic = dic[@"data"];
            self.hasmess = [[dataDic valueForKey:@"hasmess"] boolValue];
            self.countmess = [[dataDic valueForKey:@"countmess"] intValue];
            NSArray *messageArr = dataDic[@"message"];
            NSMutableArray *marr = [NSMutableArray array];
            for (NSDictionary *dic in messageArr) {
                HJMessageModel *model = [HJMessageModel mj_objectWithKeyValues:dic];
                [marr addObject:model];
            }
            self.messageArray = marr;
            success();
        } else {
//            ShowError([dic objectForKey:@"msg"]);
        }
    } fail:^(id error) {
//        ShowError(error);
    }];
}

@end
