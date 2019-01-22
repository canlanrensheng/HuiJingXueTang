//
//  HJFindSegmentView.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/10/30.
//  Copyright © 2018年 Junier. All rights reserved.
//

//#import "HJFindSegmentView.h"
//
//@interface HJFindSegmentView ()
//
//@property (nonatomic,strong) UIButton *classButton;
//@property (nonatomic,strong) UIButton *liveButton;
//
//@property (nonatomic,strong) UIButton *lastSelectButton;
//@property (nonatomic,strong) UIView *lineView;
//
//@end
//
//@implementation HJFindSegmentView
//
//- (void)hj_configSubViews {
//    self.backgroundColor = HEXColor(@"#141E2F");
//    self.lastSelectButton = self.classButton;
//    self.classButton.frame = CGRectMake(0, 0, Screen_Width / 2, self.bounds.size.height);
//    [self addSubview:self.classButton];
//    self.liveButton.frame = CGRectMake(Screen_Width / 2, 0, Screen_Width / 2, self.bounds.size.height);
//    [self addSubview:self.liveButton];
//
//    self.lineView.frame = CGRectMake(0, self.frame.size.height - kHeight(3.0), Screen_Width / 2 , kHeight(3.0));
//    [self addSubview:self.lineView];
//
//    self.lineView.centerX = self.lastSelectButton.centerX;
//
//
////    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"RefreshFindSegmentView" object:nil] subscribeNext:^(NSNotification * noty) {
////        NSDictionary *userInfo = noty.userInfo;
////        NSInteger index = [[userInfo valueForKey:@"index"] intValue];
////        if (index == 1) {
////            self.lastSelectButton = self.classButton;
////            self.lineView.centerX = self.lastSelectButton.centerX;
////        } else {
////            self.lastSelectButton = self.liveButton;
////            self.lineView.centerX = self.lastSelectButton.centerX;
////        }
////    }];
//}
//
//- (UIButton *)classButton{
//    if(!_classButton){
//        _classButton = [UIButton creatButton:^(UIButton *button) {
//            button.ljTitle_font_titleColor_state(@"推荐",MediumFont(font(15)),white_color,0);
//            @weakify(self);
//            [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//                @strongify(self);
//                self.lastSelectButton = button;
//                self.lineView.centerX = self.lastSelectButton.centerX;
//                [self.clickSubject sendNext:@(0)];
//            }];
//        }];
//    }
//    return _classButton;
//}
//
//- (UIButton *)liveButton{
//    if(!_liveButton){
//        _liveButton = [UIButton creatButton:^(UIButton *button) {
//            button.ljTitle_font_titleColor_state(@"关注",MediumFont(font(15)),white_color,0);
//            @weakify(self);
//            [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//                @strongify(self);
//                if([APPUserDataIofo AccessToken].length <= 0) {
//                    ShowMessage(@"您还未登录");
//                    [DCURLRouter pushURLString:@"route://loginVC" animated:YES];
//                    return;
//                }
//                self.lastSelectButton = button;
//                self.lineView.centerX = self.lastSelectButton.centerX;
//                [self.clickSubject sendNext:@(1)];
//            }];
//        }];
//    }
//    return _liveButton;
//}
//
//- (UIView *)lineView {
//    if(!_lineView){
//        _lineView = [[UIView alloc] init];
//        _lineView.backgroundColor = HEXColor(@"#FAD466");
//        [_lineView clipWithCornerRadius:kHeight(1.5) borderColor:nil borderWidth:0];
//    }
//    return _lineView;
//}
//
//- (RACSubject *)clickSubject {
//    if (!_clickSubject) {
//        _clickSubject = [RACSubject subject];
//    }
//    return _clickSubject;
//}
//
//
//@end


#import "HJFindSegmentView.h"

@interface HJFindSegmentView ()

@property (nonatomic,strong) UIButton *lastSelectButton;
@property (nonatomic,strong) UIView *lineView;
@property (nonatomic,strong) UIView *bottomLineView;

@property (nonatomic,copy) void (^backBlock)(NSInteger index);

@property (nonatomic,strong) NSMutableArray *buttonArray;

@end

@implementation HJFindSegmentView

- (NSMutableArray *)buttonArray {
    if(!_buttonArray) {
        _buttonArray = [NSMutableArray array];
    }
    return _buttonArray;
}

- (instancetype)initWithFrame:(CGRect)frame titleColor:(UIColor *)titleColor selectTitleColor:(UIColor *)selectTitleColor  lineColor:(UIColor *)lineColor  buttons:(NSArray *)itemButtons block:(void (^)(NSInteger index))block{
    if(self = [super initWithFrame:frame]) {
        _backBlock = block;
        self.backgroundColor = HEXColor(@"#141E2F");
        
        for (int i = 0;i < itemButtons.count; i++){
            UIButton *itemButton = [UIButton creatButton:^(UIButton *button) {
                button.ljTitle_font_titleColor_state(itemButtons[i],MediumFont(font(15)),white_color,0);
                button.titleLabel.font = MediumFont(font(15));
                [button setTitleColor:RGBA(255, 255, 255, 0.7) forState:UIControlStateNormal];
                [button setTitleColor:white_color forState:UIControlStateSelected];
                button.frame = CGRectMake(i * (Screen_Width / itemButtons.count), 0, Screen_Width / itemButtons.count, self.bounds.size.height);
                @weakify(self);
                [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                    @strongify(self);
                    self.lastSelectButton.selected = NO;
                    button.selected = YES;
                    self.lastSelectButton.titleLabel.font = MediumFont(font(15));
                    button.titleLabel.font = BoldFont(font(15));
                    [self.lastSelectButton setTitleColor:RGBA(255, 255, 255, 0.7) forState:UIControlStateNormal];
                    [button setTitleColor:white_color forState:UIControlStateNormal];
                    self.lastSelectButton = button;
                    self.lineView.centerX = self.lastSelectButton.centerX;
                    
                    if(self.backBlock) {
                        self.backBlock(i);
                    }
                }];
            }];
            if (i == 0) {
                [self.lastSelectButton setTitleColor:white_color forState:UIControlStateNormal];
                self.lastSelectButton = itemButton;
                self.lastSelectButton.selected = YES;
                self.lineView.frame = CGRectMake(0, self.frame.size.height - kHeight(3.0), self.bounds.size.width / 2 , kHeight(3.0));
                self.lineView.backgroundColor = lineColor;
                self.lineView.centerX = self.lastSelectButton.centerX;
                [self addSubview:self.lineView];
            }
            [self.buttonArray addObject:itemButton];
            [self addSubview:itemButton];
            [self addSubview:self.lineView];
        }
        
        
    }
    return  self;
}

- (void)setSelectIndex:(NSInteger)selectIndex {
    _selectIndex = selectIndex;
    UIButton *button = (UIButton *)[self.buttonArray objectAtIndex:selectIndex];
    self.lastSelectButton.selected = NO;
    [self.lastSelectButton setTitleColor:RGBA(255, 255, 255, 0.7) forState:UIControlStateNormal];
    button.selected = YES;
    self.lastSelectButton.titleLabel.font = MediumFont(font(15));
    button.titleLabel.font = BoldFont(font(15));
    [button setTitleColor:white_color forState:UIControlStateNormal];
    self.lastSelectButton = button;
    self.lineView.centerX = self.lastSelectButton.centerX;
}

- (UIView *)lineView {
    if(!_lineView){
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = HEXColor(@"#FAD466");
//        [_lineView clipWithCornerRadius:kHeight(1.5) borderColor:nil borderWidth:0];
    }
    return _lineView;
}


@end
