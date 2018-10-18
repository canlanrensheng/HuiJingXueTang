//
//  ShopCartCell.m
//  HuiJingSchool
//
//  Created by 陈燕军 on 2018/5/28.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "ShopCartCell.h"

@implementation ShopCartCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _selbtn = [[UIButton alloc]init];
        [_selbtn setImage:[UIImage imageNamed:@"uncheck"] forState:UIControlStateNormal];
        [_selbtn setImage:[UIImage imageNamed:@"check"] forState:UIControlStateSelected];
        [self addSubview:_selbtn];

        _imgview = [[UIImageView alloc]init];
        [self addSubview:_imgview];
        
        _textview = [[UILabel alloc]init];

        _textview.font = FONT(15);
        [self addSubview:_textview];
        
        _pricelabel = [[UILabel alloc]init];
        _pricelabel.font = FONT(15);
        [self addSubview:_pricelabel];
        
        _delbtn = [[UIButton alloc]init];
        [_delbtn setImage:[UIImage imageNamed:@"ShopCartdelete"] forState:UIControlStateNormal];
        [self addSubview:_delbtn];
        
    }
    return self;
}


-(void)layoutSubviews{
    [super layoutSubviews];
    _selbtn.frame = CGRectMake(0, 15*SW, 60*SW, 60*SW);
    
    _imgview.frame = CGRectMake(_selbtn.maxX, 15*SW, 90*SW, 60*SW);
    
    _textview.lineBreakMode = UILineBreakModeWordWrap;
    _textview.numberOfLines = 2;
    _textview.frame = CGRectMake(_imgview.maxX +10*SW, 15*SW, kW - _imgview.maxX - 10*SW - 80*SW, 20*SW);
    [_textview sizeToFit];

    
    _pricelabel.frame = CGRectMake(_imgview.maxX +10*SW, 55*SW, kW - _imgview.maxX - 10*SW - 80*SW, 20*SW);
    
    _delbtn.frame = CGRectMake(kW - 70*SW, 15*SW, 60*SW, 60*SW);

}
@end
