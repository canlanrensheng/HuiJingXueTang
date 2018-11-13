//
//  HJPageContentScrollView.h
//  HJPagingViewExample
//
//  Created by zhangjinshan on 2017/7/21.
//  Copyright © 2017年 zhangjinshan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HJPageContentScrollView;

@protocol HJPageContentScrollViewDelegate <NSObject>
@optional
/**
 *  联动 HJPageTitleView 的方法
 *
 *  @param pageContentScrollView      HJPageContentScrollView
 *  @param progress                   HJPageContentScrollView 内部视图滚动时的偏移量
 *  @param originalIndex              原始视图所在下标
 *  @param targetIndex                目标视图所在下标
 */
- (void)pageContentScrollView:(HJPageContentScrollView *)pageContentScrollView progress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex;
/**
 *  获取 HJPageContentScrollView 当前子控制器的下标值
 *
 *  @param pageContentScrollView     HJPageContentScrollView
 *  @param index                     HJPageContentScrollView 当前子控制器的下标值
 */
- (void)pageContentScrollView:(HJPageContentScrollView *)pageContentScrollView index:(NSInteger)index;
/** HJPageContentScrollView 内容开始拖拽方法 */
- (void)pageContentScrollViewWillBeginDragging;
/** HJPageContentScrollView 内容结束拖拽方法 */
- (void)pageContentScrollViewDidEndDecelerating;
@end

@interface HJPageContentScrollView : UIView
/**
 *  对象方法创建 HJPageContentScrollView
 *
 *  @param frame        frame
 *  @param parentVC     当前控制器
 *  @param childVCs     子控制器个数
 */
- (instancetype)initWithFrame:(CGRect)frame parentVC:(UIViewController *)parentVC childVCs:(NSArray *)childVCs;
/**
 *  类方法创建 HJPageContentScrollView
 *
 *  @param frame        frame
 *  @param parentVC     当前控制器
 *  @param childVCs     子控制器个数
 */
+ (instancetype)pageContentScrollViewWithFrame:(CGRect)frame parentVC:(UIViewController *)parentVC childVCs:(NSArray *)childVCs;

/** HJPageContentScrollViewDelegate */
@property (nonatomic, weak) id<HJPageContentScrollViewDelegate> delegatePageContentScrollView;
/** 是否需要滚动 HJPageContentScrollView 默认为 YES；设为 NO 时，不必设置 HJPageContentScrollView 的代理及代理方法 */
@property (nonatomic, assign) BOOL isScrollEnabled;
/** 点击标题触发动画切换滚动内容，默认为 NO */
@property (nonatomic, assign) BOOL isAnimated;

/** 给外界提供的方法，根据 HJPageTitleView 标题选中时的下标并显示相应的子控制器 */
- (void)setPageContentScrollViewCurrentIndex:(NSInteger)currentIndex;

@end
