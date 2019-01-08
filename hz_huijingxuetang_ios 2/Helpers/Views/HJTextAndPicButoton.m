//
//  HJTextAndPicButoton.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/12/18.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJTextAndPicButoton.h"

@interface HJTextAndPicButoton ()

@property (nonatomic,strong) UIImageView *imgV;
@property (nonatomic,strong) UILabel *textLabel;

@property (nonatomic,copy) NSString *picName;
@property (nonatomic,copy) NSString *selctPicName;
@property (nonatomic,strong) UIColor *textColor;
@property (nonatomic,strong) UIColor *selectTextColor;
@property (nonatomic,strong) UIFont *font;
@property (nonatomic,strong) UIFont *selectFont;

@property (nonatomic,copy) NSString *text;
@property (nonatomic,copy) NSString *selectText;

@property (nonatomic,assign) HJTextAndPicButotonType type;

@end

@implementation HJTextAndPicButoton

- (instancetype)initWithFrame:(CGRect)frame
                        type :(HJTextAndPicButotonType)type
                      picSize:(CGSize)picSize
                     textSize:(CGSize)textSize
                        space:(CGFloat)space
                      picName:(NSString *)picName
                 selctPicName:(NSString *)selctPicName
                         text:(NSString *)text
                   selectText:(NSString *)selectText
                    textColor:(UIColor *)textColor
              selectTextColor:(UIColor *)selectTextColor
                         font:(UIFont *)font
                   selectFont:(UIFont *)selectFont {
    if(self = [super initWithFrame:frame]) {
        self.type = type;
        self.picName = picName;
        self.selctPicName = selctPicName;
        self.textColor = textColor;
        self.selectTextColor = selectTextColor;
        self.font = font;
        self.text = text;
        self.selectText = selectText;
        self.selectFont = selectFont;
        [self setUpViewWithPicSize:picSize textSize:textSize space:space picName:picName selctPicName:selctPicName text:text selectText:selectText textColor:textColor selectTextColor:selectTextColor];
    }
    return self;
}

- (void)setUpViewWithPicSize:(CGSize)picSize
                    textSize:(CGSize)textSize
                       space:(CGFloat)space
                     picName:(NSString *)picName
                selctPicName:(NSString *)selctPicName
                        text:(NSString *)text
                  selectText:(NSString *)selectText
                   textColor:(UIColor *)textColor
             selectTextColor:(UIColor *)selectTextColor{
    
    if(self.type == HJTextAndPicButotonTypePicLeft) {
        //图左文字右
        UIImageView *imV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, picSize.width, picSize.height)];
        imV.image = V_IMAGE(picName);
        [self addSubview:imV];
        [imV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(picSize);
            make.centerY.equalTo(self);
//            make.top.equalTo(self);
            make.left.equalTo(self);
        }];
        self.imgV = imV;
        
        UILabel *textLabel = [UILabel creatLabel:^(UILabel *label) {
            label.ljTitle_font_textColor(text,self.font,self.textColor);
            label.textAlignment = NSTextAlignmentLeft;
            label.numberOfLines = 0;
            [label sizeToFit];
        }];
        [self addSubview:textLabel];
        [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(imV);
            make.left.equalTo(imV.mas_right).offset(space);
            make.size.mas_equalTo(textSize);
        }];
        self.textLabel = textLabel;
    } else if (self.type == HJTextAndPicButotonTypePicTop) {
        //图上文字下
        UIImageView *imV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, picSize.width, picSize.height)];
        imV.image = V_IMAGE(picName);
        [self addSubview:imV];
        [imV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(picSize);
            make.centerX.equalTo(self);
            make.top.equalTo(self);
        }];
        self.imgV = imV;
        
        UILabel *textLabel = [UILabel creatLabel:^(UILabel *label) {
            label.ljTitle_font_textColor(text,self.font,self.textColor);
            label.textAlignment = NSTextAlignmentCenter;
            label.numberOfLines = 0;
            [label sizeToFit];
        }];
        [self addSubview:textLabel];
        [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(imV);
            make.top.equalTo(imV.mas_bottom).offset(space);
            make.size.mas_equalTo(textSize);
        }];
        self.textLabel = textLabel;
    } else if (self.type == HJTextAndPicButotonTypePicRight) {
        //图右文字左
        UIImageView *imV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, picSize.width, picSize.height)];
        imV.image = V_IMAGE(picName);
        [self addSubview:imV];
        [imV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(picSize);
            make.centerY.equalTo(self);
            make.right.equalTo(self);
        }];
        self.imgV = imV;
        
        UILabel *textLabel = [UILabel creatLabel:^(UILabel *label) {
            label.ljTitle_font_textColor(text,self.font,self.textColor);
            label.textAlignment = NSTextAlignmentLeft;
            label.numberOfLines = 0;
            [label sizeToFit];
        }];
        [self addSubview:textLabel];
        [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(imV);
            make.right.equalTo(imV.mas_left).offset(-space);
            make.size.mas_equalTo(textSize);
        }];
        self.textLabel = textLabel;
        
    } else if ( self.type == HJTextAndPicButotonTypePicBottom) {
        //图下文字上
        UIImageView *imV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, picSize.width, picSize.height)];
        imV.image = V_IMAGE(picName);
        [self addSubview:imV];
        [imV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(picSize);
            make.centerX.equalTo(self);
            make.bottom.equalTo(self);
        }];
        self.imgV = imV;
        
        UILabel *textLabel = [UILabel creatLabel:^(UILabel *label) {
            label.ljTitle_font_textColor(text,self.font,self.textColor);
            label.textAlignment = NSTextAlignmentLeft;
            label.numberOfLines = 0;
            [label sizeToFit];
        }];
        [self addSubview:textLabel];
        [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(imV);
            make.bottom.equalTo(imV.mas_top).offset(-space);
            make.size.mas_equalTo(textSize);
        }];
        self.textLabel = textLabel;
    }
   
}

- (void)setSelect:(BOOL)select {
    if(select) {
        self.imgV.image = V_IMAGE(self.selctPicName);
        self.textLabel.textColor = self.selectTextColor;
        self.textLabel.font = self.selectFont;
        self.textLabel.text = self.selectText;
    } else {
        self.imgV.image = V_IMAGE(self.picName);
        self.textLabel.textColor = self.textColor;
        self.textLabel.font = self.font;
        self.textLabel.text = self.text;
    }
}

@end
