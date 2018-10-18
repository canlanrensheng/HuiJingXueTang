//
//  BaseTableViewControllerProtocol.h
//  ZhuanMCH
//
//  Created by txooo on 16/12/14.
//  Copyright © 2016年 张金山. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BaseTableViewControllerProtocol <NSObject>

@optional

- (void)tx_refreshData;

- (void)configTableViewCell:(UITableViewCell *)cell cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@end
