//
//  HJFindRecommondViewController.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/10/30.
//  Copyright © 2018年 Junier. All rights reserved.
//

//
//  ZFNotAutoPlayViewController.m
//  ZFPlayer
//
//  Created by 任子丰 on 2018/4/1.
//  Copyright © 2018年 紫枫. All rights reserved.
//

#import "HJFindRecommondViewController.h"
#import "HJFindRecommondTextCell.h"
#import "HJFindRecommondPictureCell.h"
#import "HJFindRecommondLinkCell.h"
#import "HJFindRecommondVideoCell.h"
#import "HJFindRecommondTextPicLinkCell.h"
#import "HJFindRecommondTextVideoLinkCell.h"

#import <ZFPlayer/ZFPlayer.h>
#import <ZFPlayer/ZFAVPlayerManager.h>
#import <ZFPlayer/ZFPlayerControlView.h>

#import "HJFindViewModel.h"
#import "HJFindRecommondModel.h"

@interface HJFindRecommondViewController ()<ZFTableViewCellDelegate>

@property (nonatomic, strong) ZFPlayerController *player;
@property (nonatomic, strong) ZFPlayerControlView *controlView;
@property (nonatomic, strong) NSMutableArray *urls;

@property (nonatomic,strong) HJFindViewModel *viewModel;

@end

@implementation HJFindRecommondViewController

- (void)hj_configSubViews{
    ZFAVPlayerManager *playerManager = [[ZFAVPlayerManager alloc] init];
    self.player = [ZFPlayerController playerWithScrollView:self.tableView playerManager:playerManager containerViewTag:100];
    self.player.controlView = self.controlView;
//    self.player.assetURLs = [NSMutableArray arrayWithObject:[NSURL URLWithString:@"http://tb-video.bdstatic.com/tieba-smallvideo-transcode/3612804_e50cb68f52adb3c4c3f6135c0edcc7b0_3.mp4"]];
    self.player.shouldAutoPlay = NO;
    // 1.0是完全消失的时候
    self.player.playerDisapperaPercent = 1.0;

    __weak typeof(self)weakSelf = self;
    self.player.orientationWillChange = ^(ZFPlayerController * _Nonnull player, BOOL isFullScreen) {
        [weakSelf setNeedsStatusBarAppearanceUpdate];
        [UIViewController attemptRotationToDeviceOrientation];
        weakSelf.tableView.scrollsToTop = !isFullScreen;
    };

    self.player.playerDidToEnd = ^(id  _Nonnull asset) {
        if (weakSelf.player.playingIndexPath.row < weakSelf.urls.count - 1 && !weakSelf.player.isFullScreen) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.player.playingIndexPath.row + 1 inSection:0];
            [weakSelf playTheVideoAtIndexPath:indexPath scrollToTop:YES];
        } else if (weakSelf.player.isFullScreen) {
            [weakSelf.player stopCurrentPlayingCell];
        }
    };
    
    self.numberOfSections = 1;

    self.sectionFooterHeight = 0.001f;

    [self.tableView registerClassCell:[HJFindRecommondTextCell class]];
    [self.tableView registerClassCell:[HJFindRecommondPictureCell class]];
    [self.tableView registerClassCell:[HJFindRecommondLinkCell class]];
    [self.tableView registerClassCell:[HJFindRecommondVideoCell class]];
    
    //文字图片链接
    [self.tableView registerClassCell:[HJFindRecommondTextPicLinkCell class]];
    //文字视频链接
    [self.tableView registerClassCell:[HJFindRecommondTextVideoLinkCell class]];
    
    

    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

- (HJFindViewModel *)viewModel {
    if(!_viewModel) {
        _viewModel = [[HJFindViewModel alloc] init];
    }
    return  _viewModel;
}

- (void)hj_loadData {
    self.viewModel.findSegmentType = 0;
    self.tableView.mj_footer.hidden = YES;
    self.viewModel.tableView = self.tableView;
//    self.viewModel = [[HJFindViewModel alloc] init];
    self.viewModel.page = 1;
    [self.viewModel teacherDynamicRecommondListWithTeacherid:@"" Success:^(BOOL successFlag) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
}


- (void)hj_bindViewModel {
//    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"RefreFindCommondData" object:nil] subscribeNext:^(NSNotification *noty) {
//        [self hj_loadData];
//    }];
}


- (void)hj_refreshData {
    self.tableView.mj_header = [MKRefreshHeader headerWithRefreshingBlock:^{
        [self hj_loadData];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer resetNoMoreData];
        });
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.viewModel.page++;
        if(self.viewModel.currentpage < self.viewModel.totalpage){
            [self.viewModel teacherDynamicRecommondListWithTeacherid:@""  Success:^(BOOL successFlag){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                    [self.tableView.mj_footer endRefreshing];
                });
            }];
        }else{
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            [self.tableView reloadData];
        }
    }];
    
}

