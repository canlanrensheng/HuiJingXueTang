//
//  BaseTableViewController.h
//  ZhuanMCH
//
//  Created by txooo on 16/12/6.
//  Copyright © 2016年 张金山. All rights reserved.
//

#import "BaseViewController.h"
#import "BaseTableViewControllerProtocol.h"

@interface BaseTableViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,BaseTableViewControllerProtocol,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>


@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *dataArray;
//Default is plain,use it before [super viewDidLoad]
@property (nonatomic,assign) UITableViewStyle tableViewStyle;

@property (nonatomic,assign) NSInteger numberOfSections;

@property (nonatomic,assign) NSInteger numberOfRows;

@property (nonatomic,assign) CGFloat tableViewRowHeight;

@property (nonatomic,assign) CGFloat sectionFooterHeight;

@property (nonatomic,assign) CGFloat sectionHeaderHeight;

@property (nonatomic,copy) void (^tableViewRowSelectBlock)(NSIndexPath *);

@end
