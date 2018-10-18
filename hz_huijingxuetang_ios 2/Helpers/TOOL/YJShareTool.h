//
//  YJShareTool.h
//  TennisClass
//
//  Created by 陈燕军 on 2018/5/31.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YJShareTool : NSObject

+(void)ToolShareUrlWithUrl:(NSString *)url title:(NSString *)title content:(NSString *)content andViewC:(UIViewController *)vc;

@end
