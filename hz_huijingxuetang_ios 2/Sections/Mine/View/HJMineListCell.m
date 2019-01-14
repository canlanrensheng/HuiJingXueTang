//
//  HJMineListCell.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/7.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJMineListCell.h"

@interface HJMineListCell ()

@property (nonatomic,strong) UILabel *textTitleLabel;
@property (nonatomic,strong) UILabel *detailTitleLabel;

@end

@implementation HJMineListCell

- (void)hj_configSubViews {
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    UILabel *textTitleLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@"我的关注",MediumFont(font(15)),HEXColor(@"#333333"));
        label.textAlignment = NSTextAlignmentLeft;
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [self addSubview:textTitleLabel];
    [textTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(kWidth(10));
        make.centerY.equalTo(self);
    }];
    self.textTitleLabel = textTitleLabel;
    
    UILabel *detailTitleLabel = [UILabel creatLabel:^(UILabel *label) {
        label.ljTitle_font_textColor(@" ",MediumFont(font(11)),HEXColor(@"#999999"));
        label.textAlignment = NSTextAlignmentRight;
        label.numberOfLines = 0;
        [label sizeToFit];
    }];
    [self addSubview:detailTitleLabel];
    [detailTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-kWidth(32));
        make.centerY.equalTo(self);
    }];
    self.detailTitleLabel = detailTitleLabel;
}

- (void)setViewModel:(BaseViewModel *)viewModel indexPath:(NSIndexPath *)indexPath {
    if(MaJia) {
        if(indexPath.section == 0) {
            if(indexPath.row == 0){
                self.textTitleLabel.text = @"我的关注";
            } else {
                self.textTitleLabel.text = @"历史观看";
            }
            self.detailTitleLabel.hidden = YES;
        } else{
            self.textTitleLabel.text = @"问题反馈";
            self.detailTitleLabel.hidden = NO;
            self.detailTextLabel.text = [APPUserDataIofo Problembacktime];
        }
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [self.detailTitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-kWidth(32));
            make.centerY.equalTo(self);
        }];
    } else {
        if(indexPath.section == 0) {
            if(indexPath.row == 0){
                self.textTitleLabel.text = @"我的关注";
            } else {
                self.textTitleLabel.text = @"历史观看";
            }
            self.detailTitleLabel.hidden = YES;
            self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [self.detailTitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self).offset(-kWidth(32));
                make.centerY.equalTo(self);
            }];
        } else if (indexPath.section == 1) {
            if(indexPath.row == 0){
                self.textTitleLabel.text = @"我的订单";
            } else {
                self.textTitleLabel.text = @"我的卡券";
            }
            self.detailTitleLabel.hidden = YES;
            self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [self.detailTitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self).offset(-kWidth(32));
                make.centerY.equalTo(self);
            }];
        } else {
            if (indexPath.row == 0 ){
                //问题反馈
                self.textTitleLabel.text = @"问题反馈";
                self.detailTitleLabel.hidden = NO;
                self.detailTitleLabel.text = [APPUserDataIofo Problembacktime];
                self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                [self.detailTitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(self).offset(-kWidth(32));
                    make.centerY.equalTo(self);
                }];
            } else {
                 if([APPUserDataIofo Eval].integerValue == 0) {
                    //没有风险评估
                     self.textTitleLabel.text = @"风险评估";
                     self.detailTitleLabel.hidden = YES;
                     self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                     [self.detailTitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                         make.right.equalTo(self).offset(-kWidth(32));
                         make.centerY.equalTo(self);
                     }];
                 } else {
                    //已经做过风险评估
                     self.textTitleLabel.text = @"风险评估";
                     self.detailTitleLabel.text = @"已评估";
                     self.detailTitleLabel.hidden = NO;
                     self.accessoryType = UITableViewCellAccessoryNone;
                     [self.detailTitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                         make.right.equalTo(self).offset(-kWidth(20));
                         make.centerY.equalTo(self);
                     }];
                 }
            }
        }
    }
}

@end
