//
//  YJAPPNetwork.m
//  TennisClass
//
//  Created by Junier on 2017/12/7.
//  Copyright © 2017年 陈燕军. All rights reserved.
//

#import "YJAPPNetwork.h"
#import "YJNetWorkTool.h"

@implementation YJAPPNetwork

/**
 首页获取场馆分页
 **/
+(void)Cityid:(NSString *)cityid venuename:(NSString *)venuename page:(NSString *)page venueIds:(NSString *)venueIds success:(void (^)(NSDictionary *))success failure:(void (^)(NSString *))failure{
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/venues!search",API_BASEURL];
    NSDictionary *parameters = @{
                          @"query.name":venuename,
                          @"query.cityId":cityid,
                          @"query.venuesIds":venueIds,
                          @"query.begin":page,
                          };

    [[YJNetWorkTool sharedTool]requestWithURLString:url parameters:parameters method:@"POST" callBack:^(id responseObject) {
        NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
        NSLog(@"%@",dic);
        success(dic);
    } fail:^(id error) {
        failure(error);
    }];
    
}

/**
 首页 - 最新动态
 **/
+(void)HomeViewNewsuccess:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure{
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/dynamicnews",API_BASEURL];
 
    [[YJNetWorkTool sharedTool]requestWithURLString:url parameters:nil method:@"GET" callBack:^(id responseObject) {
        NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
        NSLog(@"%@",dic);
        success(dic);
    } fail:^(id error) {
        failure(error);
    }];
}

/**
 首页 - 名师推荐
 **/
+(void)HomeViewTeachersuccess:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure{
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/indexteacher",API_BASEURL];
    
    [[YJNetWorkTool sharedTool]requestWithURLString:url parameters:nil method:@"GET" callBack:^(id responseObject) {
        NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
        NSLog(@"%@",dic);
        success(dic);
    } fail:^(id error) {
        failure(error);
    }];
}

+(void)HomeViewFreeAndType:(NSString *)type success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure{
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/indexcourselist",API_BASEURL];
    NSDictionary *parameters = @{
                                 @"type":type
                                 };
    [[YJNetWorkTool sharedTool]requestWithURLString:url parameters:parameters method:@"GET" callBack:^(id responseObject) {
        NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
        NSLog(@"%@",dic);
        success(dic);
    } fail:^(id error) {
        failure(error);
    }];
}

/**
 首页 - 资讯
 **/
+(void)HomeViewNewslistsuccess:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure{
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/indexnewslist",API_BASEURL];
    
    [[YJNetWorkTool sharedTool]requestWithURLString:url parameters:nil method:@"GET" callBack:^(id responseObject) {
        NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
        NSLog(@"%@",dic);
        success(dic);
    } fail:^(id error) {
        failure(error);
    }];
}

/**
 首页 - 精彩推荐
 **/
+(void)HomeViewlivelogsuccess:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure{
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/indexlivelogo",API_BASEURL];
    
    [[YJNetWorkTool sharedTool]requestWithURLString:url parameters:nil method:@"GET" callBack:^(id responseObject) {
        NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
        NSLog(@"%@",dic);
        success(dic);
    } fail:^(id error) {
        failure(error);
    }];
}

/**
 注册获取验证码
 **/
+(void)GetCodeWithPhonenum:(NSString *)phonenum success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure{
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/getregcode",API_BASEURL];
    NSDictionary *parameters = @{
                                 @"telephone":phonenum,
                                 };
    [[YJNetWorkTool sharedTool]requestWithURLString:url parameters:parameters method:@"GET" callBack:^(id responseObject) {
        NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
        NSLog(@"%@",dic);
        success(dic);
    } fail:^(id error) {
        failure(error);
    }];
}

/**
 注册
 **/
+(void)registWithPhonenum:(NSString *)phonenum pwd:(NSString *)pwd code:(NSString *)code incode:(NSString *)incode success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure{
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/register",API_BASEURL];
    NSDictionary *parameters = @{
                                 @"telno":phonenum,
                                 @"password":pwd,
                                 @"smscode":code,
                                 @"invite_code":incode,

                                 };
    [[YJNetWorkTool sharedTool]requestWithURLString:url parameters:parameters method:@"POST" callBack:^(id responseObject) {
        NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
        NSLog(@"%@",dic);
        success(dic);
    } fail:^(id error) {
        failure(error);
    }];
}

/**
 登录
 **/
