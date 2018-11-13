//
//  FeedBackViewController.m
//  HuiJingSchool
//
//  Created by Junier on 2018/2/6.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "FeedBackViewController.h"
//#import "FSTextView.h"
@interface FeedBackViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@end

@implementation FeedBackViewController
{
    UIButton *button;
    UIImageView *btnimg;
    NSString *imgurl;
//    FSTextView *remaktext1;
    NSString *remark;
    UITextField *textf;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"意见反馈";
    self.view.backgroundColor = ALLViewBgColor;
    
    UIButton *releaseButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [releaseButton setTitle:@"提交" forState:normal];
    [releaseButton addTarget:self action:@selector(releaseInfo) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *releaseButtonItem = [[UIBarButtonItem alloc] initWithCustomView:releaseButton];
    self.navigationItem.rightBarButtonItem = releaseButtonItem;
    
//    remaktext1 = [[FSTextView alloc]initWithFrame:CGRectMake(0, 10*SW, kW, 215*SW)];
//    remaktext1.backgroundColor= [UIColor whiteColor];
//    remaktext1.placeholder = @"请输入反馈，我们将不断改进";
//    remaktext1.maxLength = 100;
//    [remaktext1 addTextDidChangeHandler:^(FSTextView *textView) {
//        // 文本改变后的相应操作.
//        remark = remaktext1.text;
//    }];
//    [self.view addSubview:remaktext1];
//
//    UIView *ln = [[UIView alloc]initWithFrame:CGRectMake(0,remaktext1.maxY, kW, 0.5*SW)];
//    ln.backgroundColor = LnColor;
//    [self.view addSubview:ln];
    
//    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, ln.maxY, kW, 85*SW)];
//    view.backgroundColor = CWHITE;
//    [self.view addSubview:view];
//
//    btnimg = [[UIImageView alloc]initWithFrame:CGRectMake(15*SW, 15*SW, 85*SW, 55*SW)];
//    [view addSubview:btnimg];
//
//    button = [[UIButton alloc]initWithFrame:CGRectMake(15*SW, 15*SW, 85*SW, 55*SW)];
//    [button setImage:[UIImage imageNamed:@"34_"] forState:UIControlStateNormal];
//    button.layer.borderColor = [LnColor CGColor];
//    button.layer.borderWidth = 1;
//    [button addTarget:self action:@selector(Iconaction) forControlEvents:UIControlEventTouchUpInside];
//    [view addSubview:button];
//
//    UILabel *titlb = [[UILabel alloc]initWithFrame:CGRectMake(15*SW, view.maxY, 200*SW, 40*SW)];
//    titlb.text = @"你的联系方式";
//    [self.view addSubview:titlb];
//
//    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, titlb.maxY, kW, 40*SW)];
//    view1.backgroundColor = CWHITE;
//    [self.view addSubview:view1];
//
//    textf = [[UITextField alloc]initWithFrame:CGRectMake(15*SW, 0, kW -30*SW, 40*SW)];
//    textf.placeholder = @"单行输入";
//    textf.keyboardType = UIKeyboardTypeNumberPad;
//    [view1 addSubview:textf];
//
//    UIButton *btn1 = [[UIButton alloc]init];
//    btn1.frame = CGRectMake( 20*SW, view1.maxY +100*SW, kW-40*SW, 50*SW);
//    btn1.backgroundColor = NavAndBtnColor;
//    btn1.layer.cornerRadius = 5*SW;
//    btn1.layer.masksToBounds = YES;
//    [btn1 addTarget:self action:@selector(releaseInfo) forControlEvents:UIControlEventTouchUpInside];
//    [btn1 setTitle:@"提交" forState:UIControlStateNormal];
//    [self.view addSubview:btn1];
//
//    //添加手势
//    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide)];
//    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
//    tapGestureRecognizer.cancelsTouchesInView = NO;
//    //将触摸事件添加到当前view
//    [self.view addGestureRecognizer:tapGestureRecognizer];
//
//    //上滑手势
//    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(keyboardHide)];
//    [recognizer setDirection:(UISwipeGestureRecognizerDirectionUp)];
//    [self.view addGestureRecognizer:recognizer];
    
}
-(void)releaseInfo{
    if (remark.length == 0) {
        return SVshowInfo(@"请输入反馈");
    }
    
    if (!textf.text.length) {
        return SVshowInfo(@"请输入联系方式");

    }
    
    if (!imgurl.length) {
        imgurl = @"";
    }
//    [YJAPPNetwork FeedBackAccesstoken:[APPUserDataIofo AccessToken] content:remark img:imgurl phone:textf.text success:^(NSDictionary *responseObject) {
//        NSInteger code = [[responseObject objectForKey:@"code"]integerValue];
//        if (code == 200) {
//            SVShowSuccess(@"提交成功！感谢您的反馈，我们将不断改进");
//            remaktext1.text = @"";
//            textf.text = @"";
//            imgurl = @"";
//            btnimg.image = nil;
//            [self keyboardHide];
//        }else{
//            [ConventionJudge NetCode:code vc:self type:@"1"];
//        }
//    } failure:^(NSString *error) {
//        [SVProgressHUD showInfoWithStatus:netError];
//
//    }];
}

-(void)Iconaction{
    UIAlertController *alterVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:0];
    //
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alterVC addAction:cancel];
    //
    __weak __typeof(self)weakSelf = self;
    UIAlertAction *certain1 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDestructive handler:
                               ^(UIAlertAction * _Nonnull action) {
                                   NSLog(@"拍照");
                                   
                                   // 初始化图片选择控制器
                                   UIImagePickerController *controller = [[UIImagePickerController alloc] init];
                                   
                                   [controller setSourceType:UIImagePickerControllerSourceTypeCamera];
                                   // 设置所支持的媒体功能，即只能拍照，或则只能录像，或者两者都可以
                                   NSString *requiredMediaType = ( NSString *)kUTTypeImage;
                                   NSArray *arrMediaTypes=[NSArray arrayWithObjects:requiredMediaType,nil];
                                   [controller setMediaTypes:arrMediaTypes];
                                   // 设置录制视频的质量
                                   //                                       [controller setVideoQuality:UIImagePickerControllerQualityTypeHigh];
                                   //设置最长摄像时间
                                   //                                       [controller setVideoMaximumDuration:10.f];
                                   // 设置是否可以管理已经存在的图片或者视频
                                   [controller setAllowsEditing:NO];
                                   // 设置代理
                                   [controller setDelegate:weakSelf];
                                   [self presentViewController:controller animated:YES completion:nil];
                               }];
    [alterVC addAction:certain1];
    //
    UIAlertAction *certain2 = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDestructive handler:
                               ^(UIAlertAction * _Nonnull action) {
                                   NSLog(@"相册");
                                   UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                                   imagePicker.allowsEditing = NO;
                                   imagePicker.delegate = weakSelf;
                                   UIImagePickerControllerSourceType soureType = UIImagePickerControllerSourceTypePhotoLibrary ;
                                   [weakSelf.navigationController presentViewController:imagePicker animated:YES completion:nil];
                                   imagePicker.sourceType = soureType;
                               }];
    [alterVC addAction:certain2];
    [self presentViewController:alterVC animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *img = [info objectForKey:UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:^{
        [self uploadImg:img];
    }];
}

-(void)uploadImg:(UIImage *)img{
    [YJAPPNetwork upLoadImgWithAccesstoken:[APPUserDataIofo AccessToken] type:@"feedback" img:img success:^(NSDictionary *responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"]integerValue];
        if (code == 200) {
            NSURL *url = [NSURL URLWithString:[responseObject objectForKey:@"data"]];
            [btnimg sd_setImageWithURL:url];
            imgurl = [responseObject objectForKey:@"data"];
            SVDismiss;
       }else{
            [ConventionJudge NetCode:code vc:self type:@"1"];
        }
    } failure:^(NSString *error) {
        [SVProgressHUD showInfoWithStatus:netError];
        
    }];
}


-(void)keyboardHide{
//    [remaktext1 endEditing:YES];
    [textf endEditing:YES];
}
@end
