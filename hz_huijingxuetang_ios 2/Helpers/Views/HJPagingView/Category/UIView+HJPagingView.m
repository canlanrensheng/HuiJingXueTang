//
//  UIView+HJPagingView.m
//  UIView+HJPagingView
//
//  Created by zhangjinshan on 15/7/13.
//  Copyright © 2015年 zhangjinshan. All rights reserved.
//

#import "UIView+HJPagingView.h"

@implementation UIView (HJPagingView)
- (void)setHJ_x:(CGFloat)HJ_x {
    CGRect frame = self.frame;
    frame.origin.x = HJ_x;
    self.frame = frame;
}
- (CGFloat)HJ_x {
    return self.frame.origin.x;
}

- (void)setHJ_y:(CGFloat)HJ_y {
    CGRect frame = self.frame;
    frame.origin.y = HJ_y;
    self.frame = frame;
}
- (CGFloat)HJ_y {
    return self.frame.origin.y;
}

- (void)setHJ_width:(CGFloat)HJ_width {
    CGRect frame = self.frame;
    frame.size.width = HJ_width;
    self.frame = frame;
}
- (CGFloat)HJ_width {
    return self.frame.size.width;
}

- (void)setHJ_height:(CGFloat)HJ_height {
    CGRect frame = self.frame;
    frame.size.height = HJ_height;
    self.frame = frame;
}
- (CGFloat)HJ_height {
    return self.frame.size.height;
}

- (CGFloat)HJ_centerX {
    return self.center.x;
}
- (void)setHJ_centerX:(CGFloat)HJ_centerX {
    CGPoint center = self.center;
    center.x = HJ_centerX;
    self.center = center;
}

- (CGFloat)HJ_centerY {
    return self.center.y;
}
- (void)setHJ_centerY:(CGFloat)HJ_centerY {
    CGPoint center = self.center;
    center.y = HJ_centerY;
    self.center = center;
}

- (void)setHJ_origin:(CGPoint)HJ_origin {
    CGRect frame = self.frame;
    frame.origin = HJ_origin;
    self.frame = frame;
}
- (CGPoint)HJ_origin {
    return self.frame.origin;
}

- (void)setHJ_size:(CGSize)HJ_size {
    CGRect frame = self.frame;
    frame.size = HJ_size;
    self.frame = frame;
}
- (CGSize)HJ_size {
    return self.frame.size;
}

/// 从 XIB 中加载视图
+ (instancetype)HJ_loadViewFromXib {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
}


@end
