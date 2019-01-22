//
//  HJSearchResultViewController.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/10/26.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJSearchResultViewController.h"
#import "HJSearchResultListCell.h"
#import "HJSearchResultNoDataCell.h"
#import "HJSearchResultCourceCell.h"
#import "HJSearchResultTeacherCell.h"
#import "HJSearchResultLiveCell.h"
#import "HJSearchResultInfomationCell.h"
#import "HJSearchResultViewModel.h"
#define MAXCOUNT 6
@interface HJSearchResultViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UIView *searchView;
    NSString *searchKey;
}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UITableView *searchResultTableView;
@property (nonatomic,strong) UITextField *searchText;
@property (nonatomic,strong) NSArray *historyArray;
@property (nonatomic,strong) NSMutableArray *searchResultArray;

@property (nonatomic,strong) HJSearchResultViewModel *viewModel;

@end

@implementation HJSearchResultViewController

- (HJSearchResultViewModel *)viewModel {
    if(!_viewModel){
        _viewModel = [[HJSearchResultViewModel alloc] init];
    }
    return _viewModel;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.viewModel.searchResultType = [self.params[@"type"] integerValue];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_searchText resignFirstResponder];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

//搜索的方法
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    //搜索方法
    if (textField.text.length > 0) {
        [self cacheSearchText:textField.text];
        NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
        //读取数组NSArray类型的数据
        self.historyArray = [userDefaultes arrayForKey:[NSString stringWithFormat:@"searchHistory%@%@",[self getSearchType],[APPUserDataIofo UserID]]];
        
        self.tableView.hidden = YES;
        self.searchResultTableView.hidden = NO;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self.viewModel getSearchResultListDataWithSearchParam:textField.text success:^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.searchResultTableView reloadData];
                });
            }];
        });
       
    }else{
        [MBProgressHUD showMessage:@"请输入搜索内容" view:self.view];
    }
    return YES;
}

- (void)valueChanged:(UITextField *)textField{
    //搜索内容改变的时候动态地请求数据源
    if(textField.text.length > 0) {
        self.tableView.hidden = YES;
        self.searchResultTableView.hidden = NO;
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        [self performSelector:@selector(loadData) withObject:nil afterDelay:1.0f];
    } else {
        self.tableView.hidden = NO;
        self.searchResultTableView.hidden = YES;
        [self.tableView reloadData];
    }
}

- (void)loadData {
    [self.viewModel getSearchResultListDataWithSearchParam:_searchText.text success:^{
        [self.searchResultTableView reloadData];
    }];
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavigationBarHeight, Screen_Width, Screen_Height - kNavigationBarHeight) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = Background_Color;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.userInteractionEnabled = YES;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClassCell:[HJSearchResultListCell class]];
    }
    return _tableView;
}

