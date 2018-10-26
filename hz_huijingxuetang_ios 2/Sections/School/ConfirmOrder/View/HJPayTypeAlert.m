//
//  HJPayTypeAlert.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/10/24.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJPayTypeAlert.h"

typedef void (^backBlock)(NSInteger type);

@interface HJPayTypeAlert ()

@property (nonatomic,strong) UIView * contentView;
@property (nonatomic,copy) backBlock backBlock;
@property (nonatomic,strong) UIButton *lastSelectButton;

@end

@implementation HJPayTypeAlert

- (HJPayTypeAlert*)initWithBlock:(void(^)(PayType payType))block{
    HJPayTypeAlert * sheet = [[HJPayTypeAlert alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)  block:block];
    [sheet set];
    return sheet;
}

- (void)show {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

- (void)set{
    [UIView animateWithDuration:0.3 animations:^{
        _contentView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height -kHeight(205), [UIScreen mainScreen].bounds.size.width, kHeight(205));
        _contentView.backgroundColor = [UIColor whiteColor];
    }];
}

- (instancetype)initWithFrame:(CGRect)frame block:(void(^)(PayType payType))block{
    _backBlock = block;
    if (self = [super initWithFrame:frame]) {
        UIView *back = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        back.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.3];

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TapGesture)];
        [back addGestureRecognizer:tap];
        
        [self addSubview:back];
        
        _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height,  [UIScreen mainScreen].bounds.size.width,kHeight(205))];
        [self addSubview:_contentView];
        
        //支付方式
        UILabel *warnLabel = [UILabel creatLabel:^(UILabel *label) {
            label.ljTitle_font_textColor(@"选择支付方式",BoldFont(font(15)),HEXColor(@"#333333"));
            label.textAlignment = NSTextAlignmentLeft;
            label.numberOfLines = 1.0;
            [label sizeToFit];
        }];
        [_contentView addSubview:warnLabel];
        [warnLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_contentView).offset(kHeight(16.0));
            make.left.equalTo(_contentView).offset(kWidth(10.0));
            make.height.mas_equalTo(kHeight(15.0));
        }];
 
        //
        for (int i = 0 ;i < 2;i++ ){
            UIView *backView = [[UIView alloc] init];
            backView.frame = CGRectMake(i, i * kHeight(45) + kHeight(45), Screen_Width, kHeight(45));
            backView.backgroundColor = white_color;
            [_contentView addSubview:backView];
            
            UIImageView *imav = [[UIImageView alloc] init];
            imav.image = V_IMAGE(@"支付宝");
            [backView addSubview:imav];
            [imav mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(backView);
                make.left.equalTo(back).offset(kWidth(20));
            }];
            
            UILabel *payTypeLabel = [UILabel creatLabel:^(UILabel *label) {
                label.ljTitle_font_textColor(@"支付宝支付",BoldFont(font(11)),HEXColor(@"#22476B"));
                label.textAlignment = NSTextAlignmentLeft;
                label.numberOfLines = 1.0;
                [label sizeToFit];
            }];
            [backView addSubview:payTypeLabel];
            [payTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(backView);
                make.left.equalTo(imav.mas_right).offset(kWidth(15));
            }];
            
            UIButton *selectButton = [UIButton creatButton:^(UIButton *button) {
                button.ljTitle_font_titleColor_state(@"",H15,clear_color,0);
                [button setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
                [button setImage:[UIImage imageNamed:@"勾选"] forState:UIControlStateSelected];
                @weakify(self);
                [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                    @strongify(self);
                    self.lastSelectButton.selected = NO;
                    button.selected = YES;
                    self.lastSelectButton = button;
                }];
            }];
            [backView addSubview:selectButton];
            [selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(backView);
                make.right.equalTo(backView).offset(-kWidth(20.0));
                make.width.height.mas_equalTo(kHeight(15.0));
            }];
            
            if(i == 0) {
                imav.image = V_IMAGE(@"支付宝");
                payTypeLabel.text = @"支付宝支付";
                self.lastSelectButton = selectButton;
                self.lastSelectButton.selected = YES;
            } else {
                imav.image = V_IMAGE(@"微信支付");
                payTypeLabel.text = @"微信支付";
            }
            
        }
        
        UIButton *payButton = [UIButton creatButton:^(UIButton *button) {
            button.ljTitle_font_titleColor_state(@"去支付",MediumFont(font(13)),white_color,0);
            [button clipWithCornerRadius:kHeight(2.5) borderColor:nil borderWidth:0];
            button.backgroundColor = HEXColor(@"#FF4400");
            @weakify(self);
            [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                @strongify(self);
                
            }];
        }];
        [_contentView addSubview:payButton];
        [payButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_contentView).offset(kWidth(10));
            make.height.mas_equalTo(kHeight(40.0));
            make.right.equalTo(_contentView).offset(-kWidth(10.0));
            make.bottom.equalTo(_contentView).offset(-kHeight(15));
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
        _contentView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, kHeight(205));
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if(_backBlock){
            //点击空白的回调
            _backBlock(-1);
        }
    }];
}


@end

