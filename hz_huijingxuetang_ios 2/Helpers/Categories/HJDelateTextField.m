//
//  HJDelateTextField.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/10/18.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJDelateTextField.h"

@implementation HJDelateTextField


- (void)deleteBackward {
    [super deleteBackward];
    if ([self.delegate respondsToSelector:@selector(hjTextFieldDeleteBackward:)]) {
        [self.delegate hjDelateTextFieldDeleteBackward:self];
    }
}

@end


