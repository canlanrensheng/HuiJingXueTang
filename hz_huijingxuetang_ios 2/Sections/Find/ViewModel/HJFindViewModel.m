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

- (void)teacherDynamicRecommondListWithSuccess:(void (^)(void))success {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/teacherdynamiclist",API_BASEURL];
        NSDictionary *parameters = nil;
        if([APPUserDataIofo AccessToken].length <= 0){
            parameters =  @{
                           @"page" : [NSString stringWithFormat:@"%ld",self.page]
                          };
        } else {
            parameters =  @{
                            @"page" : [NSString stringWithFormat:@"%ld",self.page],
                            @"accesstoken" : [APPUserDataIofo AccessToken]
                            };
        }
//        if (self.page == 1) {
//            ShowHint(@"");
//        }
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
                    
//                    model.dynamicpic1 = @"http://imgsrc.baidu.com/forum/eWH%3D240%2C176/sign=183252ee8bd6277ffb784f351a0c2f1c/5d6034a85edf8db15420ba310523dd54564e745d.jpg";
//                    model.dynamicpic2 = @"http://imgsrc.baidu.com/forum/eWH%3D240%2C176/sign=183252ee8bd6277ffb784f351a0c2f1c/5d6034a85edf8db15420ba310523dd54564e745d.jpg";
//                    model.dynamicpic3 = @"http://imgsrc.baidu.com/forum/eWH%3D240%2C176/sign=183252ee8bd6277ffb784f351a0c2f1c/5d6034a85edf8db15420ba310523dd54564e745d.jpg";
//                    model.dynamicpic4 = @"http://imgsrc.baidu.com/forum/eWH%3D240%2C176/sign=183252ee8bd6277ffb784f351a0c2f1c/5d6034a85edf8db15420ba310523dd54564e745d.jpg";
//                    model.dynamicpic5 = @"http://imgsrc.baidu.com/forum/eWH%3D240%2C176/sign=183252ee8bd6277ffb784f351a0c2f1c/5d6034a85edf8db15420ba310523dd54564e745d.jpg";
//                    model.dynamicpic6 = @"http://imgsrc.baidu.com/forum/eWH%3D240%2C176/sign=183252ee8bd6277ffb784f351a0c2f1c/5d6034a85edf8db15420ba310523dd54564e745d.jpg";
//                    model.dynamicpic7 = @"http://imgsrc.baidu.com/forum/eWH%3D240%2C176/sign=183252ee8bd6277ffb784f351a0c2f1c/5d6034a85edf8db15420ba310523dd54564e745d.jpg";
//                    model.dynamicpic8 = @"http://imgsrc.baidu.com/forum/eWH%3D240%2C176/sign=183252ee8bd6277ffb784f351a0c2f1c/5d6034a85edf8db15420ba310523dd54564e745d.jpg";
                    
//                    model.dynamiclinkid = @"100";
                    
//                    model.dynamicvideo = @"http://tb-video.bdstatic.com/tieba-smallvideo/68_20df3a646ab5357464cd819ea987763a.mp4";
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
                    self.findArray = marr;
                } else {
                    [self.findArray addObjectsFromArray:marr];
                }
                if (marr.count < 10) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
                self.tableView.mj_footer.hidden =  self.findArray.count < 10 ? YES : NO;
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

//关注列表获取
- (void)teacherDynamicCareListWithSuccess:(void (^)(void))success {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *url = [NSString stringWithFormat:@"%@LiveApi/app/teacherdynamiclist",API_BASEURL];
        NSDictionary *parameters = @{
                                     @"page" : [NSString stringWithFormat:@"%ld",self.page],
                                     @"accesstoken" : [APPUserDataIofo AccessToken] ,
                                     @"isinterest" : @"2"
                                     };
//        if (self.page == 1) {
//            ShowHint(@"");
//        }
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
                    
                    //                    model.dynamicpic1 = @"http://imgsrc.baidu.com/forum/eWH%3D240%2C176/sign=183252ee8bd6277ffb784f351a0c2f1c/5d6034a85edf8db15420ba310523dd54564e745d.jpg";
                    //                    model.dynamicpic2 = @"http://imgsrc.baidu.com/forum/eWH%3D240%2C176/sign=183252ee8bd6277ffb784f351a0c2f1c/5d6034a85edf8db15420ba310523dd54564e745d.jpg";
                    //                    model.dynamicpic3 = @"http://imgsrc.baidu.com/forum/eWH%3D240%2C176/sign=183252ee8bd6277ffb784f351a0c2f1c/5d6034a85edf8db15420ba310523dd54564e745d.jpg";
                    //                    model.dynamicpic4 = @"http://imgsrc.baidu.com/forum/eWH%3D240%2C176/sign=183252ee8bd6277ffb784f351a0c2f1c/5d6034a85edf8db15420ba310523dd54564e745d.jpg";
                    //                    model.dynamicpic5 = @"http://imgsrc.baidu.com/forum/eWH%3D240%2C176/sign=183252ee8bd6277ffb784f351a0c2f1c/5d6034a85edf8db15420ba310523dd54564e745d.jpg";
                    //                    model.dynamicpic6 = @"http://imgsrc.baidu.com/forum/eWH%3D240%2C176/sign=183252ee8bd6277ffb784f351a0c2f1c/5d6034a85edf8db15420ba310523dd54564e745d.jpg";
                    //                    model.dynamicpic7 = @"http://imgsrc.baidu.com/forum/eWH%3D240%2C176/sign=183252ee8bd6277ffb784f351a0c2f1c/5d6034a85edf8db15420ba310523dd54564e745d.jpg";
                    //                    model.dynamicpic8 = @"http://imgsrc.baidu.com/forum/eWH%3D240%2C176/sign=183252ee8bd6277ffb784f351a0c2f1c/5d6034a85edf8db15420ba310523dd54564e745d.jpg";
                    
//                    model.dynamiclinkid = @"100";
                    
//                    model.dynamicvideo = @"http://tb-video.bdstatic.com/tieba-smallvideo/68_20df3a646ab5357464cd819ea987763a.mp4";
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
    ShowHint(@"");
    [[YJNetWorkTool sharedTool] requestWithURLString:url parameters:parameters method:@"POST" callBack:^(id responseObject) {
        hideHud();
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
