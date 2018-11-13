//
//  MKRefreshHeader.h
//  MK100
//
//  Created by txooo on 2017/12/25.
//  Copyright © 2017年 txooo. All rights reserved.
//

#import <MJRefresh/MJRefresh.h>

@interface MKRefreshHeader : MJRefreshStateHeader

@property (weak, nonatomic, readonly) UIImageView *arrowView;
/** 菊花的样式 */
@property (assign, nonatomic) UIActivityIndicatorViewStyle activityIndicatorViewStyle;

@end
