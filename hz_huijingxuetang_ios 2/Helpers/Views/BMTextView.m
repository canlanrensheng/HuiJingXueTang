//
//  BMTextView.m
//  BM
//
//  Created by txooo on 17/8/18.
//  Copyright © 2017年 张金山. All rights reserved.
//

#import "BMTextView.h"

@interface BMTextView ()

@property (nonatomic,copy) NSString *placeholderOrignal;

@end

@implementation BMTextView

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpPlaceholder];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self setNeedsDisplay];
}

- (void)setUpPlaceholder {
    self.font = [UIFont systemFontOfSize:15];
    self.placeholderColor = lightGray_color;
    // 使用通知监听文字改变
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextViewTextDidChangeNotification object:self];
}

- (void)textDidChange:(NSNotification *)noti {
    // 会重新调用drawRect:方法
    UITextView *textView = noti.object;
    if (textView.text.length == 0) {
        self.placeholder = self.placeholderOrignal;
    }else {
        self.placeholder = @"";
    }
    if (_maxLimitCount && textView.text.length >= _maxLimitCount) {
        textView.text = [textView.text substringToIndex:_maxLimitCount];
        return;
    }
    [self setNeedsDisplay];
}

/**
 * 每次调用drawRect:方法，都会将以前画的东西清除掉
 */
- (void)drawRect:(CGRect)rect {
    
    if (self.showLimitString) {
        CGRect limitRect = CGRectMake(rect.size.width - 70, rect.size.height - 20, 60, 15);
        NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        paragraphStyle.lineBreakMode = NSLineBreakByClipping;
        paragraphStyle.alignment = NSTextAlignmentRight;
        NSString *limitStr = [NSString stringWithFormat:@"%tu/%tu",self.text.length,self.maxLimitCount];
        NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
        attrs[NSFontAttributeName] = H12;
        attrs[NSForegroundColorAttributeName] = gray_color;
        attrs[NSParagraphStyleAttributeName] = paragraphStyle;
        [limitStr drawInRect:limitRect withAttributes:attrs];
    }
    
    // 如果有文字，就直接返回，不需要画占位文字
    if (self.hasText) return;
    
    // 属性
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = self.font;
    attrs[NSForegroundColorAttributeName] = self.placeholderColor;
    
    // 画文字
    rect.origin.x = 5;
    rect.origin.y = 8;
    rect.size.width -= 2 * rect.origin.x;
    [self.placeholder drawInRect:rect withAttributes:attrs];
}
#pragma mark - setter
- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = [placeholder copy];
    if (placeholder.length) {
        _placeholderOrignal = placeholder;
    }
    [self setNeedsDisplay];
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    _placeholderColor = placeholderColor;
    
    [self setNeedsDisplay];
}

- (void)setFont:(UIFont *)font {
    [super setFont:font];
    
    [self setNeedsDisplay];
}

- (void)setText:(NSString *)text {
    [super setText:text];
    
    [self setNeedsDisplay];
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    [super setAttributedText:attributedText];
    
    [self setNeedsDisplay];
}

@end
