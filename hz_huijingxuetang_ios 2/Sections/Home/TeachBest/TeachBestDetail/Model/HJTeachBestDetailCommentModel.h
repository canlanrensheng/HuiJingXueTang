//
//  HJTeachBestDetailCommentModel.h
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/12.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HJTeachBestDetailCommentModel : BaseModel

@property (nonatomic,copy) NSString *commentid;
@property (nonatomic,copy) NSString *infomationid;
@property (nonatomic,copy) NSString *commentuserid;
@property (nonatomic,copy) NSString *iconurl;
@property (nonatomic,copy) NSString *nickname;
@property (nonatomic,copy) NSString *commentcontent;
@property (nonatomic,copy) NSString *createtime;
@property (nonatomic,assign) CGFloat cellHeight;
@property (nonatomic,copy) NSString *userzone;
@property (nonatomic,copy) NSString *userterminal;

@end

NS_ASSUME_NONNULL_END