+(void)LoginPwdWithPhonenum:(NSString *)phonenum code:(NSString *)code success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure{
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/login",API_BASEURL];
    NSDictionary *parameters = @{
                                 @"telno":phonenum,
                                 @"password":code,
                                 };
    [[YJNetWorkTool sharedTool]requestWithURLString:url parameters:parameters method:@"POST" callBack:^(id responseObject) {
        NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
        NSLog(@"%@",dic);
        success(dic);
    } fail:^(id error) {
        failure(error);
    }];
}

/**
 登录获取验证码
 **/
+(void)GetCodeLoginWithPhonenum:(NSString *)phonenum success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure{
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/getlogincode",API_BASEURL];
    NSDictionary *parameters = @{
                                 @"telephone":phonenum,
                                 };
    [[YJNetWorkTool sharedTool]requestWithURLString:url parameters:parameters method:@"GET" callBack:^(id responseObject) {
        NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
        NSLog(@"%@",dic);
        success(dic);
    } fail:^(id error) {
        failure(error);
    }];
}

/**
 忘记获取验证码
 **/
+(void)GetCodeForgetWithPhonenum:(NSString *)phonenum success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure{
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/getrepwdcode",API_BASEURL];
    NSDictionary *parameters = @{
                                 @"telephone":phonenum,
                                 
                                 };
    [[YJNetWorkTool sharedTool]requestWithURLString:url parameters:parameters method:@"POST" callBack:^(id responseObject) {
        NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
        NSLog(@"%@",dic);
        success(dic);
    } fail:^(id error) {
        failure(error);
    }];
}

/**
 重置密码
 **/
+(void)ForgetPWDWithPhonenum:(NSString *)phonenum code:(NSString *)code pwd:(NSString *)pwd rpwd:(NSString *)rpwd  success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure{
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/resetpwd",API_BASEURL];
    NSDictionary *parameters = @{
                                 @"telno":phonenum,
                                 @"password":pwd,
                                 @"smscode":code,
                                 @"repassword":rpwd,
                                 
                                 };
    [[YJNetWorkTool sharedTool]requestWithURLString:url parameters:parameters method:@"POST" callBack:^(id responseObject) {
        NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
        NSLog(@"%@",dic);
        success(dic);
    } fail:^(id error) {
        failure(error);
    }];
}

/**
 课程列表
 **/
+(void)GetClassTaskWithAccesstoken:(NSString *)Accesstoken coursetype:(NSString *)coursetype num:(NSString *)num evaluate:(NSString *)evaluate teacherid:(NSString *)teacherid type:(NSString *)type price:(NSString *)price page:(NSString *)page success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure{
    
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/courselist",API_BASEURL];
    NSDictionary *parameters = @{
                                 @"accesstoken":Accesstoken,
                                 @"coursetype":coursetype,
                                 @"peopleunm":num,
                                 @"evaluate":evaluate,
                                 @"teacherid":teacherid,
                                 @"type":type,
                                 @"price":price,
                                 @"page":page,
                                 };
    [[YJNetWorkTool sharedTool]requestWithURLString:url parameters:parameters method:@"GET" callBack:^(id responseObject) {
        NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
        NSLog(@"%@",dic);
        success(dic);
    } fail:^(id error) {
        failure(error);
    }];
}


/**
 点赞按钮
 **/
+(void)zanwithAccesstoken:(NSString *)Accesstoken Id:(NSString *)Id success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure{
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/praise",API_BASEURL];
    NSDictionary *parameters = @{
                                 @"accesstoken":Accesstoken,
                                 @"courseid":Id
                                 
                                 };
    [[YJNetWorkTool sharedTool]requestWithURLString:url parameters:parameters method:@"GET" callBack:^(id responseObject) {
        NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
        NSLog(@"%@",dic);
        success(dic);
    } fail:^(id error) {
        failure(error);
    }];
}

/**
 进入播放+1
 **/
+(void)PalywithId:(NSString *)Id success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure{
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/coursedirectory",API_BASEURL];
    NSDictionary *parameters = @{
                                 @"videoid":Id
                                 
                                 };
    [[YJNetWorkTool sharedTool]requestWithURLString:url parameters:parameters method:@"GET" callBack:^(id responseObject) {
        NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
        NSLog(@"%@",dic);
        success(dic);
    } fail:^(id error) {
        failure(error);
    }];
}

/**
 课程详情
 **/
