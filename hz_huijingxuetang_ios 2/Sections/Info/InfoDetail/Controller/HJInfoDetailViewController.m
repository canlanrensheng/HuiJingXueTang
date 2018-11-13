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
@interface HJInfoDetailViewController ()<UIWebViewDelegate>


@property (nonatomic,strong) HJSchoolLiveInputView *bottomView;

@property (nonatomic,strong) UIActivityIndicatorView *activityV;
@property (nonatomic,strong) HJInfoDetailViewModel *viewModel;

@property (nonatomic,strong) UIView *headerView;
@property (nonatomic,strong) UILabel *infoTitleLabel;
@property (nonatomic,strong) UILabel *dateLabel;
@property (nonatomic,strong) UIImageView *liveImageV;
@property (nonatomic,assign) CGFloat webViewCellHeight;

@property (nonatomic,strong) UIWebView *webView;
@property (nonatomic,assign) NSInteger page;

@end

@implementation HJInfoDetailViewController

- (HJInfoDetailViewModel *)viewModel {
    if(!_viewModel){
        _viewModel = [[HJInfoDetailViewModel alloc] init];
    }
    return  _viewModel;
}

- (UIActivityIndicatorView *)activityV {
    if (!_activityV) {
        _activityV = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activityV.hidesWhenStopped = YES;
        [self.view addSubview:_activityV];
        
        [_activityV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(50, 50));
            make.center.mas_equalTo(self.view);
        }];
    }
    return _activityV;
}

- (void)viewDidLoad {
    self.tableViewStyle = UITableViewStyleGrouped;
    [super viewDidLoad];
}

- (void)createHeaderView {
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, kHeight(298))];
    _headerView.backgroundColor = white_color;
    
    UILabel *infoTitleLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"股市心经之平常心之心静",MediumFont(font(21)),HEXColor(@"#333333"));
        label.textAlignment = NSTextAlignmentLeft;
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    infoTitleLabel.frame = CGRectMake(kWidth(10), kHeight(23.0), Screen_Width - kWidth(20), kHeight(20));
    [_headerView addSubview:infoTitleLabel];
    self.infoTitleLabel = infoTitleLabel;
    
    //日期
    UILabel *dateLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"2018年8月28日|于和伟|阅读量 2208",MediumFont(font(11)),HEXColor(@"#999999"));
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



#pragma mark UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    CGRect rect = webView.frame;
    rect.size.height = webView.scrollView.contentSize.height;
    
    CGSize fittingSize = [webView sizeThatFits:CGSizeZero];
    self.webViewCellHeight = fittingSize.height;
    
    //    DLog(@"高度是:%f %f %f",[webView.scrollView contentSize].height,fittingSize.width,webView.scrollView.contentSize.height);
    
    
    [webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    [self.activityV stopAnimating];
    [self.tableView reloadData];
}

//webViewDidFinishLoad代理方法被调用时，页面并不一定完全展现完成，可能有图片还未加载出来，导致此时获取的高度是并不是最终高度，过会儿图片加载出来后，浏览器会重新排版，而我们在这之前给了一个错误高度，导致显示异常。
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if([keyPath isEqualToString:@"contentSize"]){
        //        CGSize fittingSize = [_webView sizeThatFits:CGSizeZero];
        //        self.webViewCellHeight = fittingSize.height;
        //        [self.tableView reloadData];
    }
}

- (void)hj_setNavagation {
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonItemWithTitle:nil image:V_IMAGE(@"分享-1") action:^(id sender) {
        [self.activityV stopAnimating];
        [HJShareTool shareWithTitle:@"慧鲸学堂" content:@"邀请好友" images:nil url:@"http://mp.huijingschool.com/#/share"];
    }];
}

