 //
//  UIView+YJMethods.m
//  HuiJingSchool
//
//  Created by Junier on 2018/1/21.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "UIView+YJMethods.h"

@implementation UIView (YJMethods)
- (void)changeFrameForX:(CGFloat)x{
    
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
    
}

- (void)changeFrameForY:(CGFloat)y{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (void)changeFrameForWidth:(CGFloat)width{
    
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
    
}

- (void)changeFrameForHeight:(CGFloat)height{
    
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
    
}




//添加ItemView右边箭头
- (UIImageView *)addRightArrowForItemView{
    
    CGFloat arrowHeight = CGRectGetHeight(self.frame);
    
    UIImageView *rightArrowImageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.frame) - 30, arrowHeight/2 - 18.0/2.0, 10, 18)];
    rightArrowImageView.image = [UIImage imageNamed:@"arrowRight"];
    [self addSubview:rightArrowImageView];
    
    return rightArrowImageView;
    
}

//添加一个点击手势
- (void)addTapAction:(id)object tapSel:(SEL)tapSel{
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:object action:tapSel];
    [self addGestureRecognizer:tapGesture];
    
}

-(void)setWidth:(CGFloat)width{
    
    CGRect frame = self.frame;
    
    frame.size.width = width;
    
    self.frame = frame;
}

-(CGFloat)width{
    
    return self.frame.size.width;
}

-(void)setHeight:(CGFloat)height{
    
    CGRect frame = self.frame;
    
    frame.size.height = height;
    
    self.frame = frame;
}

-(CGFloat)height{
    
    return  self.frame.size.height;
}

-(void)setX:(CGFloat)x{
    
    CGRect frame = self.frame;
    
    frame.origin.x = x;
    
    self.frame = frame;
}

-(CGFloat)x{
    return  self.frame.origin.x;
}

-(void)setY:(CGFloat)y{
    
    CGRect frame = self.frame;
    
    frame.origin.y = y;
    
    self.frame = frame;
}

-(CGFloat)y{
    return  self.frame.origin.y;
}

-(void)setCenterX:(CGFloat)centerX{
    CGPoint point = self.center;
    
    point.x = centerX;
    
    self.center = point;
}

-(CGFloat)centerX{
    return  self.center.x;
}

-(void)setCenterY:(CGFloat)centerY{
    CGPoint point = self.center;
    
    point.y = centerY;
    
    self.center = point;
}

-(CGFloat)centerY{
    return  self.center.y;
}

-(CGFloat)minX{
    return self.x;
}

-(CGFloat)maxX{
    return CGRectGetMaxX(self.frame);
}

-(CGFloat)minY{
    return self.y;
}

-(CGFloat)maxY{
    return CGRectGetMaxY(self.frame);
}




@end