+(void)ClassInfowithCoureId:(NSString *)Id Accesstoken:(NSString *)accesstoken success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure{
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/coursedetail",API_BASEURL];
    NSDictionary *parameters = @{
                                 @"courseid":Id,
                                 @"accesstoken":accesstoken
                                 };
    [[YJNetWorkTool sharedTool]requestWithURLString:url parameters:parameters method:@"GET" callBack:^(id responseObject) {
        NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
        NSLog(@"%@",dic);
        success(dic);
    } fail:^(id error) {
        failure(error);
    }];
}

/**
 课程目录
 **/
+(void)ClasscatalogedwithCoureId:(NSString *)Id Accesstoken:(NSString *)accesstoken success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure{
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/coursedirectory",API_BASEURL];
    NSDictionary *parameters = @{
                                 @"courseid":Id,
                                 @"accesstoken":accesstoken
                                 };
    [[YJNetWorkTool sharedTool]requestWithURLString:url parameters:parameters method:@"GET" callBack:^(id responseObject) {
        NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
        NSLog(@"%@",dic);
        success(dic);
    } fail:^(id error) {
        failure(error);
    }];
}


/**
 课程目录
 **/
+(void)ClassAppraisewithCoureId:(NSString *)Id page:(NSString *)page success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure{
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/coursecomment",API_BASEURL];
    NSDictionary *parameters = @{
                                 @"courseid":Id,
                                 @"reqpage":page
                                 };
    [[YJNetWorkTool sharedTool]requestWithURLString:url parameters:parameters method:@"GET" callBack:^(id responseObject) {
        NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
        NSLog(@"%@",dic);
        success(dic);
    } fail:^(id error) {
        failure(error);
    }];
}

/**
 咨询头部列表
 **/
+(void)InformationTopsuccess:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure{
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/newsmodellist",API_BASEURL];
    [[YJNetWorkTool sharedTool]requestWithURLString:url parameters:nil method:@"GET" callBack:^(id responseObject) {
        NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
        NSLog(@"%@",dic);
        success(dic);
    } fail:^(id error) {
        failure(error);
    }];
}

/**
 咨讯列表
 **/
+(void)NewslistwithCoureId:(NSString *)Id page:(NSString *)page success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure{
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/newslist",API_BASEURL];
    NSDictionary *parameters = @{
                                 @"modelid":Id,
                                 @"reqpage":page
                                 };
    [[YJNetWorkTool sharedTool]requestWithURLString:url parameters:parameters method:@"GET" callBack:^(id responseObject) {
        NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
        NSLog(@"%@",dic);
        success(dic);
    } fail:^(id error) {
        failure(error);
    }];
}

/**
 咨讯详情
 **/
+(void)NewslistInfowithCoureId:(NSString *)Id success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure{
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/newsdetail",API_BASEURL];
    NSDictionary *parameters = @{
                                 @"infoid":Id,
                                 };
    [[YJNetWorkTool sharedTool]requestWithURLString:url parameters:parameters method:@"GET" callBack:^(id responseObject) {
        NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
        NSLog(@"%@",dic);
        success(dic);
    } fail:^(id error) {
        failure(error);
    }];
}

/**
 咨讯评论
 **/
+(void)NewsCommentwithCoureId:(NSString *)Id page:(NSString *)page success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure{
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/newscomment",API_BASEURL];
    NSDictionary *parameters = @{
                                 @"infoid":Id,
                                 @"page":page
                                 };
    [[YJNetWorkTool sharedTool]requestWithURLString:url parameters:parameters method:@"GET" callBack:^(id responseObject) {
        NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
        NSLog(@"%@",dic);
        success(dic);
    } fail:^(id error) {
        failure(error);
    }];
}

/**
 发表咨讯评论
 **/
+(void)CommentwithCoureinfoid:(NSString *)infoid accesstoken:(NSString *)accesstoken commid:(NSString *)commid content:(NSString *)content success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure{
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/sendnewscomment",API_BASEURL];
    NSDictionary *parameters = @{
                                 @"infoid":infoid,
                                 @"accesstoken":accesstoken,
                                 @"commid":commid,
                                 @"content":content,
                                 };
    [[YJNetWorkTool sharedTool]requestWithURLString:url parameters:parameters method:@"POST" callBack:^(id responseObject) {
        NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
        NSLog(@"%@",dic);
        success(dic);
    } fail:^(id error) {
        failure(error);
    }];
}

/**
 vip策略列表
 **/
