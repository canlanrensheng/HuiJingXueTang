//
//  TimeCountDownView.m
//  countDownDemo
//
//  Created by 孔凡列 on 15/12/9.
//  Copyright © 2015年 czebd. All rights reserved.
//

#import "TimeCountDownView.h"
// label数量
#define labelCount 3
#define separateLabelCount 2
#define padding 5
@interface TimeCountDownView (){
    // 定时器
    NSTimer *timer;
}
@property (nonatomic,strong)NSMutableArray *timeLabelArrM;
@property (nonatomic,strong)NSMutableArray *separateLabelArrM;
// day
@property (nonatomic,strong)UILabel *dayLabel;
// hour
@property (nonatomic,strong)UILabel *hourLabel;
// minues
@property (nonatomic,strong)UILabel *minuesLabel;
// seconds
@property (nonatomic,strong)UILabel *secondsLabel;

@end

@implementation TimeCountDownView

// 创建单例
+ (instancetype)shareCountDown{
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[TimeCountDownView alloc] init];
    });
    return instance;
}

+ (instancetype)countDown{
    return [[self alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //秒
        UILabel *miaoLabel = [UILabel creatLabel:^(UILabel *label) {
            label.ljTitle_font_textColor(@"05",MediumFont(font(11)),white_color);
            label.backgroundColor = HEXColor(@"#333740");
            label.textAlignment = NSTextAlignmentCenter;
            label.numberOfLines = 0;
            [label sizeToFit];
        }];
        [miaoLabel clipWithCornerRadius:kHeight(2.5) borderColor:nil borderWidth:0];
        [self addSubview:miaoLabel];
        [miaoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.equalTo(self).offset(-kWidth(10.0));
            make.size.mas_equalTo(CGSizeMake(kWidth(18), kHeight(15)));
        }];
        
        self.secondsLabel = miaoLabel;
    
        //分号
        UILabel *fenHaoLabel = [UILabel creatLabel:^(UILabel *label) {
            label.ljTitle_font_textColor(@":",BoldFont(font(11)),HEXColor(@"#333740"));
            label.textAlignment = NSTextAlignmentCenter;
            label.numberOfLines = 0;
            [label sizeToFit];
        }];
        [self addSubview:fenHaoLabel];
        [fenHaoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.equalTo(miaoLabel.mas_left).offset(-kWidth(5.0));
            make.size.mas_equalTo(CGSizeMake(kWidth(2), kHeight(15)));
        }];
    
        //分
        UILabel *fenLabel = [UILabel creatLabel:^(UILabel *label) {
            label.ljTitle_font_textColor(@"00",MediumFont(font(11)),white_color);
            label.backgroundColor = HEXColor(@"#333740");
            label.textAlignment = NSTextAlignmentCenter;
            label.numberOfLines = 0;
            [label sizeToFit];
        }];
        [fenLabel clipWithCornerRadius:kHeight(2.5) borderColor:nil borderWidth:0];
        [self addSubview:fenLabel];
        [fenLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.equalTo(fenHaoLabel.mas_right).offset(-kWidth(4.0));
            make.size.mas_equalTo(CGSizeMake(kWidth(18), kHeight(15)));
        }];
        
        self.minuesLabel = fenLabel;
    
        //分号
        UILabel *fenHaoLabel1 = [UILabel creatLabel:^(UILabel *label) {
            label.ljTitle_font_textColor(@":",BoldFont(font(11)),HEXColor(@"#333740"));
            label.textAlignment = NSTextAlignmentCenter;
            label.numberOfLines = 0;
            [label sizeToFit];
        }];
        [self addSubview:fenHaoLabel1];
        [fenHaoLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.equalTo(fenLabel.mas_left).offset(-kWidth(5.0));
            make.size.mas_equalTo(CGSizeMake(kWidth(2), kHeight(15)));
        }];
        
        //小时
        UILabel *hourLabel = [UILabel creatLabel:^(UILabel *label) {
            label.ljTitle_font_textColor(@"00",MediumFont(font(11)),white_color);
            label.backgroundColor = HEXColor(@"#333740");
            label.textAlignment = NSTextAlignmentCenter;
            label.numberOfLines = 0;
            [label sizeToFit];
        }];
        [hourLabel clipWithCornerRadius:kHeight(2.5) borderColor:nil borderWidth:0];
        [self addSubview:hourLabel];
        [hourLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.equalTo(fenHaoLabel1.mas_left).offset(-kWidth(4.0));
            make.size.mas_equalTo(CGSizeMake(kWidth(18), kHeight(15)));
        }];
        
        self.hourLabel = hourLabel;
        
        //天
        UILabel *dayLabel = [UILabel creatLabel:^(UILabel *label) {
            label.ljTitle_font_textColor(@"天",MediumFont(font(13)),HEXColor(@"#333333"));
            label.textAlignment = NSTextAlignmentCenter;
            label.numberOfLines = 0;
            [label sizeToFit];
        }];
        [self addSubview:dayLabel];
        [dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.equalTo(hourLabel.mas_left).offset(-kWidth(5.0));
            make.size.mas_equalTo(CGSizeMake(kWidth(12), kHeight(12)));
        }];
    
        //天
        UILabel *dayNumLabel = [UILabel creatLabel:^(UILabel *label) {
            label.ljTitle_font_textColor(@"05",MediumFont(font(11)),white_color);
            label.backgroundColor = HEXColor(@"#333740");
            label.textAlignment = NSTextAlignmentCenter;
            label.numberOfLines = 0;
            [label sizeToFit];
        }];
        [dayNumLabel clipWithCornerRadius:kHeight(2.5) borderColor:nil borderWidth:0];
        [self addSubview:dayNumLabel];
        [dayNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.equalTo(dayLabel.mas_left).offset(-kWidth(6.0));
            make.size.mas_equalTo(CGSizeMake(kWidth(18), kHeight(15)));
        }];
        
        self.dayLabel = dayNumLabel;
    
        //限时特惠
        UILabel *limitLabel = [UILabel creatLabel:^(UILabel *label) {
            label.ljTitle_font_textColor(@"限时特惠",MediumFont(font(11)),white_color);
            label.backgroundColor = HEXColor(@"#DC1E4F");
            label.textAlignment = NSTextAlignmentCenter;
            label.numberOfLines = 0;
            [label sizeToFit];
        }];
        [self addSubview:limitLabel];
        [limitLabel clipWithCornerRadius:kHeight(2.5) borderColor:nil borderWidth:0];
        [limitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.equalTo(dayNumLabel.mas_left).offset(-kWidth(10.0));
            make.size.mas_equalTo(CGSizeMake(kWidth(50), kHeight(15)));
        }];
       
    }
    return self;
}

