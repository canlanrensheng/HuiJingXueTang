//
//  HJMySuggestionViewController.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/19.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJMySuggestionViewController.h"
#import "BMTextView.h"
#import "LJAvatarBrowser.h"
#import <TZImagePickerController/TZImagePickerController.h>

static const  NSInteger MaxCount  = 9;

@interface HJMySuggestionViewController ()<UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIGestureRecognizerDelegate,TZImagePickerControllerDelegate>

@property (nonatomic,strong) BMTextView *textView;
@property (nonatomic,strong) UIScrollView *scrollView;

@property (nonatomic,strong) NSMutableArray *assets;
@property (nonatomic,strong) NSMutableArray *imgUrlArr;

@end

@implementation HJMySuggestionViewController

- (BMTextView *)textView{
    if(!_textView){
        _textView = [[BMTextView alloc] init];
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.placeholderColor = HEXColor(@"#CCCCCC");
        _textView.placeholder = @" 写下你的问题吧~";
        _textView.showLimitString = NO;
        _textView.font = MediumFont(font(13));
    }
    return _textView;
}

- (UIScrollView *)scrollView {
    if(!_scrollView){
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.bounces = NO;
        _scrollView.backgroundColor = clear_color;
    }
    return _scrollView;
}

- (void)hj_setNavagation {
    self.title = @"问题反馈";
    __weak typeof(self)weakSelf = self;
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonItemWithTitle:@"提交" font:MediumFont(font(15)) action:^(id sender) {
        [weakSelf sunmmitOperation];
    }];
}

//提交意见反馈进行的操作
- (void)sunmmitOperation{
    if (self.textView.text.length <= 0) {
        ShowMessage(@"写下你的问题吧");
        return ;
    }
    ShowHint(@"正在提交...");
    dispatch_group_t dispatchGroup = dispatch_group_create();
    for (int i = 0; i < self.assets.count - 1; i++){
        dispatch_group_enter(dispatchGroup);
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [YJAPPNetwork upLoadImgWithAccesstoken:[APPUserDataIofo AccessToken] type:@"feedback" img:self.assets[i] success:^(NSDictionary *responseObject) {
                NSInteger code = [[responseObject objectForKey:@"code"]integerValue];
                if (code == 200) {
                    [self.imgUrlArr addObject:[responseObject objectForKey:@"data"]];
                    dispatch_group_leave(dispatchGroup);
                }else{
                    ShowError([responseObject objectForKey:@"msg"]);
                }
            } failure:^(NSString *error) {
                ShowError(error);
            }];
        });
    }
    
    //图片转url成功的时候
    dispatch_group_notify(dispatchGroup, dispatch_get_main_queue(), ^(){
        DLog(@"获取到的图片的数组是:%@",self.imgUrlArr);
        hideHud();
        //提交操作
        NSString *imageUrl = @"";
        if(self.imgUrlArr.count > 0) {
            imageUrl = [self.imgUrlArr componentsJoinedByString:@","];
        }
        [YJAPPNetwork FeedBackAccesstoken:[APPUserDataIofo AccessToken] content:self.textView.text img:imageUrl phone:@"" success:^(NSDictionary *responseObject) {
            NSInteger code = [[responseObject objectForKey:@"code"]integerValue];
            if (code == 200) {
                [MBProgressHUD showMessage:@"提交成功！" view:self.view];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }else{
                ShowError([responseObject objectForKey:@"msg"]);
            }
        } failure:^(NSString *error) {
            ShowError(error);
        }];
    });
}

- (void)hj_configSubViews {
    self.view.backgroundColor = Background_Color;
    //输入文本
    [self.view addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(kHeight(200));
    }];
    
    //图片试图
    NSInteger picCount = 5;
    CGFloat padding = kWidth(10.0);
    CGFloat picHeight = (Screen_Width - kWidth(20) - (picCount - 1) * padding) / picCount;
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.textView).offset(kWidth(10));
        make.top.equalTo(self.textView.mas_bottom).offset(kHeight(10));
        make.right.equalTo(self.textView).offset(-kWidth(10));
        make.height.mas_equalTo(picHeight);
    }];
    
    //刷新试图
    NSMutableArray *picArr = [NSMutableArray arrayWithObject:[UIImage imageNamed:@"添加图片 "]];
    self.assets = picArr;
    [self reloadScrollViewWithImageArr:self.assets];
}

