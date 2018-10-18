//
//  YJShareCategory.h
//  TennisClass
//
//  Created by Junier on 2017/12/14.
//  Copyright © 2017年 陈燕军. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YJShareCategory : NSObject

+(void)JumploginWhichVC:(UIViewController *)whichvc;
+(void)JumploginWhichVC:(UIViewController *)whichvc andtype:(NSString *)type;

+ (UIWindow *)lastWindow;

@end
