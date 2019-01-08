//
//  HJSelectToUpdateVersionView.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/12/13.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJSelectToUpdateVersionView.h"

#import "HJVersionUpdateCell.h"
#define MYCOLOR(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define PX (SWIDTH / 1242)

@interface HJSelectToUpdateVersionView()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>{
    
    
}

@property (nonatomic,strong)  UIView *alertView;
@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,copy) NSString * versionNum;
@property (nonatomic,copy) NSString * versionUpdateContent;
@property (nonatomic,copy) NSString * link;
@property (nonatomic,strong) NSMutableArray *dataArray;

@end

@implementation HJSelectToUpdateVersionView


- (NSMutableArray *)dataArray {
    if(!_dataArray){
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //背景图
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sureBtnClick)];
        [_bgView addGestureRecognizer:tap];
        _bgView.userInteractionEnabled = YES;
        _bgView.backgroundColor = MYCOLOR(0, 0, 0, 0.6);
        [self addSubview:_bgView];
        
        //弹出视图
        
        UIImageView *alertView = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth(48), (Screen_Height - kHeight(394)) / 2, Screen_Width - kWidth(96), kHeight(394))];
        alertView.image = V_IMAGE(@"版本更新背景");
        alertView.centerY = _bgView.centerY;
        UITapGestureRecognizer * alertTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(alertTapClick)];
        alertView.userInteractionEnabled = YES;
        [alertView addGestureRecognizer:alertTap];
        [alertView setBackgroundColor:clear_color];
        alertView.layer.cornerRadius = kHeight(5.0);
        alertView.clipsToBounds = YES;
        [_bgView addSubview:alertView];
        
        _alertView.centerY = _bgView.centerY;
        CGRect rec = alertView.frame;
        rec.origin.x = (Screen_Width - rec.size.width) / 2;
        alertView.frame = rec;
        
        //框的试图
        UIImageView *kuangImagV = [[UIImageView alloc] init];
        kuangImagV.image = V_IMAGE(@"版本更新框");
        [alertView addSubview:kuangImagV];
        [kuangImagV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(alertView).offset(kHeight(147));
            make.centerX.equalTo(alertView);
            make.left.equalTo(alertView).offset(kWidth(20.0));
            make.right.equalTo(alertView).offset(-kWidth(20.0));
        }];
        
        if(self.versionUpdateContent.length > 0) {
            self.dataArray = (NSMutableArray *)[self.versionUpdateContent componentsSeparatedByString:@" "];
        }
        //更新的具体的内容
        [self.tableView registerClassCell:[HJVersionUpdateCell class]];
        [alertView addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kuangImagV).offset(kWidth(21.0));
            make.right.equalTo(kuangImagV).offset(-kWidth(21.0));
            make.top.equalTo(kuangImagV).offset(kHeight(25.0));
            make.bottom.equalTo(kuangImagV).offset(-kHeight(17.5));
        }];
        //        self.tableView.backgroundColor = red_color;
        [self.tableView reloadData];
        
        //更新内容的提示文字
        UILabel *updateTextLabel = [UILabel creatLabel:^(UILabel *label) {
            label.ljTitle_font_textColor(@"更新内容",BoldFont(font(15)),HEXColor(@"#666666"));
            label.textAlignment = NSTextAlignmentCenter;
            label.numberOfLines = 0;
            [label sizeToFit];
        }];
        [alertView addSubview:updateTextLabel];
        [updateTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(alertView);
            make.top.equalTo(alertView).offset(kHeight(139));
        }];
        
        //暂无更新的按钮
        UIButton *notToUpdateBtn = [UIButton creatButton:^(UIButton *button) {
            button.ljTitle_font_titleColor_state(@"暂不升级",MediumFont(font(13)),HEXColor(@"#999999"),0);
            button.backgroundColor = white_color;
            @weakify(self);
            [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                @strongify(self);
                [self removeFromSuperview];
            }];
        }];
        [notToUpdateBtn clipWithCornerRadius:kHeight(5.0) borderColor:HEXColor(@"#EAEAEA") borderWidth:kHeight(1.0)];
        [alertView addSubview:notToUpdateBtn];
        [notToUpdateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kuangImagV);
            make.top.equalTo(kuangImagV.mas_bottom).offset(kHeight(23));
            make.size.mas_equalTo(CGSizeMake(kWidth(110), kHeight(40)));
        }];
        
        //立即更新的按钮
        UIButton *nowToUpdateBtn = [UIButton creatButton:^(UIButton *button) {
            button.ljTitle_font_titleColor_state(@"立即升级",MediumFont(font(13)),white_color,0);
            button.backgroundColor = HEXColor(@"#3BBDF2");
            @weakify(self);
            [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                @strongify(self);
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.link.length > 0 ? self.link : @""]];
            }];
        }];
        [nowToUpdateBtn clipWithCornerRadius:kHeight(5.0) borderColor:HEXColor(@"#3BBDF2") borderWidth:0];
        [alertView addSubview:nowToUpdateBtn];
        [nowToUpdateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(kuangImagV);
            make.top.equalTo(kuangImagV.mas_bottom).offset(kHeight(23));
            make.size.mas_equalTo(CGSizeMake(kWidth(110), kHeight(40)));
        }];
        
        //版本号的展示
        UILabel *versionNumLabel = [UILabel creatLabel:^(UILabel *label) {
            label.ljTitle_font_textColor([NSString stringWithFormat:@"V %@",self.versionNum],MediumFont(font(10)),white_color);
            label.backgroundColor = HEXColor(@"#40BBF4");
            label.textAlignment = NSTextAlignmentCenter;
            label.numberOfLines = 0;
            [label sizeToFit];
        }];
        [versionNumLabel clipWithCornerRadius:kHeight(6.0) borderColor:HEXColor(@"#40BBF4") borderWidth:0.0];
        [alertView addSubview:versionNumLabel];
        [versionNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(alertView);
            make.bottom.equalTo(notToUpdateBtn.mas_top).offset(-kHeight(16));
            make.width.mas_equalTo(kHeight(45.0));
            make.height.mas_equalTo(kHeight(15));
        }];
        
        _alertView = alertView;
    }
    return self;
}

