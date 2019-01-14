//
//  HJMyInfoViewController.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/11/16.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJMyInfoViewController.h"
#import "CZHAddressPickerView.h"
#import "AccountMessageListCell.h"
#import "AccountMessageViewModel.h"
#import "ModifyNameViewController.h"
#import "MLImageCrop.h"
#import "HJMyInfoOutLoginCell.h"

@interface HJMyInfoViewController ()<MLImageCropDelegate>

@property (nonatomic,strong) AccountMessageViewModel *viewModel;

@end

@implementation HJMyInfoViewController

- (void)viewDidLoad {
    self.tableViewStyle = UITableViewStyleGrouped;
    [super viewDidLoad];
    self.navigationItem.title = @"我的资料";
}

- (void)hj_configSubViews{
    self.sectionFooterHeight = 10;
    [self.tableView registerClass:[AccountMessageListCell class] forCellReuseIdentifier:@"AccountCellID"];
    [self.tableView registerClassCell:[HJMyInfoOutLoginCell class]];
    
    @weakify(self);
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UpdateUserInfoNotification object:nil] subscribeNext:^(id x) {
        @strongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
}

- (void)hj_loadData {
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kHeight(45.0);
}

#pragma mark UITableView delagte
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.viewModel.dataArray[section] count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.viewModel.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    self.tableView.separatorColor = RGBCOLOR(225, 225, 225);
    if(indexPath.section == 0 && indexPath.row == 0){
        AccountMessageListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AccountCellID"];
        [cell setViewModel:self.viewModel indexPath:indexPath];
        return cell;
    }
    if(indexPath.section == 2) {
        HJMyInfoOutLoginCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HJMyInfoOutLoginCell class])];
        [cell setViewModel:self.viewModel indexPath:indexPath];
        return cell;
    }
    MineListTextCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AccountCellValueID"];
    if(!cell){
        cell = [[MineListTextCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"AccountCellValueID"];
    }
    [cell setViewModel:self.viewModel withIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    @weakify(self);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section == 0){
        if(indexPath.row == 0){
            [TXAlertView showAlertWithTitle:nil message:@"请选择照片来源" cancelButtonTitle:@"取消" style:TXAlertViewStyleActionSheet buttonIndexBlock:^(NSInteger buttonIndex) {
                if (buttonIndex == 0) {
                    return ;
                }
                @strongify(self);
                [self showPickerVCWithButtonIndex:buttonIndex];
            } otherButtonTitles:@"拍照",@"从相册选取", nil];
            return;
        }
        
        if(indexPath.row == 1){
            ModifyNameViewController *modifyNameVC = [[ModifyNameViewController alloc] init];
            modifyNameVC.navigationItem.title = @"修改昵称";
            [self.navigationController pushViewController:modifyNameVC animated:YES];
            return;
        }
        
        if(indexPath.row == 2){
            //修改性别
            [CZHAddressPickerView provincePickerViewWithProvince:@"" provinceBlock:^(NSString *province) {
                NSString *sex = @"";
                if([province isEqualToString:@"男"]) {
                    sex = @"1";
                } else {
                    sex = @"2";
                }
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    ShowHint(@"");
                    [self.viewModel updateUserInfoWithMessage:sex userInfoType:UserInfoTypeSex success:^{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            hideHud();
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                ShowMessage(@"修改成功");
                            });
                            [APPUserDataIofo getSex:province];
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self.tableView reloadData];
                            });
                        });
                    }];
                });
                
            }];
            return;
        }
    }
    
    if(indexPath.section == 1){
        if(indexPath.row == 1) {
            //修改地区
            [CZHAddressPickerView cityPickerViewWithProvince:@"" city:@"" cityBlock:^(NSString *province, NSString *city) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    ShowHint(@"");
                    [self.viewModel updateUserInfoWithMessage:[NSString stringWithFormat:@"%@ %@",province,city] userInfoType:UserInfoTypeProv success:^{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            hideHud();
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                ShowMessage(@"修改成功");
                            });
                            
                            [APPUserDataIofo getCityname:[NSString stringWithFormat:@"%@ %@",province,city]];
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self.tableView reloadData];
                            });
                        });
                    }];
                });
               
            }];
        }
        return;
    }
    
    //退出登录
    if(indexPath.section == 2) {
        [TXAlertView showAlertWithTitle:@"提示" message:@"确定要退出吗" cancelButtonTitle:@"取消" style:TXAlertViewStyleAlert buttonIndexBlock:^(NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                [APPUserDataIofo LogOut];
                NSDictionary *para = @{@"isLoginOut" : @(YES)};
                [DCURLRouter pushURLString:@"route://loginVC" query:para animated:YES];
            }
        } otherButtonTitles:@"确定", nil];
       
    }
}

- (void)showPickerVCWithButtonIndex:(NSInteger)buttonIndex{
    WS(weakSelf);
    UIImagePickerController *pickerVC = [[UIImagePickerController alloc]init];
    if (buttonIndex == 1) {
        pickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }else if (buttonIndex == 2){
        pickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    [self presentViewController:pickerVC animated:YES completion:nil];
    __weak typeof(pickerVC) weakPickerVC = pickerVC;
    [[pickerVC rac_imageSelectedSignal] subscribeNext:^(id x) {
        [weakPickerVC dismissViewControllerAnimated:YES completion:^{
            //裁剪
            UIImage *imageOriginal = [x objectForKey:UIImagePickerControllerOriginalImage];
            MLImageCrop *imageCrop = [[MLImageCrop alloc]init];
            imageCrop.ratioOfWidthAndHeight = 1.0;
            imageCrop.outputWidth = 720;
            imageCrop.image = imageOriginal;
            imageCrop.delegate = weakSelf;
            [imageCrop showWithAnimation:YES];
        }];
    } completed:^{
        [weakPickerVC dismissViewControllerAnimated:YES completion:^{
        }];
    }];
}

- (AccountMessageViewModel *)viewModel{
    if(!_viewModel){
        _viewModel = [[AccountMessageViewModel alloc] init];
    }
    return _viewModel;
}

#pragma mark ClipPhoto
- (void)cropImage:(UIImage *)cropImage forOriginalImage:(UIImage *)originalImage{
    ShowHint(@"");
    [self.viewModel upLoadImgWithType:@"avator" img:cropImage success:^{
        [self.viewModel upLoadIconUrl:self.viewModel.iconUrl success:^{
            hideHud();
            [APPUserDataIofo getUserIcon:self.viewModel.iconUrl];
            [self.tableView reloadData];
            [[NSNotificationCenter defaultCenter] postNotificationName:UpdateUserInfoNotification object:nil userInfo:nil];
        }];
    }];
}

@end
