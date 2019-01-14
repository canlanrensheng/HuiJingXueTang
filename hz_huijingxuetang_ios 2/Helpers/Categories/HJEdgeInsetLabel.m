//
//  HJEdgeInsetLabel.m
//  HuiJingSchool
//
//  Created by 张金山 on 2019/1/2.
//  Copyright © 2019年 Junier. All rights reserved.
//

#import "HJEdgeInsetLabel.h"

@implementation HJEdgeInsetLabel

- (instancetype)init {
    if (self = [super init]) {
        _textInsets = UIEdgeInsetsZero;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _textInsets = UIEdgeInsetsZero;
    }
    return self;
}

- (void)setTextInsets:(UIEdgeInsets)textInsets {
    _textInsets = textInsets;
}

- (void)drawTextInRect:(CGRect)rect {
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, _textInsets)];
}


@end