+(void)VIPtacticswithaccesstoken:(NSString *)accesstoken page:(NSString *)page success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure{
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/vipnewslist",API_BASEURL];

    NSDictionary *parameters = @{
                                 @"accesstoken":accesstoken,
                                 @"page":page,
                                 };
    [[YJNetWorkTool sharedTool]requestWithURLString:url parameters:parameters method:@"POST" callBack:^(id responseObject) {
        NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
        NSLog(@"%@",dic);
        success(dic);
    } fail:^(id error) {
        failure(error);
    }];
}


/**
 vip策略咨讯详情
 **/
+(void)VIPtacticsInfowithaccesstoken:(NSString *)accesstoken infoid:(NSString *)infoid success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure{
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/vipnewsdetail",API_BASEURL];
    
    NSDictionary *parameters = @{
                                 @"accesstoken":accesstoken,
                                 @"infoid":infoid,
                                 };
    [[YJNetWorkTool sharedTool]requestWithURLString:url parameters:parameters method:@"POST" callBack:^(id responseObject) {
        NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
        NSLog(@"%@",dic);
        success(dic);
    } fail:^(id error) {
        failure(error);
    }];
}


/**
 vip策略咨讯评论列表
 **/
+(void)VIPNewsCommentwithinfoid:(NSString *)infoid success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure{
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/newscomment",API_BASEURL];
    
    NSDictionary *parameters = @{
                                 @"infoid":infoid
                                 };
    [[YJNetWorkTool sharedTool]requestWithURLString:url parameters:parameters method:@"POST" callBack:^(id responseObject) {
        NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
        NSLog(@"%@",dic);
        success(dic);
    } fail:^(id error) {
        failure(error);
    }];
}

/**
 教师列表
 **/
+(void)TeachTasksuccess:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure{
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/recommendteacher",API_BASEURL];

    
    [[YJNetWorkTool sharedTool]requestWithURLString:url parameters:nil method:@"GET" callBack:^(id responseObject) {
        NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
        NSLog(@"%@",dic);
        success(dic);
    } fail:^(id error) {
        failure(error);
    }];
}

/**
 教师详情页
 **/
+(void)TeacherTaskInfowithinfoid:(NSString *)infoid success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure{
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/teacherdetail",API_BASEURL];
    NSDictionary *parameters = @{
                                 @"teacherid":infoid
                                 };
    [[YJNetWorkTool sharedTool]requestWithURLString:url parameters:parameters method:@"GET" callBack:^(id responseObject) {
        NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
        NSLog(@"%@",dic);
        success(dic);
    } fail:^(id error) {
        failure(error);
    }];
}

/**
 教师的课程列表
 **/
+(void)TeacherClassTaskwithinfoid:(NSString *)infoid type:(NSString *)type success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure{
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/teachercourselist",API_BASEURL];
    NSDictionary *parameters = @{
                                 @"teacherid":infoid,
                                 @"type":type,
                                 };
    [[YJNetWorkTool sharedTool]requestWithURLString:url parameters:parameters method:@"GET" callBack:^(id responseObject) {
        NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
        NSLog(@"%@",dic);
        success(dic);
    } fail:^(id error) {
        failure(error);
    }];
}

/**
 我的基本信息
 **/
+(void)MyInfowithaccesstoken:(NSString *)accesstoken success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure{
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/mybaseinfo",API_BASEURL];
    NSDictionary *parameters = @{
                                 @"accesstoken":accesstoken,
                                 };
    [[YJNetWorkTool sharedTool]requestWithURLString:url parameters:parameters method:@"GET" callBack:^(id responseObject) {
        NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
        NSLog(@"%@",dic);
        success(dic);
    } fail:^(id error) {
        failure(error);
    }];
}

/**
 专家诊股列表
 **/
+(void)SpecialistwithType:(NSString *)type page:(NSString *)page success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure{
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/stockinfolist",API_BASEURL];
    NSDictionary *parameters = @{
                                 @"type":type,
                                 @"page":page
                                 };
    [[YJNetWorkTool sharedTool]requestWithURLString:url parameters:parameters method:@"GET" callBack:^(id responseObject) {
        NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
        NSLog(@"%@",dic);
        success(dic);
    } fail:^(id error) {
        failure(error);
    }];
}

/**
 专家诊股提问
 **/
