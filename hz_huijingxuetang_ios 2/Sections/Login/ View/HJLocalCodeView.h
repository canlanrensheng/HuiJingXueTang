//
//  HJLocalCodeView.h
//  HuiJingSchool
//
//  Created by 张金山 on 2018/10/19.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "BaseView.h"


typedef void(^NNChangeValidationCodeBlock)();

@interface HJLocalCodeView : UIView

@property (nonatomic, copy) NSArray *charArray;

@property (nonatomic, strong) NSMutableString *charString;

@property (nonatomic, copy) NNChangeValidationCodeBlock changeValidationCodeBlock;

- (instancetype)initWithFrame:(CGRect)frame andCharCount:(NSInteger)charCount andLineCount:(NSInteger)lineCount;

@end