- (void)hj_configSubViews{
    [self createHeaderView];
    //底部试图
    self.bottomView = [[HJSchoolLiveInputView alloc] init];
    [self.view addSubview:self.bottomView];
    @weakify(self);
    [self.bottomView.backSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        if([APPUserDataIofo AccessToken].length <= 0) {
            ShowMessage(@"您还未登录");
            [DCURLRouter pushURLString:@"route://loginVC" animated:YES];
            return;
        }
        NSString *infoId = self.params[@"infoId"];
        [self.viewModel addNewsCommentWithInfoId:infoId  content:x Success:^{
            self.viewModel.page = 1;
            [self.viewModel getInfoDetailCommondWithInfoid:infoId Success:^{
                [self.tableView reloadData];
            }];
        }];
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(kHeight(49.0));
    }];
    
    self.sectionFooterHeight = 0.001f;
    [self.tableView registerClass:[HJTeachBestDetailHotCommontCell class] forCellReuseIdentifier:NSStringFromClass([HJTeachBestDetailHotCommontCell class])];
    [self.tableView registerClassHeaderFooter:[HJTeachTestDetailSectionHeaderView class]];
    [self.tableView registerClassCell:[HJTeachBestDetailWebViewCell class]];
    [self.tableView registerClassCell:[HJTeachBestDetailNoCommentCell class]];
    
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, kHeight(49), 0));
    }];
}

- (void)hj_loadData {
    NSString *infoId = self.params[@"infoId"];
    //获取详情的数据
    [self.viewModel getInfoDetailWithInfoid:infoId Success:^{
        [self.activityV startAnimating];
        self.infoTitleLabel.text = self.viewModel.model.infomationtitle;
        NSDate *date = [NSDate dateWithString:self.viewModel.model.createtime formatString:@"yyyy-MM-dd HH:mm:ss"];
        self.dateLabel.text = [NSString stringWithFormat:@"%ld/%ld/%ld",date.year,date.month,date.day];
        self.dateLabel.text = [NSString stringWithFormat:@"%@ | %@ | 阅读量 %tu",date,self.viewModel.model.singname,self.viewModel.model.readcounts];
        [self.liveImageV sd_setImageWithURL:URL(self.viewModel.model.picurl) placeholderImage:V_IMAGE(@"占位图")];
    }];
    //获取评论列表的数据
    self.viewModel.tableView = self.tableView;
    self.viewModel.page = 1;
    [self.viewModel getInfoDetailCommondWithInfoid:infoId Success:^{
        [self.tableView reloadData];
    }];
}

- (void)hj_refreshData {
    @weakify(self);
    NSString *infoId = self.params[@"infoId"];
    self.tableView.mj_header = [MKRefreshHeader headerWithRefreshingBlock:^{
        @strongify(self);
        self.viewModel.page = 1;
        [self.viewModel getInfoDetailCommondWithInfoid:infoId Success:^{
            [self.tableView reloadData];
        }];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer resetNoMoreData];
        });
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        self.viewModel.page++;
        if(self.viewModel.currentpage < self.viewModel.totalpage){
            [self.viewModel getInfoDetailCommondWithInfoid:infoId Success:^{
                [self.tableView reloadData];
                [self.tableView.mj_footer endRefreshing];
            }];
        }else{
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            [self.tableView reloadData];
        }
    }];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0) {
        return self.webViewCellHeight;
    }
    if(self.viewModel.infoCommondArray.count <= 0){
        return kHeight(218);
    }
    HJTeachBestDetailCommentModel *model = self.viewModel.infoCommondArray[indexPath.row];
    return  model.cellHeight;;
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


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        HJTeachBestDetailWebViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HJTeachBestDetailWebViewCell class]) forIndexPath:indexPath];
        self.tableView.separatorColor = RGBCOLOR(225, 225, 225);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.webView.delegate = self;
        self.webView = cell.webView;
        [cell.webView loadHTMLString:self.viewModel.model.content baseURL:nil];
        return cell;
    }
    if(self.viewModel.infoCommondArray.count <= 0){
        HJTeachBestDetailNoCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HJTeachBestDetailNoCommentCell class]) forIndexPath:indexPath];
        self.tableView.separatorColor = clear_color;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    HJTeachBestDetailHotCommontCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HJTeachBestDetailHotCommontCell class]) forIndexPath:indexPath];
    self.tableView.separatorColor = RGBCOLOR(225, 225, 225);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
    return kHeight(62.0);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if(section == 0) {
        return nil;
    }
    HJTeachTestDetailSectionHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"HJTeachTestDetailSectionHeaderView"];
    return headerView;
}



@end

