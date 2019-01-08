//
//  MineListCell.m
//  MKnight
//
//  Created by 张金山 on 2018/1/19.
//  Copyright © 2018年 张金山. All rights reserved.
//

#import "MineListCell.h"

@interface MineListCell()
@property (nonatomic,strong) UIImageView *iconImageView;
@property (nonatomic,strong) UILabel *nameLabel;
@end

@implementation MineListCell

- (void)hj_configSubViews{
    [self addSubview:self.iconImageView];
    [self addSubview:self.nameLabel];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(kWidth(15));
//        make.size.mas_equalTo(CGSizeMake(36, 36));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.iconImageView);
        make.left.equalTo(self.iconImageView.mas_right).offset(kWidth(15));
    }];
}

- (void)setIndexPath:(NSIndexPath *)indexPath{
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    switch (indexPath.row) {
        case 0:{
            self.nameLabel.text = @"账号安全";
            self.iconImageView.image = V_IMAGE(@"icon_accountsecurity");
            
        }
            break;
        case 1:{
            self.nameLabel.text = @"意见反馈";
            self.iconImageView.image = V_IMAGE(@"icon_opinion_feedback");
        }
            break;
        case 2:{
            self.nameLabel.text = @"关于砺检宝";
            self.iconImageView.image = V_IMAGE(@"icon_aboutus");

        }
            break;
            
        default:{
            self.nameLabel.text = @"设置";
            self.iconImageView.image = V_IMAGE(@"icon_intercalate");

        }
            break;
    }
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [UILabel creatLabel:^(UILabel *label) {
            label.ljTitle_font_textColor(@" ",MediumFont(font(14)),RGBCOLOR(51, 51, 51));
            label.numberOfLines = 1;
            [label sizeToFit];
        }];
    }
    return _nameLabel;
}

- (UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        [_iconImageView sizeToFit];
//        _iconImageView.backgroundColor = RGBCOLOR(240, 240, 240);
//        _iconImageView.layer.cornerRadius = 18.0f;
//        _iconImageView.clipsToBounds = YES;
    }
    return _iconImageView;
}

@end