- (UITableView *)searchResultTableView{
    if (!_searchResultTableView) {
        _searchResultTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavigationBarHeight, Screen_Width, Screen_Height - kNavigationBarHeight) style:UITableViewStyleGrouped];
        _searchResultTableView.backgroundColor = Background_Color;
        _searchResultTableView.delegate = self;
        _searchResultTableView.dataSource = self;
        _searchResultTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _searchResultTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_searchResultTableView registerClassCell:[HJSearchResultCourceCell class]];
        [_searchResultTableView registerClassCell:[HJSearchResultTeacherCell class]];
        [_searchResultTableView registerClassCell:[HJSearchResultLiveCell class]];
        [_searchResultTableView registerClassCell:[HJSearchResultInfomationCell class]];
        [_searchResultTableView registerClassCell:[HJSearchResultNoDataCell class]];
    }
    return _searchResultTableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(self.viewModel.isEmptyData) {
        return 1;
    }
    if(self.searchText.text.length > 0) {
        if(self.viewModel.searchResultType == SearchResultTypeAll) {
            return 4;
        } else if (self.viewModel.searchResultType == SearchResultTypeCourse) {
            return 2;
        } else {
            return 2;
        }
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.viewModel.isEmptyData) {
        return 1;
    }
    if(self.searchText.text.length > 0) {
        
        if(self.viewModel.searchResultType == SearchResultTypeAll) {
            //首页
            if(section == 0) {
                return self.viewModel.model.courseResponses.count;
            } else if (section == 1) {
                return self.viewModel.model.teacherResponses.count;
            } else if (section == 2) {
                return self.viewModel.model.courseLiveResponses.count;
            } else {
                return self.viewModel.model.informationResponses.count;
            }
        } else if (self.viewModel.searchResultType == SearchResultTypeCourse) {
            //课程
            if(section == 0) {
                return self.viewModel.model.courseResponses.count;
            } else {
                return self.viewModel.model.teacherResponses.count;
            }
        } else {
            //直播
            if(section == 0) {
                return self.viewModel.model.courseLiveResponses.count;
            } else {
                return self.viewModel.model.teacherResponses.count;
            }
        }
    }
    return self.historyArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.viewModel.isEmptyData) {
        HJSearchResultNoDataCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HJSearchResultNoDataCell class])];
        if(!cell){
            cell = [[HJSearchResultNoDataCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([HJSearchResultNoDataCell class])];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        self.tableView.separatorColor = RGBCOLOR(225, 225, 225);
        return cell;
    }
    if(self.searchText.text.length > 0) {
        if(self.viewModel.searchResultType == SearchResultTypeAll) {
            if(indexPath.section == 0) {
                HJSearchResultCourceCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HJSearchResultCourceCell class]) forIndexPath:indexPath];
                self.searchResultTableView.separatorColor = HEXColor(@"#EAEAEA");
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                if(self.viewModel.model.courseResponses.count  > 0){
                    if (indexPath.row < self.viewModel.model.courseResponses.count){
                        CourseResponses *model = self.viewModel.model.courseResponses[indexPath.row];
                        cell.model = model;
                    }
                    cell.hidden = NO;
                } else {
                    cell.hidden = YES;
                }
                return cell;
            } else if (indexPath.section == 1) {
                HJSearchResultTeacherCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HJSearchResultTeacherCell class]) forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                self.searchResultTableView.separatorColor = HEXColor(@"#EAEAEA");
                if(self.viewModel.model.teacherResponses.count  > 0){
                    if (indexPath.row < self.viewModel.model.teacherResponses.count){
                        TeacherResponses *model = self.viewModel.model.teacherResponses[indexPath.row];
                        cell.model = model;
                    }
                    cell.hidden = NO;
                } else {
                    cell.hidden = YES;
                }
                return cell;
            } else if (indexPath.section == 2) {
                HJSearchResultLiveCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HJSearchResultLiveCell class]) forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                self.searchResultTableView.separatorColor = HEXColor(@"#EAEAEA");
                if(self.viewModel.model.courseLiveResponses.count  > 0){
                    if (indexPath.row < self.viewModel.model.courseLiveResponses.count){
                        CourseLiveModel *model = self.viewModel.model.courseLiveResponses[indexPath.row];
                        cell.model = model;
                    }
                    cell.hidden = NO;
                } else {
                    cell.hidden = YES;
                }
                return cell;
            } else {
                HJSearchResultInfomationCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HJSearchResultInfomationCell class]) forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                self.searchResultTableView.separatorColor = HEXColor(@"#EAEAEA");
                if(self.viewModel.model.informationResponses.count  > 0){
                    if (indexPath.row < self.viewModel.model.informationResponses.count){
                        InformationResponses *model = self.viewModel.model.informationResponses[indexPath.row];
                        cell.model = model;
                    }
                    cell.hidden = NO;
                } else {
                    cell.hidden = YES;
                }
                return cell;
            }
        } else if (self.viewModel.searchResultType == SearchResultTypeCourse) {
            //课程
            if(indexPath.section == 0) {
                HJSearchResultCourceCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HJSearchResultCourceCell class]) forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                self.searchResultTableView.separatorColor = HEXColor(@"#EAEAEA");
                if(self.viewModel.model.courseResponses.count  > 0){
                    if (indexPath.row < self.viewModel.model.courseResponses.count){
                        CourseResponses *model = self.viewModel.model.courseResponses[indexPath.row];
                        cell.model = model;
                    }
                    cell.hidden = NO;
                } else {
                    cell.hidden = YES;
                }
                return cell;
            } else {
                HJSearchResultTeacherCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HJSearchResultTeacherCell class]) forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                self.searchResultTableView.separatorColor = HEXColor(@"#EAEAEA");
                if(self.viewModel.model.teacherResponses.count  > 0){
                    if (indexPath.row < self.viewModel.model.teacherResponses.count){
                        TeacherResponses *model = self.viewModel.model.teacherResponses[indexPath.row];
                        cell.model = model;
                    }
                    cell.hidden = NO;
                } else {
                    cell.hidden = YES;
                }
                return cell;
            }
        } else {
            //直播
            if(indexPath.section == 0) {
                HJSearchResultLiveCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HJSearchResultLiveCell class]) forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                self.searchResultTableView.separatorColor = HEXColor(@"#EAEAEA");
                if(self.viewModel.model.courseLiveResponses.count  > 0){
                    if (indexPath.row < self.viewModel.model.courseLiveResponses.count){
                        CourseLiveModel *model = self.viewModel.model.courseLiveResponses[indexPath.row];
                        cell.model = model;
                    }
                    cell.hidden = NO;
                } else {
                    cell.hidden = YES;
                }
                return cell;
            } else {
                HJSearchResultTeacherCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HJSearchResultTeacherCell class]) forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                self.searchResultTableView.separatorColor = HEXColor(@"#EAEAEA");
                if(self.viewModel.model.teacherResponses.count  > 0){
                    if (indexPath.row < self.viewModel.model.teacherResponses.count){
                        TeacherResponses *model = self.viewModel.model.teacherResponses[indexPath.row];
                        cell.model = model;
                    }
                    cell.hidden = NO;
                } else {
                    cell.hidden = YES;
                }
                return cell;
            }
        }
        
    }
    //没有搜索的时候展示
    HJSearchResultListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HJSearchResultListCell class])];
    if(!cell){
        cell = [[HJSearchResultListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([HJSearchResultListCell class])];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    self.tableView.separatorColor = RGBCOLOR(225, 225, 225);
    NSArray* reversedArray = [[self.historyArray reverseObjectEnumerator] allObjects];
    cell.searchResultLabel.text = reversedArray[indexPath.row];
    cell.userInteractionEnabled = YES;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.viewModel.isEmptyData) {
        return kHeight(40.0);
    }
    if(self.searchText.text.length > 0){
        if(self.viewModel.searchResultType == SearchResultTypeAll) {
            if(indexPath.section == 0) {
                if(self.viewModel.model.courseResponses.count  > 0) {
                    return kHeight(111.0);
                }
                return 0.0001f;
            } else if (indexPath.section == 1) {
                if(self.viewModel.model.teacherResponses.count  > 0) {
                    return kHeight(90.0);
                }
                return 0.0001f;
            } else if (indexPath.section == 2) {
                if(self.viewModel.model.courseLiveResponses.count  > 0) {
                    return kHeight(110.0);
                }
                return 0.0001f;
            } else {
                if(self.viewModel.model.informationResponses.count  > 0) {
                    return kHeight(125.0);
                }
                return 0.0001f;
            }
        } else if (self.viewModel.searchResultType == SearchResultTypeCourse){
            //课程
            if(indexPath.section == 0) {
                if(self.viewModel.model.courseResponses.count  > 0) {
                    return kHeight(111.0);
                }
                return 0.0001f;
            } else  {
                if(self.viewModel.model.teacherResponses.count  > 0) {
                    return kHeight(90.0);
                }
                return 0.0001f;
            }
        } else {
            //直播
            if(indexPath.section == 0) {
                if(self.viewModel.model.courseLiveResponses.count  > 0) {
                    return kHeight(110.0);
                }
                return 0.0001f;
            } else  {
                if(self.viewModel.model.teacherResponses.count  > 0) {
                    return kHeight(111.0);
                }
                return 0.0001f;
            }
        }
    }
    return kHeight(40.0);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(self.viewModel.isEmptyData) {
        return 0.0001f;
    }
    if(self.searchText.text.length > 0) {
        
        if(self.viewModel.searchResultType == SearchResultTypeAll) {
            if(section == 0) {
                if(self.viewModel.model.courseResponses.count  > 0) {
                    return kHeight(40.0);
                }
                return 0.0001f;
            } else if (section == 1) {
                if(self.viewModel.model.teacherResponses.count  > 0) {
                    return kHeight(40.0);
                }
                return 0.0001f;
            } else if (section == 2) {
                if(self.viewModel.model.courseLiveResponses.count  > 0) {
                    return kHeight(40.0);
                }
                return 0.0001f;
            } else {
                if(self.viewModel.model.informationResponses.count  > 0) {
                    return kHeight(40.0);
                }
                return 0.0001f;
            }
        } else if (self.viewModel.searchResultType == SearchResultTypeCourse){
            //课程
            if(section == 0) {
                if(self.viewModel.model.courseResponses.count  > 0) {
                    return kHeight(40.0);
                }
                return 0.0001f;
            } else {
                if(self.viewModel.model.teacherResponses.count  > 0) {
                    return kHeight(40.0);
                }
                return 0.0001f;
            }
        } else {
            //直播
            if(section == 0) {
                if(self.viewModel.model.courseLiveResponses.count  > 0) {
                    return kHeight(40.0);
                }
                return 0.0001f;
            } else {
                if(self.viewModel.model.teacherResponses.count  > 0) {
                    return kHeight(40.0);
                }
                return 0.0001f;
            }
        }
    }
    return kHeight(40.0);
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if(self.viewModel.isEmptyData) {
        return 0.00001f;
    }
    if(self.searchText.text.length > 0){
        
        return 0.0001f;
    }
    if (self.historyArray.count > 0){
        return kHeight(40.0);
    }
    return 0.0001f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if(self.viewModel.isEmptyData) {
        return nil;
    }
    if(self.searchText.text.length > 0) {
        return nil;
    }
    if (self.historyArray.count > 0) {
        UIView *sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, kHeight(40))];
        sectionView.backgroundColor = white_color;
        UIButton *deleateBtn = [UIButton creatButton:^(UIButton *button) {
            button.ljTitle_font_titleColor_state(@"清除搜索记录",MediumFont(font(13)),HEXColor(@"#22476B"),0);
            @weakify(self);
            [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                @strongify(self);
                [TXAlertView showAlertWithTitle:@"确认要删除吗?" message:@"" cancelButtonTitle:@"取消" style:TXAlertViewStyleAlert buttonIndexBlock:^(NSInteger buttonIndex) {
                    if(buttonIndex == 1) {
                        [self deleteAction];
                    }
                } otherButtonTitles:@"确定", nil];
            }];
        }];
        [sectionView addSubview:deleateBtn];
        [deleateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(sectionView);
            make.top.bottom.equalTo(sectionView);
            make.width.equalTo(sectionView);
        }];
        return sectionView;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if(self.viewModel.isEmptyData) {
        return nil;
    }
    UIView *sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, kHeight(40))];
    sectionView.backgroundColor = HEXColor(@"#F8FCFF");
     if(self.searchText.text.length > 0) {
         
         UIView *lineView = [[UIView alloc] init];
         lineView.backgroundColor = HEXColor(@"#22476B");
         [sectionView addSubview:lineView];
         [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
             make.left.equalTo(sectionView).offset(kWidth(10.0));
             make.size.mas_equalTo(CGSizeMake(kWidth(2.0), kHeight(14)));
             make.centerY.equalTo(sectionView);
         }];
         
         UILabel *timeKillLabel = [UILabel creatLabel:^(UILabel *label) {
             label.ljTitle_font_textColor(@"",BoldFont(font(15)),HEXColor(@"#333333"));
             label.numberOfLines = 0;
             [label sizeToFit];
         }];
         [sectionView addSubview:timeKillLabel];
         [timeKillLabel mas_makeConstraints:^(MASConstraintMaker *make) {
             make.centerY.equalTo(lineView);
             make.left.equalTo(lineView.mas_right).offset(kWidth(5.0));
         }];
         
         UIButton *moreBtn = [UIButton creatButton:^(UIButton *button) {
             button.ljTitle_font_titleColor_state(@"更多",MediumFont(font(13)),HEXColor(@"#22476B"),0);
             @weakify(self);
             [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                 @strongify(self);
                 if(self.viewModel.searchResultType == SearchResultTypeAll) {
                     if(section == 0) {
                         NSDictionary *para = @{@"searchParam" : self.viewModel.searchParam.length > 0 ? self.viewModel.searchParam : @""};
                         [DCURLRouter pushURLString:@"route://searchMoreCourseVC" query:para animated:YES];
                     } else if (section == 1) {
                         NSDictionary *para = @{@"searchParam" : self.viewModel.searchParam.length > 0 ? self.viewModel.searchParam : @""};
                         [DCURLRouter pushURLString:@"route://searchMoreTeacherVC" query:para animated:YES];
                     } else if (section == 2) {
                         //直播
                         NSDictionary *para = @{@"searchParam" : self.viewModel.searchParam.length > 0 ? self.viewModel.searchParam : @""};
                         [DCURLRouter pushURLString:@"route://searchResultMoreLiveVC" query:para animated:YES];
                     } else {
                         NSDictionary *para = @{@"searchParam" : self.viewModel.searchParam.length > 0 ? self.viewModel.searchParam : @""};
                         [DCURLRouter pushURLString:@"route://searchMoreInfoVC" query:para animated:YES];
                     }
                 } else if (self.viewModel.searchResultType == SearchResultTypeCourse){
                     //课程
                     if(section == 0) {
                         NSDictionary *para = @{@"searchParam" : self.viewModel.searchParam.length > 0 ? self.viewModel.searchParam : @""};
                         [DCURLRouter pushURLString:@"route://searchMoreCourseVC" query:para animated:YES];

                     } else {
                         NSDictionary *para = @{@"searchParam" : self.viewModel.searchParam.length > 0 ? self.viewModel.searchParam : @""};
                         [DCURLRouter pushURLString:@"route://searchMoreTeacherVC" query:para animated:YES];
                     }
                 } else {
                     //直播
                     if(section == 0) {
                         //更多直播页面
                         NSDictionary *para = @{@"searchParam" : self.viewModel.searchParam.length > 0 ? self.viewModel.searchParam : @""};
                         [DCURLRouter pushURLString:@"route://searchResultMoreLiveVC" query:para animated:YES];
                     } else {
                        // 更多老师页面
                         NSDictionary *para = @{@"searchParam" : self.viewModel.searchParam.length > 0 ? self.viewModel.searchParam : @""};
                         [DCURLRouter pushURLString:@"route://searchMoreTeacherVC" query:para animated:YES];
                     }
                 }
             }];
         }];
         [sectionView addSubview:moreBtn];
         [moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
             make.centerY.equalTo(sectionView);
             make.right.equalTo(sectionView).offset(-kWidth(10.0));
             make.height.mas_equalTo(kHeight(12));
         }];
         
         if(self.viewModel.searchResultType == SearchResultTypeAll) {
             if(section == 0) {
                 timeKillLabel.text = @"课程";
             } else if (section == 1) {
                 timeKillLabel.text = @"老师";
             } else if (section == 2) {
                 timeKillLabel.text = @"直播";
             } else {
                 timeKillLabel.text = @"资讯";
             }
             //首页
             if(section == 0) {
                 if(self.viewModel.model.courseResponses.count  > 0) {
                     sectionView.hidden = NO;
                     if(self.viewModel.model.courseMore == 1) {
                         moreBtn.hidden = NO;
                     } else {
                         moreBtn.hidden = YES;
                     }
                 } else {
                     sectionView.hidden = YES;
                 }
             } else if (section == 1) {
                 if(self.viewModel.model.teacherResponses.count  > 0) {
                     sectionView.hidden = NO;
                     if(self.viewModel.model.teacherMore == 1) {
                         moreBtn.hidden = NO;
                     } else {
                         moreBtn.hidden = YES;
                     }
                 } else {
                     sectionView.hidden = YES;
                 }
             } else if (section == 2) {
                 if(self.viewModel.model.courseLiveResponses.count  > 0) {
                     sectionView.hidden = NO;
                     if(self.viewModel.model.courseLiveMore == 1) {
                         moreBtn.hidden = NO;
                     } else {
                         moreBtn.hidden = YES;
                     }
                 } else {
                     sectionView.hidden = YES;
                 }
             } else {
                 if(self.viewModel.model.informationResponses.count  > 0) {
                     sectionView.hidden = NO;
                     if(self.viewModel.model.inormationMore == 1) {
                         moreBtn.hidden = NO;
                     } else {
                         moreBtn.hidden = YES;
                     }
                 } else {
                     sectionView.hidden = YES;
                 }
             }
         } else if (self.viewModel.searchResultType == SearchResultTypeCourse){
             if(section == 0) {
                 timeKillLabel.text = @"课程";
             } else if (section == 1) {
                 timeKillLabel.text = @"老师";
             }
             //课程
             if(section == 0) {
                 if(self.viewModel.model.courseResponses.count  > 0) {
                     sectionView.hidden = NO;
                     if(self.viewModel.model.courseMore == 1) {
                         moreBtn.hidden = NO;
                     } else {
                         moreBtn.hidden = YES;
                     }
                 } else {
                     sectionView.hidden = YES;
                 }
                 
             } else {
                 if(self.viewModel.model.teacherResponses.count  > 0) {
                     sectionView.hidden = NO;
                     if(self.viewModel.model.teacherMore == 1) {
                         moreBtn.hidden = NO;
                     } else {
                         moreBtn.hidden = YES;
                     }
                 } else {
                     sectionView.hidden = YES;
                 }
                 
             }
         } else {
             if(section == 0) {
                 timeKillLabel.text = @"直播";
             } else if (section == 1) {
                 timeKillLabel.text = @"老师";
             }
             //直播
             if(section == 0) {
                 if(self.viewModel.model.courseLiveResponses.count  > 0) {
                     sectionView.hidden = NO;
                     if(self.viewModel.model.courseLiveMore == 1) {
                         moreBtn.hidden = NO;
                     } else {
                         moreBtn.hidden = YES;
                     }
                 } else {
                     sectionView.hidden = YES;
                 }
                 
             } else {
                 if(self.viewModel.model.teacherResponses.count  > 0) {
                     sectionView.hidden = NO;
                     if(self.viewModel.model.teacherMore == 1) {
                         moreBtn.hidden = NO;
                     } else {
                         moreBtn.hidden = YES;
                     }
                 } else {
                     sectionView.hidden = YES;
                 }
             }
         }
         return sectionView;
     }
    
    if (self.historyArray.count > 0){
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = HEXColor(@"#22476B");
        [sectionView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(sectionView).offset(kWidth(10.0));
            make.size.mas_equalTo(CGSizeMake(kWidth(2.0), kHeight(14)));
            make.centerY.equalTo(sectionView);
        }];
        
        UILabel *timeKillLabel = [UILabel creatLabel:^(UILabel *label) {
            label.ljTitle_font_textColor(@"最近搜索",BoldFont(font(15)),HEXColor(@"#333333"));
            label.numberOfLines = 0;
            [label sizeToFit];
        }];
        [sectionView addSubview:timeKillLabel];
        [timeKillLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(lineView);
            make.left.equalTo(lineView.mas_right).offset(kWidth(5.0));
        }];

        return sectionView;
    }
    sectionView.backgroundColor = Background_Color;
    UILabel *noSearchRecordLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"暂无搜索记录",MediumFont(font(13)),HEXColor(@"#666666"));
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [sectionView addSubview:noSearchRecordLabel];
    [noSearchRecordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(sectionView);
        make.height.mas_equalTo(kHeight(13.0));
    }];
    return sectionView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    kRepeatClickTime(1.0);
    if(self.searchText.text.length > 0) {
        if(self.viewModel.searchResultType == SearchResultTypeAll) {
            if(indexPath.section == 0) {
                //课程
                if([APPUserDataIofo AccessToken].length <= 0) {
                    [DCURLRouter pushURLString:@"route://loginVC" animated:YES];
                    return;
                }
                if(indexPath.row < self.viewModel.model.courseResponses.count) {
                    CourseResponses *model = self.viewModel.model.courseResponses[indexPath.row];
                    [DCURLRouter pushURLString:@"route://classDetailVC" query:@{@"courseId" : model.courseid} animated:YES];
                }
               
            } else if (indexPath.section == 1) {
                //老师
                if(indexPath.row < self.viewModel.model.teacherResponses.count) {
                    TeacherResponses *model = self.viewModel.model.teacherResponses[indexPath.row];
                    [DCURLRouter pushURLString:@"route://teacherDetailVC" query:@{@"teacherId" : model.userid} animated:YES];
                }
            } else if (indexPath.section == 2) {
                //直播
                HJSearchResultLiveCell *cell = (HJSearchResultLiveCell *)[tableView cellForRowAtIndexPath:indexPath];
                if (indexPath.row  < self.viewModel.model.courseLiveResponses.count) {
                    CourseLiveModel *model = self.viewModel.model.courseLiveResponses[indexPath.row];
                    NSString *liveId = @"";
                    if (model.l_courseid.length > 0) {
                        //正在直播
                        liveId = model.l_courseid;
                    } else if (model.a_courseid.length > 0) {
                        //直播预告
                        liveId = model.a_courseid;
                    } else if (model.p_courseid.length > 0) {
                        //往期回顾
                        liveId = model.p_courseid;
                    } else {
                        //暂无直播
                        ShowMessage(@"暂无直播");
                        return;
                    }
                    if(model.courseid.integerValue != -1) {
                        if([APPUserDataIofo AccessToken].length <= 0) {
//                            ShowMessage(@"您还未登录");
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                [DCURLRouter pushURLString:@"route://loginVC" animated:YES];
                            });
                            return;
                        }
                    }
                    [cell.loadingView startAnimating];
                    [[HJCheckLivePwdTool shareInstance] checkLivePwdWithPwd:@"" courseId:liveId success:^(BOOL isSetPwd){
                        [cell.loadingView stopLoadingView];
                        //没有设置密码
                        if(isSetPwd) {
                            [DCURLRouter pushURLString:@"route://schoolDetailLiveVC" query:@{@"liveId" : liveId
                                                                                             } animated:YES];
                        } else {
                            HJCheckLivePwdAlertView *alertView = [[HJCheckLivePwdAlertView alloc] initWithLiveId:liveId teacherId:model.userid BindBlock:^(NSString * _Nonnull pwd) {
                                [DCURLRouter pushURLString:@"route://schoolDetailLiveVC" query:@{@"liveId" : liveId } animated:YES];
                            }];
                            [alertView show];
                        }
                        
                    } error:^{
                        //设置了密码，弹窗提示
                        [cell.loadingView stopLoadingView];
                    }];
                }
            } else {
                //文章
                if(indexPath.row < self.viewModel.model.informationResponses.count) {
                    InformationResponses *model = self.viewModel.model.informationResponses[indexPath.row];
                    NSDictionary *para = @{@"infoId" : model.informationId
                                           };
                    [DCURLRouter pushURLString:@"route://infoDetailVC" query:para animated:YES];
                }
            }
        } else if (self.viewModel.searchResultType == SearchResultTypeCourse) {
            //课程
            if(indexPath.section == 0) {
                //课程
                if([APPUserDataIofo AccessToken].length <= 0) {
//                    ShowMessage(@"您还未登录");
                    [DCURLRouter pushURLString:@"route://loginVC" animated:YES];
                    return;
                }
                if(indexPath.row < self.viewModel.model.courseResponses.count)  {
                    CourseResponses *model = self.viewModel.model.courseResponses[indexPath.row];
                    [DCURLRouter pushURLString:@"route://classDetailVC" query:@{@"courseId" : model.courseid} animated:YES];
                }
                
            } else {
                //老师
                if(indexPath.row < self.viewModel.model.teacherResponses.count)  {
                    TeacherResponses *model = self.viewModel.model.teacherResponses[indexPath.row];
                    [DCURLRouter pushURLString:@"route://teacherDetailVC" query:@{@"teacherId" : model.userid} animated:YES];
                }
            }
        } else {
            //直播
            if(indexPath.section == 0) {
                HJSearchResultLiveCell *cell = (HJSearchResultLiveCell *)[tableView cellForRowAtIndexPath:indexPath];
                if([APPUserDataIofo AccessToken].length <= 0) {
//                    ShowMessage(@"您还未登录");
                    [DCURLRouter pushURLString:@"route://loginVC" animated:YES];
                    return;
                }
                if (indexPath.row  < self.viewModel.model.courseLiveResponses.count) {
                    CourseLiveModel *model = self.viewModel.model.courseLiveResponses[indexPath.row];
                    NSString *liveId = @"";
                    if (model.l_courseid.length > 0) {
                        //正在直播
                        liveId = model.l_courseid;
                    } else if (model.a_courseid.length > 0) {
                        //直播预告
                        liveId = model.a_courseid;
                    } else if (model.p_courseid.length > 0) {
                        //往期回顾
                        liveId = model.p_courseid;
                    } else {
                        //暂无直播
                        ShowMessage(@"暂无直播");
                        return;
                    }
                    if(model.courseid.integerValue != -1) {
                        if([APPUserDataIofo AccessToken].length <= 0) {
//                            ShowMessage(@"您还未登录");
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                [DCURLRouter pushURLString:@"route://loginVC" animated:YES];
                            });
                            return;
                        }
                    }
                    [cell.loadingView startAnimating];
                    [[HJCheckLivePwdTool shareInstance] checkLivePwdWithPwd:@"" courseId:liveId success:^(BOOL isSetPwd){
                        [cell.loadingView stopLoadingView];
                        //没有设置密码
                        if(isSetPwd) {
                            [DCURLRouter pushURLString:@"route://schoolDetailLiveVC" query:@{@"liveId" : liveId,
                                                                                             @"teacherId" : model.userid.length > 0 ? model.userid : @""
                                                                                             } animated:YES];
                        } else {
                            HJCheckLivePwdAlertView *alertView = [[HJCheckLivePwdAlertView alloc] initWithLiveId:liveId  teacherId:model.userid BindBlock:^(NSString * _Nonnull pwd) {
                                [DCURLRouter pushURLString:@"route://schoolDetailLiveVC" query:@{@"liveId" : liveId,
                                                                                                 @"teacherId" : model.userid.length > 0 ? model.userid : @""
                                                                                                 } animated:YES];
                            }];
                            [alertView show];
                        }
                        
                    } error:^{
                        //设置了密码，弹窗提示
                        [cell.loadingView stopLoadingView];
                    }];
                }
               
            } else {
                if(indexPath.row < self.viewModel.model.teacherResponses.count)  {
                    TeacherResponses *model = self.viewModel.model.teacherResponses[indexPath.row];
                    [DCURLRouter pushURLString:@"route://teacherDetailVC" query:@{@"teacherId" : model.userid} animated:YES];
                }
            }
        }
    } else {
        NSArray* reversedArray = [[self.historyArray reverseObjectEnumerator] allObjects];
        self.searchText.text = reversedArray[indexPath.row];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self.viewModel getSearchResultListDataWithSearchParam:reversedArray[indexPath.row] success:^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.searchResultTableView reloadData];
                    self.tableView.hidden = YES;
                    self.searchResultTableView.hidden = NO;
                });
            }];
        });
    }
}

