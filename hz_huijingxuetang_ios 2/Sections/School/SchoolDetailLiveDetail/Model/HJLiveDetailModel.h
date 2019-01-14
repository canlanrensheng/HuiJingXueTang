//
//  HJLiveDetailModel.h
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/28.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface Chat : BaseModel
//用户网易云tokenid
@property (nonatomic , copy) NSString              * tokenid;
//网易云用户ID
@property (nonatomic , copy) NSString              * accid;
//网易云分配AppKey
@property (nonatomic , copy) NSString              * appkey;
//聊天室地址
@property (nonatomic , copy) NSString              * addr;
//聊天室房间号
@property (nonatomic , copy) NSString              * roomid;

@end

@interface Course : BaseModel
//日期
@property (nonatomic,strong) NSDate *date;
//讲师ID
@property (nonatomic , copy) NSString              * userid;
//代理商ID
@property (nonatomic , copy) NSString              * agentid;
//课程id
@property (nonatomic , copy) NSString              * courseid;
//老师头像
@property (nonatomic , copy) NSString              * iconurl;
//视频播放链接
@property (nonatomic , copy) NSString              * videourl;
//课程描述
@property (nonatomic , copy) NSString              * coursedes;
@property (nonatomic , copy) NSString              * coursetypecode;
//课程封面图片
@property (nonatomic , copy) NSString              * coursepic;
@property (nonatomic , copy) NSString              * videoid;
@property (nonatomic , copy) NSString              * coursetypename;
@property (nonatomic , assign) NSInteger              bannerflag;
@property (nonatomic , copy) NSString              * starttime;
@property (nonatomic , copy) NSString              * endtime;
@property (nonatomic , copy) NSString              * cause;
//教师名称
@property (nonatomic , copy) NSString              * realname;
@property (nonatomic , assign) NSInteger              flag;
@property (nonatomic , copy) NSString              * endtime_fmt;
@property (nonatomic , copy) NSString              * starttime_fmt;
//直播密码
@property (nonatomic , copy) NSString              * couserpwd;
//1是免费 2是付费
@property (nonatomic , assign) NSInteger              coursekind;
//课程名称
@property (nonatomic , copy) NSString              * coursename;
@property (nonatomic , assign) NSInteger              auth;
@property (nonatomic , copy) NSString              * agentname;
@property (nonatomic , assign) NSInteger              thumbsupcount;
//1 正在直播 2往期回顾 3预告直播
@property (nonatomic , assign) NSInteger              liveflag;
//老师简介
@property (nonatomic , copy) NSString              * introduction;
@property (nonatomic , copy) NSString              * createtime;
//0 未关注 1已关注
@property (nonatomic , assign) NSInteger              isinterest;
//老师推荐语
@property (nonatomic,copy) NSString *slogen;

@end

@interface Room : BaseModel

//房间号
@property (nonatomic , copy) NSString              * roomId;
//聊天室名称
@property (nonatomic , copy) NSString              * chatroomname;
//拉流地址
@property (nonatomic , copy) NSString              * hlsPullUrl;
//房间号
@property (nonatomic , copy) NSString              * roomid;
@property (nonatomic , copy) NSString              * rtmpPullUrl;
@property (nonatomic , copy) NSString              * pushUrl;
//频道ID
@property (nonatomic , copy) NSString              * cid;
//频道名称
@property (nonatomic , copy) NSString              * channelname;
//网易云token
@property (nonatomic , copy) NSString              * token;
@property (nonatomic , copy) NSString              * ctime;
@property (nonatomic , copy) NSString              * httpPullUrl;
//网易云用户ID
@property (nonatomic , copy) NSString              * accid;

@end

@interface HJLiveDetailModel : BaseModel
//聊天室信息
@property (nonatomic , strong) Chat              * chat;
//课程信息
@property (nonatomic , strong) Course            * course;
//聊天室信息
@property (nonatomic , strong) Room              * room;

@end

NS_ASSUME_NONNULL_END
