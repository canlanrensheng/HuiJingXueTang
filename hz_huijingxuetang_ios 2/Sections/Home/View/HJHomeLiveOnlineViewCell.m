//
//  HJHomeLiveOnlineView.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/10/22.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJHomeLiveOnlineViewCell.h"
#import "HJHomeViewModel.h"
#import "HJHomeLiveModel.h"
@interface HJHomeLiveOnlineViewCell ()

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) HJHomeViewModel *viewModel;

@end

@implementation HJHomeLiveOnlineViewCell

- (void)hj_configSubViews {
    self.backgroundColor = Background_Color;
    //轮播图
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.backgroundColor = Background_Color;
    _scrollView.scrollEnabled = YES;
    [self addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(kWidth(10));
        make.right.equalTo(self);
        make.top.equalTo(self);
        make.height.mas_equalTo(kHeight(150  + 10.0));
    }];
}

- (void)reloadScrollViewWithImageArr:(NSArray *)assets{
    [[self.scrollView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSUInteger assetCount = assets.count;
    CGFloat width = kWidth(145);
    CGFloat height = kHeight(150);
    CGFloat padding = kWidth(10.0);
    for (NSInteger i = 0; i < assetCount; i++) {
//        UIView *backView = [[UIView alloc] init];
//        backView.frame = CGRectMake((width + padding) * i + kHeight(5.0), kHeight(5.0), width, height);
//        backView.backgroundColor = white_color;
//        backView.tag = i;
//
//        backView.layer.cornerRadius = 3.0;
//        backView.layer.shadowOffset = CGSizeMake(0.0, 0.0);
//        backView.layer.shadowOpacity = 0.2;
//        backView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1].CGColor;
//        [self.scrollView addSubview:backView];
//
//        backView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.1].CGColor;
//        backView.layer.shadowOffset = CGSizeMake(0,1);
//        backView.layer.shadowOpacity = 1;
//        backView.layer.shadowRadius = 5;
//        backView.layer.cornerRadius = 5.0;
//        backView.clipsToBounds = YES;
//
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backTap:)];
//        [backView addGestureRecognizer:tap];
        
        UIView *shadowView = [[UIView alloc] initWithFrame:CGRectMake((width + padding) * i + kWidth(5.0), kHeight(5.0), width, height)];
        shadowView.backgroundColor = clear_color;
        
        shadowView.layer.cornerRadius = 5.0;
        shadowView.layer.shadowOffset = CGSizeMake(0.0, 0.0);
        shadowView.layer.shadowOpacity = 0.2;
        shadowView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1].CGColor;
        
        [self.scrollView addSubview:shadowView];
        
        UIView *backView = [[UIView alloc] init];
        backView.frame = CGRectMake(0 , 0 , width , height);
        backView.backgroundColor = white_color;
        backView.tag = i;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backTap:)];
        [backView addGestureRecognizer:tap];
        [shadowView addSubview:backView];
        
        [backView clipWithCornerRadius:kHeight(5.0) borderColor:nil borderWidth:0.0];
        
        HJHomeLiveModel *model = assets[i];
        //图片
        UIImageView *imaV = [[UIImageView alloc] init];
        [imaV sd_setImageWithURL:URL(model.coursepic) placeholderImage:V_IMAGE(@"占位图")];
        imaV.backgroundColor = white_color;
        [backView addSubview:imaV];
        [imaV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(backView);
            make.height.mas_equalTo(kHeight(90));
        }];
        
        //live
        UIImageView *liveImageV = [[UIImageView alloc] init];
        liveImageV.image = V_IMAGE(@"直播ICON-2");
        [backView addSubview:liveImageV];
        [liveImageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imaV);
            make.top.equalTo(imaV).offset(kHeight(10.0));
        }];
        
        //标题的背景的图片
        UIView *courseTitleBackView = [[UIView alloc] init];
        courseTitleBackView.backgroundColor = RGBA(0, 0, 0, 0.4);
        [backView addSubview:courseTitleBackView];
        [courseTitleBackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(imaV);
            make.height.mas_equalTo(kHeight(25.0));
        }];
        
        //课程的标题
        UILabel *courseTitleLabel = [UILabel creatLabel:^(UILabel *label) {
            label.ljTitle_font_textColor(model.coursename,MediumFont(font(11)),white_color);
            label.textAlignment = NSTextAlignmentLeft;
            label.numberOfLines = 0;
            [label sizeToFit];
        }];
        [backView addSubview:courseTitleLabel];
        [courseTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(courseTitleBackView);
            make.left.equalTo(courseTitleBackView).offset(kWidth(10.0));
        }];
        
        //头像图片
        UIImageView *iconImageV = [[UIImageView alloc] init];
        [iconImageV sd_setImageWithURL:URL(model.iconurl) placeholderImage:V_IMAGE(@"默认头像")];
        [iconImageV clipWithCornerRadius:kWidth(20.0) borderColor:nil borderWidth:0];
        iconImageV.backgroundColor = Background_Color;
        [backView addSubview:iconImageV];
        [iconImageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(backView).offset(kWidth(10));
            make.width.height.mas_equalTo(kWidth(40));
            make.top.equalTo(imaV.mas_bottom).offset(kHeight(10.0));
        }];
        
        [iconImageV clipWithCornerRadius:kHeight(20) borderColor:nil borderWidth:0];
    
        
        //标题
        UILabel *nameLabel = [UILabel creatLabel:^(UILabel *label) {
            label.ljTitle_font_textColor(model.realname,BoldFont(font(13)),HEXColor(@"#333333"));
            [label sizeToFit];
        }];
        [backView addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(iconImageV).offset(kHeight(3.0));
            make.left.equalTo(iconImageV.mas_right).offset(kWidth(11.0));
            make.height.mas_equalTo(kHeight(13));
        }];
  
        
        //职位
        UILabel *jobLabel = [UILabel creatLabel:^(UILabel *label) {
            label.ljTitle_font_textColor(model.l_livecoursename,MediumFont(font(11)),HEXColor(@"#666666"));
            [label sizeToFit];
        }];
        [backView addSubview:jobLabel];
        [jobLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(nameLabel.mas_bottom).offset(kHeight(7.0));
            make.left.equalTo(nameLabel);
            make.height.mas_equalTo(kHeight(11.0));
        }];

    }
    //self.scrollView.backgroundColor = [UIColor redColor];
    self.scrollView.contentSize = CGSizeMake((width + padding) * assetCount, CGRectGetMaxY([[self.scrollView.subviews lastObject] frame]));
    
}

