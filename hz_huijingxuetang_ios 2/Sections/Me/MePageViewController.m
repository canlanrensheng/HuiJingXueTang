//
//  MePageViewController.m
//  HuiJingSchool
//
//  Created by Junier on 2018/1/15.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "MePageViewController.h"
#import "ImgLabelAndLabelTableViewCell.h"
#import "MyClassViewController.h"
#import "FeedBackViewController.h"
#import "InviteViewController.h"
#import "AboutViewController.h"
#import "MyCardViewController.h"
#import "LoginViewController.h"
#import "AllOrderListViewController.h"

@interface MePageViewController ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@end

@implementation MePageViewController
{
    NSArray *imgarr;
    NSArray *titarr;
    UIView *menbanview;
    UIImageView *iconimg;
    UILabel *namelabel;
    UIButton *btn;
    NSString *phonenum;
    NSString *supervisephone;
    UIButton *iconbtn;
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"back" object:nil];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loaddata];

    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self
           selector:@selector(backHome)
               name:@"back"
             object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getmainview];

    
}

-(void)getmainview{
    
    UIImageView *topimg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kW, 180*SW)];
    topimg.image = [UIImage imageNamed:@"个人中心_02"];
    topimg.userInteractionEnabled = YES;
    [self.view addSubview:topimg];
    
    iconimg = [[UIImageView alloc]initWithFrame:CGRectMake(kW/2 - 41.25*SW, 21*SW, 82.5*SW, 82.5*SW)];
    iconimg.image = [UIImage imageNamed:@"tuixiang"];
    iconimg.layer.cornerRadius =82.5/2*SW;
    iconimg.layer.masksToBounds = YES;
    [topimg addSubview:iconimg];
    
    iconbtn = [[UIButton alloc]initWithFrame:iconimg.frame];
    [iconbtn addTarget:self action:@selector(Iconaction) forControlEvents:UIControlEventTouchUpInside];
    [topimg addSubview:iconbtn];
    
    namelabel = [[UILabel alloc]initWithFrame:CGRectMake(0, iconimg.maxY +10*SW, kW, 30*SW)];
    namelabel.text = @"";
    namelabel.textAlignment = 1;
    [topimg addSubview:namelabel];
    
    btn = [[UIButton alloc]initWithFrame:CGRectMake(kW/2 - 30*SW, namelabel.maxY + 5*SW, 60*SW, 30*SW)];
    [btn setTitleColor:[UIColor colorWithHexString:@"#26f0df"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"登出" forState:UIControlStateNormal];
    [topimg addSubview:btn];
    
    UIView *bgview = [[UIView alloc]initWithFrame:CGRectMake(0, topimg.maxY, kW, 70*SW)];
    bgview.backgroundColor = CWHITE;
    [self.view addSubview:bgview];
    
    UILabel *titlabel = [[UILabel alloc]initWithFrame:CGRectMake(10*SW, 10*SW, 150*SW, 20*SW)];
    titlabel.text = @"VIP服务";
    [bgview addSubview:titlabel];
    
    UILabel *conlabel = [[UILabel alloc]initWithFrame:CGRectMake(10*SW,titlabel.maxY+ 10*SW, 150*SW, 20*SW)];
    conlabel.text = @"暂未开通VIP服务";
    conlabel.textColor = TextColor;
    conlabel.font = FONT(14);
    [bgview addSubview:conlabel];
    
    UIButton *openbtn = [[UIButton alloc]initWithFrame:CGRectMake(kW-90*SW, 20*SW, 80*SW, 30*SW)];
    [openbtn setTitle:@"开通服务" forState:UIControlStateNormal];
    [openbtn setTitleColor:CWHITE forState:UIControlStateNormal];
    openbtn.titleLabel.font = FONT(16);
    openbtn.backgroundColor = NavAndBtnColor;
    openbtn.layer.cornerRadius = 5;
    openbtn.layer.masksToBounds = YES;
    openbtn.hidden = YES;
    [openbtn addTarget:self action:@selector(openvip) forControlEvents:UIControlEventTouchUpInside];
    [bgview addSubview:openbtn];
    
    UIView *ln = [[UIView alloc]initWithFrame:CGRectMake(0, 69.5*SW, kW, 0.5*SW)];
    ln.backgroundColor = LnColor;
    [bgview addSubview:ln];
    
    
    UITableView *tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, bgview.maxY, kW, self.view.height - topimg.height - bgview.height - SafeAreaTopHeight- 49)];
    tableview.dataSource = self;
    tableview.delegate = self;
    [self.view addSubview:tableview];
    
    imgarr = @[@"个人中心_07",@"个人中心_10",@"case",@"个人中心_12",@"个人中心_18",@"个人中心_20",@"个人中心_22",@"个人中心_24",@"个人中心_26",@"个人中心_28"];
    titarr = @[@"我的精品课",@"我的私教课",@"我的订单",@"我的卡券",@"学习进度",@"意见反馈",@"联系我们",@"邀请好友",@"关注微信号",@"关于我们"];
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
                                   [controller setAllowsEditing:YES];
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
                                   imagePicker.allowsEditing = YES;
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
    UIImage *img = [info objectForKey:UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:YES completion:^{
        [self uploadImg:img];
    }];
}