+(void)SpeciaQuestionwithaccesstoken:(NSString *)accesstoken title:(NSString *)title des:(NSString *)des success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure{
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/stockquestion",API_BASEURL];
    NSDictionary *parameters = @{
                                 @"accesstoken":accesstoken,
                                 @"title":title,
                                 @"des":des,
                                 };
    [[YJNetWorkTool sharedTool]requestWithURLString:url parameters:parameters method:@"POST" callBack:^(id responseObject) {
        NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
        NSLog(@"%@",dic);
        success(dic);
    } fail:^(id error) {
        failure(error);
    }];
}

/**
 牛人观点列表
 **/
+(void)Geniusviewlistwithpage:(NSString *)page success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure{
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/geniusviewlist",API_BASEURL];
    NSDictionary *parameters = @{
                                 @"page":page,
                                 };
    [[YJNetWorkTool sharedTool]requestWithURLString:url parameters:parameters method:@"GET" callBack:^(id responseObject) {
        NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
        NSLog(@"%@",dic);
        success(dic);
    } fail:^(id error) {
        failure(error);
    }];
}

/**
 牛人观点详情
 **/
+(void)GeniusviewInfowithId:(NSString *)Id success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure{
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/geniusviewdetail",API_BASEURL];
    NSDictionary *parameters = @{
                                 @"id":Id,
                                 };
    [[YJNetWorkTool sharedTool]requestWithURLString:url parameters:parameters method:@"GET" callBack:^(id responseObject) {
        NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
        NSLog(@"%@",dic);
        success(dic);
    } fail:^(id error) {
        failure(error);
    }];
}

/**
 自动登录
 **/
+(void)AutoLoginWithAccesstoken:(NSString *)accesstoken success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure{
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/autologin",API_BASEURL];
    NSDictionary *parameters = @{
                                 @"accesstoken":accesstoken,
                                 };
    [[YJNetWorkTool sharedTool] requestWithURLString:url parameters:parameters method:@"POST" callBack:^(id responseObject) {
        NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
        NSLog(@"%@",dic);
        success(dic);
    } fail:^(id error) {
        failure(error);
    }];
}

/**
 我的课程
 **/
+(void)MyClssWithAccesstoken:(NSString *)accesstoken type:(NSString *)type page:(NSString *)page success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure{
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/mycourse",API_BASEURL];
    NSDictionary *parameters = @{
                                 @"accesstoken":accesstoken,
                                 @"type":type,
                                 @"page":page
                                 };
    [[YJNetWorkTool sharedTool]requestWithURLString:url parameters:parameters method:@"POST" callBack:^(id responseObject) {
        NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
        NSLog(@"%@",dic);
        success(dic);
    } fail:^(id error) {
        failure(error);
    }];
}

/**
 礼物列表
 **/
+(void)GiftTasksuccess:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure{
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/goodslist",API_BASEURL];

    [[YJNetWorkTool sharedTool]requestWithURLString:url parameters:nil method:@"GET" callBack:^(id responseObject) {
        NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
        NSLog(@"%@",dic);
        success(dic);
    } fail:^(id error) {
        failure(error);
    }];
}

/**
 直播页顶部正在直播的课程
 **/
+(void)LivecourselivingWithType:(NSString *)type success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure{
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/livecourseliving",API_BASEURL];
    NSDictionary *parameters = @{
                                 @"type":type
                                 };
    [[YJNetWorkTool sharedTool]requestWithURLString:url parameters:parameters method:@"GET" callBack:^(id responseObject) {
        NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
        NSLog(@"%@",dic);
        success(dic);
    } fail:^(id error) {
        failure(error);
    }];
}

/**
 我的卡券
 **/
+(void)MycardWithAccessToken:(NSString *)Accesstoken type:(NSString*)type success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure{
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/mycoupon",API_BASEURL];
    NSDictionary *parameters = @{
                                 @"accesstoken":Accesstoken,
                                 @"type":type
                                 };
    [[YJNetWorkTool sharedTool]requestWithURLString:url parameters:parameters method:@"POST" callBack:^(id responseObject) {
        NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
        NSLog(@"%@",dic);
        success(dic);
    } fail:^(id error) {
        failure(error);
    }];
}

/**
 直播间
 **/
+(void)LiveRoomWithAccessToken:(NSString *)Accesstoken ID:(NSString*)ID success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure{
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/livecourseroom",API_BASEURL];
    NSDictionary *parameters = @{
                                 @"accesstoken":Accesstoken,
                                 @"courseid":ID
                                 };
    [[YJNetWorkTool sharedTool]requestWithURLString:url parameters:parameters method:@"POST" callBack:^(id responseObject) {
        NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
        NSLog(@"%@",dic);
        success(dic);
    } fail:^(id error) {
        failure(error);
    }];
}

