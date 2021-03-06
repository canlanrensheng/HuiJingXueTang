//
//  UIView+category.h
//  AiTiTi
//
//  Created by Oma-002 on 2018/5/31.
//  Copyright © 2018年 云辉. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (category)

- (void)clipWithCornerRadius:(CGFloat)cornerRadius borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth;

#pragma mark - 设置部分圆角
/**
 *  设置部分圆角(绝对布局)
 *
 *  @param corners 需要设置为圆角的角 UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerAllCorners
 *  @param radii   需要设置的圆角大小 例如 CGSizeMake(20.0f, 20.0f)
 */
- (void)addRoundedCorners:(UIRectCorner)corners
                withRadii:(CGSize)radii;
/**
 *  设置部分圆角(相对布局)
 *
 *  @param corners 需要设置为圆角的角 UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerAllCorners
 *  @param radii   需要设置的圆角大小 例如 CGSizeMake(20.0f, 20.0f)
 *  @param rect    需要设置的圆角view的rect
 */
- (void)addRoundedCorners:(UIRectCorner)corners
                withRadii:(CGSize)radii
                 viewRect:(CGRect)rect;

/*设置顶部圆角*/
- (void)setCornerOnTop:(CGFloat )cornerRadius;

/*设置左边圆角*/
- (void)setCornerOnLeft:(CGFloat )cornerRadius;
/*设置右边圆角*/
- (void)setCornerOnRight:(CGFloat )cornerRadius ;


@end
