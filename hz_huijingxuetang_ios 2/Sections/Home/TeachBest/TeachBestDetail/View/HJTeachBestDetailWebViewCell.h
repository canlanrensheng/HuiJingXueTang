//
//  HJTeachBestDetailWebViewCell.h
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/12.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "BaseTableViewCell.h"
#import <WebKit/WebKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface HJTeachBestDetailWebViewCell : BaseTableViewCell

@property (nonatomic,strong)  WKWebView *webView;

@end

NS_ASSUME_NONNULL_END
