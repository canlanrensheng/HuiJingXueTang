//
//  HJMessageViewModel.h
//  HuiJingSchool
//
//  Created by 张金山 on 2018/12/7.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "BaseTableViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HJMessageViewModel : BaseTableViewModel

//是否未读的消息
@property (nonatomic,assign) BOOL hasmess;
//未读的消息的数量
@property (nonatomic,assign) NSInteger countmess;
@property (nonatomic,strong) NSMutableArray *messageArray;
- (void)getMessageWithSuccess:(void (^)(void))success;

@end

NS_ASSUME_NONNULL_END
