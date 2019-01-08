//
//  HJMessageViewController.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/8.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJMessageViewController.h"
#import "HJMessageListCell.h"
#import "HJMessageViewModel.h"
#import "HJMessageModel.h"
@interface HJMessageViewController ()

@property (nonatomic,strong) HJMessageViewModel *viewModel;

@end

@implementation HJMessageViewController

- (HJMessageViewModel *)viewModel {
    if (!_viewModel){
        _viewModel = [[HJMessageViewModel alloc] init];
    }
    return  _viewModel;
}

- (void)hj_setNavagation {
    self.title = @"消息通知";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
     __weak typeof(self)weakSelf = self;
    [self.viewModel getMessageWithSuccess:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
        });
    }];
}

- (void)hj_configSubViews {
    self.numberOfSections = 1;
    
    self.sectionFooterHeight = 0.001f;
    
    [self.tableView registerClass:[HJMessageListCell class] forCellReuseIdentifier:NSStringFromClass([HJMessageListCell class])];
    
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

- (void)hj_loadData {
    
}

- (void)hj_refreshData {
    __weak typeof(self)weakSelf = self;
    [self.viewModel getMessageWithSuccess:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
        });
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  kHeight(61.0);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.viewModel.messageArray.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HJMessageListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HJMessageListCell class]) forIndexPath:indexPath];
    self.tableView.separatorColor = RGBCOLOR(225, 225, 225);
    if (indexPath.row < self.viewModel.messageArray.count) {
        [cell setViewModel:self.viewModel indexPath:indexPath];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row < self.viewModel.messageArray.count) {
        kRepeatClickTime(1.0);
        HJMessageModel *model = self.viewModel.messageArray[indexPath.row];
        NSDictionary *para = @{@"type" : @(model.type)};
        [DCURLRouter  pushURLString:@"route://messageDetailVC"  query:para animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0001f;
}

#pragma mark 数据为空的占位视图
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"形状 1567"];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView{
    NSString *text = @"暂时没有新的消息";
    NSDictionary *attribute = @{NSFontAttributeName: MediumFont(font(15)), NSForegroundColorAttributeName: HEXColor(@"#999999")};
    return [[NSAttributedString alloc] initWithString:text attributes:attribute];
}



@end
