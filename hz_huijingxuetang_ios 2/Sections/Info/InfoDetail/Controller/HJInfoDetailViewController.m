//
//  HJInfoDetailViewController.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/13.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJInfoDetailViewController.h"

#import "HJTeachBestDetailHotCommontCell.h"
#import "HJTeachBestDetailWebViewCell.h"
#import "HJTeachTestDetailSectionHeaderView.h"
#import "HJSchoolLiveInputView.h"
#import "HJInfoDetailViewModel.h"
#import "HJTeachBestDetailNoCommentCell.h"
#import "HJTeachBestDetailCommentModel.h"

#import <WebKit/WebKit.h>
@interface HJInfoDetailViewController ()<WKNavigationDelegate,WKUIDelegate,UIScrollViewDelegate>


@property (nonatomic,strong) HJSchoolLiveInputView *bottomView;

//@property (nonatomic,strong) UIActivityIndicatorView *activityV;
@property (nonatomic,strong) HJInfoDetailViewModel *viewModel;

@property (nonatomic,strong) UIView *headerView;
@property (nonatomic,strong) UILabel *infoTitleLabel;
@property (nonatomic,strong) UILabel *dateLabel;
@property (nonatomic,strong) UIImageView *liveImageV;
@property (nonatomic,assign) CGFloat webViewCellHeight;

@property (nonatomic,strong) WKWebView *webView;
@property (nonatomic,assign) NSInteger page;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, assign) CGFloat webViewHeight;

@end

@implementation HJInfoDetailViewController

- (HJInfoDetailViewModel *)viewModel {
    if(!_viewModel){
        _viewModel = [[HJInfoDetailViewModel alloc] init];
    }
    return  _viewModel;
}

- (void)viewDidLoad {
    self.tableViewStyle = UITableViewStyleGrouped;
    [super viewDidLoad];
}

- (void)createHeaderView {
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, kHeight(298))];
    _headerView.backgroundColor = white_color;
    
    UILabel *infoTitleLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@" ",MediumFont(font(21)),HEXColor(@"#333333"));
        label.textAlignment = NSTextAlignmentLeft;
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    infoTitleLabel.frame = CGRectMake(kWidth(10), kHeight(23.0), Screen_Width - kWidth(20), kHeight(20));
    [_headerView addSubview:infoTitleLabel];
    self.infoTitleLabel = infoTitleLabel;
    
    //日期
    UILabel *dateLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@" ",MediumFont(font(11)),HEXColor(@"#999999"));
        label.textAlignment = NSTextAlignmentLeft;
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    dateLabel.frame = CGRectMake(kWidth(10),CGRectGetMaxY(infoTitleLabel.frame) + kHeight(23.0), Screen_Width - kWidth(20), kHeight(20));
    [_headerView addSubview:dateLabel];
    self.dateLabel = dateLabel;
    
    //图片
    UIImageView *liveImageV = [[UIImageView alloc] init];
    liveImageV.image = V_IMAGE(@"占位图");
    liveImageV.frame = CGRectMake(kWidth(10),CGRectGetMaxY(dateLabel.frame) + kHeight(16.0), Screen_Width - kWidth(20), kHeight(200));
    [_headerView addSubview:liveImageV];
    [liveImageV clipWithCornerRadius:kHeight(5.0) borderColor:nil borderWidth:0];
    self.liveImageV = liveImageV;
    
    self.tableView.tableHeaderView = _headerView;
}

