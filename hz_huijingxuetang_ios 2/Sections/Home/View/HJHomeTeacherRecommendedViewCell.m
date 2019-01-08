//
//  HJHomeTeacherRecommendedView.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/10/22.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJHomeTeacherRecommendedViewCell.h"
#import "HJHomeViewModel.h"
#import "HJRecommentTeacherModel.h"

@interface HJHomeTeacherRecommendedViewCell ()

@property (nonatomic,strong) UIScrollView *scrollView;

@property (nonatomic,strong) HJHomeViewModel *listViewModel;

@end

@implementation HJHomeTeacherRecommendedViewCell

- (void)hj_configSubViews {
    self.opaque = YES;
    self.backgroundColor = white_color;
    
    //轮播图
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.backgroundColor = white_color;
    _scrollView.opaque = YES;
    _scrollView.scrollEnabled = YES;
    [self addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(kWidth(10));
        make.right.equalTo(self);
        make.top.equalTo(self);
        make.height.mas_equalTo(kHeight(130));
    }];
    
    UIView *bottomiew = [[UIView alloc] init];
    bottomiew.backgroundColor = Background_Color;
    bottomiew.opaque = YES;
    [self addSubview:bottomiew];
    [bottomiew mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(_scrollView.mas_bottom);
        make.height.mas_equalTo(kHeight(10.0));
    }];
}

- (void)reloadScrollViewWithImageArr:(NSArray *)assets{
    [[self.scrollView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSUInteger assetCount = assets.count;
    CGFloat width = kWidth(76);
    CGFloat height = kHeight(131.0);
    CGFloat padding = kWidth(10.0);
    for (NSInteger i = 0; i < assetCount; i++) {
        UIView *backView = [[UIView alloc] init];
        backView.frame = CGRectMake((width + padding) * i, 0, width, height);
        backView.tag = i;
        backView.opaque = YES;
        backView.backgroundColor = clear_color;
        [self.scrollView addSubview:backView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backTap:)];
        [backView addGestureRecognizer:tap];
        
        HJRecommentTeacherModel *model = assets[i];
        
        //图片
        UIImageView *imaV = [[UIImageView alloc] init];
        [imaV sd_setImageWithURL:URL(model.iconurl) placeholderImage:V_IMAGE(@"默认头像")];
        imaV.backgroundColor = Background_Color;
        imaV.opaque = YES;
        [backView addSubview:imaV];
        [imaV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(backView);
            make.top.equalTo(backView).offset(kHeight(7.0));
            make.width.height.mas_equalTo(kWidth(60));
        }];
        [imaV clipWithCornerRadius:kHeight(30.0) borderColor:nil borderWidth:0];
        
        //live
        UIImageView *liveImageV = [[UIImageView alloc] init];
        liveImageV.image = V_IMAGE(@"特级");
        liveImageV.opaque = YES;
        liveImageV.hidden = model.isspecialgrade ? NO : YES;
        [backView addSubview:liveImageV];
        [liveImageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imaV.mas_right).offset(-kWidth(29.0 / 2 + 3.0));
            make.top.equalTo(imaV.mas_top).offset(-kHeight(7.0));
            make.width.height.mas_equalTo(kWidth(29));
        }];
        
        //标题
        UILabel *nameLabel = [UILabel creatLabel:^(UILabel *label) {
            label.ljTitle_font_textColor(model.realname,BoldFont(font(13)),HEXColor(@"#333333"));
            label.textAlignment = NSTextAlignmentCenter;
            label.opaque = YES;
            [label sizeToFit];
        }];
        [backView addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imaV.mas_bottom).offset(kHeight(10.0));
            make.centerX.equalTo(imaV);
            make.height.mas_equalTo(kHeight(13));
        }];
        
        
        //职位
        UILabel *jobLabel = [UILabel creatLabel:^(UILabel *label) {
            label.ljTitle_font_textColor(model.teacprofessional,MediumFont(font(11)),HEXColor(@"#999999"));
            label.textAlignment = NSTextAlignmentCenter;
            jobLabel.opaque = YES;
            [label sizeToFit];
        }];
        [backView addSubview:jobLabel];
        [jobLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(nameLabel.mas_bottom).offset(kHeight(7.0));
            make.centerX.equalTo(imaV);
            make.height.mas_equalTo(kHeight(11.0));
        }];
        
    }
    self.scrollView.contentSize = CGSizeMake((width + padding) * assetCount, kHeight(130));
}


- (void)setViewModel:(BaseViewModel *)viewModel indexPath:(NSIndexPath *)indexPath{
    self.listViewModel = (HJHomeViewModel *)viewModel;
    if (self.listViewModel.recommentTeacherArray.count > 0){
        [self reloadScrollViewWithImageArr:self.listViewModel.recommentTeacherArray];;
    }
}

- (void)backTap:(UITapGestureRecognizer *)tap {
    if (tap.view.tag < self.listViewModel.recommentTeacherArray.count) {
        HJRecommentTeacherModel *model = self.listViewModel.recommentTeacherArray[tap.view.tag];
        [DCURLRouter pushURLString:@"route://teacherDetailVC" query:@{@"teacherId" : model.userid} animated:YES];
    }
}




@end
