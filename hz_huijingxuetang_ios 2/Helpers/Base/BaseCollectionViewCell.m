//
//  BaseCollectionViewCell.m
//  BM
//
//  Created by txooo on 17/3/1.
//  Copyright © 2017年 张金山. All rights reserved.
//

#import "BaseCollectionViewCell.h"

@implementation BaseCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self tx_configSubViews];
    }
    return self;
}

- (void)tx_configSubViews{};

@end
