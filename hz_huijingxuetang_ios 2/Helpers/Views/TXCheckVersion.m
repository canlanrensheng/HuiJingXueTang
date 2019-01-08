//
//  CheckVersion.m
//  Zhuan
//
//  Created by txooo on 16/6/27.
//  Copyright © 2016年 张金山. All rights reserved.
//

#import "TXCheckVersion.h"
#import "TXAlertView.h"
#import "HJSelectToUpdateVersionView.h"
#import "HJForceToUpdateView.h"

@implementation TXCheckVersion

static TXCheckVersion *checkManager = nil;

+ (instancetype)sharedCheckManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        checkManager = [[TXCheckVersion alloc] init];
    });
    return checkManager;
}

- (void)checkVersion {
    [YJAPPNetwork CheckVersionWithSuccess:^(NSDictionary *responseObject) {
        NSDictionary *data = [responseObject objectForKey:@"data"];
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if (code == 200) {
            //最新已经上线的版本
            NSString *latestVer = [data valueForKey:@"latestVer"];
            //是否强制更新
            NSString *forceUpdate = [data valueForKey:@"forceUpdate"];
            //app下载的地址
            NSString *downloadpath = [data valueForKey:@"downloadpath"];
            //笨笨更新的内容
            NSString *updateexpain = [data valueForKey:@"updateexpain"];
            NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
            DLog(@"获取到的版本的更新的内容是:%@",[NSString convertToJsonData:responseObject]);
            if ([self floatForVersion:latestVer] > [self floatForVersion:currentVersion]) {
                if([forceUpdate integerValue] == 1) {
                    //强制更新
                    HJForceToUpdateView *forceToUpdateView = [[HJForceToUpdateView alloc] initWithVersionNum:latestVer versionUpdateContent:updateexpain link:downloadpath bindBlock:^(BOOL success) {
                        
                    }];
                    [forceToUpdateView show];
                } else {
                    //选择性更新
                    HJSelectToUpdateVersionView *forceToUpdateView = [[HJSelectToUpdateVersionView alloc] initWithVersionNum:latestVer versionUpdateContent:updateexpain link:downloadpath bindBlock:^(BOOL success) {
                        
                    }];
                    [forceToUpdateView show];
                }
            }
        }else{
            ShowError([responseObject objectForKey:@"msg"]);
        }
    } failure:^(NSString *error) {
        ShowMessage(netError);
    }];
}


- (double)floatForVersion:(NSString *)version {
    NSArray *versionArray = [version componentsSeparatedByString:@"."];
    NSMutableString *versionString = @"".mutableCopy;
    for (int i = 0; i < versionArray.count; i++) {
        [versionString appendString:versionArray[i]];
        if (!i) {
            [versionString appendString:@"."];
        }
    }
    return versionString.doubleValue;
}

@end
