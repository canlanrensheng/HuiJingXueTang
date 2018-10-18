//
//  BaseTableViewCellProtocol.h
//  ZhuanMCH
//
//  Created by txooo on 16/12/14.
//  Copyright © 2016年 张金山. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BaseViewModel;
@protocol BaseTableViewCellProtocol <NSObject>

@optional

- (void)tx_configSubViews;

- (void)setViewModel:(BaseViewModel *)viewModel indexPath:(NSIndexPath *)indexPath;

@end
