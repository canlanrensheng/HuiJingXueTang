//
//  CheckVersion.m
//  Zhuan
//
//  Created by txooo on 16/6/27.
//  Copyright © 2016年 张金山. All rights reserved.
//

#import "TXCheckVersion.h"
#import "TXAlertView.h"
#import <StoreKit/StoreKit.h>
#define REQUEST_SUCCEED 200
#define CURRENT_VERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define BUNDLE_IDENTIFIER [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"]
#define SYSTEM_VERSION_8_OR_ABOVE (([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)? (YES):(NO))
#define TRACK_ID @"TRACKID"
#define APP_LAST_VERSION @"APPLastVersion"
#define APP_RELEASE_NOTES @"APPReleaseNotes"
#define APP_TRACK_VIEW_URL @"APPTRACKVIEWURL"
#define SPECIAL_MODE_CHECK_URL @"https://itunes.apple.com/lookup?country=%@&bundleId=%@"
#define NORMAL_MODE_CHECK_URL @"https://itunes.apple.com/lookup?bundleId=%@"
#define SKIP_CURRENT_VERSION @"SKIPCURRENTVERSION"
#define SKIP_VERSION @"SKIPVERSION"
@interface TXCheckVersion ()<SKStoreProductViewControllerDelegate>

@property (nonatomic, copy) NSString *nextTimeTitle;
@property (nonatomic, copy) NSString *confimTitle;
@property (nonatomic, copy) NSString *alertTitle;
@property (nonatomic, copy) NSString *skipVersionTitle;
@end

@implementation TXCheckVersion

static TXCheckVersion *checkManager = nil;
+ (instancetype)sharedCheckManager {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        checkManager = [[TXCheckVersion alloc] init];
        checkManager.nextTimeTitle = @"下次提示";
        checkManager.confimTitle = @"前往更新";
        checkManager.alertTitle = @"发现新版本";
        checkManager.skipVersionTitle = nil;
    });
    return checkManager;
}

- (void)checkVersion {
    [self checkVersionWithAlertTitle:self.alertTitle nextTimeTitle:self.nextTimeTitle confimTitle:self.confimTitle];
}

- (void)checkVersionWithAlertTitle:(NSString *)alertTitle nextTimeTitle:(NSString *)nextTimeTitle confimTitle:(NSString *)confimTitle {
    
    [self checkVersionWithAlertTitle:alertTitle nextTimeTitle:nextTimeTitle confimTitle:confimTitle skipVersionTitle:nil];
}

- (void)checkVersionWithAlertTitle:(NSString *)alertTitle nextTimeTitle:(NSString *)nextTimeTitle confimTitle:(NSString *)confimTitle skipVersionTitle:(NSString *)skipVersionTitle {
    
    self.alertTitle = alertTitle;
    self.nextTimeTitle = nextTimeTitle;
    self.confimTitle = confimTitle;
    self.skipVersionTitle = skipVersionTitle;
    [checkManager getInfoFromAppStore];
}

//利用lookUp查找appStore的应用的信息
- (void)getInfoFromAppStore {
    
    NSURL *requestURL;
    if (self.countryAbbreviation == nil) {
        requestURL = [NSURL URLWithString:[NSString stringWithFormat:NORMAL_MODE_CHECK_URL,BUNDLE_IDENTIFIER]];
    } else {
        requestURL = [NSURL URLWithString:[NSString stringWithFormat:SPECIAL_MODE_CHECK_URL,self.countryAbbreviation,BUNDLE_IDENTIFIER]];
    }
    
//    DLog(@"获取到的请求的url是:%@",requestURL.absoluteString);
    NSURLRequest *request = [NSURLRequest requestWithURL:requestURL];
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSHTTPURLResponse *urlResponse = (NSHTTPURLResponse *)response;
        
        if (urlResponse.statusCode == REQUEST_SUCCEED) {
            NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            if ([responseDic[@"resultCount"] intValue] == 1) {
                NSArray *results = responseDic[@"results"];
                NSDictionary *resultDic = [results firstObject];
                //最新的版本
                [userDefault setObject:resultDic[@"version"] forKey:APP_LAST_VERSION];
                //版本的更新内容
                [userDefault setObject:resultDic[@"releaseNotes"] forKey:APP_RELEASE_NOTES];
                //appStore的链接
                [userDefault setObject:resultDic[@"trackViewUrl"] forKey:APP_TRACK_VIEW_URL];
                //应用内模态AppStore需要的应用id
                [userDefault setObject:[resultDic[@"trackId"] stringValue] forKey:TRACK_ID];
                if ([resultDic[@"version"] isEqualToString:CURRENT_VERSION] || ![[userDefault objectForKey:SKIP_VERSION] isEqualToString:resultDic[@"version"]]) {
                    [userDefault setBool:NO forKey:SKIP_CURRENT_VERSION];
                }
                if (self.debugEnable) {
                    DLog(@"%@   %@",[userDefault objectForKey:APP_LAST_VERSION],[userDefault objectForKey:APP_RELEASE_NOTES]);
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(self.isForceUpdate){
                        //强制更新
                        DLog(@"获取到的版本是:%@  %@",resultDic[@"version"],CURRENT_VERSION);
                        CGFloat currentVersion = [self floatForVersion:CURRENT_VERSION];
                        CGFloat lastestVersion = [self floatForVersion:resultDic[@"version"]];
//                        if(lastestVersion == 1.0){
//
//                        }
                        if(lastestVersion - currentVersion > 0){
                             [self limitUpdate];
                        }else{
                           
                        }
                    }else{
                        //不需要强制更新
                        if (![[userDefault objectForKey:SKIP_CURRENT_VERSION] boolValue]) {
                            CGFloat currentVersion = [self floatForVersion:CURRENT_VERSION];
                            CGFloat lastestVersion = [self floatForVersion:resultDic[@"version"]];
                            if (lastestVersion - currentVersion >= 1) {
                                [self limitUpdate];
                            }else if (lastestVersion > currentVersion){
                                [self optionalUpdate];
                            }
                        }
                    }
                   
                });
            }
        }
    }];
    [dataTask resume];
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

