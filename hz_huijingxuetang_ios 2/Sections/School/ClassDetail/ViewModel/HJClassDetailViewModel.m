//
//  HJClassDetailViewModel.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/14.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJClassDetailViewModel.h"
#import "HJCourseSelectJiModel.h"
#import "HJCourseDetailCommentModel.h"
@implementation HJClassDetailViewModel


//获取课程详情的数据
- (void)getCourceDetailWithCourseid:(NSString *)courseid Success:(void (^)(BOOL successFlag))success {
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/coursedetail",API_BASEURL];
    NSDictionary *para = @{@"accesstoken": [APPUserDataIofo AccessToken],
                           @"courseid" : courseid .length > 0 ? courseid : @""
                           };
    [[YJNetWorkTool sharedTool] requestWithURLString:url parameters:para method:@"GET" callBack:^(id responseObject) {
        NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
        NSInteger code = [[dic objectForKey:@"code"]integerValue];
        DLog(@"获取到的课程详情的数据是:%@",[NSString convertToJsonData:dic]);
        if (code == 200) {
            NSDictionary *dataDic = dic[@"data"];
            self.commentcount = [dataDic valueForKey:@"commentcount"];
            self.model = [HJSchoolCourseDetailModel mj_objectWithKeyValues:dataDic];
            CGFloat teacheeMessageheight = [self.model.introduction calculateSize:CGSizeMake(Screen_Width - kWidth(70), MAXFLOAT) font:MediumFont(font(11))].height;
            CGFloat minHeight = kHeight(89 + 20);
            CGFloat realHeight = teacheeMessageheight + kHeight(20) + kHeight(70);
            self.model.teacherIntroCellHeight = realHeight > minHeight ? realHeight : minHeight;
            
            CGFloat courseMessageheight = [self.model.coursedes calculateSize:CGSizeMake(Screen_Width - kWidth(20), MAXFLOAT) font:MediumFont(font(11))].height;
            self.model.courseCellHeight = kHeight(68) + courseMessageheight;
            success(YES);
        } else {
            success(NO);
            if(!MaJia) {
                ShowError([dic objectForKey:@"msg"]);
            }
        }
    } fail:^(id error) {
        success(NO);
        if(!MaJia) {
            ShowError(error);
        }
    }];
}

//获取选集列表的数据
- (void)getCourceSelectJiWithCourseid:(NSString *)courseid Success:(void (^)(void))success {
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/coursedirectory",API_BASEURL];
    NSDictionary *para = @{
                           @"courseid" : courseid .length > 0 ? courseid : @""
                           };
    [[YJNetWorkTool sharedTool] requestWithURLString:url parameters:para method:@"GET" callBack:^(id responseObject) {
        NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
        NSInteger code = [[dic objectForKey:@"code"]integerValue];
        if (code == 200) {
            NSArray *dataArr = dic[@"data"];
            NSMutableArray *marr = [NSMutableArray array];
            for (NSDictionary *dic in dataArr) {
                HJCourseSelectJiModel *model = [HJCourseSelectJiModel mj_objectWithKeyValues:dic];
                [marr addObject:model];
            }
           
            self.selectJiArray = marr;
            success();
        } else {
            ShowError([dic objectForKey:@"msg"]);
        }
    } fail:^(id error) {
        ShowError(error);
    }];
}