/**
 直播间内节目单列表
 **/
+(void)LiveCourseProgramWithID:(NSString*)ID success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure{
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/livecourseprogram",API_BASEURL];
    NSDictionary *parameters = @{
                                 @"teacherid":ID
                                 };
    [[YJNetWorkTool sharedTool]requestWithURLString:url parameters:parameters method:@"GET" callBack:^(id responseObject) {
        NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
        NSLog(@"%@",dic);
        success(dic);
    } fail:^(id error) {
        failure(error);
    }];
}

/**
 直播间内往前节目
 **/
+(void)TeapastLiveCourseListProgramWithID:(NSString*)ID page:(NSString *)page success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure{
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/teapastlivecourselist",API_BASEURL];
    NSDictionary *parameters = @{
                                 @"teacherid":ID,
                                 @"page":page
                                 };
    [[YJNetWorkTool sharedTool]requestWithURLString:url parameters:parameters method:@"GET" callBack:^(id responseObject) {
        NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
        NSLog(@"%@",dic);
        success(dic);
    } fail:^(id error) {
        failure(error);
    }];
}

/**
 往期节目
 **/
+(void)LiveCourseListProgramWithType:(NSString*)Type page:(NSString *)page success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure{
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/pastlivecourselist",API_BASEURL];
    NSDictionary *parameters = @{
                                 @"type":Type,
                                 @"page":page
                                 };
    [[YJNetWorkTool sharedTool]requestWithURLString:url parameters:parameters method:@"GET" callBack:^(id responseObject) {
        NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
        NSLog(@"%@",dic);
        success(dic);
    } fail:^(id error) {
        failure(error);
    }];
}

/**
 创建待支付订单
 **/
+(void)WillPayWithAccesstoken:(NSString*)accesstoken cids:(NSString *)cids success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure{
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/createcourseorder",API_BASEURL];
    NSDictionary *parameters = @{
                                 @"accesstoken":accesstoken,
                                 @"cids":cids
                                 };
    [[YJNetWorkTool sharedTool]requestWithURLString:url parameters:parameters method:@"POST" callBack:^(id responseObject) {
        NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
        NSLog(@"%@",dic);
        success(dic);
    } fail:^(id error) {
        failure(error);
    }];
}

/**
 订单详情
 **/
+(void)OrderInfoWithAccesstoken:(NSString*)accesstoken Id:(NSString *)Id success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure{
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/courseorderdetail",API_BASEURL];
    NSDictionary *parameters = @{
                                 @"accesstoken":accesstoken,
                                 @"orderid":Id
                                 };
    [[YJNetWorkTool sharedTool]requestWithURLString:url parameters:parameters method:@"POST" callBack:^(id responseObject) {
        NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
        NSLog(@"%@",dic);
        success(dic);
    } fail:^(id error) {
        failure(error);
    }];
}

/**
 立即支付
 **/
+(void)OrderPayAccesstoken:(NSString*)accesstoken orderid:(NSString *)orderid couponid:(NSString *)couponid paytype:(NSString *)paytype mch:(NSString *)mch success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure{
    NSString *url = [NSString stringWithFormat:@"%@/LiveApi/app/orderpayment",API_BASEURL];
    NSDictionary *parameters = @{
                                 @"accesstoken":accesstoken,
                                 @"orderid":orderid,
                                 @"couponid":couponid,
                                 @"paytype":paytype,
                                 @"mch":mch,
                                 };
    [[YJNetWorkTool sharedTool]requestWithURLString:url parameters:parameters method:@"POST" callBack:^(id responseObject) {
        NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
        NSLog(@"%@",dic);
        success(dic);
    } fail:^(id error) {
        failure(error);
    }];
}

/**
 加入购物车
 **/
+(void)shoppingCartWithAccesstoken:(NSString*)accesstoken courseid:(NSString *)courseid success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure{
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/addshopcart",API_BASEURL];
    NSDictionary *parameters = @{
                                 @"accesstoken":accesstoken,
                                 @"courseid":courseid,
                                 };
    [[YJNetWorkTool sharedTool]requestWithURLString:url parameters:parameters method:@"POST" callBack:^(id responseObject) {
        NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
        NSLog(@"%@",dic);
        success(dic);
    } fail:^(id error) {
        failure(error);
    }];
}

/**
 购物车列表
 **/
