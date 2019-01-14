//
//  HJBaseInfoHeaderView.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/6.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJBaseInfoHeaderView.h"
#import "HJInfoCheckPwdAlertView.h"
@interface HJBaseInfoHeaderView ()

@property (nonatomic,strong) UIImageView *imageV;
@property (nonatomic,strong) UILabel *contentTitleLabel;

@end

@implementation HJBaseInfoHeaderView

- (void)hj_configSubViews {
    
    self.backgroundColor = white_color;
    
    UIImageView *liveImageV = [[UIImageView alloc] init];
    liveImageV.image = V_IMAGE(@"占位图");
    liveImageV.userInteractionEnabled = YES;
    [self addSubview:liveImageV];
    [liveImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(kWidth(10.0));
        make.top.equalTo(self).offset(kHeight(10.0));
        make.right.equalTo(self).offset(-kWidth(10.0));
        make.height.mas_equalTo(kHeight(200));
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
    [liveImageV addGestureRecognizer:tap];
    
    //底部占位的背景图
    UIView *bottomView = [UIView new];
    bottomView.backgroundColor = RGBA(0, 0, 0, 0.4);
    [liveImageV addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(liveImageV);
        make.height.mas_equalTo(kHeight(40.0));
    }];
    
    [liveImageV clipWithCornerRadius:kHeight(5.0) borderColor:nil borderWidth:0];
    
    //描述文字
    UILabel *desLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"股市心经之平常心",BoldFont(font(14)),white_color);
        label.textAlignment = NSTextAlignmentLeft;
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [bottomView addSubview:desLabel];
    [desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bottomView);
        make.left.equalTo(bottomView).offset(kWidth(10.0));
    }];
    
    self.imageV = liveImageV;
    self.contentTitleLabel = desLabel;
}

- (void)setModel:(HJInfoListModel *)model {
    _model = model;
    if(model){
        [self.imageV sd_setImageWithURL:URL(model.picurl) placeholderImage:V_IMAGE(@"占位图") options:SDWebImageRefreshCached];
        self.contentTitleLabel.text = model.infomationtitle;
    }
}

- (void)tapClick{
    if(MaJia) {
        if(_model.itemId) {
            NSDictionary *para = @{@"infoId" : _model.itemId
                                   };
            [DCURLRouter pushURLString:@"route://infoDetailVC" query:para animated:YES];
        }
        return;
    }
    HJInfoCheckPwdAlertView *alertView = [[HJInfoCheckPwdAlertView alloc] initWithTeacherId:_model.userid BindBlock:^(BOOL success) {
        if(_model.itemId) {
            NSDictionary *para = @{@"infoId" : _model.itemId
                                   };
            [DCURLRouter pushURLString:@"route://infoDetailVC" query:para animated:YES];
        }
    }];
    [alertView show];
}

@end