- (void)backTap:(UITapGestureRecognizer *)tap {
    kRepeatClickTime(1.0);
    HJHomeLiveModel *model = self.viewModel.liveListArray[tap.view.tag];
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
//            ShowMessage(@"您还未登录");
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [DCURLRouter pushURLString:@"route://loginVC" animated:YES];
            });
            return;
        }
    }
    [[HJCheckLivePwdTool shareInstance] checkLivePwdWithPwd:@"" courseId:liveId success:^(BOOL isSetPwd){
        //没有设置密码
        if(isSetPwd) {
            [DCURLRouter pushURLString:@"route://schoolDetailLiveVC" query:@{@"liveId" : liveId,
                                                                             @"teacherId" : model.userid.length > 0 ? model.userid : @""
                                                                             } animated:YES];
        } else {
            HJCheckLivePwdAlertView *alertView = [[HJCheckLivePwdAlertView alloc] initWithLiveId:liveId teacherId:model.userid BindBlock:^(NSString * _Nonnull pwd) {
                [DCURLRouter pushURLString:@"route://schoolDetailLiveVC" query:@{@"liveId" : liveId,
                                                                                 @"teacherId" : model.userid.length > 0 ? model.userid : @""
                                                                                 } animated:YES];
            }];
            [alertView show];
        }
        
    } error:^{
        //设置了密码，弹窗提示
        
    }];
}


- (void)setViewModel:(BaseViewModel *)viewModel indexPath:(NSIndexPath *)indexPath {
    HJHomeViewModel *listViewModel = (HJHomeViewModel *)viewModel;
    self.viewModel = listViewModel;
    if(listViewModel.liveListArray.count > 0) {
        [self reloadScrollViewWithImageArr:listViewModel.liveListArray];
    }
}

@end