+(void)MyshoppingCartListWithAccesstoken:(NSString*)accesstoken page:(NSString *)page success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure{
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/myshopcat",API_BASEURL];
    NSDictionary *parameters = @{
                                 @"accesstoken":accesstoken,
                                 @"page":page,
                                 };
    [[YJNetWorkTool sharedTool]requestWithURLString:url parameters:parameters method:@"POST" callBack:^(id responseObject) {
        NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
        NSLog(@"%@",dic);
        success(dic);
    } fail:^(id error) {
        failure(error);
    }];
}

+(void)getWeakdateWithType:(NSString*)Type date:(NSString *)date success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure{
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/weeklivecourselist",API_BASEURL];
    NSDictionary *parameters = @{
                                 @"type":Type,
                                 @"date":date,
                                 };
    [[YJNetWorkTool sharedTool]requestWithURLString:url parameters:parameters method:@"GET" callBack:^(id responseObject) {
        NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
        NSLog(@"%@",dic);
        success(dic);
    } fail:^(id error) {
        failure(error);
    }];
}

/**
 获取订单列表
 **/
+(void)getOrderListWithAccesstoken:(NSString*)Accesstoken type:(NSString *)type page:(NSString *)page success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure{
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/mycourseorder",API_BASEURL];
    NSDictionary *parameters = @{
                                 @"accesstoken":Accesstoken,
                                 @"type":type,
                                 @"page":page,
                                 };
    [[YJNetWorkTool sharedTool]requestWithURLString:url parameters:parameters method:@"POST" callBack:^(id responseObject) {
        NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
        NSLog(@"%@",dic);
        success(dic);
    } fail:^(id error) {
        failure(error);
    }];
}

/**
 删除订单
 **/
+(void)DeleteOrderWithAccesstoken:(NSString*)Accesstoken Id:(NSString *)Id  success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure{
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/delcourseorder",API_BASEURL];
    NSDictionary *parameters = @{
                                 @"accesstoken":Accesstoken,
                                 @"orderid":Id,
                                 };
    [[YJNetWorkTool sharedTool]requestWithURLString:url parameters:parameters method:@"POST" callBack:^(id responseObject) {
        NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
        NSLog(@"%@",dic);
        success(dic);
    } fail:^(id error) {
        failure(error);
    }];
}

/**
 删除购物车订单
 **/
+(void)DeleteCartWithAccesstoken:(NSString*)Accesstoken Id:(NSString *)Id  success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure{
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/delshopcatcourse",API_BASEURL];
    NSDictionary *parameters = @{
                                 @"accesstoken":Accesstoken,
                                 @"courseid":Id,
                                 };
    [[YJNetWorkTool sharedTool]requestWithURLString:url parameters:parameters method:@"POST" callBack:^(id responseObject) {
        NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
        NSLog(@"%@",dic);
        success(dic);
    } fail:^(id error) {
        failure(error);
    }];
}

/**
 课程评价
 **/
+(void)appraiseWithAccesstoken:(NSString*)Accesstoken Id:(NSString *)Id content:(NSString *)content star:(NSString *)star  success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure{
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/writecomment",API_BASEURL];
    NSDictionary *parameters = @{
                                 @"accesstoken":Accesstoken,
                                 @"courseid":Id,
                                 @"content":content,
                                 @"star":star,
                                 };
    [[YJNetWorkTool sharedTool]requestWithURLString:url parameters:parameters method:@"POST" callBack:^(id responseObject) {
        NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
        NSLog(@"%@",dic);
        success(dic);
    } fail:^(id error) {
        failure(error);
    }];
}

/**
 礼物支付
 **/
+(void)GifePayAccesstoken:(NSString*)accesstoken Id:(NSString *)Id count:(NSString *)count remark:(NSString *)remark paytype:(NSString *)paytype success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure{
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/paygoodsorder",API_BASEURL];
    NSDictionary *parameters = @{
                                 @"accesstoken":accesstoken,
                                 @"gid":Id,
                                 @"count":count,
                                 @"remark":remark,
                                 @"dev":@"app",
                                 @"paytype":paytype,
                                 };
    [[YJNetWorkTool sharedTool]requestWithURLString:url parameters:parameters method:@"POST" callBack:^(id responseObject) {
        NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
        NSLog(@"%@",dic);
        success(dic);
    } fail:^(id error) {
        failure(error);
    }];
}

/**
 上传头像。图片
 **/
