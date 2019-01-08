//
//  ShareLinkAlertView.m
//  ITelematics
//
//  Created by Oma-002 on 2018/9/12.
//  Copyright © 2018年 com.lima. All rights reserved.
//

#import "ShareLinkAlertView.h"


typedef void (^backBlock)(NSInteger type);

#define KAlertHeight kHeight(240)

@interface ShareLinkAlertView ()

@property (nonatomic,strong) UIView * contentView;
@property (nonatomic,copy) backBlock backBlock;
@property (nonatomic,assign) ShareObjectType shareType;
@property (nonatomic,assign) CGFloat alertViewHeight;

@end

@implementation ShareLinkAlertView

- (ShareLinkAlertView*)initWithBlock:(void(^)(ShareObjectType shareObjectType))block {
    ShareLinkAlertView *sheet = [[ShareLinkAlertView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)  block:block];
    [sheet set];
    return sheet;
}

- (void)show{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

- (void)set{
    [UIView animateWithDuration:0.3 animations:^{
        _contentView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - KAlertHeight - KHomeIndicatorHeight, [UIScreen mainScreen].bounds.size.width, KAlertHeight);
//        _contentView.transform = CGAffineTransformMakeRotation(M_PI/2);
        _contentView.backgroundColor = [UIColor whiteColor];
    }];
}

- (instancetype)initWithFrame:(CGRect)frame block:(void(^)(ShareObjectType shareObjectType))block{
    _backBlock = block;
    if (self = [super initWithFrame:frame]) {
        UIView *back = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        back.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.3];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TapGesture)];
        [back addGestureRecognizer:tap];
        
        [self addSubview:back];
        
        _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - KHomeIndicatorHeight,  [UIScreen mainScreen].bounds.size.width,_alertViewHeight)];
        [self addSubview:_contentView];
    
        //链接
        CGFloat width = Screen_Width / 4;
        CGFloat height = kHeight(100.0);
        NSArray *moneyTextArray = @[@"微信",@"微信朋友圈",@"QQ",@"微博",@"复制链接"];
        NSArray *moneyImgArray = @[@"微信",@"朋友圈",@"qq",@"微博",@"复制链接"];
        for(int i = 0 ;i < moneyTextArray.count;i++){
            NSInteger hang = i / 4;
            NSInteger lie = i % 4;
            
            UIView *backView = [[UIView alloc] initWithFrame:CGRectMake((width + 1) * lie, hang * height, width, height)];
            backView.tag = i + 10;
            [_contentView addSubview:backView];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
            [backView addGestureRecognizer:tap];
            
            UIImageView *teamImageView = [[UIImageView alloc] init];
            teamImageView.image = V_IMAGE(moneyImgArray[i]);
            [backView addSubview:teamImageView];
            
            [teamImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(backView);
                make.size.mas_equalTo(CGSizeMake(kWidth(40), kWidth(40)));
                make.top.equalTo(backView).offset(kHeight(15));
            }];
            
            UILabel *moneyLabel = [UILabel creatLabel:^(UILabel *label) {
                label.ljTitle_font_textColor(moneyTextArray[i],MediumFont(font(11)),HEXColor(@"#333333"));
                label.textAlignment = TextAlignmentCenter;
                [label sizeToFit];
            }];
            [backView addSubview:moneyLabel];
            [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(backView);
                make.height.mas_equalTo(kHeight(12));
                make.top.equalTo(teamImageView.mas_bottom).offset(kHeight(10));
            }];
        }
        //取消按钮
        UIButton *cancalBtn = [[UIButton alloc] init];
        [cancalBtn setTitle:@"取消" forState:UIControlStateNormal];
        cancalBtn.backgroundColor = white_color;
        cancalBtn.titleLabel.font = MediumFont(font(13));
        [cancalBtn setTitleColor:HEXColor(@"#22476B") forState:UIControlStateNormal];
        [cancalBtn addTarget:self action:@selector(TapGesture) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:cancalBtn];
        [cancalBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_contentView).offset(KAlertHeight - kHeight(40));
            make.left.right.equalTo(_contentView);
            make.bottom.equalTo(_contentView);
        }];
        
        //分割线
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = HEXColor(@"#EAEAEA");
        [_contentView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(_contentView);
            make.top.equalTo(_contentView).offset(KAlertHeight - kHeight(40));
            make.height.mas_equalTo(kHeight(0.5));
        }];
    }
    return self;
}

- (void)tapClick:(UITapGestureRecognizer *)tap{
    if(self.backBlock){
        _backBlock(tap.view.tag - 10);
        [self TapGesture];
    }
}

- (void)TapGesture{
    [UIView animateWithDuration:0.5 animations:^{
        _contentView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - KHomeIndicatorHeight, [UIScreen mainScreen].bounds.size.width, self.alertViewHeight);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if(_backBlock){
            //点击空白的回调
            _backBlock(-1);
        }
    }];
}


@end
