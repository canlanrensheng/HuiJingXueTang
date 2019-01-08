//
//  AccountMessageViewModel.h
//  MK100
//
//  Created by 张金山 on 17/10/28.
//  Copyright © 2017年 txooo. All rights reserved.
//

#import "BaseTableViewModel.h"
//#import "AccountModel.h"

typedef NS_ENUM(NSInteger,UserInfoType){
    UserInfoTypeNickName = 0,
    UserInfoTypeSex = 1,
    UserInfoTypeProv = 2
};

@interface AccountMessageViewModel : BaseTableViewModel

//改变用户头像
@property (nonatomic,copy) NSString *iconUrl;
- (void)upLoadImgWithType:(NSString *)type img:(UIImage *)img success:(void (^)(void))success;

//上传操作
- (void)upLoadIconUrl:(NSString *)url success:(void (^)(void))success;

//修改用户信息的接口
- (void)updateUserInfoWithMessage:(NSString *)message  userInfoType:(UserInfoType)userInfoType success:(void (^)(void))success;


@end
