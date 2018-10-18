//
//  UILabel.h
//  LJView
//
//  Created by txooo on 17/2/24.
//  Copyright © 2017年 张金山. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef UILabel *(^ljFrame)(NSString *title, UIFont *font, UIColor *textColor);

@interface UILabel(LJLabel)

+ (UILabel *)creatLabel:(void(^)(UILabel *label))block;

- (UILabel *(^)(float left,float top,float width,float height))ljFrame;
- (UILabel* (^)(NSString *title, UIFont *font, UIColor *textColor))ljTitle_font_textColor;
- (UILabel* (^)(NSTextAlignment aligment))ljAligment;
- (UILabel* (^)(UIColor *color))ljBackgroundColor;
- (UILabel* (^)(NSInteger lines))ljNumberOfLines;

@end
