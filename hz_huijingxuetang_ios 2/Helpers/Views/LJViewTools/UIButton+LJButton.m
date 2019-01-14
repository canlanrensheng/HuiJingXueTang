//
//  UIButton.m
//  LJView
//
//  Created by txooo on 17/2/24.
//  Copyright © 2017年 张金山. All rights reserved.
//

#import "UIButton+LJButton.h"

@implementation UIButton(LJButton)

static char topNameKey;
static char rightNameKey;
static char bottomNameKey;
static char leftNameKey;

- (void)setEnlargeEdge:(CGFloat) size {
    objc_setAssociatedObject(self, &topNameKey, [NSNumber numberWithFloat:size], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &rightNameKey, [NSNumber numberWithFloat:size], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &bottomNameKey, [NSNumber numberWithFloat:size], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &leftNameKey, [NSNumber numberWithFloat:size], OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setEnlargeEdgeWithTop:(CGFloat) top right:(CGFloat) right bottom:(CGFloat) bottom left:(CGFloat) left {
    objc_setAssociatedObject(self, &topNameKey, [NSNumber numberWithFloat:top], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &rightNameKey, [NSNumber numberWithFloat:right], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &bottomNameKey, [NSNumber numberWithFloat:bottom], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &leftNameKey, [NSNumber numberWithFloat:left], OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CGRect)enlargedRect {
    NSNumber* topEdge = objc_getAssociatedObject(self, &topNameKey);
    NSNumber* rightEdge = objc_getAssociatedObject(self, &rightNameKey);
    NSNumber* bottomEdge = objc_getAssociatedObject(self, &bottomNameKey);
    NSNumber* leftEdge = objc_getAssociatedObject(self, &leftNameKey);
    if (topEdge && rightEdge && bottomEdge && leftEdge)
    {
        return CGRectMake(self.bounds.origin.x - leftEdge.floatValue,
                          self.bounds.origin.y - topEdge.floatValue,
                          self.bounds.size.width + leftEdge.floatValue + rightEdge.floatValue,
                          self.bounds.size.height + topEdge.floatValue + bottomEdge.floatValue);
    }
    else
    {
        return self.bounds;
    }
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    CGRect rect = [self enlargedRect];
    if (CGRectEqualToRect(rect, self.bounds))
    {
        return [super pointInside:point withEvent:event];
    }
    return CGRectContainsPoint(rect, point) ? YES : NO;
}


+ (UIButton *)creatButton:(void (^)(UIButton *))block{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    block(button);
    return button;
}

- (UIButton *(^)(float, float, float, float))ljFrame{
    return ^UIButton *(float left,float top,float width,float height){
        self.frame = CGRectMake(left, top, width, height);
        return self;
    };
}

- (UIButton *(^)(CGFloat, CGFloat, CGFloat, CGFloat))ljImageInsets{
    return ^UIButton *(CGFloat top, CGFloat left, CGFloat bottom, CGFloat right){
        self.imageEdgeInsets = UIEdgeInsetsMake(top, left, bottom, right);
        return self;
    };
}

- (UIButton *(^)(CGFloat, CGFloat, CGFloat, CGFloat))ljTitleInsets{
    return ^UIButton *(CGFloat top, CGFloat left, CGFloat bottom, CGFloat right){
        self.titleEdgeInsets = UIEdgeInsetsMake(top, left, bottom, right);
        return self;
    };
}

- (UIButton *(^)(UIImage *, UIViewContentMode))ljImage_contentMode{
    return ^UIButton *(UIImage *image, UIViewContentMode mode){
        [self setImage:image forState:UIControlStateNormal];
        self.imageView.contentMode = mode;
        return self;
    };
}

- (UIButton *(^)(UIImage *, UIControlState))ljImage_state {
    return ^UIButton *(UIImage *image, UIControlState state){
        [self setImage:image forState:state];
        return self;
    };
}

- (UIButton *(^)(NSString *, UIFont *, UIColor *, UIControlState))ljTitle_font_titleColor_state{
    return ^UIButton *(NSString *title, UIFont *font, UIColor *textColor, UIControlState controlState){
        [self setTitle:title forState:controlState];
        [self setTitleColor:textColor forState:controlState];
        self.titleLabel.font = font;
        return self;
    };
}

- (UIButton *(^)(NSString *, UIControlState))ljTitle_state {
    return ^UIButton *(NSString *title, UIControlState controlState){
        [self setTitle:title forState:controlState];
        return self;
    };
}

- (UIButton *(^)(UIColor *, UIControlState))ljTitleColor_state {
    return ^UIButton *(UIColor *textColor, UIControlState controlState){
        [self setTitleColor:textColor forState:controlState];
        return self;
    };
}

- (UIButton *(^)(NSAttributedString *, UIControlState))ljAttributedTitle_state{
    return ^UIButton *(NSAttributedString *title, UIControlState controlState){
        [self setAttributedTitle:title forState:controlState];
        return self;
    };
}

- (UIButton *(^)(UIControlContentHorizontalAlignment))ljHorizontalAlignment {
    return ^UIButton *(UIControlContentHorizontalAlignment alignment){
        [self setContentHorizontalAlignment:alignment];
        return self;
    };
}

- (UIButton *(^)(UIControlContentVerticalAlignment))ljVerticalAlignment {
    return ^UIButton *(UIControlContentVerticalAlignment alignment){
        [self setContentVerticalAlignment:alignment];
        return self;
    };
}

- (UIButton *(^)(UIImage *, UIControlState))ljBackgroundImage_state{
    return ^UIButton *(UIImage *image, UIControlState controlState){
        [self setBackgroundImage:image forState:controlState];
        return self;
    };
}

- (UIButton *(^)(UIColor *))ljBackgroundColor{
    return ^UIButton *(UIColor *color){
        [self setBackgroundColor:color];
        return self;
    };
}

- (UIButton *(^)(id, SEL,UIControlEvents))ljTarget_action_events{
    return ^UIButton *(id target, SEL selector, UIControlEvents event){
        [self addTarget:target action:selector forControlEvents:event];
        return self;
    };
}

- (UIButton *(^)(CGFloat, CGFloat, UIColor *))ljCornerRadius_borderWidth_borderColor{
    return ^UIButton *(CGFloat radius, CGFloat width ,UIColor *color){
        self.layer.cornerRadius = radius;
        self.layer.borderWidth = width;
        self.layer.borderColor = color.CGColor;
        return self;
    };
}

- (UIButton *(^)(BOOL))ljSelect{
    return ^UIButton *(BOOL select){
        self.selected = select;
        return self;
    };
}

//设置左文字右图片
- (void)setButtonLeftTextAndRightImage{
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0, -self.imageView.bounds.size.width, 0, self.imageView.bounds.size.width)];
    [self setImageEdgeInsets:UIEdgeInsetsMake(0, self.titleLabel.bounds.size.width, 0, -self.titleLabel.bounds.size.width)];
}


@end
