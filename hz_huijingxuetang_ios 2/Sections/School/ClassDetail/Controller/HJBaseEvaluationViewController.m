//
//  HJBaseEvaluationViewController.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/10/25.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJBaseEvaluationViewController.h"
#import "HJEvaluationTotalCourseCell.h"
#import "HJEvaluationSingleCell.h"
#import "HJClassDetailBottomView.h"

#define BottomViewHeight kHeight(49)
@interface HJBaseEvaluationViewController ()

@property (nonatomic,strong) HJClassDetailBottomView *bottomView;
//撰写评论的按钮
@property (nonatomic,strong) UIButton *writeCommotBtn;

@end

@implementation HJBaseEvaluationViewController

- (void)viewDidLoad {
    self.tableViewStyle = UITableViewStyleGrouped;
    [super viewDidLoad];
}

- (UIButton *)writeCommotBtn {
    if(!_writeCommotBtn) {
        _writeCommotBtn = [UIButton creatButton:^(UIButton *button) {
            button.ljTitle_font_titleColor_state(@"撰写评价",MediumFont(font(15)),white_color,0);
            button.backgroundColor = HEXColor(@"#22476B");
//            @weakify(self);
            [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//                @strongify(self);
                [DCURLRouter pushURLString:@"route://postEvaluationVC" animated:YES];
            }];
        }];
    }
    return _writeCommotBtn;
}

- (void)hj_configSubViews{
    //    self.tableView.scrollEnabled = NO;
    
    self.bottomView = [[HJClassDetailBottomView alloc] init];
    [self.view addSubview:self.bottomView];
    @weakify(self);
    [self.bottomView.backSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        if([x integerValue] == 0) {
            //加入购物车
            
        } else {
            //立即购买
            
        }
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(kHeight(49.0));
    }];
    self.bottomView.hidden = YES;
    
    [self.view addSubview:self.writeCommotBtn];
    [self.writeCommotBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(kHeight(49.0));
    }];
    
    [self.tableView registerClassCell:[HJEvaluationTotalCourseCell class]];
    [self.tableView registerClassCell:[HJEvaluationSingleCell class]];
    
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, BottomViewHeight, 0));
    }];
}

- (void)hj_loadData {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0) {
        return  kHeight(65.0);
    } 
    return  kHeight(130.0);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0) {
        return 1;
    }
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0) {
        HJEvaluationTotalCourseCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HJEvaluationTotalCourseCell class]) forIndexPath:indexPath];
        self.tableView.separatorColor = clear_color;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    HJEvaluationSingleCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HJEvaluationSingleCell class]) forIndexPath:indexPath];
    self.tableView.separatorColor = RGBCOLOR(225, 225, 225);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0001f;
}

@end