- (void)createWebview {
    WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
    WKUserContentController *wkUController = [[WKUserContentController alloc] init];
    wkWebConfig.userContentController = wkUController;
    // 自适应屏幕宽度js
    NSString *jSString = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
    NSString *imgJSString = @"var objs = document.getElementsByTagName('img');for(var i=0;i++){var img = objs[i];img.style.maxWidth = '100%';img.style.height='auto';}";
    WKUserScript *wkUserScript = [[WKUserScript alloc] initWithSource:jSString injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    WKUserScript *wkImgScript = [[WKUserScript alloc] initWithSource:imgJSString injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    // 添加js调用
    [wkUController addUserScript:wkUserScript];
    [wkUController addUserScript:wkImgScript];
    
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - kWidth(10.0) * 2, 1) configuration:wkWebConfig];
    self.webView.backgroundColor = [UIColor clearColor];
    self.webView.opaque = NO;
    self.webView.userInteractionEnabled = NO;
    self.webView.scrollView.bounces = NO;
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    [self.webView sizeToFit];
    
    //监听网页的contentSize的变化
    [self.webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - kWidth(10.0) * 2, 1)];
    self.scrollView.scrollEnabled = NO;
    [self.scrollView addSubview:self.webView];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentSize"]) {
        // 方法一
        UIScrollView *scrollView = (UIScrollView *)object;
        CGFloat height = scrollView.contentSize.height;
        if (self.webViewHeight != height) {
            self.webViewHeight = height;
            self.webView.frame = CGRectMake(0, 0, self.view.frame.size.width - kWidth(10.0) * 2, height);
            self.scrollView.frame = CGRectMake(0, 0, self.view.frame.size.width - kWidth(10.0) * 2, height);
            self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width - kWidth(10.0) * 2, height);
            [self.tableView reloadData];
            
            DLog(@"webview高度变化了：%lf",height);
        } else {
            [self.viewModel.loadingView stopLoadingView];
        }
        
        /*
         // 方法二
         [_webView evaluateJavaScript:@"document.body.offsetHeight" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
         CGFloat height = [result doubleValue] + 20;
         self.webViewHeight = height;
         self.webView.frame = CGRectMake(0, 0, self.view.frame.size.width, height);
         self.scrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, height);
         self.scrollView.contentSize =CGSizeMake(self.view.frame.size.width, height);
         [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:3 inSection:0], nil] withRowAnimation:UITableViewRowAnimationNone];
         }];
         */
    }
}

- (void)dealloc {
    [self.webView.scrollView removeObserver:self forKeyPath:@"contentSize"];
}

- (void)hj_setNavagation {
    __weak typeof(self)weakSelf = self;
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonItemWithTitle:nil image:V_IMAGE(@"分享-1") action:^(id sender) {
        NSString *courceName = weakSelf.viewModel.model.infomationtitle;
        NSString *coursedes = @"股市前沿资讯名家讲师一手分析。想要了解更多股市资讯下载慧鲸学堂APP更多独家资讯一网打尽！";
        id shareImg = weakSelf.viewModel.model.picurl;
        if(weakSelf.viewModel.model.picurl.length <= 0) {
            shareImg = V_IMAGE(@"shareImg");
        }
        NSString *shareUrl = [NSString stringWithFormat:@"%@informationDetails?id=%@",API_SHAREURL,weakSelf.params[@"infoId"]];
        if([APPUserDataIofo UserID].length > 0) {
            shareUrl = [NSString stringWithFormat:@"%@&userid=%@",shareUrl,[APPUserDataIofo UserID]];
        }
        [HJShareTool shareWithTitle:courceName content:coursedes images:@[shareImg] url:shareUrl];
    }];
}

