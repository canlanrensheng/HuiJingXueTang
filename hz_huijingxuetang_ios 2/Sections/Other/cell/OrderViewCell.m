//
//  OrderViewCell.m
//  HuiJingSchool
//
//  Created by 陈燕军 on 2018/5/28.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "OrderViewCell.h"

@implementation OrderViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self  = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _imgview = [[UIImageView alloc]init];
        [self addSubview:_imgview];
        
        _textview = [[UITextView alloc]init];
        _textview.font = FONT(15);
        [self addSubview:_textview];
        
        _pricelabel = [[UILabel alloc]init];
        _pricelabel.textAlignment = 2;
        _pricelabel.textColor = NavAndBtnColor;
        [self addSubview:_pricelabel];
    }
    return self;
}


-(void)layoutSubviews{
    [super layoutSubviews];
    _imgview.frame = CGRectMake(15*SW, 15*SW, 90*SW, 60*SW);
    
    _pricelabel.frame = CGRectMake(self.width -  110*SW, _imgview.minY, 100*SW, 60*SW);
    
    _textview.frame = CGRectMake(_imgview.maxX + 5*SW, _imgview.minY,self.width - _imgview.maxX - 5*SW - 120*SW, 60*SW);

    
    
}
@end
