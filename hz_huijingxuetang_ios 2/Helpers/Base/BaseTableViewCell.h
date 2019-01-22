//
//  BaseTableViewCell.h
//  ZhuanMCH
//
//  Created by txooo on 16/12/14.
//  Copyright © 2016年 张金山. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSLoadingView.h"
#import "BaseTableViewCellProtocol.h"

@interface BaseTableViewCell : UITableViewCell<BaseTableViewCellProtocol>

@property (nonatomic,strong) RACSubject *backSubject;
@property (nonatomic,strong) JSLoadingView *loadingView;

@end
