//
//  HJShareMakeMoneyBotttomView.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/23.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJShareMakeMoneyBotttomView.h"
#import "HJTextAndPicButoton.h"
@interface HJShareMakeMoneyBotttomView ()

@property (nonatomic,strong) HJTextAndPicButoton *lastSelectButton;

@property (nonatomic,copy) void (^backBlock)(NSInteger index);
@property (nonatomic,strong) NSMutableArray *buttonArray;

@end

@implementation HJShareMakeMoneyBotttomView

- (NSMutableArray *)buttonArray {
    if (!_buttonArray) {
        _buttonArray = [NSMutableArray array];
    }
    return  _buttonArray;
}

- (instancetype)initWithFrame:(CGRect)frame titleColor:(UIColor *)titleColor selectTitleColor:(UIColor *)selectTitleColor  imges:(NSArray *)imges selectImges:(NSArray *)selectImges buttons:(NSArray *)itemButtons block:(void (^)(NSInteger index))block{
    if(self = [super initWithFrame:frame]) {
        _backBlock = block;
        self.backgroundColor = white_color;
    
        for (int i = 0;i < itemButtons.count; i++){
            UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(i * (Screen_Width / itemButtons.count), 0, (Screen_Width / itemButtons.count), self.bounds.size.height)];
            [self addSubview:backView];

            HJTextAndPicButoton *itemButton = [[HJTextAndPicButoton alloc] initWithFrame:CGRectMake(0, 0, kWidth(20.0), kHeight(33.0)) type:HJTextAndPicButotonTypePicTop  picSize:CGSizeMake(kWidth(19.0), kHeight(18.0)) textSize:CGSizeMake(kWidth(20.0), kHeight(10.0)) space:kHeight(5.0) picName:imges[i] selctPicName:selectImges[i] text:itemButtons[i] selectText:itemButtons[i]  textColor:titleColor selectTextColor:selectTitleColor font:MediumFont(font(10)) selectFont:BoldFont(font(10))];
            itemButton.tag = i;
            [backView addSubview:itemButton];

            [itemButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(backView);
                make.size.mas_equalTo(CGSizeMake(kWidth(20.0), kHeight(33.0)));
            }];

            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemBtnClick:)];
            [itemButton addGestureRecognizer:tap];

            if (i == 0) {
                self.lastSelectButton = itemButton;
                self.lastSelectButton.select = YES;
            }
            [self.buttonArray addObject:itemButton];
        }
    }
    return self;
}

- (void)itemBtnClick:(UITapGestureRecognizer *)tap {
    HJTextAndPicButoton *selectView = (HJTextAndPicButoton *)tap.view;
    self.lastSelectButton.select = NO;
    selectView.select = YES;
    self.lastSelectButton = selectView;
    if(self.backBlock) {
        self.backBlock(selectView.tag);
    }
}

- (void)setSelectIndex:(NSInteger)selectIndex {
    _selectIndex = selectIndex;
    HJTextAndPicButoton *button = (HJTextAndPicButoton *)[self.buttonArray objectAtIndex:selectIndex];
    self.lastSelectButton.select = NO;
    button.select = YES;
    self.lastSelectButton = button;
}

@end
