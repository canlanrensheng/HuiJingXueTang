//
//  HJMessageListCell.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/8.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJMessageListCell.h"
#import "HJMessageViewModel.h"
#import "HJMessageModel.h"

@interface HJMessageListCell ()

@property (nonatomic,strong) UIImageView *imgV;
@property (nonatomic,strong) UILabel *titleTextLabel;
@property (nonatomic,strong) UILabel *desTextLabel;
@property (nonatomic,strong) UILabel *redBotLabel;

@end

@implementation HJMessageListCell

- (void)hj_configSubViews {
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    UIImageView *liveImageV = [[UIImageView alloc] init];
    liveImageV.image = V_IMAGE(@"占位图");
    [self addSubview:liveImageV];
    [liveImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(kWidth(10));
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(kWidth(40), kHeight(40)));
    }];
    [liveImageV clipWithCornerRadius:kHeight(20.0) borderColor:nil borderWidth:0.0];
    
    self.imgV = liveImageV;
    
    //标题
    UILabel *titleTextLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"直播通知",MediumFont(font(13)),HEXColor(@"#333333"));
        label.textAlignment = TextAlignmentLeft;
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [self addSubview:titleTextLabel];
    [titleTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(liveImageV).offset(kHeight(4.0));
        make.left.equalTo(liveImageV.mas_right).offset(kWidth(11.0));
        make.height.mas_equalTo(kHeight(13));
    }];
    self.titleTextLabel = titleTextLabel;
    
    //描述
    UILabel *desTextLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"俞春老师正在直播",MediumFont(font(11)),HEXColor(@"#999999"));
        label.textAlignment = TextAlignmentLeft;
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [self addSubview:desTextLabel];
    [desTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleTextLabel.mas_bottom).offset(kHeight(9.0));
        make.left.equalTo(titleTextLabel);
        make.height.mas_equalTo(kHeight(11));
    }];
    self.desTextLabel = desTextLabel;
    
    //红色的按钮
    UILabel *redBotLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"0",MediumFont(font(11)),white_color);
        [label clipWithCornerRadius:kHeight(7.5) borderColor:nil borderWidth:0];
        label.textAlignment = TextAlignmentCenter;
        label.backgroundColor = HEXColor(@"#FF0000");
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [self addSubview:redBotLabel];
    [redBotLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kWidth(15), kHeight(15)));
        make.right.equalTo(self).offset(-kWidth(15));
        make.centerY.equalTo(self);
    }];
    self.redBotLabel = redBotLabel;
}

- (void)setViewModel:(BaseViewModel *)viewModel indexPath:(NSIndexPath *)indexPath {
    HJMessageViewModel *listViewModel = (HJMessageViewModel *)viewModel;
    HJMessageModel *model= listViewModel.messageArray[indexPath.row];
    if(model.type == 1) {
        //直播
        self.imgV.image = V_IMAGE(@"直播ICON2");
        self.titleTextLabel.text = @"直播通知";
        
    } else if (model.type == 2) {
        //订单
        self.imgV.image = V_IMAGE(@"订单ICON");
        self.titleTextLabel.text = @"订单通知";
        
    } else if (model.type == 3) {
        //讲师
        self.imgV.image = V_IMAGE(@"讲师ICON");
        self.titleTextLabel.text = @"讲师消息";
        
    } else {
        //与我有关
        self.imgV.image = V_IMAGE(@"与我相关ICON");
        self.titleTextLabel.text = @"与我相关";
    }
    self.desTextLabel.text = model.content;
    if(model.messCount == 0) {
        self.redBotLabel.hidden = YES;
    }else if(model.messCount < 10) {
        self.redBotLabel.hidden = NO;
        self.redBotLabel.text = [NSString stringWithFormat:@"%ld",(long)model.messCount];
        [self.redBotLabel clipWithCornerRadius:kHeight(7.5) borderColor:nil borderWidth:0];
        [self.redBotLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(kWidth(15), kHeight(15)));
            make.right.equalTo(self).offset(-kWidth(15));
            make.centerY.equalTo(self);
        }];
    } else if (model.messCount < 100) {
        self.redBotLabel.hidden = NO;
        self.redBotLabel.text = [NSString stringWithFormat:@"%ld",model.messCount];
        [self.redBotLabel clipWithCornerRadius:kHeight(7.5) borderColor:nil borderWidth:0];
        [self.redBotLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(kWidth(20), kHeight(15)));
            make.right.equalTo(self).offset(-kWidth(15));
            make.centerY.equalTo(self);
        }];
    } else  if(model.messCount > 99){
        self.redBotLabel.hidden = NO;
        self.redBotLabel.text = @"99+";
        [self.redBotLabel clipWithCornerRadius:kHeight(7.5) borderColor:nil borderWidth:0];
        [self.redBotLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(kWidth(28), kHeight(15)));
            make.right.equalTo(self).offset(-kWidth(15));
            make.centerY.equalTo(self);
        }];
    }
}

@end
