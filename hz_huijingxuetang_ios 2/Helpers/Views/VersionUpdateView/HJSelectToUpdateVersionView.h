//
//  HJSelectToUpdateVersionView.h
//  HuiJingSchool
//
//  Created by 张金山 on 2018/12/13.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^infoBindBlock)(BOOL success);

@interface HJSelectToUpdateVersionView : BaseView

@property (nonatomic,copy)infoBindBlock bindBlock;

- (HJSelectToUpdateVersionView * )initWithVersionNum:(NSString *)versionNum versionUpdateContent:(NSString *)versionUpdateContent link:(NSString *)link bindBlock:(void(^)(BOOL success))bindBlock;

- (void)show;

@end

NS_ASSUME_NONNULL_END