- (void)reloadScrollViewWithImageArr:(NSArray *)assets{
    [[self.scrollView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSUInteger assetCount = assets.count;
    if (assetCount > 0) {
        NSInteger picCount = 5;
        CGFloat padding = kWidth(10.0);
        CGFloat picWidth = (Screen_Width - kWidth(20) - (picCount - 1) * padding) / picCount;
        CGFloat height = picWidth;
        for (NSInteger i = 0; i < assetCount; i++) {
            int lie = (int)(i % picCount);
            int hang = (int)(i / picCount);
            UIImageView *imaView = [[UIImageView alloc] init];
            imaView.frame = CGRectMake((picWidth + padding) * lie, (height + padding) * hang, picWidth, height);
            imaView.backgroundColor = Background_Color;
            imaView.userInteractionEnabled = YES;
            [self.scrollView addSubview:imaView];
            if([assets[i] isKindOfClass:[NSString class]]) {
                [imaView sd_setImageWithURL:URL(assets[i]) placeholderImage:V_IMAGE(@"占位图") options:SDWebImageRefreshCached];
            } else {
                imaView.image = assets[i];
            }
            
            if(i == assets.count - 1) {
                //添加图片的操作
                UITapGestureRecognizer *addPicTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addPicTap:)];
                [imaView addGestureRecognizer:addPicTap];
            } else {
                //查看大图
                UITapGestureRecognizer *lookBigPicTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lookBigPicTap:)];
                [imaView addGestureRecognizer:lookBigPicTap];
                
                //添加删除的按钮
                UIImageView *delateImageVIew = [[UIImageView alloc] init];
                delateImageVIew.image = V_IMAGE(@"删除");
                delateImageVIew.tag = i;
                delateImageVIew.userInteractionEnabled = YES;
                [self.scrollView addSubview:delateImageVIew];
                [delateImageVIew mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.top.equalTo(imaView);
                    make.size.mas_equalTo(CGSizeMake(kWidth(24), kHeight(24)));
                }];
                UITapGestureRecognizer *deletePicTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deletePicTap:)];
                [delateImageVIew addGestureRecognizer:deletePicTap];
            }
        }
        self.scrollView.contentSize = CGSizeMake(Screen_Width - kWidth(20) , CGRectGetMaxY([[self.scrollView.subviews lastObject] frame]));
        [_scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.textView).offset(kWidth(10));
            make.top.equalTo(self.textView.mas_bottom).offset(kHeight(10));
            make.right.equalTo(self.textView).offset(-kWidth(10));
            make.height.mas_equalTo(CGRectGetMaxY([[self.scrollView.subviews lastObject] frame]));
        }];
    }
}

//查看大图的操作
- (void)lookBigPicTap:(UITapGestureRecognizer *)tap{
    UIImageView *tapView = (UIImageView *)tap.view;
    [LJAvatarBrowser showImageView:tapView];
}

//添加图片的操作
- (void)addPicTap:(UITapGestureRecognizer *)tap{
    [self alertShow];
}

//删除图片的操作
- (void)deletePicTap:(UITapGestureRecognizer *)tap{
    DLog(@"点击了删除的操作");
    UIImageView *tapView = (UIImageView *)tap.view;
    [self.assets removeObjectAtIndex:tapView.tag];
    [self reloadScrollViewWithImageArr:self.assets];
//    [self.imgUrlArr removeObjectAtIndex:tapView.tag];
}

- (void)alertShow{
    [VisibleViewController().view endEditing:YES];
    [self.textView resignFirstResponder];
    UIActionSheet * sheet = [[UIActionSheet alloc]initWithTitle:@"提示" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"相册", nil];
    [sheet showInView:VisibleViewController().view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            if(self.assets.count == MaxCount + 1){
                [MBProgressHUD showMessage:[NSString stringWithFormat:@"最多选择%tu张图片",MaxCount] view:VisibleViewController().view];
                return;
            }
            [self loadImageWithType:UIImagePickerControllerSourceTypeCamera];
        }else{
            DLog(@"暂时不可以使用相机");
        }
    }else if (buttonIndex == 1){
        if(self.assets.count == MaxCount + 1){
            [MBProgressHUD showMessage:[NSString stringWithFormat:@"最多选择%tu张图片",MaxCount] view:VisibleViewController().view];
            return;
        }
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:MaxCount + 1 - self.assets.count delegate:self];
        // 你可以通过block或者代理，来得到用户选择的照片.
        imagePickerVc.allowPickingVideo = NO;
        imagePickerVc.allowTakePicture = NO;
        //    imagePickerVc.
        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {

            DLog(@"获取到的图片的数组是:%@",self.imgUrlArr);
            UIImage *lastImg = self.assets.lastObject;
            [self.assets removeLastObject];
            [self.assets addObjectsFromArray:photos];
            NSMutableArray *marr = [NSMutableArray array];
            [marr addObjectsFromArray:self.assets];
            [marr addObject:lastImg];
            self.assets = marr;
            [self reloadScrollViewWithImageArr:self.assets];
            
        }];
        [VisibleViewController() presentViewController:imagePickerVc animated:YES completion:nil];
    }
}

- (void)loadImageWithType:(UIImagePickerControllerSourceType)type{
    UIImagePickerController * ipc = [[UIImagePickerController alloc]init];
    ipc.sourceType = type;
    ipc.delegate = self;
    [VisibleViewController() presentViewController:ipc animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if ([image isKindOfClass:[UIImage class]]){
        UIImage *lastImg = self.assets.lastObject;
        [self.assets removeLastObject];
        [self.assets addObject:image];
        NSMutableArray *marr = [NSMutableArray array];
        [marr addObjectsFromArray:self.assets];
        [marr addObject:lastImg];
        self.assets = marr;
        [self reloadScrollViewWithImageArr:self.assets];
    }
    //添加图片数据源到图片浏览器
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

//提交按钮
- (NSMutableArray *)assets{
    if(!_assets){
        _assets = [NSMutableArray array];
    }
    return _assets;
}

- (NSMutableArray *)imgUrlArr {
    if(!_imgUrlArr){
        _imgUrlArr = [NSMutableArray array];
    }
    return _imgUrlArr;
}

@end