- (BOOL)shouldAutorotate {
    /// 如果只是支持iOS9+ 那直接return NO即可，这里为了适配iOS8
    return self.player.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if (self.player.isFullScreen && self.player.orientationObserver.fullScreenMode == ZFFullScreenModeLandscape) {
        return UIInterfaceOrientationMaskLandscape;
    }
    return UIInterfaceOrientationMaskPortrait;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    if (self.player.isFullScreen) {
        return UIStatusBarStyleLightContent;
    }
    return UIStatusBarStyleDefault;
}

- (BOOL)prefersStatusBarHidden {
    return self.player.isStatusBarHidden;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationSlide;
}

#pragma mark - UIScrollViewDelegate 列表播放必须实现

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [scrollView zf_scrollViewDidEndDecelerating];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [scrollView zf_scrollViewDidEndDraggingWillDecelerate:decelerate];
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    [scrollView zf_scrollViewDidScrollToTop];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [scrollView zf_scrollViewDidScroll];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [scrollView zf_scrollViewWillBeginDragging];
}

#pragma mark - ZFTableViewCellDelegate

- (void)zf_playTheVideoAtIndexPath:(NSIndexPath *)indexPath {
    [self playTheVideoAtIndexPath:indexPath scrollToTop:NO];
}

#pragma mark - private method
// play the video
- (void)playTheVideoAtIndexPath:(NSIndexPath *)indexPath scrollToTop:(BOOL)scrollToTop {
    if(indexPath.row < self.viewModel.findArray.count) {
        HJFindRecommondModel *model = self.viewModel.findArray[indexPath.row];
        if(model.dynamicvideo.length > 0) {
            [self.player playTheIndexPath:indexPath assetURL:URL(model.dynamicvideo) scrollToTop:scrollToTop];
        }
    }
}

#pragma mark - getter
- (ZFPlayerControlView *)controlView {
    if (!_controlView) {
        _controlView = [[ZFPlayerControlView alloc] init];
        _controlView.backgroundColor = clear_color;
    }
    return _controlView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row < self.viewModel.findArray.count) {
        HJFindRecommondModel *model = self.viewModel.findArray[indexPath.row];
        return model.cellHeight;
    }
    return 0.0001f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.viewModel.findArray.count;
}

