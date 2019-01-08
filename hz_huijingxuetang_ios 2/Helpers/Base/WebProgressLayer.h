//
//  WebProgressLayer.h
//  MKnight
//
//  Created by 张金山 on 2018/1/25.
//  Copyright © 2018年 张金山. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
@interface WebProgressLayer : CAShapeLayer

- (void)finishedLoad;
- (void)startLoad;
- (void)closeTimer;

@end