//获取评论列表的数据
- (void)getCourceCommentWithCourseid:(NSString *)courseid Success:(void (^)(void))success {
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/coursecomment",API_BASEURL];
    NSDictionary *parameters = nil;
    parameters = @{
                   @"courseid" : courseid.length > 0 ? courseid : @"",
                   @"reqpage" : [NSString stringWithFormat:@"%ld",self.page],
                   @"accesstoken" : [APPUserDataIofo AccessToken]
                   };
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[YJNetWorkTool sharedTool] requestWithURLString:url parameters:parameters method:@"GET" callBack:^(id responseObject) {
            NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
            NSInteger code = [[dic objectForKey:@"code"]integerValue];
            if (code == 200) {
                NSDictionary *dataDict = dic[@"data"];
                NSArray *commentArr = dataDict[@"coursecomment"];
                self.totalpage = [dataDict[@"totalpage"] intValue];
                self.currentpage = [dataDict[@"currentpage"] intValue];
                self.totalcount = [dataDict[@"totalcount"] intValue];
                self.starlevel = dataDict[@"starlevel"];
                self.commentcount = dataDict[@"commentcount"];
                NSMutableArray *marr = [NSMutableArray array];
                for (NSDictionary *dic in commentArr) {
                    HJCourseDetailCommentModel *model = [HJCourseDetailCommentModel mj_objectWithKeyValues:dic];
                    CGFloat height = [model.commentcontent calculateSize:CGSizeMake(Screen_Width - kWidth(75), MAXFLOAT) font:MediumFont(font(13))].height;
                    model.cellHeight = height + kHeight(78);
                    [marr addObject:model];
                }
                if (self.page == 1) {
                    self.commentArray = marr;
                } else {
                    [self.commentArray addObjectsFromArray:marr];
                }
                if (marr.count < 10) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
                self.tableView.mj_footer.hidden = self.commentArray.count < 10 ? YES : NO;
                success();
            } else {
                ShowError([dic objectForKey:@"msg"]);
            }
        } fail:^(id error) {
            hideHud();
            ShowError(error);
        }];
    });
}

//播放量加1的数据请求
- (void)addCourseCommentCountWithVideoId:(NSString *)videoId Success:(void (^)(void))success {
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/videohitsinc",API_BASEURL];
    NSDictionary *parameters = nil;
    parameters = @{
                    @"videoid" : videoId.length > 0 ? videoId : @""
                  };
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[YJNetWorkTool sharedTool] requestWithURLString:url parameters:parameters method:@"GET" callBack:^(id responseObject) {
            NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
            NSInteger code = [[dic objectForKey:@"code"]integerValue];
            if (code == 200) {
                success();
            } else {
                ShowError([dic objectForKey:@"msg"]);
            }
        } fail:^(id error) {
            hideHud();
            ShowError(error);
        }];
    });
}

//加入购物车的操作
- (void)addShopListOperationWithCourseId:(NSString *)courseId Success:(void (^)(void))success {
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/addshopcart",API_BASEURL];
    NSDictionary *para = @{@"accesstoken": [APPUserDataIofo AccessToken],
                           @"courseid" : courseId .length > 0 ? courseId : @""
                           };
    [[YJNetWorkTool sharedTool] requestWithURLString:url parameters:para method:@"POST" callBack:^(id responseObject) {
        NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
        NSInteger code = [[dic objectForKey:@"code"]integerValue];
        if (code == 200) {
            success();
        } else {
            ShowError([dic objectForKey:@"msg"]);
        }
    } fail:^(id error) {
        ShowError(error);
    }];
}

//生成免费的订单
- (void)createFreeCourseOrderWithCourseId:(NSString *)courseId Success:(void (^)(BOOL succcessFlag))success {
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/createfreecourseorder",API_BASEURL];
    NSDictionary *para = @{@"accesstoken": [APPUserDataIofo AccessToken],
                           @"courseid" : courseId .length > 0 ? courseId : @""
                           };
    [[YJNetWorkTool sharedTool] requestWithURLString:url parameters:para method:@"POST" callBack:^(id responseObject) {
        NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
        NSInteger code = [[dic objectForKey:@"code"]integerValue];
        if (code == 200) {
            success(YES);
        } else {
            success(NO);
            ShowError([dic objectForKey:@"msg"]);
        }
    } fail:^(id error) {
        success(NO);
        ShowError(error);
    }];
}

//选集的数据源的操作
- (NSMutableArray *)selectJiArray {
    if(!_selectJiArray){
        _selectJiArray = [NSMutableArray array];
    }
    return  _selectJiArray;
}

//评论的数据源的数量
- (NSMutableArray *)commentArray {
    if(!_commentArray){
        _commentArray = [NSMutableArray array];
    }
    return  _commentArray;
}

@end
