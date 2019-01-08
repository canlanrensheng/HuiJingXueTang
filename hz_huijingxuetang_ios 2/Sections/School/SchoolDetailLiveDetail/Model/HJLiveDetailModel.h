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
@property (nonatomic , copy) NSString              * tokenid;
@property (nonatomic , copy) NSString              * accid;
@property (nonatomic , copy) NSString              * appkey;
@property (nonatomic , copy) NSString              * addr;
@property (nonatomic , copy) NSString              * roomid;

@end

@interface Course : BaseModel
@property (nonatomic,strong) NSDate *date;
@property (nonatomic , copy) NSString              * userid;
@property (nonatomic , copy) NSString              * agentid;
@property (nonatomic , copy) NSString              * courseid;
@property (nonatomic , copy) NSString              * iconurl;
@property (nonatomic , copy) NSString              * videourl;
@property (nonatomic , copy) NSString              * coursedes;
@property (nonatomic , copy) NSString              * coursetypecode;
@property (nonatomic , copy) NSString              * coursepic;
@property (nonatomic , copy) NSString              * videoid;
@property (nonatomic , copy) NSString              * coursetypename;
@property (nonatomic , assign) NSInteger              bannerflag;
@property (nonatomic , copy) NSString              * starttime;
@property (nonatomic , copy) NSString              * endtime;
@property (nonatomic , copy) NSString              * cause;
@property (nonatomic , copy) NSString              * realname;
@property (nonatomic , assign) NSInteger              flag;
@property (nonatomic , copy) NSString              * endtime_fmt;
@property (nonatomic , copy) NSString              * starttime_fmt;
@property (nonatomic , copy) NSString              * couserpwd;
@property (nonatomic , assign) NSInteger              coursekind;
@property (nonatomic , copy) NSString              * coursename;
@property (nonatomic , assign) NSInteger              auth;
@property (nonatomic , copy) NSString              * agentname;
@property (nonatomic , assign) NSInteger              thumbsupcount;
@property (nonatomic , assign) NSInteger              liveflag;
@property (nonatomic , copy) NSString              * introduction;
@property (nonatomic , copy) NSString              * createtime;
@property (nonatomic , assign) NSInteger              isinterest;
@property (nonatomic,copy) NSString *slogen;

@end

@interface Room : BaseModel

@property (nonatomic , copy) NSString              * roomId;
@property (nonatomic , copy) NSString              * chatroomname;
@property (nonatomic , copy) NSString              * hlsPullUrl;
@property (nonatomic , copy) NSString              * roomid;
@property (nonatomic , copy) NSString              * rtmpPullUrl;
@property (nonatomic , copy) NSString              * pushUrl;
@property (nonatomic , copy) NSString              * cid;
@property (nonatomic , copy) NSString              * channelname;
@property (nonatomic , copy) NSString              * token;
@property (nonatomic , copy) NSString              * ctime;
@property (nonatomic , copy) NSString              * httpPullUrl;
@property (nonatomic , copy) NSString              * accid;

@end

@interface HJLiveDetailModel : BaseModel

@property (nonatomic , strong) Chat              * chat;
@property (nonatomic , strong) Course            * course;
@property (nonatomic , strong) Room              * room;

@end

NS_ASSUME_NONNULL_END
