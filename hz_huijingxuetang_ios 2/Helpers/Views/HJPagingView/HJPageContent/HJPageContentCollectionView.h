//
//  HJPageContentCollectionView.h
//  HJPagingViewExample
//
//  Created by zhangjinshan on 16/10/6.
//  Copyright © 2016年 zhangjinshan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HJPageContentCollectionView;

@protocol HJPageContentCollectionViewDelegate <NSObject>
@optional
/**
 *  联动 HJPageTitleView 的方法
 *
 *  @param pageContentCollectionView      HJPageContentCollectionView
 *  @param progress             HJPageContentCollectionView 内部视图滚动时的偏移量
 *  @param originalIndex        原始视图所在下标
 *  @param targetIndex          目标视图所在下标
 */
- (void)pageContentCollectionView:(HJPageContentCollectionView *)pageContentCollectionView progress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex;
/**
 *  获取 HJPageContentCollectionView 当前子控制器的下标值
 *
 *  @param pageContentCollectionView     HJPageContentCollectionView
 *  @param index                         HJPageContentCollectionView 当前子控制器的下标值
 */
- (void)pageContentCollectionView:(HJPageContentCollectionView *)pageContentCollectionView index:(NSInteger)index;
/** HJPageContentCollectionView 内容开始拖拽方法 */
- (void)pageContentCollectionViewWillBeginDragging;
/** HJPageContentCollectionView 内容结束拖拽方法 */
- (void)pageContentCollectionViewDidEndDecelerating;
@end

@interface HJPageContentCollectionView : UIView
/**
 *  对象方法创建 HJPageContentCollectionView
 *
 *  @param frame        frame
 *  @param parentVC     当前控制器
 *  @param childVCs     子控制器个数
 */
- (instancetype)initWithFrame:(CGRect)frame parentVC:(UIViewController *)parentVC childVCs:(NSArray *)childVCs;
/**
 *  类方法创建 HJPageContentCollectionView
 *
 *  @param frame        frame
 *  @param parentVC     当前控制器
 *  @param childVCs     子控制器个数
 */
+ (instancetype)pageContentCollectionViewWithFrame:(CGRect)frame parentVC:(UIViewController *)parentVC childVCs:(NSArray *)childVCs;

/** HJPageContentCollectionViewDelegate */
@property (nonatomic, weak) id<HJPageContentCollectionViewDelegate> delegatePageContentCollectionView;
/** 是否需要滚动 HJPageContentCollectionView 默认为 YES；设为 NO 时，不必设置 HJPageContentCollectionView 的代理及代理方法 */
@property (nonatomic, assign) BOOL isScrollEnabled;
/** 点击标题触发动画切换滚动内容，默认为 NO */
@property (nonatomic, assign) BOOL isAnimated;

/** 给外界提供的方法，根据 HJPageTitleView 标题选中时的下标并显示相应的子控制器 */
- (void)setPageContentCollectionViewCurrentIndex:(NSInteger)currentIndex;

@end
