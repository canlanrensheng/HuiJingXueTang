//
//  HJCourseDetailCommentModel.h
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/14.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HJCourseDetailCommentModel : BaseModel

//评论客户的ID
@property (nonatomic,copy) NSString *userid;
//评论的内容
@property (nonatomic,copy) NSString *commentcontent;
//评论的星级
@property (nonatomic,copy) NSString *coursescore;
//评论的时间
@property (nonatomic,copy) NSString *createtime;
//评论客户的昵称
@property (nonatomic,copy) NSString *nickname;
//评论客户的头像
@property (nonatomic,copy) NSString *iconurl;
//评论的cell的高度
@property (nonatomic,assign) CGFloat cellHeight;


@end

NS_ASSUME_NONNULL_END
