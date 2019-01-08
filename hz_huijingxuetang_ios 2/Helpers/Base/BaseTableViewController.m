//
//  BaseTableViewController.m
//  ZhuanMCH
//
//  Created by txooo on 16/12/6.
//  Copyright © 2016年 张金山. All rights reserved.
//

#import "BaseTableViewController.h"

#import "YYFPSLabel.h"

@interface BaseTableViewController ()

@property (nonatomic, strong) YYFPSLabel *fpsLabel;

@end

@implementation BaseTableViewController

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero
                                                 style:self.tableViewStyle];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
        _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
        _tableView.backgroundColor = Background_Color;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
    }
    return _tableView;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)updateViewConstraints {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, KHomeIndicatorHeight, 0));
    }];
    [super updateViewConstraints];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = Background_Color;
    [self.view addSubview:self.tableView];
    [self hj_refreshData];
    
   
    [self.view updateConstraintsIfNeeded];
//#if DEBUG
//    self.fpsLabel = [[YYFPSLabel alloc] init];
//    [self.view addSubview:self.fpsLabel];
//    
//    self.fpsLabel.alpha  = 0;
//    self.fpsLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
//    
//    [self.fpsLabel sizeToFit];
//    
//    [self.fpsLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_offset(20);
//        make.bottom.equalTo(self.view.mas_bottom).offset(-kBottomBarHeight - 30);
//    }];
//#endif
}

- (void)hj_refreshData{
    
};

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDataSource&delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _numberOfSections ? : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _numberOfRows ? : _dataArray ? _dataArray.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"BaseCellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:cellId];
    }
    cell.textLabel.font = H15;
    cell.textLabel.textColor = Text_Color;
    if ([self respondsToSelector:@selector(configTableViewCell:cellForRowAtIndexPath:)]) {
        [self configTableViewCell:cell cellForRowAtIndexPath:indexPath];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return _tableViewRowHeight ? : kViewDefaultHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return _sectionHeaderHeight ? : 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return _sectionFooterHeight ? : 0.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = Background_Color;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = Background_Color;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_tableViewRowSelectBlock) {
        _tableViewRowSelectBlock(indexPath);
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (_fpsLabel.alpha == 0) {
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.fpsLabel.alpha = 1;
        } completion:NULL];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        if (_fpsLabel.alpha != 0) {
            [UIView animateWithDuration:1 delay:2 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                self.fpsLabel.alpha = 0;
            } completion:NULL];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (_fpsLabel.alpha != 0) {
        [UIView animateWithDuration:1 delay:2 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.fpsLabel.alpha = 0;
        } completion:NULL];
    }
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    if (_fpsLabel.alpha == 0) {
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.fpsLabel.alpha = 1;
        } completion:^(BOOL finished) {
        }];
    }
}

#pragma 空白页代理方法
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView{
    return YES;
}

//没有数据的代理方法
//- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
//    NSString *text = @"\U0000Ea30";
//    NSDictionary *attribute = @{NSFontAttributeName: [UIFont fontWithName:@"iconfontv2" size:70], NSForegroundColorAttributeName: MYColorFromHEX(0x999999)};
//    return [[NSAttributedString alloc] initWithString:text attributes:attribute];
//}

//暂无数据空白页

//- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView{
//    NSString *text = @"暂无数据";
//    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:font(16)], NSForegroundColorAttributeName: MYColorFromHEX(0x999999)};
//    return [[NSAttributedString alloc] initWithString:text attributes:attribute];
//}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
    return Background_Color;
}

- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView {
    return 24.0f;
}

//- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
//    NSString *buttonTitle = @"重新加载";
//    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:font(16)], NSForegroundColorAttributeName: NavigationBar_Color
//                                 ,NSBackgroundColorAttributeName:[UIColor clearColor]};
//    return [[NSAttributedString alloc] initWithString:buttonTitle attributes:attributes];
//}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView{
    NSString *text = @"";
    if([UserInfoSingleObject shareInstance].networkStatus == NotReachable) {
        text = @"网络好像出了点问题";
    } else{
        text = @"暂无相关数据";
    }
    
    NSDictionary *attribute = @{NSFontAttributeName: MediumFont(font(15)), NSForegroundColorAttributeName: HEXColor(@"#999999")};
    return [[NSAttributedString alloc] initWithString:text attributes:attribute];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    if([UserInfoSingleObject shareInstance].networkStatus == NotReachable) {
        return [UIImage imageNamed:@"网络问题空白页"];
    } else {
        return [UIImage imageNamed:@"暂无数据空白页"];
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
