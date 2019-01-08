

#import "HJSchoolSementView.h"

@interface HJSchoolSementView ()

@property (nonatomic,strong) UIButton *lastSelectButton;
@property (nonatomic,strong) UIView *lineView;
@property (nonatomic,strong) UIView *bottomLineView;

@property (nonatomic,copy) void (^backBlock)(NSInteger index);

@property (nonatomic,strong) NSMutableArray *buttonArray;

@end

@implementation HJSchoolSementView

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
//                [button setTitleColor:selectTitleColor forState:UIControlStateSelected];
                button.frame = CGRectMake(i * (Screen_Width / itemButtons.count), 0, Screen_Width / itemButtons.count, self.bounds.size.height);
                @weakify(self);
                [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                    @strongify(self);
                    self.lastSelectButton.selected = NO;
                    button.selected = YES;
                    [self.lastSelectButton setTitleColor:RGBA(255, 255, 255, 0.7) forState:UIControlStateNormal];
                    self.lastSelectButton.titleLabel.font = MediumFont(font(15));
                    button.titleLabel.font = BoldFont(font(15));
                    self.lastSelectButton = button;
                    [button setTitleColor:white_color forState:UIControlStateNormal];
                    self.lineView.centerX = self.lastSelectButton.centerX;
                    
                    if(self.backBlock) {
                        self.backBlock(i);
                    }
                }];
            }];
            if (i == 0) {
                self.lastSelectButton.selected = YES;
                self.lastSelectButton = itemButton;
                [self.lastSelectButton setTitleColor:white_color forState:UIControlStateNormal];
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
    button.selected = YES;
    [self.lastSelectButton setTitleColor:RGBA(255, 255, 255, 0.7) forState:UIControlStateNormal];
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
        [_lineView clipWithCornerRadius:kHeight(1.5) borderColor:nil borderWidth:0];
    }
    return _lineView;
}



@end
