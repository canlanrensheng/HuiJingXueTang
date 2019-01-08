//
//  AccountMessageViewModel.m
//  MK100
//
//  Created by 张金山 on 17/10/28.
//  Copyright © 2017年 txooo. All rights reserved.
//

#import "AccountMessageViewModel.h"

@interface AccountMessageViewModel()

//@property (nonatomic,strong) List *listModel;

@end

@implementation AccountMessageViewModel

//改变用户头像
- (void)upLoadImgWithType:(NSString *)type img:(UIImage *)img success:(void (^)(void))success {
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/upload",API_BASEURL];
    NSDictionary *parameters = @{
                                 @"accesstoken":[APPUserDataIofo AccessToken],
                                 @"type":type,
                                 };
    [[YJNetWorkTool sharedTool]requestWithURLString:url parameters:parameters imgdata:img callBack:^(id responseObject) {
        NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
        NSInteger code = [[dic objectForKey:@"code"] integerValue];
        if (code == 200) {
            self.iconUrl = [dic objectForKey:@"data"];
        } else {
            ShowError([dic objectForKey:@"msg"]);
        }
        DLog(@"上传头像获取到的数据是%@",dic);
        success();
    } fail:^(id error) {

        ShowError(error);
    }];
}


//修改用户头像的接口
- (void)upLoadIconUrl:(NSString *)url success:(void (^)(void))success {
    [YJAPPNetwork updataIconWithAccesstoken:[APPUserDataIofo AccessToken] avator:url success:^(NSDictionary *responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"]integerValue];
        if (code == 200) {
            ShowMessage(@"修改成功");
        }else{
            ShowError([responseObject objectForKey:@"msg"]);
        }
        success();
    } failure:^(NSString *error) {
//        [SVProgressHUD showInfoWithStatus:netError];
        ShowMessage(netError);
    }];
}

//修改用户信息的接口
- (void)updateUserInfoWithMessage:(NSString *)message  userInfoType:(UserInfoType)userInfoType success:(void (^)(void))success {
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/updateUserInfo",API_BASEURL];
    NSDictionary *parameters = nil;
    if (userInfoType == UserInfoTypeNickName) {
       parameters = @{
          @"accesstoken":[APPUserDataIofo AccessToken],
          @"nickname":message
          };
    }
    if (userInfoType == UserInfoTypeSex) {
        parameters = @{
                       @"accesstoken":[APPUserDataIofo AccessToken],
                       @"sex":message
                       };
    }
    if (userInfoType == UserInfoTypeProv) {
        parameters = @{
                       @"accesstoken":[APPUserDataIofo AccessToken],
                       @"prov":message
                       };
    }
    [[YJNetWorkTool sharedTool] requestWithURLString:url parameters:parameters method:@"POST" callBack:^(id responseObject) {
        NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
        NSInteger code = [[dic objectForKey:@"code"] integerValue];
        if (code == 200) {
            self.iconUrl = [dic objectForKey:@"data"];
        } else {
            ShowError([dic objectForKey:@"msg"]);
        }
        success();
    } fail:^(id error) {
        ShowError(error);
    }];
}

- (void)tx_initialize {
    [self.dataArray addObjectsFromArray:@[@[@"头像",@"昵称",@"性别"],
                                          @[@"手机号",@"地区"],
                                          @[@"退出登录"]]];
}

@end
