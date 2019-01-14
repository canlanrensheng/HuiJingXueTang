//
//  HJGiftRewardAlertView.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/20.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJGiftRewardAlertView.h"
#import "SMPageControl.h"
#import "HJGiftRewardAlertView.h"


typedef void (^backBlock)(NSDictionary *dict);

@interface HJGiftRewardAlertView ()<UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) SMPageControl *pagecontrol;

@property (nonatomic,strong) UIView * contentView;
@property (nonatomic,copy) backBlock backBlock;
@property (nonatomic,strong) NSMutableArray *dataArray;


@end

@implementation HJGiftRewardAlertView

- (HJGiftRewardAlertView*)initWithDataArray:(NSMutableArray *)dataArray Block:(void(^)(NSDictionary *dict))block {
    
    HJGiftRewardAlertView * sheet = [[HJGiftRewardAlertView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) data:dataArray  block:block];
    [sheet set];
    return sheet;
}

- (void)show{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

- (void)set{
    [UIView animateWithDuration:0.3 animations:^{
        _contentView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - kHeight(205), [UIScreen mainScreen].bounds.size.width, kHeight(205));
        _contentView.backgroundColor = [UIColor whiteColor];
    }];
}

- (instancetype)initWithFrame:(CGRect)frame data:(NSMutableArray *)data block:(void(^)(NSDictionary *dict))block{
    _backBlock = block;
    _dataArray = (NSMutableArray *)data;
    if (self = [super initWithFrame:frame]) {
        UIView *back = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        back.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.4];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TapGesture)];
        [back addGestureRecognizer:tap];
        
        [self addSubview:back];
        
        _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height,  [UIScreen mainScreen].bounds.size.width,kHeight(205))];
        [self addSubview:_contentView];
        
        //礼物打赏
        UILabel *giftRewardLabel = [UILabel creatLabel:^(UILabel *label) {
            label.ljTitle_font_textColor(@"礼物打赏",MediumFont(font(15)),HEXColor(@"#333333"));
            label.textAlignment = NSTextAlignmentLeft;
            label.numberOfLines = 0;
            [label sizeToFit];
        }];
        [_contentView addSubview:giftRewardLabel];
        [giftRewardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_contentView).offset(kWidth(10));
            make.top.equalTo(_contentView).offset(kHeight(16));
            make.height.mas_equalTo(kHeight(15));
        }];
        
        //scrollView
        [_contentView addSubview:self.scrollView];
        [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_contentView).offset(kWidth(10));
            make.right.equalTo(_contentView).offset(-kWidth(10));
            make.top.equalTo(giftRewardLabel.mas_bottom).offset(kHeight(25));
            make.height.mas_equalTo(kHeight(110.0));
        }];
        
        [_contentView addSubview:self.pagecontrol];
        //    self.pagecontrol.backgroundColor = red_color;
        [self.pagecontrol mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_contentView);
            make.bottom.equalTo(_contentView).offset(-kHeight(15));
            make.size.mas_equalTo(CGSizeMake(Screen_Width, kHeight(15)));
        }];
    }
    return self;
}

- (void)TapGesture{
    [UIView animateWithDuration:0.5 animations:^{
        _contentView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, kHeight(205));
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if(_backBlock){
            //点击空白的回调
            _backBlock(nil);
        }
    }];
}

- (UIScrollView *)scrollView{
    if(!_scrollView){
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.scrollEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.backgroundColor = clear_color;
        _scrollView.contentSize = CGSizeMake((Screen_Width - kWidth(20))  * 3, kHeight(110));
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        CGFloat padding = kWidth(10);
        NSInteger picCount = 4;
        CGFloat width = (Screen_Width - kWidth(20) - (picCount - 1) * padding) / picCount;
        CGFloat height = kHeight(110);
        if(self.dataArray.count > 0) {
            for(int i = 0 ;i  < self.dataArray.count; i++){
                UIView *backView = [[UIView alloc] initWithFrame:CGRectMake((width + padding) * i, 0, width, height)];
                backView.backgroundColor = white_color;
                backView.tag = i;
                [_scrollView addSubview:backView];
                [backView clipWithCornerRadius:kHeight(5.0) borderColor:HEXColor(@"#EAEAEA") borderWidth:kHeight(1.0)];
                
                UITapGestureRecognizer *backViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backViewTap:)];
                [backView addGestureRecognizer:backViewTap];
                
                NSDictionary *dic = self.dataArray[i];
                //设置图片
                UIImageView *liveImageV = [[UIImageView alloc] init];
                liveImageV.backgroundColor = Background_Color;
                [liveImageV sd_setImageWithURL:URL([dic valueForKey:@"icon"]) placeholderImage:V_IMAGE(@"占位图") options:SDWebImageRefreshCached];
                [backView addSubview:liveImageV];
                [liveImageV mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.top.equalTo(backView).offset(kHeight(5.0));
                    make.right.equalTo(backView).offset(-kWidth(5.0));
                    make.height.mas_equalTo(width - kWidth(10));
                }];
                //设置标题
                UILabel *priceLabel = [UILabel creatLabel:^(UILabel *label) {
                    label.ljTitle_font_textColor(@"￥0",MediumFont(font(17)),HEXColor(@"#FF4400"));
                }];
                
                priceLabel.attributedText = [[NSString stringWithFormat:@"￥%@",[dic valueForKey:@"price"]] attributeWithStr:@"￥" color:HEXColor(@"#FF4400") font:MediumFont(font(10))];
                
                [backView addSubview:priceLabel];
                [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(backView).offset(-kWidth(2.0));
                    make.top.equalTo(liveImageV.mas_bottom).offset(kHeight(13));
                    make.height.mas_equalTo(kHeight(13));
                }];
            }
        }
        
    }
    return _scrollView;
}

- (void)backViewTap:(UITapGestureRecognizer *)tap {
    if(self.backBlock){
        if(self.dataArray.count > 0) {
            NSDictionary *dict = self.dataArray[tap.view.tag];
            _backBlock(dict);
            [self removeFromSuperview];
        }
    }
}

- (SMPageControl *)pagecontrol{
    if(!_pagecontrol){
        _pagecontrol = [[SMPageControl alloc]init];
        _pagecontrol.numberOfPages = 3;
        _pagecontrol.indicatorDiameter = 10;
        _pagecontrol.indicatorMargin = 10;
        _pagecontrol.alignment = SMPageControlAlignmentCenter;
        _pagecontrol.verticalAlignment = SMPageControlVerticalAlignmentBottom;
        [_pagecontrol setPageIndicatorImage:[UIImage imageWithColor:RGBA(34, 71, 107, 0.2)]];
        [_pagecontrol setCurrentPageIndicatorImage:[UIImage imageWithColor:HEXColor(@"#22476B")]];
        _pagecontrol.userInteractionEnabled = NO;
        [_pagecontrol addTarget:self action:@selector(pageControlChanged:) forControlEvents:UIControlEventEditingChanged];
    }
    return  _pagecontrol;
}

- (void)pageControlChanged:(UIPageControl*)sender{
    //计算scrollview相应地contentOffset
    CGFloat x = sender.currentPage * self.scrollView.frame.size.width;
    self.scrollView.contentOffset = CGPointMake(x,0);
}

#pragma mark - scrollView的代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //计算pagecontroll相应地页(滚动视图可以滚动的总宽度/单个滚动视图的宽度=滚动视图的页数)
    NSInteger currentPage = (int)(scrollView.contentOffset.x) / (int)((self.bounds.size.width - kWidth(20)));
    self.pagecontrol.currentPage = currentPage;//将上述的滚动视图页数重新赋给当
}


@end

