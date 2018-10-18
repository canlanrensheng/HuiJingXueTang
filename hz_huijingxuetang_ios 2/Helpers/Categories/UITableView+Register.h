//
//  UITableView+Register.h
//  BaoXianBaApp
//
//  Created by JngViho on 2017/3/22.
//  Copyright © 2017年 yjyc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface UITableView (Register)

- (void)registerNibCell:(nullable Class)className;
- (void)registerClassCell:(nullable Class)className;
- (void)registerNibHeaderFooter:(nullable Class)className;
- (void)registerClassHeaderFooter:(nullable Class)className;
- (__kindof UITableViewCell *_Nonnull)reuseCell:(nullable Class)className forIndexPath:(NSIndexPath *_Nonnull)indexPath;
@end

@interface UICollectionView (Register)

- (void)registerNibItem:(nullable Class)className;
- (void)registerClassItem:(nullable Class)className;
- (void)registerNibHeaderFooter:(nullable Class)className;
- (void)registerClassHeaderFooter:(nullable Class)className;

@end

@interface NSString (Convert)
+ (NSString *_Nonnull)convertString:(Class _Nonnull)className;
@end
