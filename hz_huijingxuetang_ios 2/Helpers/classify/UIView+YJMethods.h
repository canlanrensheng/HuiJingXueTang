//
//  UIView+YJMethods.h
//  HuiJingSchool
//
//  Created by Junier on 2018/1/21.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (YJMethods)
//改变UIView的frame的单个属性
- (void)changeFrameForX:(CGFloat)x;
- (void)changeFrameForY:(CGFloat)y;
- (void)changeFrameForWidth:(CGFloat)width;
- (void)changeFrameForHeight:(CGFloat)height;

@property(nonatomic, assign) CGFloat width;

@property(nonatomic, assign) CGFloat height;

@property(nonatomic, assign) CGFloat x;

@property(nonatomic, assign) CGFloat y;

@property(nonatomic, assign) CGFloat centerX;

@property(nonatomic, assign) CGFloat centerY;

@property(nonatomic, assign, readonly) CGFloat minX;

@property(nonatomic, assign, readonly) CGFloat minY;

@property(nonatomic, assign, readonly) CGFloat maxX;

@property(nonatomic, assign, readonly) CGFloat maxY;



//添加ItemView右边箭头
- (UIImageView *)addRightArrowForItemView;

//添加一个点击手势
- (void)addTapAction:(id)object tapSel:(SEL)tapSel;

@end
