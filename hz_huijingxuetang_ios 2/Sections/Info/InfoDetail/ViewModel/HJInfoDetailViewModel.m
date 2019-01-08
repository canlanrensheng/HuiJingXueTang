//
//  HJInfoDetailViewModel.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/13.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJInfoDetailViewModel.h"
#import "HJTeachBestDetailCommentModel.h"
#import <sys/utsname.h>
@implementation HJInfoDetailViewModel

- (void)getInfoDetailWithInfoid:(NSString *)infoid Success:(void (^)(void))success {
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/newsdetail",API_BASEURL];
    NSDictionary *parameters = nil;
    parameters = @{
                   @"infoid" : infoid.length > 0 ? infoid : @""
                   };
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[YJNetWorkTool sharedTool] requestWithURLString:url parameters:parameters method:@"GET" callBack:^(id responseObject) {
            NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
            NSInteger code = [[dic objectForKey:@"code"]integerValue];
            if (code == 200) {
                NSDictionary *dataDict = dic[@"data"];
                self.model = [HJInfoDetailModel mj_objectWithKeyValues:dataDict];
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

//获取评论的列表的数据
- (void)getInfoDetailCommondWithInfoid:(NSString *)infoid Success:(void (^)(void))success {
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/newscomment",API_BASEURL];
    NSDictionary *parameters = nil;
    parameters = @{
                   @"infoid" : infoid,
                   @"page" : [NSString stringWithFormat:@"%ld",self.page]
                   };
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[YJNetWorkTool sharedTool] requestWithURLString:url parameters:parameters method:@"GET" callBack:^(id responseObject) {
            NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
            NSInteger code = [[dic objectForKey:@"code"]integerValue];
            if (code == 200) {
                NSDictionary *dataDict = dic[@"data"];
                NSArray *commentlistArr = dataDict[@"commentlist"];
                self.totalpage = [dataDict[@"totalpage"] intValue];
                self.currentpage = [dataDict[@"currentpage"] intValue];
                DLog(@"评论吧的数据的数量是:%tu",commentlistArr.count);
                NSMutableArray *marr = [NSMutableArray array];
                for(NSDictionary *daDic in commentlistArr) {
                    HJTeachBestDetailCommentModel *model = [HJTeachBestDetailCommentModel mj_objectWithKeyValues:daDic];
                    CGFloat height = [model.commentcontent calculateSize:CGSizeMake(Screen_Width - kWidth(75), MAXFLOAT) font:MediumFont(font(13))].height;
                    model.cellHeight = kHeight(80) + height;
                    [marr addObject:model];
                }
                if (self.page == 1) {
                    self.infoCommondArray = marr;
                } else {
                    [self.infoCommondArray addObjectsFromArray:marr];
                }
                if (marr.count < 10) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
                self.tableView.mj_footer.hidden = self.infoCommondArray.count < 10 ? YES : NO;
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

//添加评论
- (void)addNewsCommentWithInfoId:(NSString *)infoId  content:(NSString *)content Success:(void (^)(void))success {
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/sendnewscomment",API_BASEURL];
    //获取当前的的定位的位置
    NSString *currentCicy = [[NSUserDefaults standardUserDefaults] valueForKey:@"CurrentLocation"];
    NSDictionary *parameters = @{
                                 @"accesstoken" : [APPUserDataIofo AccessToken],
                                 @"infoid" : infoId ,
                                 @"content" : content,
                                 @"userzone" : currentCicy.length > 0 ? currentCicy : @"",
                                 @"userterminal" : [self iphoneType].length > 0 ? [self iphoneType] : @""
                                 };
    ShowHint(@"");
    [[YJNetWorkTool sharedTool] requestWithURLString:url parameters:parameters method:@"POST" callBack:^(id responseObject) {
        hideHud();
        [MBProgressHUD showMessage:@"评论成功" view:[UIApplication sharedApplication].keyWindow];
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

//校验资讯密码
- (void)verifyInfoPwdWithInfoPwd:(NSString *)infoPwd Success:(void (^)(BOOL successFlag))success {
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/verifyinfopwd",API_BASEURL];
    NSDictionary *parameters = @{
                                 @"infopwd" : infoPwd
                                 };
    [[YJNetWorkTool sharedTool] requestWithURLString:url parameters:parameters method:@"GET" callBack:^(id responseObject) {
//        hideHud();
        NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
        NSInteger code = [[dic objectForKey:@"code"]integerValue];
        if (code == 200) {
            success(YES);
        } else {
            success(NO);
//            ShowError([dic objectForKey:@"msg"]);
        }
    } fail:^(id error) {
//        hideHud();
        success(NO);
        ShowError(error);
    }];
}

- (NSMutableArray *)infoCommondArray {
    if(!_infoCommondArray){
        _infoCommondArray = [NSMutableArray array];
    }
    return  _infoCommondArray;
}

- (NSString *)iphoneType {
    struct utsname systemInfo;
    
    uname(&systemInfo);
    
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G";
    
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c";
    
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
    
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s";
    
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
    
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    
    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    
    if ([platform isEqualToString:@"iPhone9,1"]) return @"iPhone 7";
    
    if ([platform isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus";
    
    if([platform isEqualToString:@"iPhone10,1"])return @"iPhone 8";
    if([platform isEqualToString:@"iPhone10,4"])return @"iPhone 8";
    
    if([platform isEqualToString:@"iPhone10,2"])return @"iPhone 8 Plus";
    if([platform isEqualToString:@"iPhone10,5"])return @"iPhone 8 Plus";
    
    if([platform isEqualToString:@"iPhone10,3"])return @"iPhone X";
    if([platform isEqualToString:@"iPhone10,6"])return @"iPhone X";
    
    if ([platform isEqualToString:@"iPhone11,2"])return @"iPhone XS";
    if ([platform isEqualToString:@"iPhone11,6"])return @"iPhone XS Max";
    if ([platform isEqualToString:@"iPhone11,8"])return @"iPhone XR";
    
    if([platform isEqualToString:@"i386"])return @"Simulator";
    if([platform isEqualToString:@"x86_64"])return @"Simulator";
    return platform;
    
}

@end
