//
//  HJSchoolClassSelectToolView.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/10/24.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJSchoolClassSelectToolView.h"
#import "HJPicAndTextButton.h"
@interface HJSchoolClassSelectToolView ()


@property (nonatomic,strong) UIButton *priceBtn;

@property (nonatomic,strong) UIButton *buyerBtn;
@property (nonatomic,strong) UIButton *limitTeHuiBtn;

@end

@implementation HJSchoolClassSelectToolView

- (void)hj_configSubViews {
    self.backgroundColor = white_color;
    
    UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [selectBtn setTitle:@" 筛选" forState:UIControlStateNormal];
    selectBtn.tag = 0;
    selectBtn.titleLabel.font = MediumFont(font(13.0));
    [selectBtn setTitleColor:HEXColor(@"#333333") forState:UIControlStateNormal];
    [selectBtn setTitleColor:HEXColor(@"#22476B") forState:UIControlStateSelected];
    [selectBtn setImage:V_IMAGE(@"筛选未启用") forState:UIControlStateNormal];
    [selectBtn setImage:V_IMAGE(@"筛选") forState:UIControlStateSelected];
    [self addSubview:selectBtn];
    self.selectButton = selectBtn;
    
    //关注的按钮
    HJPicAndTextButton *priceBtn = [HJPicAndTextButton buttonWithType:UIButtonTypeCustom withSpace:kHeight(5.0)];
    priceBtn.buttonStyle = ButtonImageRight;
    priceBtn.tag = 1;
    [priceBtn setTitle:@"价格排序" forState:UIControlStateNormal];
    [priceBtn setImage:V_IMAGE(@"箭头默认") forState:UIControlStateNormal];
    [priceBtn setTitleColor:HEXColor(@"#333333") forState:UIControlStateNormal];
    priceBtn.titleLabel.font = MediumFont(font(13.0));
    [priceBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:priceBtn];
    self.priceBtn = priceBtn;

    UIButton *buyerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [buyerBtn setTitle:@"销量排序" forState:UIControlStateNormal];
    buyerBtn.tag = 2;
    [buyerBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [buyerBtn setTitleColor:HEXColor(@"#333333") forState:UIControlStateNormal];
    [buyerBtn setTitleColor:HEXColor(@"#22476B") forState:UIControlStateSelected];
    buyerBtn.titleLabel.font = MediumFont(font(13.0));
    [self addSubview:buyerBtn];
    
    self.buyerBtn = buyerBtn;

    //限时特惠
    UIButton *limitTeHuiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [limitTeHuiBtn setTitle:@"评分排序" forState:UIControlStateNormal];
    limitTeHuiBtn.tag = 3;
    [limitTeHuiBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [limitTeHuiBtn setTitleColor:HEXColor(@"#333333") forState:UIControlStateNormal];
    [limitTeHuiBtn setTitleColor:HEXColor(@"#22476B") forState:UIControlStateSelected];
    limitTeHuiBtn.titleLabel.font = MediumFont(font(13.0));
    [self addSubview:limitTeHuiBtn];
    self.limitTeHuiBtn = limitTeHuiBtn;

    
    [selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self);
        make.width.mas_equalTo(Screen_Width / 4);
    }];
    
    [priceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self);
        make.left.equalTo(selectBtn.mas_right);
        make.width.mas_equalTo(selectBtn);
    }];
    
    [buyerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self);
        make.left.equalTo(priceBtn.mas_right);
        make.width.mas_equalTo(selectBtn);
    }];
    
    [limitTeHuiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self);
        make.left.equalTo(buyerBtn.mas_right);
        make.width.mas_equalTo(selectBtn);
    }];
    
    UIView *lineView = [UIView new];
    lineView.backgroundColor = HEXColor(@"#EAEAEA");
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(kHeight(0.5));
    }];
}

