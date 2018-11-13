//
//  UIView+HJPagingView.h
//  UIView+HJPagingView
//
//  Created by zhangjinshan on 15/7/13.
//  Copyright © 2015年 zhangjinshan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (HJPagingView)
@property (nonatomic, assign) CGFloat HJ_x;
@property (nonatomic, assign) CGFloat HJ_y;
@property (nonatomic, assign) CGFloat HJ_width;
@property (nonatomic, assign) CGFloat HJ_height;
@property (nonatomic, assign) CGFloat HJ_centerX;
@property (nonatomic, assign) CGFloat HJ_centerY;
@property (nonatomic, assign) CGPoint HJ_origin;
@property (nonatomic, assign) CGSize HJ_size;

/// 从 XIB 中加载视图
+ (instancetype)HJ_loadViewFromXib;

@end
