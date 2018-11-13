//
//  HJSchoolClassViewController.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/10/23.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJSchoolClassViewController.h"
#import "HJSchoolClassCell.h"
#import "HJSchoolClassSelectToolView.h"
#import "HJSchoolClassSelectView.h"
@interface HJSchoolClassViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) HJSchoolClassSelectView *selectView;
@property (nonatomic,strong) HJSchoolClassSelectToolView *toolView;

@end

@implementation HJSchoolClassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (HJSchoolClassSelectView *)selectView {
    if(!_selectView){
        _selectView = [[HJSchoolClassSelectView alloc] initWithFrame:CGRectMake(-Screen_Width, kNavigationBarHeight, Screen_Width, Screen_Height - kNavigationBarHeight - kBottomBarHeight)];
        _selectView.backgroundColor = white_color;
        @weakify(self);
        [_selectView.backSubject subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            if([x integerValue] == 0) {
                self.toolView.selectButton.selected = NO;
            } else {
                self.toolView.selectButton.selected = YES;
            }
            [self.selectView setFrame:CGRectMake(-Screen_Width, kNavigationBarHeight, Screen_Width, Screen_Height - kNavigationBarHeight - kBottomBarHeight)];
        }];
    }
    return _selectView;
}

- (void)hj_configSubViews{
    //    self.tableView.scrollEnabled = NO;

    [self.tableView registerClass:[HJSchoolClassCell class] forCellReuseIdentifier:NSStringFromClass([HJSchoolClassCell class])];

    HJSchoolClassSelectToolView *toolView = [[HJSchoolClassSelectToolView alloc] init];
    [self.view addSubview:toolView];
    [toolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo(kHeight(40.0));
    }];
    @weakify(self);
    [toolView.clickSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        if([x integerValue] == 0) {
            //点击筛选进行的操作
            [UIView animateWithDuration:0.3 animations:^{
                [self.selectView setFrame:CGRectMake(0, kNavigationBarHeight, Screen_Width, Screen_Height - kNavigationBarHeight - kBottomBarHeight)];
                
            }];
        }
    }];
    
    self.toolView = toolView;

    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(kHeight(40.0) , 0, 0, 0));
    }];
    
    //添加筛选的试图
    [[UIApplication sharedApplication].keyWindow addSubview:self.selectView];
}

- (void)hj_loadData {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  kHeight(111.0);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HJSchoolClassCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HJSchoolClassCell class]) forIndexPath:indexPath];
    self.tableView.separatorColor = clear_color;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [DCURLRouter pushURLString:@"route://classDetailVC" animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0001f;
}


- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero
                                                 style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
        _tableView.backgroundColor = Background_Color;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
    }
    return _tableView;
}

@end
