//
//  HJSchoolCourseDetailModel.h
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/14.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HJSchoolCourseDetailModel : BaseModel


//课程周期
@property (nonatomic , assign) NSInteger              periods;
//老师的ID
@property (nonatomic , copy) NSString              * userid;
//1 能砍价 2 不能砍价
@property (nonatomic , assign) NSInteger              canbargain;
//1 能推广赚钱 2不能推广赚钱
@property (nonatomic , assign) NSInteger              canpromote;
//课程id
@property (nonatomic , copy) NSString              * courseid;
//老师的头像
@property (nonatomic , copy) NSString              * iconurl;
//视频播放链接
@property (nonatomic , copy) NSString              * videourl;
//课程描述
@property (nonatomic , copy) NSString              * coursedes;
//
@property (nonatomic , copy) NSString              * videoid;
//课程图片
@property (nonatomic , copy) NSString              * coursepic;
//能砍到的的最低价
@property (nonatomic , assign) CGFloat              bargaintoprice;
//秒杀开始是时间
@property (nonatomic , copy) NSString              * starttime;
//秒杀结束时间
@property (nonatomic , copy) NSString              * endtime;
//y 能购买 n 不能购买
@property (nonatomic , copy) NSString              * buy;
//
@property (nonatomic , assign) NSInteger              thumbsupcount;
//1 免费课程 2 付费课程
@property (nonatomic , assign) NSInteger              courselimit;
//是否需要登陆
@property (nonatomic , copy) NSString              * loginstatus;
//1 有秒杀 0不能秒杀
@property (nonatomic , assign) NSInteger              hassecond;
//秒杀的价格
@property (nonatomic , copy) NSString              * secondprice;
//课程的价格
@property (nonatomic , assign) CGFloat              coursemoney;
//老师的简介
@property (nonatomic , copy) NSString              * introduction;
//视频的封面图片
@property (nonatomic , copy) NSString              * videoppicurl;

@property (nonatomic , copy) NSString              * praise;
//用户的名称
@property (nonatomic , copy) NSString              * username;
//老师介绍的cell的高度
@property (nonatomic,assign) CGFloat teacherIntroCellHeight;
//课程的cell的高度
@property (nonatomic,assign) CGFloat courseCellHeight;

//是否常见过砍价订单 1创建过砍价订单 0没有创建过砍价订单
@property (nonatomic,assign) NSInteger createdBargainOrderStatus;

@end

NS_ASSUME_NONNULL_END