-(void)uploadImg:(UIImage *)img{
    [YJAPPNetwork upLoadImgWithAccesstoken:[APPUserDataIofo AccessToken] type:@"avator" img:img success:^(NSDictionary *responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"]integerValue];
        if (code == 200) {
            [self changeIcon:[responseObject objectForKey:@"data"]];
        }else{
            [ConventionJudge NetCode:code vc:self type:@"1"];
        }
    } failure:^(NSString *error) {
        [SVProgressHUD showInfoWithStatus:netError];
    }];
}

-(void)changeIcon:(NSString *)url{
    [YJAPPNetwork updataIconWithAccesstoken:[APPUserDataIofo AccessToken] avator:url success:^(NSDictionary *responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"]integerValue];
        if (code == 200) {

            [self loaddata];
        }else{
            [ConventionJudge NetCode:code vc:self type:@"1"];
        }
    } failure:^(NSString *error) {
        [SVProgressHUD showInfoWithStatus:netError];
    }];
}

-(void)loaddata{

    [YJAPPNetwork MyInfowithaccesstoken:[APPUserDataIofo AccessToken] success:^(NSDictionary *responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"]integerValue];
        if (code == 200) {
            [btn setTitle:@"登出" forState:UIControlStateNormal];

            NSDictionary *dic = [responseObject objectForKey:@"data"];
            if ([ConventionJudge isNotNULL:[dic objectForKey:@"avator"]]) {
                NSURL *url = [NSURL URLWithString:[dic objectForKey:@"avator"]];
                [iconimg sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"tuixiang"]];
                [APPUserDataIofo getUserIcon:[dic objectForKey:@"avator"]];
            }
            if ([ConventionJudge isNotNULL:[dic objectForKey:@"contact"]]) {
                phonenum = [dic objectForKey:@"contact"];
            }
            if ([ConventionJudge isNotNULL:[dic objectForKey:@"supervision"]]) {
                supervisephone = [dic objectForKey:@"supervision"];
            }
            namelabel.text = [dic objectForKey:@"nickname"];
            [APPUserDataIofo getUserName:[dic objectForKey:@"nickname"]];
            SVDismiss;
        }else{
//            [ConventionJudge NetCode:code vc:self type:@"2"];
            [btn setTitle:@"登录" forState:UIControlStateNormal];
            SVDismiss;
        }
    } failure:^(NSString *error) {
        [SVProgressHUD showInfoWithStatus:netError];
        
    }];
}

-(void)backHome{
    [self.tabBarController setSelectedIndex:0];
}

