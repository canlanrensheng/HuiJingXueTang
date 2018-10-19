//
//  HJDelateTextField.h
//  HuiJingSchool
//
//  Created by 张金山 on 2018/10/18.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HJDelateTextField;
@protocol HJDelateTextFieldDeleteDelegate <NSObject>

- (void)hjDelateTextFieldDeleteBackward:(HJDelateTextField *)textField;

@end

@interface HJDelateTextField : UITextField

@property (nonatomic,weak)id <HJDelateTextFieldDeleteDelegate>delegate;

@end

