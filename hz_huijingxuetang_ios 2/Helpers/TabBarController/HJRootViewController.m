//
//  HJRootViewController.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/28.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJRootViewController.h"
#import "CustomTabbarController.h"
@interface HJRootViewController ()

@property (nonatomic,strong) UIImageView *imgV;
@end

@implementation HJRootViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(CGFLOAT_MIN * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController setNavigationBarHidden:YES animated:NO];
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
    
    self.view.backgroundColor = red_color;
    [self.view addSubview:self.imgV];
    [self.imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
    }];
    
    CustomTabbarController *tabbarVC = [[CustomTabbarController alloc]init];
    tabbarVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self.navigationController presentViewController:tabbarVC animated:YES completion:^{
        
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
