//
//  HJFindRecommondVideoCell.h
//  HuiJingSchool
//
//  Created by 张金山 on 2018/10/31.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "BaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN


@protocol ZFTableViewCellDelegate <NSObject>

- (void)zf_playTheVideoAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface HJFindRecommondVideoCell : BaseTableViewCell

@property (nonatomic,strong) RACSubject *backRefreshSubject;


@property (nonatomic, copy) void(^playCallback)(void);

- (void)setDelegate:(id<ZFTableViewCellDelegate>)delegate withIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
