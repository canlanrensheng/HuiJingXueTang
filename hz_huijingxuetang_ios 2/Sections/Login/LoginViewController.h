//
//  LoginViewController.h
//  HuiJingSchool
//
//  Created by Junier on 2018/2/8.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "BaseViewController.h"

@interface LoginViewController : BaseViewController

//type = 1 点加其他页面跳转到登陆页面的，登陆成功之后回到之前的页面并且刷新数据
@property (nonatomic,assign) NSInteger type;

@end
