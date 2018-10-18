//
//  OrderListCell.m
//  HuiJingSchool
//
//  Created by 陈燕军 on 2018/6/1.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "OrderListCell.h"

@implementation OrderListCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self  = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _imgview = [[UIImageView alloc]init];
        [self addSubview:_imgview];
        
        _textview = [[UILabel alloc]init];
        _textview.font = FONT(15);
        [self addSubview:_textview];
        
        _pricelabel = [[UILabel alloc]init];
        _pricelabel.textColor = NavAndBtnColor;
        _pricelabel.font = FONT(15);
        [self addSubview:_pricelabel];
        
        UIView *ln = [[UIView alloc]initWithFrame:CGRectMake(0, 90*SW, kW, 0.5*SW)];
        ln.backgroundColor = LnColor;
        [self addSubview:ln];
        
        _paybtn = [[UIButton alloc]initWithFrame:CGRectMake(kW - 100*SW, 100*SW, 90*SW, 30*SW)];
        [_paybtn setTitle:@"立即支付" forState:UIControlStateNormal];
        [self addSubview:_paybtn];
        
        _delbtn = [[UIButton alloc]initWithFrame:CGRectMake(_paybtn.minX - 95*SW, 100*SW, 90*SW, 30*SW)];
        [_delbtn setTitle:@"删除订单" forState:UIControlStateNormal];
        [self addSubview:_delbtn];
        
        _infobtn = [[UIButton alloc]initWithFrame:CGRectMake(_delbtn.minX - 95*SW, 100*SW, 90*SW, 30*SW)];
        [_infobtn setTitle:@"查看详情" forState:UIControlStateNormal];
        [self addSubview:_infobtn];
        
        _timelabel = [[UILabel alloc]init];
        _timelabel.font = FONT(15);
        _timelabel.textColor = [UIColor redColor];
        [self addSubview:_timelabel];
    }
    return self;
}




-(void)layoutSubviews{
    [super layoutSubviews];
    _imgview.frame = CGRectMake(15*SW, 15*SW, 90*SW, 60*SW);

    _textview.lineBreakMode = UILineBreakModeWordWrap;
    _textview.numberOfLines = 2;
    _textview.frame = CGRectMake(_imgview.maxX +10*SW, 15*SW, kW - _imgview.maxX - 10*SW - 80*SW, 20*SW);
    [_textview sizeToFit];
    
    _pricelabel.frame = CGRectMake(_imgview.maxX +10*SW, 55*SW, kW - _imgview.maxX - 10*SW - 80*SW, 20*SW);
    
    _paybtn.layer.cornerRadius = 15*SW;
    _paybtn.layer.masksToBounds = YES;
    _paybtn.backgroundColor = NavAndBtnColor;
    _paybtn.titleLabel.font = FONT(15);
    
    _delbtn.layer.borderColor = [[UIColor redColor] CGColor];
    [_delbtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    _delbtn.layer.borderWidth = 1;
    _delbtn.layer.cornerRadius = 15*SW;
    _delbtn.layer.masksToBounds = YES;
    _delbtn.titleLabel.font = FONT(15);

    _infobtn.layer.borderColor = [NavAndBtnColor CGColor];
    _infobtn.layer.borderWidth = 1;
    _infobtn.layer.cornerRadius = 15*SW;
    [_infobtn setTitleColor:NavAndBtnColor forState:UIControlStateNormal];
    _infobtn.layer.masksToBounds = YES;
    _infobtn.titleLabel.font = FONT(15);

    _timelabel.frame = CGRectMake(15*SW, 100*SW, 200*SW, 30*SW);
    
}

-(void)setModel:(orderModel *)model{
    NSURL *url = [NSURL URLWithString:model.coursepic];
    [self.imgview sd_setImageWithURL:url];
    
    self.textview.text = model.coursename;
    
    self.pricelabel.text = [NSString stringWithFormat:@"总价：￥%.2f",[model.money doubleValue]];
    
    NSInteger state = [model.paystatus integerValue];
    if (state != 0) {
        _paybtn.hidden = YES;
        CGRect frame = _delbtn.frame;
        frame.origin.x = kW - 100*SW;
        _delbtn.frame = frame;
        if (state == 1) {
            _infobtn.hidden = NO;
            CGRect frame1 = _infobtn.frame;
            frame1.origin.x = kW - 195*SW;
            _infobtn.frame = frame1;
        }else{
            _infobtn.hidden = YES;
        }
    }else{
        _paybtn.hidden = NO;
        _infobtn.hidden = NO;
        CGRect frame = _delbtn.frame;
        frame.origin.x = kW - 195*SW;
        _delbtn.frame = frame;
        
        CGRect frame1 = _infobtn.frame;
        frame1.origin.x = kW - 195*SW-95*SW;
        _infobtn.frame = frame1;
    }
}
@end