- (void)limitUpdate{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *updateMessage = [userDefault objectForKey:APP_RELEASE_NOTES];
//    UpdateAlertViewController *alertView = [[UpdateAlertViewController alloc]init];
//    alertView.alertTitle = self.alertTitle;
//    alertView.message = updateMessage;
//    alertView.updateUrl = [userDefault objectForKey:APP_TRACK_VIEW_URL];
//    [alertView setAlertView];
    
    [TXAlertView showAlertWithTitle:self.alertTitle message:updateMessage cancelButtonTitle:nil style:TXAlertViewStyleAlert buttonIndexBlock:^(NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            [self openAPPStore];
        }
    } otherButtonTitles:@"立即更新", nil];
}

- (void)optionalUpdate {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *updateMessage = [userDefault objectForKey:APP_RELEASE_NOTES];
    if (![[userDefault objectForKey:APP_LAST_VERSION] isEqualToString:CURRENT_VERSION]) {
        [TXAlertView showAlertWithTitle:self.alertTitle message:updateMessage cancelButtonTitle:self.nextTimeTitle style:TXAlertViewStyleAlert buttonIndexBlock:^(NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                [self openAPPStore];
            }else if (buttonIndex == 2){
                [userDefault setBool:YES forKey:SKIP_CURRENT_VERSION];
                [userDefault setObject:[userDefault objectForKey:APP_LAST_VERSION] forKey:SKIP_VERSION];
            }
        } otherButtonTitles:self.confimTitle,self.skipVersionTitle, nil];
    }
}

- (void)openAPPStore {
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if (!self.openAPPStoreInsideAPP) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[userDefault objectForKey:APP_TRACK_VIEW_URL]]];
        
    } else {
        SKStoreProductViewController *storeViewController = [[SKStoreProductViewController alloc] init];
        storeViewController.delegate = self;
        
        NSDictionary *parametersDic = @{SKStoreProductParameterITunesItemIdentifier:[userDefault objectForKey:TRACK_ID]};
        [storeViewController loadProductWithParameters:parametersDic completionBlock:^(BOOL result, NSError * _Nullable error) {
            
            if (result) {
                [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:storeViewController animated:YES completion:^{
                    
                }];
            }
        }];
    }
    
}

- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController {
    [[UIApplication sharedApplication].keyWindow.rootViewController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end

@implementation UpdateAlertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)setAlertView{
    self.view.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.5];
    CGSize size = CGSizeZero;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    NSDictionary *attributes = @{NSFontAttributeName:H15, NSParagraphStyleAttributeName:paragraphStyle.copy};
    size = [self.message boundingRectWithSize:CGSizeMake(Screen_Width - 70, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
    UIView *alerView = [[UIView alloc]initWithFrame:CGRectMake(40, 0, Screen_Width - 80, (130 + size.height)  > Screen_Height - 80 ? Screen_Height - 80 : (130 + size.height))];
    alerView.backgroundColor = [UIColor whiteColor];
    alerView.center = self.view.center;
    alerView.layer.cornerRadius = 10;
    [self.view addSubview:alerView];
    
    UILabel *titileLb = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(alerView.bounds), 50)];
    titileLb.numberOfLines = 0;
    titileLb.text = self.alertTitle;
    titileLb.font = [UIFont systemFontOfSize:18];
    titileLb.textAlignment = NSTextAlignmentCenter;
    [alerView addSubview:titileLb];
    
    UIScrollView *sv = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 50, CGRectGetWidth(alerView.bounds), (130 + size.height)  > Screen_Height - 80 ? Screen_Height - 180 : (30 + size.height))];
    sv.contentSize = CGSizeMake(CGRectGetWidth(alerView.bounds), size.height + 30);
    [alerView addSubview:sv];
    
    UILabel *messageLb = [[UILabel alloc]initWithFrame:CGRectMake(15, 15,CGRectGetWidth(alerView.bounds) - 30, size.height)];
    messageLb.text = self.message;
    messageLb.textColor = Text_Color;
    messageLb.font = [UIFont systemFontOfSize:15];
    messageLb.numberOfLines = 0;
    messageLb.textAlignment = NSTextAlignmentCenter;
    [sv addSubview:messageLb];
    
    UILabel *bottomLine = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(alerView.bounds) - 50, CGRectGetWidth(alerView.bounds), onePixel)];
    bottomLine.backgroundColor = Line_Color;
    [alerView addSubview:bottomLine];
    
    UIButton *updateBtn = [UIButton buttonWithType:0];
    updateBtn.frame = CGRectMake(0, CGRectGetHeight(alerView.bounds) - 50, CGRectGetWidth(alerView.bounds), 50);
    [updateBtn setTitle:@"立即更新" forState:UIControlStateNormal];
    [updateBtn setTitleColor:RGBCOLOR(0, 131, 250) forState:0];
    [updateBtn addTarget:self action:@selector(updateBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [alerView addSubview:updateBtn];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.view];
    [window.rootViewController addChildViewController:self];
}

- (void)updateBtnAction{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.updateUrl]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
