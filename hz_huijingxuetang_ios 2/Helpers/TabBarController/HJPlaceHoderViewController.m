//
//  HJPlaceHoderViewController.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/12/12.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJPlaceHoderViewController.h"

@interface HJPlaceHoderViewController ()

@property (nonatomic,strong) UIImageView *imgV;

@end

@implementation HJPlaceHoderViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(CGFLOAT_MIN * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController setNavigationBarHidden:YES animated:NO];
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
    
    self.view.backgroundColor = white_color;
    [self.view addSubview:self.imgV];
    [self.imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
    }];
}

- (UIImageView *)imgV {
    if (!_imgV){
        _imgV = [[UIImageView alloc] init];
        _imgV.image = [self getLauchImage];
    }
    return _imgV;
}

- (UIImage *)getLauchImage {
    CGSize viewSize = [UIScreen mainScreen].bounds.size;
    NSString *viewOrientation = @"Portrait";
    NSString *launchImage = nil;
    NSArray *imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    for (NSDictionary *dict in imagesDict) {
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
        if (CGSizeEqualToSize(imageSize, viewSize) && [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]]) {
            launchImage = dict[@"UILaunchImageName"];
        }
    }
    return [UIImage imageNamed:launchImage];
}

@end