- (void)hj_configSubViews{
    [self createHeaderView];
    [self createWebview];
    //底部试图
    self.bottomView = [[HJSchoolLiveInputView alloc] init];
    [self.view addSubview:self.bottomView];
    @weakify(self);
    [self.bottomView.backSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        if([APPUserDataIofo AccessToken].length <= 0) {
            //            ShowMessage(@"您还未登录");
            [DCURLRouter pushURLString:@"route://loginVC" animated:YES];
            return;
        }
        NSString *infoId = self.params[@"infoId"];
        __weak typeof(self)weakSelf = self;
        [weakSelf.viewModel addNewsCommentWithInfoId:infoId  content:x Success:^{
            weakSelf.viewModel.page = 1;
            [weakSelf.viewModel getInfoDetailCommondWithInfoid:infoId Success:^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    //                    [weakSelf.tableView reloadData];
                    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:1];
                    [weakSelf.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
                });
            }];
        }];
        weakSelf.bottomView.inputTextField.text = @"";
        [weakSelf.view endEditing:YES];
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-KHomeIndicatorHeight);
        make.height.mas_equalTo(kHeight(49.0));
    }];
    
    self.sectionFooterHeight = 0.001f;
    [self.tableView registerClass:[HJTeachBestDetailHotCommontCell class] forCellReuseIdentifier:NSStringFromClass([HJTeachBestDetailHotCommontCell class])];
    [self.tableView registerClassHeaderFooter:[HJTeachTestDetailSectionHeaderView class]];
    [self.tableView registerClassCell:[HJTeachBestDetailWebViewCell class]];
    [self.tableView registerClassCell:[HJTeachBestDetailNoCommentCell class]];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"WebViewCell"];
    
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, kHeight(49) + KHomeIndicatorHeight, 0));
    }];
    
    //适配iPhone X
    if(isFringeScreen) {
        UIView *bottomView = [[UIView alloc] init];
        bottomView.backgroundColor = white_color;
        [self.view addSubview:bottomView];
        [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.height.mas_equalTo(KHomeIndicatorHeight);
        }];
    }
}

- (void)hj_loadData {
    NSString *infoId = self.params[@"infoId"];
    //获取详情的数据
    [self.viewModel.loadingView startAnimating];
    __weak typeof(self)weakSelf = self;
    [self.viewModel getInfoDetailWithInfoid:infoId Success:^{
        if(weakSelf.viewModel.model) {
            weakSelf.infoTitleLabel.text = weakSelf.viewModel.model.infomationtitle;
            NSDate *date = [NSDate dateWithString:weakSelf.viewModel.model.createtime formatString:@"yyyy-MM-dd HH:mm:ss"];
            NSString *dateString = [NSString stringWithFormat:@"%ld-%@-%@ %@:%@",(long)(date.year),[NSString convertDateSingleData:date.month],[NSString convertDateSingleData:date.day],[NSString convertDateSingleData:date.hour],[NSString convertDateSingleData:date.minute]];
            weakSelf.dateLabel.text = [NSString stringWithFormat:@"%@ | %@ | 阅读量 %tu",dateString,weakSelf.viewModel.model.singname,weakSelf.viewModel.model.readcounts];
            [weakSelf.liveImageV sd_setImageWithURL:URL(weakSelf.viewModel.model.picurl) placeholderImage:V_IMAGE(@"占位图") options:SDWebImageRefreshCached];
            
            [weakSelf.webView loadHTMLString:weakSelf.viewModel.model.content baseURL:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
            });
        } else {
            [weakSelf.viewModel.loadingView stopLoadingView];
            ShowMessage(@"空的或者无效的资讯");
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [DCURLRouter popViewControllerAnimated:YES];
            });
        }
    }];
    
    //获取评论列表的数据
    self.viewModel.tableView = self.tableView;
    self.viewModel.page = 1;
    [self.viewModel getInfoDetailCommondWithInfoid:infoId Success:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
        });
    }];
}

