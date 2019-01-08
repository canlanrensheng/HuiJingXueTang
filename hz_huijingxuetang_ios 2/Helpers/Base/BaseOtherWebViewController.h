//
//  BaseOtherWebViewController.h
//  MKnight
//
//  Created by 张金山 on 2018/1/25.
//  Copyright © 2018年 张金山. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseOtherWebViewController : BaseViewController

//加载html字符串
@property (nonatomic, strong) NSString * urlStr;
//加载html片段
@property (nonatomic, strong) NSString * htmlString;
//加载网页的url
@property (nonatomic, strong) NSURL * url;
@property (nonatomic, strong) NSString * webTitle;

@end
