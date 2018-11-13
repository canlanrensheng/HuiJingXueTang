//
//  HJTeachBestViewController.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/2.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJTeachBestViewController.h"
#import "HJBaseTeachBestListCell.h"
#import "HJTeachBestListModel.h"
#import "HJTeachBestViewModel.h"
#import "HJInfoCheckPwdAlertView.h"
@interface HJTeachBestViewController ()

@property (nonatomic,strong) HJTeachBestViewModel *viewModel;

@end

@implementation HJTeachBestViewController

- (HJTeachBestViewModel *)viewModel {
    if(!_viewModel){
        _viewModel = [[HJTeachBestViewModel alloc] init];
    }
    return  _viewModel;
}

- (void)hj_setNavagation {
    self.title = @"教参精华";
}

- (void)hj_configSubViews{
    //    self.tableView.scrollEnabled = NO;
    self.numberOfSections = 1;
    
    self.sectionFooterHeight = 0.001f;
    
    [self.tableView registerClass:[HJBaseTeachBestListCell class] forCellReuseIdentifier:NSStringFromClass([HJBaseTeachBestListCell class])];
    
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}


- (void)hj_loadData {
    self.tableView.mj_footer.hidden = YES;
    self.viewModel.tableView = self.tableView;
    self.viewModel.page = 1;
    [self.viewModel getListWithSuccess:^{
        [self.tableView reloadData];
    }];
}

- (void)hj_refreshData {
    @weakify(self);
    self.tableView.mj_header = [MKRefreshHeader headerWithRefreshingBlock:^{
        @strongify(self);
        self.viewModel.page = 1;
        [self.viewModel getListWithSuccess:^{
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
            [self.viewModel getListWithSuccess:^{
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
    return  kHeight(91.0);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.viewModel.infoListArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HJBaseTeachBestListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HJBaseTeachBestListCell class]) forIndexPath:indexPath];
    self.tableView.separatorColor = HEXColor(@"#EAEAEA");
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setViewModel:self.viewModel indexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HJInfoCheckPwdAlertView *alertView = [[HJInfoCheckPwdAlertView alloc] initWithBindBlock:^(BOOL success) {
        HJTeachBestListModel *model = self.viewModel.infoListArray[indexPath.row];
        if(model.articalid) {
            NSDictionary *para = @{@"infoId" : model.articalid
                                   };
            [DCURLRouter pushURLString:@"route://teachBestDetailVC" query:para animated:YES];
        }
    }];
    [alertView show];
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
    NSString *text = @"暂无相关文章";
    NSDictionary *attribute = @{NSFontAttributeName: MediumFont(font(15)), NSForegroundColorAttributeName: HEXColor(@"#999999")};
    return [[NSAttributedString alloc] initWithString:text attributes:attribute];
}


#pragma mark - 空白页显示按钮
- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
    NSString *text = @"重新加载";
    UIFont *font = [UIFont systemFontOfSize:16.0];
    UIColor *textColor = [UIColor whiteColor];
    
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    if (font) [attributes setObject:font forKey:NSFontAttributeName];
    if (textColor) [attributes setObject:textColor forKey:NSForegroundColorAttributeName];
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

#pragma mark - 设置按钮的背景颜色
- (UIImage *)buttonBackgroundImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    UIImage *image = [UIImage imageWithColor:red_color];
    UIEdgeInsets capInsets = UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0);
    UIEdgeInsets rectInsets = UIEdgeInsetsZero;
    
    return [[image resizableImageWithCapInsets:capInsets resizingMode:UIImageResizingModeStretch] imageWithAlignmentRectInsets:rectInsets];
}

#pragma mark - 空白数据集 按钮被点击时 触发该方法：
- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button {
    NSLog(@"按钮被点击");
}

@end


