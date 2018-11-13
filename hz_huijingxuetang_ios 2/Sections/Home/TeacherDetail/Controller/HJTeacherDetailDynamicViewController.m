//
//  HJTeacherDetailDynamicViewController.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/5.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJTeacherDetailDynamicViewController.h"
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

@interface HJTeacherDetailDynamicViewController ()<ZFTableViewCellDelegate>

@property (nonatomic, strong) ZFPlayerController *player;
@property (nonatomic, strong) ZFPlayerControlView *controlView;
@property (nonatomic, strong) NSMutableArray *urls;

@property (nonatomic,strong) HJFindViewModel *viewModel;

@end

@implementation HJTeacherDetailDynamicViewController

- (void)hj_configSubViews{
    self.urls = @[URL(@"http://tb-video.bdstatic.com/tieba-smallvideo-transcode/3612804_e50cb68f52adb3c4c3f6135c0edcc7b0_3.mp4")];
    
    ZFAVPlayerManager *playerManager = [[ZFAVPlayerManager alloc] init];
    /// player的tag值必须在cell里设置
    self.player = [ZFPlayerController playerWithScrollView:self.tableView playerManager:playerManager containerViewTag:100];
    self.player.controlView = self.controlView;
    self.player.assetURLs = [NSMutableArray arrayWithObject:[NSURL URLWithString:@"http://tb-video.bdstatic.com/tieba-smallvideo-transcode/3612804_e50cb68f52adb3c4c3f6135c0edcc7b0_3.mp4"]];;
    self.player.shouldAutoPlay = NO;
    /// 1.0是完全消失的时候
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
    self.viewModel = [[HJFindViewModel alloc] init];
    self.viewModel.page = 1;
    [self.viewModel teacherDynamicRecommondListWithSuccess:^{
        [self.tableView reloadData];
    }];
}


- (void)hj_bindViewModel {
//    @weakify(self);
//    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"RefreshFindData" object:nil] subscribeNext:^(NSNotification *noty) {
//        @strongify(self);
//        NSDictionary *para = noty.userInfo;
//        if([[para objectForKey:@"index"] integerValue] == 0) {
//            self.viewModel.findSegmentType = 0;
//            [self hj_loadData];
//        }
//    }];
}


- (void)hj_refreshData {
    @weakify(self);
    self.tableView.mj_header = [MKRefreshHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self hj_loadData];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer resetNoMoreData];
        });
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        self.viewModel.page++;
        if(self.viewModel.currentpage < self.viewModel.totalpage){
            [self.viewModel teacherDynamicRecommondListWithSuccess:^{
                [self.tableView reloadData];
                [self.tableView.mj_footer endRefreshing];
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

/// play the video
- (void)playTheVideoAtIndexPath:(NSIndexPath *)indexPath scrollToTop:(BOOL)scrollToTop {
    //    [self.player playTheIndexPath:indexPath scrollToTop:NO];
    
    if(indexPath.row < self.viewModel.findArray.count) {
        HJFindRecommondModel *model = self.viewModel.findArray[indexPath.row];
        if(model.dynamicvideo.length > 0) {
            [self.player playTheIndexPath:indexPath assetURL:URL(model.dynamicvideo) scrollToTop:scrollToTop];
            //            [self.controlView showTitle:@""
            //                         coverURLString:@"https://upload-images.jianshu.io/upload_images/635942-14593722fe3f0695.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240"
            //                         fullScreenMode:ZFFullScreenModeLandscape];
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
        HJFindRecommondModel *model = self.viewModel.findArray [indexPath.row];
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
                return cell;
            }
                break;
            case FindTypePic: {
                HJFindRecommondPictureCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HJFindRecommondPictureCell class]) forIndexPath:indexPath];
                self.tableView.separatorColor = RGBCOLOR(225, 225, 225);
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                self.viewModel.findSegmentType = 0;
                [cell setViewModel:self.viewModel indexPath:indexPath];
                return cell;
            }
                break;
            case FindTypeLink: {
                HJFindRecommondLinkCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HJFindRecommondLinkCell class]) forIndexPath:indexPath];
                self.tableView.separatorColor = RGBCOLOR(225, 225, 225);
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                self.viewModel.findSegmentType = 0;
                [cell setViewModel:self.viewModel indexPath:indexPath];
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
                return cell;
            }
                break;
            case FindTypePicLink: {
                HJFindRecommondTextPicLinkCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HJFindRecommondTextPicLinkCell class]) forIndexPath:indexPath];
                self.tableView.separatorColor = RGBCOLOR(225, 225, 225);
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                self.viewModel.findSegmentType = 0;
                [cell setViewModel:self.viewModel indexPath:indexPath];
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
                return cell;
            }
                break;
            default: {
                HJFindRecommondTextCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HJFindRecommondTextCell class]) forIndexPath:indexPath];
                self.tableView.separatorColor = RGBCOLOR(225, 225, 225);
                self.viewModel.findSegmentType = 0;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
//- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView{
//    return - kHeight(40);
//}


- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"学习小组空白页"];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView{
    NSString *text = @"暂无数据";
    NSDictionary *attribute = @{NSFontAttributeName: MediumFont(font(15)), NSForegroundColorAttributeName: HEXColor(@"#999999")};
    return [[NSAttributedString alloc] initWithString:text attributes:attribute];
}


@end

