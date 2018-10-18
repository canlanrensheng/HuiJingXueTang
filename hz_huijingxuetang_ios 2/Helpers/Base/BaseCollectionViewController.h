//
//  BaseCollectionViewController.h
//  ZhuanMCH
//
//  Created by txooo on 17/6/29.
//  Copyright © 2017年 张金山. All rights reserved.
//

#import "BaseViewController.h"
#import "BaseCollectionViewControllerProtocol.h"

@interface BaseCollectionViewController : BaseViewController<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,BaseCollectionViewControllerProtocol>

@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,strong) NSMutableArray *dataArray;

@end