- (UITextField *)searchText{
    if (!_searchText) {
        _searchText = [[UITextField alloc] initWithFrame:CGRectMake(30, 0, Screen_Width - 100, 30)];
        _searchText.delegate = self;
        _searchText.font = MediumFont(font(11));
        _searchText.placeholder = @"搜索/老师/直播/课程/资讯";
        _searchText.clearButtonMode = UITextFieldViewModeWhileEditing;
        _searchText.returnKeyType = UIReturnKeySearch;
//        [_searchText becomeFirstResponder];
        [_searchText addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventAllEditingEvents];
    }
    return _searchText;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = Background_Color;
    self.fd_prefersNavigationBarHidden = YES;
    [self readSearchHistory];
}

- (void)hj_configSubViews {
    UIView *navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, kNavigationBarHeight)];
    navView.backgroundColor = NavigationBar_Color;
    [self.view addSubview:navView];
    
    searchView = [[UIView alloc]initWithFrame:CGRectMake(kWidth(10.0), (kNavigationBarHeight - kStatusBarHeight - kHeight(28.0)) / 2 + kStatusBarHeight, Screen_Width - kWidth(58.0), kHeight(28.0))];
    searchView.backgroundColor = RGBCOLOR(241, 242, 243);
    searchView.layer.cornerRadius = kHeight(2.5);
    [searchView addSubview:self.searchText];
    [navView addSubview:searchView];
    
    UIImageView *imaV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kHeight(12.0), kHeight(12.0))];
    imaV.image = V_IMAGE(@"搜索");
    [searchView addSubview:imaV];
    
    [imaV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(searchView);
        make.size.mas_equalTo(CGSizeMake(kHeight(12), kHeight(12)));
        make.left.equalTo(searchView).offset(kWidth(10));
    }];
    
    [searchView addSubview:self.searchText];
    [self.searchText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(searchView);
        make.height.mas_equalTo(kHeight(28.0));
        make.left.equalTo(imaV.mas_right).offset(kWidth(6.0));
        make.right.equalTo(searchView).offset(-kWidth(10.0));
    }];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.titleLabel.font = MediumFont(font(15));
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:white_color forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(searchView.mas_right);
        make.right.mas_equalTo(navView);
        make.centerY.mas_equalTo(searchView);
        make.height.mas_equalTo(kHeight(28.0));
    }];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.searchResultTableView];
}

