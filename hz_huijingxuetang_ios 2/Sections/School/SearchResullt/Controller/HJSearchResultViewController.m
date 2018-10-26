//
//  HJSearchResultViewController.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/10/26.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJSearchResultViewController.h"
#import "HJSearchResultListCell.h"

#import "HJSearchResultCourceCell.h"
#import "HJSearchResultTeacherCell.h"
#import "HJSearchResultLiveCell.h"
#import "HJSearchResultInfomationCell.h"
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

@end

@implementation HJSearchResultViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
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
//        [self readSearchHistory];
        NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
        //读取数组NSArray类型的数据
        self.historyArray = [userDefaultes arrayForKey:[NSString stringWithFormat:@"searchHistory%@%@",[self getSearchType],[APPUserDataIofo UserID]]];
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
        [self.searchResultTableView reloadData];
    } else {
        self.tableView.hidden = NO;
        self.searchResultTableView.hidden = YES;
        [self.tableView reloadData];
    }
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavigationBarHeight, Screen_Width, Screen_Height - kNavigationBarHeight) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = Background_Color;
        _tableView.delegate = self;
        _tableView.dataSource = self;
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
    }
    return _searchResultTableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(self.searchText.text.length > 0) {
        return 4;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.searchText.text.length > 0) {
//        return self.searchResultArray.count;
        return 2;
    }
    return self.historyArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.searchText.text.length > 0){
        if(indexPath.section == 0) {
            HJSearchResultCourceCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HJSearchResultCourceCell class]) forIndexPath:indexPath];
            self.searchResultTableView.separatorColor = RGBCOLOR(225, 225, 225);
            return cell;
        } else if (indexPath.section == 1) {
            HJSearchResultTeacherCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HJSearchResultTeacherCell class]) forIndexPath:indexPath];
            self.searchResultTableView.separatorColor = RGBCOLOR(225, 225, 225);
            return cell;
        } else if (indexPath.section == 2) {
            HJSearchResultLiveCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HJSearchResultLiveCell class]) forIndexPath:indexPath];
            self.searchResultTableView.separatorColor = RGBCOLOR(225, 225, 225);
            return cell;
        } else {
            HJSearchResultInfomationCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HJSearchResultInfomationCell class]) forIndexPath:indexPath];
            self.searchResultTableView.separatorColor = RGBCOLOR(225, 225, 225);
            return cell;
        }
    }
    HJSearchResultListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HJSearchResultListCell class])];
    if(!cell){
        cell = [[HJSearchResultListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([HJSearchResultListCell class])];
    }
    self.tableView.separatorColor = RGBCOLOR(225, 225, 225);
    NSArray* reversedArray = [[self.historyArray reverseObjectEnumerator] allObjects];
    cell.searchResultLabel.text = reversedArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.searchText.text.length > 0){
        if(indexPath.section == 0) {
           return kHeight(111.0);
        } else if (indexPath.section == 1) {
           return kHeight(90.0);
        } else if (indexPath.section == 2) {
           return kHeight(110.0);
        } else {
           return kHeight(125.0);
        }
    }
    return kHeight(40.0);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(self.searchText.text.length > 0){
        return kHeight(40.0);
    }
    return kHeight(40.0);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if(self.searchText.text.length > 0){
        return 0.0001f;
    }
    if (self.historyArray.count > 0){
        return kHeight(40.0);
    }
    return 0.0001f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
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
         if(section == 0) {
             timeKillLabel.text = @"课程";
         } else if (section == 1) {
             timeKillLabel.text = @"老师";
         } else if (section == 2) {
             timeKillLabel.text = @"直播";
         } else {
             timeKillLabel.text = @"资讯";
         }
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
                 NSDictionary *para = @{@"title" : timeKillLabel.text};
                 [DCURLRouter pushURLString:@"route://MoreResultVC" query:para animated:YES];
             }];
         }];
         [sectionView addSubview:moreBtn];
         [moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
             make.centerY.equalTo(sectionView);
             make.right.equalTo(sectionView).offset(-kWidth(10.0));
             make.height.mas_equalTo(kHeight(12));
         }];
         
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

- (UITextField *)searchText{
    if (!_searchText) {
        _searchText = [[UITextField alloc]initWithFrame:CGRectMake(30, 0, Screen_Width - 100, 30)];
        _searchText.delegate = self;
        _searchText.font = MediumFont(font(11));
        _searchText.placeholder = @"搜索/老师/直播/课程/资讯";
        _searchText.clearButtonMode = UITextFieldViewModeWhileEditing;
        _searchText.returnKeyType = UIReturnKeySearch;
        [_searchText becomeFirstResponder];
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
    
    searchView = [[UIView alloc]initWithFrame:CGRectMake(kWidth(10.0), kHeight(8.0) + kStatusBarHeight, Screen_Width - kWidth(58.0), kHeight(28.0))];
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
        make.height.mas_equalTo(kHeight(28));
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