//点击筛选的操作
- (void)btnClick:(UIButton *)btn {
    if(btn.tag == 1) {
        if(self.lastSelectBtn == btn) {
            btn.selected = !btn.selected;
            if (btn.selected) {
                [btn setTitleColor:HEXColor(@"#22476B") forState:UIControlStateNormal];
                [btn setImage:V_IMAGE(@"箭头选中从高到低") forState:UIControlStateNormal];
                self.viewModel.sort_price = @"desc";
                self.viewModel.sort_sales = @"";
                self.viewModel.sort_starlevel = @"";
                self.viewModel.filter_price = @"";
                self.viewModel.filter_preference = @"";
                [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshVideoCourseListData" object:nil userInfo:nil];
            } else {
                [btn setTitleColor:HEXColor(@"#22476B") forState:UIControlStateNormal];
                [btn setImage:V_IMAGE(@"箭头选中从低到高") forState:UIControlStateNormal];
                self.viewModel.sort_price = @"asc";
                self.viewModel.sort_sales = @"";
                self.viewModel.sort_starlevel = @"";
                self.viewModel.filter_price = @"";
                self.viewModel.filter_preference = @"";
                [[NSNotificationCenter defaultCenter]postNotificationName:@"RefreshVideoCourseListData" object:nil userInfo:nil];
            }
            self.lastSelectBtn = btn;
            [self.clickSubject sendNext:@(btn.tag)];
        } else {
            self.lastSelectBtn.selected = NO;
            [btn setTitleColor:HEXColor(@"#22476B") forState:UIControlStateNormal];
            [btn setImage:V_IMAGE(@"箭头选中从高到低") forState:UIControlStateNormal];
            btn.selected = YES;
            self.viewModel.sort_price = @"desc";
            self.viewModel.sort_sales = @"";
            self.viewModel.sort_starlevel = @"";
            self.viewModel.filter_price = @"";
            self.viewModel.filter_preference = @"";
            self.lastSelectBtn = btn;
            [[NSNotificationCenter defaultCenter]postNotificationName:@"RefreshVideoCourseListData" object:nil userInfo:nil];
            [self.clickSubject sendNext:@(btn.tag)];
        }
    } else {
        [self.priceBtn setTitleColor:HEXColor(@"#333333") forState:UIControlStateNormal];
        [self.priceBtn setImage:V_IMAGE(@"箭头默认") forState:UIControlStateNormal];
        
        //销量
        if(btn == self.buyerBtn) {
            self.lastSelectBtn.selected = NO;
            btn.selected = YES;
            self.lastSelectBtn.titleLabel.font = BoldFont(font(13));
            btn.titleLabel.font = MediumFont(font(13));
            self.lastSelectBtn = btn;
            
            self.viewModel.sort_price = @"";
            self.viewModel.sort_sales = @"desc";
            self.viewModel.sort_starlevel = @"";
            self.viewModel.filter_price = @"";
            self.viewModel.filter_preference = @"";
            //评分排序
        } else if (btn == self.limitTeHuiBtn) {
            self.lastSelectBtn.selected = NO;
            btn.selected = YES;
            self.lastSelectBtn.titleLabel.font = BoldFont(font(13));
            btn.titleLabel.font = MediumFont(font(13));
            self.lastSelectBtn = btn;
            
            self.viewModel.sort_price = @"";
            self.viewModel.sort_sales = @"";
            self.viewModel.sort_starlevel = @"desc";
            self.viewModel.filter_price = @"";
            self.viewModel.filter_preference = @"";
        } else  if(btn == self.selectButton){
            //筛选操作
            self.lastSelectBtn.selected = NO;
            btn.selected = YES;
            self.lastSelectBtn.titleLabel.font = BoldFont(font(13));
            btn.titleLabel.font = MediumFont(font(13));
            self.lastSelectBtn = btn;
            
        }
        //刷新数据请求
        [[NSNotificationCenter defaultCenter]postNotificationName:@"RefreshVideoCourseListData" object:nil userInfo:nil];
        [self.clickSubject sendNext:@(btn.tag)];
    }
}

//回掉的按钮
- (RACSubject *)clickSubject {
    if (!_clickSubject) {
        _clickSubject = [RACSubject subject];
    }
    return _clickSubject;
}

- (void)setViewModel:(HJSchoolCourseListViewModel *)viewModel {
    _viewModel = viewModel;
}

@end