-(void)logout{
    [APPUserDataIofo LogOut];
    namelabel.text = @"";
    iconimg.image = [UIImage imageNamed:@"tuixiang"];
    LoginViewController *vc = [[LoginViewController alloc]init];
    vc.type = @"3";
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)phoneAction{
    if (phonenum.length) {
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",phonenum];
        //            NSLog(@"str======%@",str);
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
}
-(void)openvip{
    UIStoryboard*storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    // 2.通过标识符找到对应的页面
    UIViewController*vc=[storyBoard instantiateViewControllerWithIdentifier:@"BuyVipViewController"];
    // 3.这里以push的方式加载控制器
    [self.navigationController pushViewController:vc animated:YES];
    [self.navigationController setNavigationBarHidden:NO];
}
-(void)jumpHUD{
    menbanview = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    menbanview.backgroundColor = RGBA(0, 0, 0, 0.5);
    [self.navigationController.view addSubview:menbanview];
    
    UIView *main = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 330*SW, 305*SW)];
    main.center = CGPointMake(self.view.center.x, 350*SW);
    main.layer.cornerRadius = 10*SW;
    main.layer.masksToBounds = YES;
    main.backgroundColor = [UIColor whiteColor];
    [menbanview addSubview:main];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, main.width, 50*SW)];
    label.textAlignment = 1;
    label.text = @"关注惠鲸学堂微信公众号";
    label.font = FONT(20);
    [main addSubview:label];
    
    UITextView *textview = [[UITextView alloc]initWithFrame:CGRectMake(15*SW, 50*SW, main.width - 30*SW, main.height - 110*SW)];
    textview.text = @"慧鲸学堂专注精耕投资者教育事业，多维度实时共享投资经验、策略及方法。平台联合国内主流金融在线教育机构，打造具备互联网新闻信息服务、网络文化经营许可、广播电视节目制作、互联网出版许可及证券期货经营许可等资质的知识传播学堂！\n\n平台特邀多位实力名师坐镇，以独家并结合实战为核心的培训模式，实时共享投资经验、策略及方法。致力于帮助广大投资者构建专属的投资知识体系。";
    textview.userInteractionEnabled = NO;
    textview.font = FONT(14);
    [main addSubview:textview];
    
    UIButton *offbtn = [[UIButton alloc]initWithFrame:CGRectMake(0,255*SW, main.width/2, 50*SW)];
    [offbtn setTitle:@"取消" forState:UIControlStateNormal];
    [offbtn setTitleColor:TextColor forState:UIControlStateNormal];
    [offbtn addTarget:self action:@selector(backHide) forControlEvents:UIControlEventTouchUpInside];
    [main addSubview:offbtn];
    
    UIButton *gobtn = [[UIButton alloc]initWithFrame:CGRectMake(main.width/2, 255*SW, main.width/2, 50*SW)];
    [gobtn setTitle:@"去微信" forState:UIControlStateNormal];
    [gobtn setTitleColor:NavAndBtnColor forState:UIControlStateNormal];
    [gobtn addTarget:self action:@selector(goweixin) forControlEvents:UIControlEventTouchUpInside];
    [main addSubview:gobtn];
    
    UIView *lnview = [[UIView alloc]initWithFrame:CGRectMake(0, main.height - 50*SW, main.width, 1)];
    lnview.backgroundColor = LnColor;
    [main addSubview:lnview];
    
    UIView *lnview1 = [[UIView alloc]initWithFrame:CGRectMake(main.width/2, main.height - 50*SW, 1, 50*SW)];
    lnview1.backgroundColor = LnColor;
    [main addSubview:lnview1];
}

-(void)goweixin{
//    JumpToBizProfileReq *req = [[JumpToBizProfileReq alloc]init];
//    req.profileType =WXBizProfileType_Normal;
//    req.username=@"gh_6b31b722a1e8";
//    req.extMsg = @"";
//    req.profileType =0;
//    [WXApi sendReq:req];
}

-(void)backHide{
    [menbanview removeFromSuperview];
}
#pragma mark --<UITabBarDelegate,UITableViewDataSource>
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ImgLabelAndLabelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"imglabellabelcell"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([ImgLabelAndLabelTableViewCell class]) owner:self options:nil]objectAtIndex:0];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.imgview.image = [UIImage imageNamed:imgarr[indexPath.row]];
    cell.title.text = titarr[indexPath.row];
    cell.venuelabel.textColor = NavAndBtnColor;
    if (indexPath.row == 0||indexPath.row == 1) {
        cell.venuelabel.hidden = YES;
    }else{
        cell.venuelabel.hidden = YES;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        MyClassViewController *vc = [[MyClassViewController alloc]init];
        vc.type =  @"3";
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 1) {
        MyClassViewController *vc = [[MyClassViewController alloc]init];
        vc.type =  @"4";
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 2){
        AllOrderListViewController *vc = [[AllOrderListViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 3){
        MyCardViewController *vc = [[MyCardViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 5){
        FeedBackViewController *vc = [[FeedBackViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 7){
        InviteViewController *vc = [[InviteViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 6){
        [self phoneAction];
    }else if (indexPath.row == 9){
        AboutViewController *vc = [[AboutViewController alloc]init];
        vc.phone = supervisephone;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 8){
        [self jumpHUD];
    }else if (indexPath.row == 4){
     
    }
    

}
@end
