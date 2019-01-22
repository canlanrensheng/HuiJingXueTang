//
//  HJFindViewModel.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/10/30.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJFindViewModel.h"
#import "HJFindRecommondModel.h"

#import <AVFoundation/AVFoundation.h>

@implementation HJFindViewModel

//检测资讯VIP权限
- (void)checkVipInfoPowerWithInfoId:(NSString *)infoId success:(void (^)(void))success {
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/cangetvipnews",API_BASEURL];
    NSDictionary *parameters = nil;
    parameters = @{
                   @"accesstoken" : [APPUserDataIofo AccessToken],
                   @"infoid" : infoId
                   };
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[YJNetWorkTool sharedTool] requestWithURLString:url parameters:parameters method:@"POST" callBack:^(id responseObject) {
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

//推荐列表的数据
- (void)teacherDynamicRecommondListWithTeacherid:(NSString *)teacherid Success:(void (^)(BOOL successFlag))success{
    
    if(self.isDynamicRecommondFirstLoad.length <= 0) {
        [self.loadingView startAnimating];
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/teacherdynamiclist",API_BASEURL];
        NSDictionary *parameters = nil;
        if(teacherid.length > 0) {
            //老师的动态
            if( [APPUserDataIofo AccessToken].length <= 0) {
                parameters =  @{
                                @"teacherid" : teacherid.length > 0 ? teacherid : @""
                                };
            } else {
                parameters =  @{
                                @"teacherid" : teacherid.length > 0 ? teacherid : @"",
                                @"accesstoken" : [APPUserDataIofo AccessToken]
                                };
            }
            if(MaJia) {
                parameters = @{
                               @"teacherid" : teacherid.length > 0 ? teacherid : @""
                               ,@"vesttype" : @"free",
                                @"accesstoken" : [APPUserDataIofo AccessToken]
                               };
            }
        } else {
            if([APPUserDataIofo AccessToken].length <= 0){
                parameters =  @{
                                @"page" : [NSString stringWithFormat:@"%ld",self.page]
                                };
                if(MaJia) {
                    parameters =  @{
                                    @"page" : [NSString stringWithFormat:@"%ld",self.page],
                                    @"vesttype" : @"free"
                                   };
                }
            } else {
                parameters =  @{
                                @"page" : [NSString stringWithFormat:@"%ld",self.page],
                                @"accesstoken" : [APPUserDataIofo AccessToken]
                                };
                if(MaJia) {
                    parameters =  @{
                                    @"page" : [NSString stringWithFormat:@"%ld",self.page],
                                    @"accesstoken" : [APPUserDataIofo AccessToken],
                                    @"vesttype" : @"free"
                                    };
                }
            }
        }
        STARTTIME;
        [[YJNetWorkTool sharedTool] requestWithURLString:url parameters:parameters method:@"GET" callBack:^(id responseObject) {
            if(self.isDynamicRecommondFirstLoad.length <= 0) {
                [self.loadingView stopLoadingView];
                self.isDynamicRecommondFirstLoad = @"1";
            }
            STOPTIME;
            hideHud();
            NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
            NSInteger code = [[dic objectForKey:@"code"]integerValue];
            if (code == 200) {
                NSDictionary *dataDict = dic[@"data"];
                NSArray *stocklistArr = dataDict[@"dynamiclist"];
                self.totalpage = [dataDict[@"totalpage"] intValue];
                self.currentpage = [dataDict[@"currentpage"] intValue];
                NSMutableArray *marr = [NSMutableArray array];
                for(int i = 0; i < stocklistArr.count;i++) {
                    NSDictionary *daDic = stocklistArr[i];
                    HJFindRecommondModel *model = [HJFindRecommondModel mj_objectWithKeyValues:daDic];
                    CGFloat height = [model.dynamiccontent calculateSize:CGSizeMake(Screen_Width - kWidth(65), MAXFLOAT) font:MediumFont(font(13))].height;
                    
                    NSMutableArray *picArr = [[NSMutableArray alloc] init];
                    if(model.dynamicpic1.length > 0) {
                        [picArr addObject:model.dynamicpic1];
                    }
                    if(model.dynamicpic2.length > 0) {
                        [picArr addObject:model.dynamicpic2];
                    }
                    if(model.dynamicpic3.length > 0) {
                        [picArr addObject:model.dynamicpic3];
                    }
                    if(model.dynamicpic4.length > 0) {
                        [picArr addObject:model.dynamicpic4];
                    }
                    if(model.dynamicpic5.length > 0) {
                        [picArr addObject:model.dynamicpic5];
                    }
                    if(model.dynamicpic6.length > 0) {
                        [picArr addObject:model.dynamicpic6];
                    }
                    if(model.dynamicpic7.length > 0) {
                        [picArr addObject:model.dynamicpic7];
                    }
                    if(model.dynamicpic8.length > 0) {
                        [picArr addObject:model.dynamicpic8];
                    }
                    if(model.dynamicpic9.length > 0) {
                        [picArr addObject:model.dynamicpic9];
                    }
                    
                    
                    //纯文字
                    if(model.dynamiccontent.length > 0 &&
                       picArr.count <= 0  &&
                       model.dynamicvideo.length <=0 &&
                       model.dynamiclinkid.length <= 0) {
                        
                       model.findType = FindTypeText;
                       model.cellHeight = kHeight(85) + height;
                        
                        //文字加链接
                    } else if(model.dynamiccontent.length > 0 &&
                           picArr.count <= 0 &&
                           model.dynamicvideo.length <=0 &&
                           model.dynamiclinkid.length > 0) {
                            
                           model.findType = FindTypeLink;
                           model.cellHeight = kHeight(85) + height + kHeight(60) + kHeight(15);
                        //文字图片类型
                    } else if(model.dynamiccontent.length > 0 &&
                           picArr.count > 0 &&
                           model.dynamicvideo.length <=0 &&
                           model.dynamiclinkid.length <= 0) {
                           model.picArray = picArr;
                            CGFloat padding = kWidth(10);
                            CGFloat onePicHeight = (Screen_Width - kWidth(55) - kWidth(10) - padding * 2 ) / 3;
                            CGFloat scrollViewHeight = 0;
                            if(model.picArray.count <= 3) {
                                scrollViewHeight = onePicHeight;
                            } else if (model.picArray.count <= 6) {
                                scrollViewHeight = onePicHeight * 2 + padding;
                            } else if (model.picArray.count <= 9) {
                                scrollViewHeight = onePicHeight * 3 + padding * 2;
                            }
                            model.findType = FindTypePic;
                            model.cellHeight = kHeight(85) + height + scrollViewHeight + kHeight(15);
                    //文字加图片加链接
                    } else if(model.dynamiccontent.length > 0 &&
                           picArr.count > 0 &&
                           model.dynamicvideo.length <= 0 &&
                           model.dynamiclinkid.length > 0) {
                            model.picArray = picArr;
                            CGFloat padding = kWidth(10);
                            CGFloat onePicHeight = (Screen_Width - kWidth(55) - kWidth(10) - padding * 2 ) / 3;
                            CGFloat scrollViewHeight = 0;
                            if(model.picArray.count <= 3) {
                                scrollViewHeight = onePicHeight;
                            } else if (model.picArray.count <= 6) {
                                scrollViewHeight = onePicHeight * 2 + padding;
                            } else if (model.picArray.count <= 9) {
                                scrollViewHeight = onePicHeight * 3 + padding * 2;
                            }
                            
                            model.findType = FindTypePicLink;
                            model.cellHeight = (kHeight(85) + height) + (scrollViewHeight + kHeight(15)) + (kHeight(60) + kHeight(15));
                        //文字加视频
                    } else  if(model.dynamiccontent.length > 0 &&
                           picArr.count <= 0 &&
                           model.dynamicvideo.length > 0 &&
                           model.dynamiclinkid.length <= 0) {
                            
                           model.coverVideoImg = [self getImageWithVideoURL:URL(model.dynamicvideo) size:CGSizeMake(Screen_Width - kWidth(65), (Screen_Width - kWidth(65)) / 16 * 9)];
                           model.findType = FindTypeVideo;
                           model.cellHeight = kHeight(85) + height + (Screen_Width - kWidth(65)) / 16 * 9 + kHeight(15);
                        //文字视频加链接
                    } else  if(model.dynamiccontent.length > 0 &&
                           picArr.count <= 0 &&
                           model.dynamicvideo.length > 0 &&
                           model.dynamiclinkid.length > 0) {
                            
                            model.coverVideoImg = [self getImageWithVideoURL:URL(model.dynamicvideo) size:CGSizeMake(Screen_Width - kWidth(65), (Screen_Width - kWidth(65)) / 16 * 9)];
                            model.findType = FindTypeVideoLink;
                            model.cellHeight = (kHeight(85) + height) + ((Screen_Width - kWidth(65)) / 16 * 9 + kHeight(15)) + (kHeight(60) + kHeight(15));
                    }
                    [marr addObject:model];
                }
                if(self.page == 1) {
                    self.findArray = marr;
                } else {
                    [self.findArray addObjectsFromArray:marr];
                }
                if (marr.count < 10) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
                self.tableView.mj_footer.hidden =  self.findArray.count < 10 ? YES : NO;
                success(YES);
            } else {
                if(self.isDynamicRecommondFirstLoad.length <= 0) {
                    [self.loadingView stopLoadingView];
                    self.isDynamicRecommondFirstLoad = @"1";
                }
                success(NO);
                ShowError([dic objectForKey:@"msg"]);
            }
        } fail:^(id error) {
            if(self.isDynamicRecommondFirstLoad.length <= 0) {
                [self.loadingView stopLoadingView];
                self.isDynamicRecommondFirstLoad = @"1";
            }
            success(NO);
            hideHud();
            ShowError(error);
        }];
    });
}

//关注列表获取
- (void)teacherDynamicCareListWithSuccess:(void (^)(void))success {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/teacherdynamiclist",API_BASEURL];
        NSDictionary *parameters = @{
                                     @"page" : [NSString stringWithFormat:@"%ld",self.page],
                                     @"accesstoken" : [APPUserDataIofo AccessToken] ,
                                     @"isinterest" : @"2"
                                     };
        if(MaJia) {
            parameters = @{
                           @"page" : [NSString stringWithFormat:@"%ld",self.page],
                           @"accesstoken" : [APPUserDataIofo AccessToken] ,
                           @"isinterest" : @"2",
                           @"vesttype" : @"free"
                           };
        }
        [[YJNetWorkTool sharedTool] requestWithURLString:url parameters:parameters method:@"GET" callBack:^(id responseObject) {
            hideHud();
            NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
            NSInteger code = [[dic objectForKey:@"code"]integerValue];
            if (code == 200) {
                NSDictionary *dataDict = dic[@"data"];
                NSArray *stocklistArr = dataDict[@"dynamiclist"];
                self.totalpage = [dataDict[@"totalpage"] intValue];
                self.currentpage = [dataDict[@"currentpage"] intValue];
                NSMutableArray *marr = [NSMutableArray array];
                for(NSDictionary *daDic in stocklistArr) {
                    HJFindRecommondModel *model = [HJFindRecommondModel mj_objectWithKeyValues:daDic];
                    CGFloat height = [model.dynamiccontent calculateSize:CGSizeMake(Screen_Width - kWidth(65), MAXFLOAT) font:MediumFont(font(13))].height;
                    //纯文字
                    if(model.dynamiccontent.length > 0 &&
                       model.dynamicpic1.length <= 0  &&
                       model.dynamicvideo.length <=0 &&
                       model.dynamiclinkid.length <= 0) {
                        
                       model.findType = FindTypeText;
                       model.cellHeight = kHeight(85) + height;
                    }
                    
                    //文字图片类型
                    if(model.dynamiccontent.length > 0 &&
                       model.dynamicpic1.length > 0 &&
                       model.dynamicvideo.length <=0 &&
                       model.dynamiclinkid.length <= 0) {
                        
                        NSMutableArray *picArr = [NSMutableArray array];
                        if(model.dynamicpic1.length > 0) {
                            [picArr addObject:model.dynamicpic1];
                        }
                        if(model.dynamicpic2.length > 0) {
                            [picArr addObject:model.dynamicpic2];
                        }
                        if(model.dynamicpic3.length > 0) {
                            [picArr addObject:model.dynamicpic3];
                        }
                        if(model.dynamicpic4.length > 0) {
                            [picArr addObject:model.dynamicpic4];
                        }
                        if(model.dynamicpic5.length > 0) {
                            [picArr addObject:model.dynamicpic5];
                        }
                        if(model.dynamicpic6.length > 0) {
                            [picArr addObject:model.dynamicpic6];
                        }
                        if(model.dynamicpic7.length > 0) {
                            [picArr addObject:model.dynamicpic7];
                        }
                        if(model.dynamicpic8.length > 0) {
                            [picArr addObject:model.dynamicpic8];
                        }
                        if(model.dynamicpic9.length > 0) {
                            [picArr addObject:model.dynamicpic9];
                        }
                        
                        model.picArray = picArr;
                        CGFloat padding = kWidth(10);
                        CGFloat onePicHeight = (Screen_Width - kWidth(55) - kWidth(10) - padding * 2 ) / 3;
                        CGFloat scrollViewHeight = 0;
                        if(model.picArray.count <= 3) {
                            scrollViewHeight = onePicHeight;
                        } else if (model.picArray.count <= 6) {
                            scrollViewHeight = onePicHeight * 2 + padding;
                        } else if (model.picArray.count <= 9) {
                            scrollViewHeight = onePicHeight * 3 + padding * 2;
                        }
                        model.findType = FindTypePic;
                        model.cellHeight = kHeight(85) + height + scrollViewHeight + kHeight(15);
                    }
                    
                    //文字加链接
                    if(model.dynamiccontent.length > 0 &&
                       model.dynamicpic1.length <= 0 &&
                       model.dynamicvideo.length <=0 &&
                       model.dynamiclinkid.length > 0) {
                        
                        model.findType = FindTypeLink;
                        model.cellHeight = kHeight(85) + height + kHeight(60) + kHeight(15);
                    }
                    
                    //文字加视频
                    if(model.dynamiccontent.length > 0 &&
                       model.dynamicpic1.length <= 0 &&
                       model.dynamicvideo.length > 0 &&
                       model.dynamiclinkid.length <= 0) {
                        
                        model.coverVideoImg = [self getImageWithVideoURL:URL(model.dynamicvideo) size:CGSizeMake(Screen_Width - kWidth(65), (Screen_Width - kWidth(65)) / 16 * 9)];
                        model.findType = FindTypeVideo;
                        model.cellHeight = kHeight(85) + height + (Screen_Width - kWidth(65)) / 16 * 9 + kHeight(15);
                    }
                    
                    //文字加图片加链接
                    if(model.dynamiccontent.length > 0 &&
                       model.dynamicpic1.length > 0 &&
                       model.dynamicvideo.length <= 0 &&
                       model.dynamiclinkid.length > 0) {
                        
                        NSMutableArray *picArr = [NSMutableArray array];
                        if(model.dynamicpic1.length > 0) {
                            [picArr addObject:model.dynamicpic1];
                        }
                        if(model.dynamicpic2.length > 0) {
                            [picArr addObject:model.dynamicpic2];
                        }
                        if(model.dynamicpic3.length > 0) {
                            [picArr addObject:model.dynamicpic3];
                        }
                        if(model.dynamicpic4.length > 0) {
                            [picArr addObject:model.dynamicpic4];
                        }
                        if(model.dynamicpic5.length > 0) {
                            [picArr addObject:model.dynamicpic5];
                        }
                        if(model.dynamicpic6.length > 0) {
                            [picArr addObject:model.dynamicpic6];
                        }
                        if(model.dynamicpic7.length > 0) {
                            [picArr addObject:model.dynamicpic7];
                        }
                        if(model.dynamicpic8.length > 0) {
                            [picArr addObject:model.dynamicpic8];
                        }
                        if(model.dynamicpic9.length > 0) {
                            [picArr addObject:model.dynamicpic9];
                        }
                        
                        model.picArray = picArr;
                        CGFloat padding = kWidth(10);
                        CGFloat onePicHeight = (Screen_Width - kWidth(55) - kWidth(10) - padding * 2 ) / 3;
                        CGFloat scrollViewHeight = 0;
                        if(model.picArray.count <= 3) {
                            scrollViewHeight = onePicHeight;
                        } else if (model.picArray.count <= 6) {
                            scrollViewHeight = onePicHeight * 2 + padding;
                        } else if (model.picArray.count <= 9) {
                            scrollViewHeight = onePicHeight * 3 + padding * 2;
                        }
                        
                        model.findType = FindTypePicLink;
                        model.cellHeight = (kHeight(85) + height) + (scrollViewHeight + kHeight(15)) + (kHeight(60) + kHeight(15));
                    }
                    
                    //文字视频加链接
                    if(model.dynamiccontent.length > 0 &&
                       model.dynamicpic1.length <= 0 &&
                       model.dynamicvideo.length > 0 &&
                       model.dynamiclinkid.length > 0) {
                        
                        model.coverVideoImg = [self getImageWithVideoURL:URL(model.dynamicvideo) size:CGSizeMake(Screen_Width - kWidth(65), (Screen_Width - kWidth(65)) / 16 * 9)];
                        model.findType = FindTypeVideoLink;
                        model.cellHeight = (kHeight(85) + height) + ((Screen_Width - kWidth(65)) / 16 * 9 + kHeight(15)) + (kHeight(60) + kHeight(15));
                    }
                    
                    [marr addObject:model];
                }
                if(self.page == 1) {
                    self.careArray = marr;
                } else {
                    [self.careArray addObjectsFromArray:marr];
                }
                if (marr.count < 10) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
                self.tableView.mj_footer.hidden =  self.careArray.count < 10 ? YES : NO;
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

//关注和取消关注
- (void)careOrCancleCareWithTeacherId:(NSString *)teacherId
                          accessToken:(NSString *)accessToken
                            insterest:(NSString *)insterest
                              Success:(void (^)(void))success {
    NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/tointerestornot",API_BASEURL];
    NSDictionary *parameters = @{
                                 @"accesstoken" : [APPUserDataIofo AccessToken],
                                 @"teacherid" : teacherId,
                                 @"interest" :insterest
                                 };
//    ShowHint(@"");
    [[YJNetWorkTool sharedTool] requestWithURLString:url parameters:parameters method:@"POST" callBack:^(id responseObject) {
//        hideHud();
        NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
        NSInteger code = [[dic objectForKey:@"code"]integerValue];
        if (code == 200) {
            //刷新数据
            success();
        } else {
            ShowError([dic objectForKey:@"msg"]);
        }
    } fail:^(id error) {
//        hideHud();
        ShowError(error);
    }];
}

- (UIImage *)getImageWithVideoURL:(NSURL *)url size:(CGSize)size{
    // 获取视频第一帧
    NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:url options:opts];
    AVAssetImageGenerator *generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:urlAsset];
    generator.appliesPreferredTrackTransform = YES;
    generator.maximumSize = CGSizeMake(size.width, size.height);
    NSError *error = nil;
    CGImageRef img = [generator copyCGImageAtTime:CMTimeMake(0, 10) actualTime:NULL error:&error];
    {
        return [UIImage imageWithCGImage:img];
    }
    return nil;
}


@end
