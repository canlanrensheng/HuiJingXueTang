//
//  AnimationTabbarItem.m
//  ISupermarket
//
//  Created by txooo on 17/11/14.
//  Copyright © 2017年 txooo. All rights reserved.
//

#import "AnimationTabbarItem.h"

@interface AnimationTabbarItem ()

@property (nonatomic,strong) CAShapeLayer *scanLayer;

@end

@implementation AnimationTabbarItem

- (instancetype)init {
    if (self = [super init]) {
        [self setLayer];
    }
    return self;
}

- (void)setLayer {
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        for (UIControl *tabBarButton in self.subviews) {
            if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
                [tabBarButton addTarget:self action:@selector(tabBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
    });
}

- (void)tabBarButtonClick:(UIControl *)tabBarButton {
    for (UIView *imageView in tabBarButton.subviews) {
        if ([imageView isKindOfClass:NSClassFromString(@"UITabBarSwappableImageView")]) {
            CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
            animation.keyPath = @"transform.scale";
            animation.values = @[@1.0,@1.3,@0.9,@1.15,@0.95,@1.02,@1.0];
            animation.duration = 1;
            animation.calculationMode = kCAAnimationCubic;
            [imageView.layer addAnimation:animation forKey:nil];
        }
    }
}

@end

