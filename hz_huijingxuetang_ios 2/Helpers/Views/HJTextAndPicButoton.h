//
//  HJTextAndPicButoton.h
//  HuiJingSchool
//
//  Created by 张金山 on 2018/12/18.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,HJTextAndPicButotonType){
    HJTextAndPicButotonTypePicLeft = 0, //图片在左，文字在右
    HJTextAndPicButotonTypePicTop = 1, //图片在上，文字在下
    HJTextAndPicButotonTypePicRight = 2, //图片在右，文字在左
    HJTextAndPicButotonTypePicBottom = 3 //图片在下，文字在上
};


@interface HJTextAndPicButoton : UIButton

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
                   selectFont:(UIFont *)selectFont;

@property (nonatomic,assign) BOOL select;

@end

NS_ASSUME_NONNULL_END