- (void)cancelAction{
    [DCURLRouter popViewControllerAnimated:YES];
}

- (void)deleteAction {
    [self removeSearchHistory];
    self.historyArray = nil;
    [self.searchResultTableView reloadData];
    [self.tableView reloadData];
}


- (void)readSearchHistory {//取出缓存的数据
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    //读取数组NSArray类型的数据
    self.historyArray = [userDefaultes arrayForKey:[NSString stringWithFormat:@"searchHistory%@%@",[self getSearchType],[APPUserDataIofo UserID]]];
    [self.tableView reloadData];
}

//缓存搜索数组
- (void)cacheSearchText :(NSString *)searchTxt {
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    //读取数组NSArray类型的数据
    NSArray *myArray = [userDefaultes arrayForKey:[NSString stringWithFormat:@"searchHistory%@%@",[self getSearchType],[APPUserDataIofo UserID]]];
    if (myArray.count > 0) {//先取出数组，判断是否有值，有值继续添加，无值创建数组
        
    }else{
        myArray = [NSArray array];
    }
    // NSArray --> NSMutableArray
    NSMutableArray *searTXT = [myArray mutableCopy];
    if (![searTXT containsObject:searchTxt]) {
        //判断数量
        if(searTXT.count >= MAXCOUNT) {
            //先删除最后一个，然后插入一个
            [searTXT removeObjectAtIndex:0];
            [searTXT addObject:searchTxt];
        } else {
            //不足6个直接添加
            [searTXT addObject:searchTxt];
        }
    }
    
    //将上述数据全部存储到NSUserDefaults中
    [userDefaultes setObject:searTXT forKey:[NSString stringWithFormat:@"searchHistory%@%@",[self getSearchType],[APPUserDataIofo UserID]]];
    [userDefaultes synchronize];
}

- (void)updateSearchHistory:(NSArray *)array {
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    [userDefaultes setObject:array forKey:[NSString stringWithFormat:@"searchHistory%@%@",[self getSearchType],[APPUserDataIofo UserID]]];
    [userDefaultes synchronize];
}

- (void)removeSearchHistory {
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:[NSString stringWithFormat:@"searchHistory%@%@",[self getSearchType],[APPUserDataIofo UserID]]];
    [userDefaults synchronize];
}

- (NSString*)getSearchType {
    if (self.searchType == SearchTypeIsTeacher) {
        return @"SearchTypeIsTeacher";
    }
    if (self.searchType == SearchTypeIsLive) {
        return @"SearchTypeIsLive";
    }
    if (self.searchType == SearchTypeIsCource) {
        return @"SearchTypeIsCource";
    }
    return @"SearchTypeIsInformation";
}

@end