+(void)upLoadImgWithAccesstoken:(NSString *)accesstoken type:(NSString *)type img:(UIImage *)img success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure{
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/upload",API_BASEURL];
    NSDictionary *parameters = @{
                                 @"accesstoken":accesstoken,
                                 @"type":type,
                                 };
    [[YJNetWorkTool sharedTool]requestWithURLString:url parameters:parameters imgdata:img callBack:^(id responseObject) {
        NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
        NSLog(@"%@",dic);
        success(dic);
    } fail:^(id error) {
        failure(error);
    }];
}

/**
 用户反馈
 **/
+(void)FeedBackAccesstoken:(NSString*)accesstoken content:(NSString *)content img:(NSString *)img phone:(NSString *)phone success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure{
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/submitfeedback",API_BASEURL];
    NSDictionary *parameters = @{
                                 @"content":content,
                                 @"img":img,
                                 @"phone":phone,
                                 };
    [[YJNetWorkTool sharedTool]requestWithURLString:url parameters:parameters method:@"POST" callBack:^(id responseObject) {
        NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
        NSLog(@"%@",dic);
        success(dic);
    } fail:^(id error) {
        failure(error);
    }];
}

/**
 修改头像
 **/
+(void)updataIconWithAccesstoken:(NSString*)accesstoken avator:(NSString *)avator success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure{
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/changeavator",API_BASEURL];
    NSDictionary *parameters = @{
                                 @"accesstoken":accesstoken,
                                 @"avator":avator,
                                 };
    [[YJNetWorkTool sharedTool]requestWithURLString:url parameters:parameters method:@"POST" callBack:^(id responseObject) {
        NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
        NSLog(@"%@",dic);
        success(dic);
    } fail:^(id error) {
        failure(error);
    }];
}

/**
 课程详情内推荐课程
 **/
+(void)recommendCourseWithteacherid:(NSString*)teacherid courseid:(NSString *)courseid success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure{
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/recommendcourse",API_BASEURL];
    NSDictionary *parameters = @{
                                 @"teacherid":teacherid,
                                 @"courseid":courseid,
                                 };
    [[YJNetWorkTool sharedTool]requestWithURLString:url parameters:parameters method:@"GET" callBack:^(id responseObject) {
        NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
        NSLog(@"%@",dic);
        success(dic);
    } fail:^(id error) {
        failure(error);
    }];
}

/**
 学习进度
 **/
+(void)MycoursestudyWithaccesstoken:(NSString*)accesstoken page:(NSString *)page success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure{
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/mycoursestudy",API_BASEURL];
    NSDictionary *parameters = @{
                                 @"accesstoken":accesstoken,
                                 @"page":page,
                                 };
    [[YJNetWorkTool sharedTool]requestWithURLString:url parameters:parameters method:@"POST" callBack:^(id responseObject) {
        NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
        NSLog(@"%@",dic);
        success(dic);
    } fail:^(id error) {
        failure(error);
    }];
}

/**
 视频播放量+1
 **/
+(void)vedioCountWithID:(NSString*)ID success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure{
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/videohitsinc",API_BASEURL];
    NSDictionary *parameters = @{
                                 @"videoid":ID,
                                 };
    [[YJNetWorkTool sharedTool]requestWithURLString:url parameters:parameters method:@"GET" callBack:^(id responseObject) {
        NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
        NSLog(@"%@",dic);
        success(dic);
    } fail:^(id error) {
        failure(error);
    }];
}

/**
 直播验证密码
 **/
+(void)getLivePsdWithToken:(NSString *)token ID:(NSString*)ID pwd:(NSString *)pwd success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure{
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/checkroompwd",API_BASEURL];
    NSDictionary *parameters = @{
                                 @"accesstoken":token,
                                 @"courseid":ID,
                                 @"roompwd":pwd
                                 };
    [[YJNetWorkTool sharedTool]requestWithURLString:url parameters:parameters method:@"POST" callBack:^(id responseObject) {
        NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
        NSLog(@"%@",dic);
        success(dic);
    } fail:^(id error) {
        failure(error);
    }];
}



/**
 首页轮播
 **/
+(void)getAdSuccess:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure{
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/mp/bannerlist",API_BASEURL];
    
    [[YJNetWorkTool sharedTool]requestWithURLString:url parameters:nil method:@"GET" callBack:^(id responseObject) {
        NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
        NSLog(@"%@",dic);
        success(dic);
    } fail:^(id error) {
        failure(error);
    }];
}


@end
