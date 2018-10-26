//
//  BMTextView.h
//  BM
//
//  Created by txooo on 17/8/18.
//  Copyright © 2017年 张金山. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BMTextView : UITextView

@property (nonatomic, copy) NSString *placeholder;

@property (nonatomic, strong) UIColor *placeholderColor;

@property (nonatomic, assign) NSInteger maxLimitCount;

@property (nonatomic, assign) BOOL showLimitString;

@end
