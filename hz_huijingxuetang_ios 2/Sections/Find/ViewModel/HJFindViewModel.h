//
//  HJFindViewModel.h
//  HuiJingSchool
//
//  Created by 张金山 on 2018/10/30.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "BaseViewModel.h"

typedef NS_ENUM(NSInteger,FindSegmentType){
    FindSegmentTypeRecommond = 0,
    FindSegmentTypeCare = 1
};

NS_ASSUME_NONNULL_BEGIN

@interface HJFindViewModel : BaseViewModel

@property (nonatomic,weak) UITableView *tableView;
@property (nonatomic,assign) NSInteger page;

@property (nonatomic , assign) NSInteger              currentpage;
@property (nonatomic , assign) NSInteger              totalpage;



@property (nonatomic,strong) NSMutableArray *findArray;
- (void)teacherDynamicRecommondListWithSuccess:(void (^)(void))success;

@property (nonatomic,strong) NSMutableArray *careArray;
- (void)teacherDynamicCareListWithSuccess:(void (^)(void))success;

@property (nonatomic,assign) FindSegmentType findSegmentType;

//关注的操作
- (void)careOrCancleCareWithTeacherId:(NSString *)teacherId
                          accessToken:(NSString *)accessToken
                            insterest:(NSString *)insterest
                              Success:(void (^)(void))success;

@end

NS_ASSUME_NONNULL_END
