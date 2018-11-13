//
//  HJShareTool.h
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/5.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HJShareTool : NSObject

+ (void)shareWithTitle:(NSString *)title content:(NSString *)content images:(NSArray *)images url:(NSString *)url;

@end

NS_ASSUME_NONNULL_END