//处理选中的数据
- (void)dealCareOrCancleCareDataWithSelect:(BOOL)isSelect indexPath:(NSIndexPath *)indexPath {
    HJFindRecommondModel *selectModel = self.viewModel.findArray[indexPath.row];
    if(isSelect == 1) {
        //选中的时候
        for (HJFindRecommondModel *model in self.viewModel.findArray) {
            if ([model.teacherid isEqualToString:selectModel.teacherid]) {
                model.isinterest = 1;
            }
        }
    } else {
        //取消选中的时候
        for (HJFindRecommondModel *model in self.viewModel.findArray) {
            if ([model.teacherid isEqualToString:selectModel.teacherid]) {
                model.isinterest = 0;
            }
        }
    }
    [self.tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.viewModel.findArray.count) {
        HJFindRecommondModel *model = self.viewModel.findArray[indexPath.row];
        switch (model.findType) {
            case FindTypeText: {
                HJFindRecommondTextCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HJFindRecommondTextCell class]) forIndexPath:indexPath];
                self.tableView.separatorColor = RGBCOLOR(225, 225, 225);
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                self.viewModel.findSegmentType = 0;
                [cell setViewModel:self.viewModel indexPath:indexPath];
                [cell.backRefreshSubject subscribeNext:^(NSNumber *select) {
                    [self dealCareOrCancleCareDataWithSelect:select.integerValue indexPath:indexPath];
                }];
                return cell;
            }
                break;
            case FindTypePic: {
                HJFindRecommondPictureCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HJFindRecommondPictureCell class]) forIndexPath:indexPath];
                self.tableView.separatorColor = RGBCOLOR(225, 225, 225);
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                self.viewModel.findSegmentType = 0;
                [cell setViewModel:self.viewModel indexPath:indexPath];
                [cell.backRefreshSubject subscribeNext:^(NSNumber *select) {
                    [self dealCareOrCancleCareDataWithSelect:select.integerValue indexPath:indexPath];
                }];
                return cell;
            }
              break;
            case FindTypeLink: {
                HJFindRecommondLinkCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HJFindRecommondLinkCell class]) forIndexPath:indexPath];
                self.tableView.separatorColor = RGBCOLOR(225, 225, 225);
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                self.viewModel.findSegmentType = 0;
                [cell setViewModel:self.viewModel indexPath:indexPath];
                [cell.backRefreshSubject subscribeNext:^(NSNumber *select) {
                    [self dealCareOrCancleCareDataWithSelect:select.integerValue indexPath:indexPath];
                }];
                return cell;
            }
                break;
            case FindTypeVideo: {
                HJFindRecommondVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HJFindRecommondVideoCell class]) forIndexPath:indexPath];
                [cell setDelegate:self withIndexPath:indexPath];
                self.tableView.separatorColor = RGBCOLOR(225, 225, 225);
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                self.viewModel.findSegmentType = 0;
                [cell setViewModel:self.viewModel indexPath:indexPath];
                [cell.backRefreshSubject subscribeNext:^(NSNumber *select) {
                    [self dealCareOrCancleCareDataWithSelect:select.integerValue indexPath:indexPath];
                }];
                return cell;
            }
                break;
            case FindTypePicLink: {
                HJFindRecommondTextPicLinkCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HJFindRecommondTextPicLinkCell class]) forIndexPath:indexPath];
                self.tableView.separatorColor = RGBCOLOR(225, 225, 225);
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                self.viewModel.findSegmentType = 0;
                [cell setViewModel:self.viewModel indexPath:indexPath];
                [cell.backRefreshSubject subscribeNext:^(NSNumber *select) {
                    [self dealCareOrCancleCareDataWithSelect:select.integerValue indexPath:indexPath];
                }];
                return cell;
            }
                break;
            case FindTypeVideoLink: {
                HJFindRecommondTextVideoLinkCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HJFindRecommondTextVideoLinkCell class]) forIndexPath:indexPath];
                [cell setDelegate:self withIndexPath:indexPath];
                self.tableView.separatorColor = RGBCOLOR(225, 225, 225);
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                self.viewModel.findSegmentType = 0;
                [cell setViewModel:self.viewModel indexPath:indexPath];
                [cell.backRefreshSubject subscribeNext:^(NSNumber *select) {
                    [self dealCareOrCancleCareDataWithSelect:select.integerValue indexPath:indexPath];
                }];
                return cell;
            }
                break;
            default: {
                HJFindRecommondTextCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HJFindRecommondTextCell class]) forIndexPath:indexPath];
                self.tableView.separatorColor = RGBCOLOR(225, 225, 225);
                self.viewModel.findSegmentType = 0;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell.backRefreshSubject subscribeNext:^(NSNumber *select) {
                    [self dealCareOrCancleCareDataWithSelect:select.integerValue indexPath:indexPath];
                }];
                cell.hidden = YES;
                return cell;
            }
                break;
        }
    }
    
    HJFindRecommondTextCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HJFindRecommondTextCell class]) forIndexPath:indexPath];
    self.tableView.separatorColor = RGBCOLOR(225, 225, 225);
    self.viewModel.findSegmentType = 0;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.hidden = YES;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    /// 如果正在播放的index和当前点击的index不同，则停止当前播放的index
    kRepeatClickTime(1.0);
    if (self.player.playingIndexPath != indexPath) {
        [self.player stopCurrentPlayingCell];
    }
    /// 如果没有播放，则点击进详情页会自动播放
    if (!self.player.currentPlayerManager.isPlaying) {
        [self playTheVideoAtIndexPath:indexPath scrollToTop:NO];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0001f;
}

#pragma mark 数据为空的占位视图
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView{
    return - kHeight(40);
}


- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView{
    NSString *text = @"";
    if([UserInfoSingleObject shareInstance].networkStatus == NotReachable) {
        text = @"网络好像出了点问题";
    } else{
        text = @"暂无数据";
    }
    
    NSDictionary *attribute = @{NSFontAttributeName: MediumFont(font(15)), NSForegroundColorAttributeName: HEXColor(@"#999999")};
    return [[NSAttributedString alloc] initWithString:text attributes:attribute];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    if([UserInfoSingleObject shareInstance].networkStatus == NotReachable) {
        return [UIImage imageNamed:@"网络问题空白页"];
    } else {
        return [UIImage imageNamed:@"学习小组空白页"];
    }
}


- (UIImage *)buttonImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    if([UserInfoSingleObject shareInstance].networkStatus == NotReachable) {
        return  [UIImage imageNamed:@"点击刷新"];
    } else {
        return nil;
    }
}

#pragma mark - 空白数据集 按钮被点击时 触发该方法：
- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button {
    if([UserInfoSingleObject shareInstance].networkStatus == NotReachable) {
        [self hj_loadData];
    } else {
       
    }
}


@end
