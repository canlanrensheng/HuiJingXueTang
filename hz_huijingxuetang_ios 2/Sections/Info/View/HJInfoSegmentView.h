//
//  HJInfoSegmentView.h
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/6.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "BaseView.h"


@interface HJInfoSegmentView : BaseView

@property (nonatomic,strong) RACSubject *clickSubject;

@property (nonatomic,strong) NSMutableArray *nameArray;

@end