//上拉加载和下拉刷新操作
- (void)hj_refreshData {
    //下拉刷新操作
    @weakify(self);
    NSString *infoId = self.params[@"infoId"];
    self.tableView.mj_header = [MKRefreshHeader headerWithRefreshingBlock:^{
        @strongify(self);
        self.viewModel.page = 1;
        [self.viewModel getInfoDetailCommondWithInfoid:infoId Success:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer resetNoMoreData];
        });
    }];
    
    //上拉加载操作
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        self.viewModel.page++;
        if(self.viewModel.currentpage < self.viewModel.totalpage){
            [self.viewModel getInfoDetailCommondWithInfoid:infoId Success:^{
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

#pragma UITableView delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0) {
        //        return self.webViewCellHeight + kHeight(10.0);
        return _webViewHeight + kWidth(10.0);
    }
    if(self.viewModel.infoCommondArray.count <= 0){
        return kHeight(218);
    }
    HJTeachBestDetailCommentModel *model = self.viewModel.infoCommondArray[indexPath.row];
    return  model.cellHeight + kHeight(10.0);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        return 1;
    }
    if(self.viewModel.infoCommondArray.count <= 0){
        return 1;
    }
    return self.viewModel.infoCommondArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        //        HJTeachBestDetailWebViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HJTeachBestDetailWebViewCell class]) forIndexPath:indexPath];
        //        self.tableView.separatorColor = RGBCOLOR(225, 225, 225);
        //        cell.webView.navigationDelegate = self;
        //        cell.webView.UIDelegate = self;
        //        self.webView = cell.webView;
        //        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //        if(self.viewModel.model.content) {
        //             [cell.webView loadHTMLString:self.viewModel.model.content baseURL:nil];
        //        }
        //        return cell;
        
        UITableViewCell *webCell = [tableView dequeueReusableCellWithIdentifier:@"WebViewCell" forIndexPath:indexPath];
        [webCell.contentView addSubview:self.scrollView];
        [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(webCell.contentView).offset(kWidth(10.0));
            make.right.equalTo(webCell.contentView).offset(-kWidth(10.0));
            make.top.equalTo(webCell.contentView).offset(kWidth(10.0));
            make.bottom.equalTo(webCell.contentView);
        }];
        return webCell;
    }
    if(self.viewModel.infoCommondArray.count <= 0){
        HJTeachBestDetailNoCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HJTeachBestDetailNoCommentCell class]) forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        self.tableView.separatorColor = clear_color;
        return cell;
    }
    HJTeachBestDetailHotCommontCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HJTeachBestDetailHotCommontCell class]) forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    self.tableView.separatorColor = RGBCOLOR(225, 225, 225);
    [cell setViewModel:self.viewModel indexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0) {
        return 0.0001f;
    }
    return kHeight(49.0);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if(section == 0) {
        return nil;
    }
    HJTeachTestDetailSectionHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"HJTeachTestDetailSectionHeaderView"];
    return headerView;
}

//- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{//这里修改导航栏的标题，动态改变
//    CGRect rect = webView.frame;
//    rect.size.height = webView.scrollView.contentSize.height;
//    DLog(@"正常获取到的数据的高度时:%lf",self.webViewCellHeight);
//    if (self.webViewCellHeight != webView.scrollView.contentSize.height || self.webViewCellHeight <= kHeight(44)) {
//        DLog(@"重新加载的操作");
//        self.webView.frame = CGRectMake(rect.origin.x, rect.origin.y, Screen_Width - kWidth(20.0), rect.size.height);
//        self.webViewCellHeight = rect.size.height;
////        [self.activityV stopAnimating];
//        [self.tableView reloadData];
//    } else {
//        DLog(@"网页数据加载完成的时候进行的操作");
//        [self.viewModel.loadingView stopLoadingView];
//    }
//}
//
//// 页面加载失败时调用
//- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation {
//    [self.viewModel.loadingView stopLoadingView];
//    ShowMessage(@"网页加载失败");
//    [self.tableView reloadData];
//}
//
//// 接收到服务器跳转请求之后再执行
//- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
//
//}

// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    WKNavigationResponsePolicy actionPolicy = WKNavigationResponsePolicyAllow;
    //这句是必须加上的，不然会异常
    decisionHandler(actionPolicy);
}

// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    WKNavigationActionPolicy actionPolicy = WKNavigationActionPolicyAllow;
    if (navigationAction.navigationType == WKNavigationTypeBackForward) {//判断是返回类型
        
    }
    //这句是必须加上的，不然会异常
    decisionHandler(actionPolicy);
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return nil;
    
}

@end

