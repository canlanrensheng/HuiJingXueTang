//
//  UIButton+HJPagingView.h
//  HJPagingViewExample
//
//  Created by zhangjinshan on 2018/5/27.
//  Copyright © 2018年 zhangjinshan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    /// 图片在左，文字在右
    HJImagePositionStyleDefault,
    /// 图片在右，文字在左
    HJImagePositionStyleRight,
    /// 图片在上，文字在下
    HJImagePositionStyleTop,
    /// 图片在下，文字在上
    HJImagePositionStyleBottom,
} HJImagePositionStyle;

@interface UIButton (HJPagingView)
/**
 *  设置图片与文字样式
 *
 *  @param imagePositionStyle     图片位置样式
 *  @param spacing                图片与文字之间的间距
 *  @param imagePositionBlock     在此 Block 中设置按钮的图片、文字以及 contentHorizontalAlignment 属性
 */
- (void)HJ_imagePositionStyle:(HJImagePositionStyle)imagePositionStyle spacing:(CGFloat)spacing imagePositionBlock:(void (^)(UIButton *button))imagePositionBlock;

@end
