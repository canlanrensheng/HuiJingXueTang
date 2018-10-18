//
//  UITableView+Register.m
//  BaoXianBaApp
//
//  Created by JngViho on 2017/3/22.
//  Copyright © 2017年 yjyc. All rights reserved.
//

#import "UITableView+Register.h"

@implementation UITableView (Register)

- (void)registerNibCell:(nullable Class)className {
    NSString *str = [NSString stringWithUTF8String: object_getClassName(className)];
    [self registerNib:[UINib nibWithNibName:str bundle:nil] forCellReuseIdentifier:str];
}

- (void)registerClassCell:(nullable Class)className {
    NSString *str = [NSString stringWithUTF8String: object_getClassName(className)];
    [self registerClass:className forCellReuseIdentifier:str];
}

- (__kindof UITableViewCell *_Nonnull)reuseCell:(nullable Class)className forIndexPath:(NSIndexPath *_Nonnull)indexPath {
    NSString *identifier = [NSString stringWithUTF8String:object_getClassName(className)];
    return [self dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
}

- (void)registerNibHeaderFooter:(nullable Class)className {
    NSString *str = [NSString stringWithUTF8String: object_getClassName(className)];
    [self registerNib:[UINib nibWithNibName:str bundle:nil] forHeaderFooterViewReuseIdentifier:str];
}

- (void)registerClassHeaderFooter:(nullable Class)className {
    NSString *str = [NSString stringWithUTF8String: object_getClassName(className)];
    [self registerClass:className forHeaderFooterViewReuseIdentifier:str];
}
@end

@implementation UICollectionView (Register)

- (void)registerNibItem:(nullable Class)className {
    NSString *str = [NSString stringWithUTF8String: object_getClassName(className)];
    [self registerNib:[UINib nibWithNibName:str bundle:nil] forCellWithReuseIdentifier:str];
}

- (void)registerClassItem:(nullable Class)className {
    NSString *str = [NSString stringWithUTF8String: object_getClassName(className)];
    [self registerClass:className forCellWithReuseIdentifier:str];
}

- (void)registerNibHeaderFooter:(nullable Class)className {
    NSString *str = [NSString stringWithUTF8String: object_getClassName(className)];
    [self registerNib:[UINib nibWithNibName:str bundle:nil]  forSupplementaryViewOfKind:str withReuseIdentifier:str];
}

- (void)registerClassHeaderFooter:(nullable Class)className {
    NSString *str = [NSString stringWithUTF8String: object_getClassName(className)];
    [self registerClass:className forSupplementaryViewOfKind:str withReuseIdentifier:str];
}
@end

@implementation NSString (Convert)

+ (NSString *_Nonnull)convertString:(Class _Nonnull)className {
    return
        [NSString stringWithUTF8String:object_getClassName(className)];
}

@end
