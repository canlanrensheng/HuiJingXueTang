//
//  UITabBar+TXAdditions.m
//  TXToolbox
//
//  Created by txooo on 17/5/15.
//  Copyright © 2017年 张金山. All rights reserved.
//

#import "UITabBar+TXAdditions.h"

#define TabbarItemNums 5.0

@implementation UITabBar (TXAdditions)

- (void)showBadgeValueAtIndex:(int)index value:(NSString *)value {
    [self removeBadgeOnItemIndex:index];
    UILabel *badgeView = [[UILabel alloc]init];
    badgeView.tag = 888 + index;
    badgeView.text = value;
    
    int contNum = [value intValue];
    if(contNum <= 0){
        badgeView.hidden = NO;
    }else{
        badgeView.hidden = NO;
        if(contNum > 99){
            badgeView.text = @"99+";
            badgeView.font = [UIFont systemFontOfSize:8];
        }else{
            badgeView.text = value;
            badgeView.font = [UIFont systemFontOfSize:10];
        }
    }
    
    badgeView.textColor = [UIColor whiteColor];
    badgeView.textAlignment = NSTextAlignmentCenter;
    badgeView.backgroundColor = [UIColor redColor];
    CGRect tabFrame = self.frame;
    
    float percentX = (index + 0.5) / TabbarItemNums;
    CGFloat x = ceilf(percentX * tabFrame.size.width);
//    CGFloat x = CGRectGetMaxX(self.frame);
    CGFloat y = ceilf(0.11 * tabFrame.size.height);
    badgeView.frame = CGRectMake(x, y, kHeight(10.0), kHeight(10.0));
    badgeView.layer.cornerRadius = kHeight(5.0);
    badgeView.clipsToBounds = YES;
    [self addSubview:badgeView];
}


- (void)hideBadgeValueAtIndex:(int)index {
    [self removeBadgeOnItemIndex:index];
}

- (void)removeBadgeOnItemIndex:(int)index{
    for (UIView *subView in self.subviews) {
        if (subView.tag == 888 + index) {
            [subView removeFromSuperview];
        }
    }
}

@end
