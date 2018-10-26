//
//  HJSearchResultViewController.h
//  HuiJingSchool
//
//  Created by 张金山 on 2018/10/26.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "BaseTableViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, SearchType) {
    SearchTypeIsTeacher = 1,   //老师
    SearchTypeIsLive,          //直播
    SearchTypeIsCource,        //课程
    SearchTypeIsInformation     //资讯
};

@interface HJSearchResultViewController : BaseViewController
@property (nonatomic,assign) SearchType searchType;
@property (nonatomic,assign) NSInteger pageIndex;
//用户输入次数，用来控制延迟搜索请求
//@property (nonatomic,assign) NSInteger inputCount;


NS_ASSUME_NONNULL_END

@end
