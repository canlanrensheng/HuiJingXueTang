//
//  YJAlertview.h
//  TennisClass
//
//  Created by Junier on 2017/12/19.
//  Copyright © 2017年 陈燕军. All rights reserved.
//

#import <UIKit/UIKit.h>
// 协议名一般以本类的类名开头+Delegate (包含前缀)
@protocol YJAlertviewDelegate <NSObject>
// 声明协议方法，一般以类名开头(不需要前缀)
- (void)changevalue:(NSString* )value type:(NSString *)type seltype:(NSInteger)sel;

@end

@interface YJAlertview : UIView


@property (nonatomic,weak) id<YJAlertviewDelegate> delegate;

@property(strong ,nonatomic) NSArray *dataarr;
@property(copy,nonatomic)NSString *type;
@property(copy,nonatomic)NSString *typeName;

@property(copy,nonatomic)NSString *number;
@property(assign,nonatomic)NSInteger seltype;
@property(assign,nonatomic)NSInteger count;

@end
