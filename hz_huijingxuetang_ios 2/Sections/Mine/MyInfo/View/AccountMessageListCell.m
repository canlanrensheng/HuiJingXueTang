//
//  MineListCell.m
//  ZhuanMCH
//
//  Created by 张金山 on 16/9/7.
//  Copyright © 2016年 领琾. All rights reserved.
//

#import "AccountMessageListCell.h"
#import "AccountMessageViewModel.h"
#import "LJAvatarBrowser.h"
@interface AccountMessageListCell ()

@property (nonatomic,strong) UIImageView *iconImageView;

@end

@implementation AccountMessageListCell


-(void)hj_configSubViews {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    self.textLabel.font = H15;
    self.textLabel.text = @"";
    self.textLabel.textColor = Text_Color;
    
    UIImageView *iconImageView = [[UIImageView alloc] init];
    iconImageView.backgroundColor = Background_Color;
    [self addSubview:iconImageView];
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-kWidth(37));
        make.size.mas_equalTo(CGSizeMake(kWidth(30), kHeight(30)));
    }];
    [iconImageView clipWithCornerRadius:kHeight(15.0) borderColor:nil borderWidth:0];
    self.iconImageView = iconImageView;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    @weakify(self)
    [[tap rac_gestureSignal] subscribeNext:^(id x) {
        @strongify(self)
        [LJAvatarBrowser showImageView:self.iconImageView];
    }];
    [self.iconImageView addGestureRecognizer:tap];
    
}

- (void)setViewModel:(BaseViewModel *)viewModel indexPath:(NSIndexPath *)indexPath{
    AccountMessageViewModel *accountViewModel = (AccountMessageViewModel *)viewModel;
    self.textLabel.text = accountViewModel.dataArray[indexPath.section][indexPath.row];
    [self.iconImageView  sd_setImageWithURL:URL([APPUserDataIofo UserIcon]) placeholderImage:V_IMAGE(@"默认头像")];
}

@end

#import "AccountMessageViewModel.h"

@implementation MineListTextCell

- (void)hj_configSubViews {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    self.textLabel.font = MediumFont(font(15));
    self.textLabel.textColor = HEXColor(@"#333333");
    self.detailTextLabel.font = MediumFont(font(13));
    self.detailTextLabel.textColor = HEXColor(@"#666666");
    self.detailTextLabel.numberOfLines = 2;
}

- (void)setViewModel:(id)viewModel withIndexPath:(NSIndexPath *)indexPath{
    AccountMessageViewModel *accountViewModel = (AccountMessageViewModel *)viewModel;
    self.textLabel.text = accountViewModel.dataArray[indexPath.section][indexPath.row];
    if(indexPath.section == 0){
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if(indexPath.row == 1){
            self.detailTextLabel.text = [APPUserDataIofo nikename].length > 0 ? [APPUserDataIofo nikename] : @"未设置";
        }else{
            //性别
            self.detailTextLabel.text = [APPUserDataIofo sex].length > 0 ? [APPUserDataIofo sex] : @"未设置";
        }
    }else{
        if(indexPath.row == 0) {
            self.accessoryType = UITableViewCellAccessoryNone;
            self.detailTextLabel.text = [APPUserDataIofo phone].length > 0 ? [APPUserDataIofo phone] : @"未设置        ";
        } else {
            self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            self.detailTextLabel.text = [APPUserDataIofo Cityname].length > 0 ? [APPUserDataIofo Cityname] : @"未设置";
        }
//        self.detailTextLabel.text = [[[BMSingleObject shareInstance] GetUserInfo] objectForKey:@"sex"];
    }
}

@end

