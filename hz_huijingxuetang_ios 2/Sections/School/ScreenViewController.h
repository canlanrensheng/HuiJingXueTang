//
//  ScreenViewController.h
//  HuiJingSchool
//
//  Created by Junier on 2018/2/8.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScreenViewController : UIViewController
typedef void(^velueBlock)(NSString *type1,NSString *Id);

@property (nonatomic, copy) velueBlock Block;

@property (strong ,nonatomic ) NSDictionary *datadic;
@property (strong ,nonatomic ) NSString *teacherid;
@property (strong ,nonatomic ) NSString *price;
@property (strong ,nonatomic ) NSString *type;

@end
