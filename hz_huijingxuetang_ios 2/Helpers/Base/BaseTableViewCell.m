//
//  BaseTableViewCell.m
//  ZhuanMCH
//
//  Created by txooo on 16/12/14.
//  Copyright © 2016年 张金山. All rights reserved.
//

#import "BaseTableViewCell.h"

@implementation BaseTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self hj_configSubViews];
    }
    return self;
}

- (void)hj_configSubViews{}

- (void)setViewModel:(BaseViewModel *)viewModel indexPath:(NSIndexPath *)indexPath{}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (RACSubject *)backSubject {
    if(!_backSubject) {
        _backSubject = [[RACSubject alloc] init];
    }
    return  _backSubject;
}

- (JSLoadingView *)loadingView{
    if (!_loadingView) {
        _loadingView = [[JSLoadingView alloc] init];
        _loadingView.backgroundColor = clear_color;
        [self addSubview:_loadingView];
        [_loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(self);
            make.width.mas_equalTo(self);
            make.height.mas_equalTo(self);
        }];
    }
    return _loadingView;
}


@end