- (void)setBackgroundImageName:(NSString *)backgroundImageName{
    _backgroundImageName = backgroundImageName;
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:backgroundImageName]];
    imageView.frame = self.bounds;
    [self addSubview:imageView];
}

// 拿到外界传来的时间戳
- (void)setTimestamp:(NSInteger)timestamp{
    _timestamp = timestamp;
    if (_timestamp != 0) {
        timer =[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timer:) userInfo:nil repeats:YES];
    }
}

-(void)timer:(NSTimer*)timerr{
    _timestamp--;
    [self getDetailTimeWithTimestamp:_timestamp];
    if (_timestamp == 0) {
        [timer invalidate];
        timer = nil;
        // 执行block回调
        self.timerStopBlock();
    }
}

- (void)getDetailTimeWithTimestamp:(NSInteger)timestamp{
    NSInteger ms = timestamp;
    NSInteger ss = 1;
    NSInteger mi = ss * 60;
    NSInteger hh = mi * 60;
    NSInteger dd = hh * 24;
    
    // 剩余的
    NSInteger day = ms / dd;// 天
    NSInteger hour = (ms - day * dd) / hh;// 时
    NSInteger minute = (ms - day * dd - hour * hh) / mi;// 分
    NSInteger second = (ms - day * dd - hour * hh - minute * mi) / ss;// 秒
    
    self.dayLabel.text = [NSString stringWithFormat:@"%@",[NSString convertDateSingleData:day]];
    self.hourLabel.text = [NSString stringWithFormat:@"%@",[NSString convertDateSingleData:hour]];
    self.minuesLabel.text = [NSString stringWithFormat:@"%@",[NSString convertDateSingleData:minute]];
    self.secondsLabel.text = [NSString stringWithFormat:@"%@",[NSString convertDateSingleData:second]];
    
}

//- (void)layoutSubviews{
//    [super layoutSubviews];
//    // 获得view的宽、高
//    CGFloat viewW = self.frame.size.width;
//    CGFloat viewH = self.frame.size.height;
//    // 单个label的宽高
//    CGFloat labelW = viewW / labelCount;
//    CGFloat labelH = viewH;
//    self.dayLabel.frame = CGRectMake(0, 0, labelW, labelH);
//    self.hourLabel.frame = CGRectMake(labelW, 0, labelW, labelH);
//    self.minuesLabel.frame = CGRectMake(2 * labelW , 0, labelW, labelH);
//    self.secondsLabel.frame = CGRectMake(3 * labelW, 0, labelW, labelH);
//    
//    for (NSInteger index = 0; index < self.separateLabelArrM.count ; index ++) {
//        UILabel *separateLabel = self.separateLabelArrM[index];
//        separateLabel.frame = CGRectMake((labelW - 1) * (index + 1), 0, 5, labelH);
//    }
//}


#pragma mark - setter & getter

//- (NSMutableArray *)timeLabelArrM{
//    if (_timeLabelArrM == nil) {
//        _timeLabelArrM = [[NSMutableArray alloc] init];
//    }
//    return _timeLabelArrM;
//}
//
//- (NSMutableArray *)separateLabelArrM{
//    if (_separateLabelArrM == nil) {
//        _separateLabelArrM = [[NSMutableArray alloc] init];
//    }
//    return _separateLabelArrM;
//}
//
//- (UILabel *)dayLabel{
//    if (_dayLabel == nil) {
//        _dayLabel = [[UILabel alloc] init];
//        _dayLabel.textAlignment = NSTextAlignmentCenter;
//    }
//    return _dayLabel;
//}
//
//- (UILabel *)hourLabel{
//    if (_hourLabel == nil) {
//        _hourLabel = [[UILabel alloc] init];
//        _hourLabel.textAlignment = NSTextAlignmentCenter;
//    }
//    return _hourLabel;
//}
//
//- (UILabel *)minuesLabel{
//    if (_minuesLabel == nil) {
//        _minuesLabel = [[UILabel alloc] init];
//        _minuesLabel.textAlignment = NSTextAlignmentCenter;
//    }
//    return _minuesLabel;
//}

//- (UILabel *)secondsLabel{
//    if (_secondsLabel == nil) {
//        _secondsLabel = [[UILabel alloc] init];
//        _secondsLabel.textAlignment = NSTextAlignmentCenter;
//    }
//    return _secondsLabel;
//}


@end
