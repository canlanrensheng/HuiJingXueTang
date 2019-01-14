//
//  HJFindRecommondModel.h
//  HuiJingSchool
//
//  Created by 张金山 on 2018/10/31.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,FindType){
    FindTypeText = 0, //纯文字类型
    FindTypePic = 1,
    FindTypeLink = 2,
    FindTypeVideo= 3,
    FindTypePicLink = 4,
    FindTypeVideoLink = 5
};

@interface HJFindRecommondModel : BaseModel

@property (nonatomic , copy) NSString              * dynamicpic8;
@property (nonatomic , copy) NSString              * dynamicpic9;
@property (nonatomic , copy) NSString              * createtime;
@property (nonatomic , copy) NSString              * realname;
@property (nonatomic , copy) NSString              * teacherid;
@property (nonatomic , copy) NSString              * dynamiclinkid;
@property (nonatomic , copy) NSString              * iconurl;
@property (nonatomic , assign) NSInteger              type;
@property (nonatomic , copy) NSString              * dynamiccontent;
@property (nonatomic , copy) NSString              * dynamicpic1;
@property (nonatomic , copy) NSString              * dynamicpic2;
@property (nonatomic , copy) NSString              * dynamicpic3;
@property (nonatomic , copy) NSString              * dynamicpic4;
@property (nonatomic , copy) NSString              * dynamicvideo;
@property (nonatomic , copy) NSString              * dynamicpic5;
@property (nonatomic , copy) NSString              * updatetime;
@property (nonatomic , copy) NSString              * dynamicpic6;
@property (nonatomic , assign) NSInteger              isinterest;
@property (nonatomic , copy) NSString              * dynamicpic7;
@property (nonatomic,copy) NSString *dynamiclinkpic;

@property (nonatomic,strong) UIImage *coverVideoImg;
@property (nonatomic,assign) FindType findType;
@property (nonatomic,assign) CGFloat  cellHeight;
@property (nonatomic,strong) NSMutableArray *picArray;



@end

NS_ASSUME_NONNULL_END
