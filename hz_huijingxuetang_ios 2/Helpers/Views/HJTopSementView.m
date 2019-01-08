//
//  HJTopSementView.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/9.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJTopSementView.h"

@interface HJTopSementView ()

@property (nonatomic,strong) UIButton *lastSelectButton;
@property (nonatomic,strong) UIView *lineView;
@property (nonatomic,strong) UIView *bottomLineView;

@property (nonatomic,copy) void (^backBlock)(NSInteger index);

@property (nonatomic,strong) NSMutableArray *buttonArray;

@end

@implementation HJTopSementView

- (NSMutableArray *)buttonArray {
    if(!_buttonArray) {
        _buttonArray = [NSMutableArray array];
    }
    return _buttonArray;
}

- (instancetype)initWithFrame:(CGRect)frame titleColor:(UIColor *)titleColor selectTitleColor:(UIColor *)selectTitleColor  lineColor:(UIColor *)lineColor  buttons:(NSArray *)itemButtons block:(void (^)(NSInteger index))block{
    if(self = [super initWithFrame:frame]) {
        _backBlock = block;
        self.backgroundColor = white_color;
        
        for (int i = 0;i < itemButtons.count; i++){
            UIButton *itemButton = [UIButton creatButton:^(UIButton *button) {
                button.ljTitle_font_titleColor_state(itemButtons[i],MediumFont(font(15)),white_color,0);
                button.titleLabel.font = MediumFont(font(15));
                [button setTitleColor:titleColor forState:UIControlStateNormal];
                [button setTitleColor:selectTitleColor forState:UIControlStateSelected];
                button.frame = CGRectMake(i * (Screen_Width / itemButtons.count), 0, Screen_Width / itemButtons.count, self.bounds.size.height);
                @weakify(self);
                [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                    @strongify(self);
                    self.lastSelectButton.selected = NO;
                    button.selected = YES;
                    self.lastSelectButton.titleLabel.font = MediumFont(font(15));
                    button.titleLabel.font = BoldFont(font(15));
                    self.lastSelectButton = button;
                    self.lineView.centerX = self.lastSelectButton.centerX;
                    
                    if(self.backBlock) {
                        self.backBlock(i);
                    }
                }];
            }];
            if (i == 0) {
                self.lastSelectButton = itemButton;
                self.lastSelectButton.selected = YES;
                self.lastSelectButton.titleLabel.font = BoldFont(font(15));
                
                self.lineView.frame = CGRectMake(0, self.frame.size.height - kHeight(2.0 + 5.0), kWidth(20.0) , kHeight(2.0));
                self.lineView.backgroundColor = lineColor;
                self.lineView.centerX = self.lastSelectButton.centerX;
                [self addSubview:self.lineView];
            }
            [self.buttonArray addObject:itemButton];
            [self addSubview:itemButton];
            [self addSubview:self.lineView];
            self.bottomLineView.frame = CGRectMake(0, self.frame.size.height - kHeight(1.0), Screen_Width , kHeight(1.0));
            [self addSubview:self.bottomLineView];
        }
       
        
    }
    return  self;
}

- (void)setSelectIndex:(NSInteger)selectIndex {
    _selectIndex = selectIndex;
    UIButton *button = (UIButton *)[self.buttonArray objectAtIndex:selectIndex];
    self.lastSelectButton.selected = NO;
    button.selected = YES;
    self.lastSelectButton.titleLabel.font = MediumFont(font(15));
    button.titleLabel.font = BoldFont(font(15));
    self.lastSelectButton = button;
    self.lineView.centerX = self.lastSelectButton.centerX;
}

- (UIView *)lineView {
    if(!_lineView){
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = HEXColor(@"#EAEAEA");
        [_lineView clipWithCornerRadius:kHeight(1.0) borderColor:nil borderWidth:0];
    }
    return _lineView;
}

- (UIView *)bottomLineView {
    if(!_bottomLineView){
        _bottomLineView = [[UIView alloc] init];
        _bottomLineView.backgroundColor = HEXColor(@"#EAEAEA");
    }
    return _bottomLineView;
}


@end