- (HJSelectToUpdateVersionView * )initWithVersionNum:(NSString *)versionNum versionUpdateContent:(NSString *)versionUpdateContent link:(NSString *)link bindBlock:(void(^)(BOOL success))bindBlock {
    self.versionNum = versionNum;
    self.versionUpdateContent = versionUpdateContent;
    self.link = link;
    HJSelectToUpdateVersionView *alretView = [self initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height)];
    _bindBlock = bindBlock;
    return alretView;
}

- (void)show{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    _alertView.centerY = _bgView.centerY;
    CGRect rec = _alertView.frame;
    rec.origin.x = (Screen_Width - rec.size.width) / 2;
    _alertView.frame = rec;
}

- (void)alertTapClick{
    
}

- (void)sureBtnClick{
    [self removeFromSuperview];
}

- (void)dismissView{
    [UIView animateWithDuration:0.5 animations:^{
        CGRect rec = self.alertView.frame;
        rec.origin.x = -(rec.size.width);
        self.alertView.frame = rec;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero
                                                 style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
        _tableView.backgroundColor = white_color;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
    }
    return _tableView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.dataArray.count > 0) {
        CGFloat height = [self.dataArray[indexPath.row] calculateSize:CGSizeMake(Screen_Width - kWidth(138.0), MAXFLOAT)  lineSpace:kHeight(3.0) font:MediumFont(font(11))].height;
        return height + kHeight(5.0);
    }
    return  kHeight(20.0);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HJVersionUpdateCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HJVersionUpdateCell class]) forIndexPath:indexPath];
    self.tableView.separatorColor = clear_color;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(indexPath.row < self.dataArray.count) {
        cell.versionContentLabel.text = self.dataArray[indexPath.row];
    }
    return cell;
}


@end





