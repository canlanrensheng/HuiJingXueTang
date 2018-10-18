//
//  FreeLiveViewController.m
//  HuiJingSchool
//
//  Created by Junier on 2018/2/5.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "FreeLiveViewController.h"
#import "HACursor.h"
#import "RestoreTableViewCell.h"
#import "NowTableViewCell.h"
#import "NELivePlayerController.h"
#import "NELivePlayerControlView.h"
#import "ClassCollectionViewCell.h"
#import <MJRefresh.h>
#import <NIMSDK/NIMSDK.h>
#import <NIMSDK/NIMChatroomManagerProtocol.h>
#import "GiftView.h"
#import "AppDelegate.h"
#import "LiveAncientlyViewControllerViewController.h"

#define topiewH SafeAreaTopHeight - 64

@interface FreeLiveViewController ()<UITableViewDelegate,UITableViewDataSource,NELivePlayerControlViewProtocol,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,NIMChatManagerDelegate,NIMChatroomManagerDelegate>
@property (nonatomic, strong) NSMutableArray *titleArray;
@property(strong,nonatomic) UIView *bottomView;
@property(strong,nonatomic) UITextField *commentTextField;
@property(strong,nonatomic) UIButton *commentButton;
@property(nonatomic, strong) UIView *playerView;
@property(nonatomic,strong)NELivePlayerController *liveplayer;
@property(nonatomic,strong)NELivePlayerControlView *controlView;
@property(strong,nonatomic)UICollectionView *collectionview;
@property(strong,nonatomic) NSMutableArray *chatArr;


@end

@implementation FreeLiveViewController
{
    UIScrollView *scrollview;
    HACursor*cursor;
    UITableView *tableview1;
    UITableView *tableview2;
    UIButton *menbanview;
    UIView *giftview;
    NSMutableArray *btnarr;
    UIView *view1;
    UILabel*label4;
    UIView *cardview;
    NSMutableArray *imgarr;
    NSDictionary *roomdic;
    NSDictionary *coursedic;
    NSDictionary *chatdic;
    NSDictionary *datadic;
    NSArray *dataArr;
    NSString *courseid;
    NSMutableArray *courseArr;
    UIView * view3;
    NSInteger page1;
    NSInteger totalpage1;
    NSArray *dataarr;
    BOOL fool;
    NSString *menikename;
    NSString *meicon;
    BOOL isOnRoom;
    UIView *liveimgview;

}

-(NSMutableArray *)chatArr{
    if (_chatArr == nil) {
        _chatArr = [NSMutableArray array];
    }
    return _chatArr;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [[NIMSDK sharedSDK].chatManager removeDelegate:self];
    [self.liveplayer shutdown];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.liveplayer shutdown];
    [UIApplication sharedApplication].statusBarHidden = NO;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];


    // 播放器媒体流初始化完成后触发，收到该通知表示可以开始播放
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(NELivePlayerDidPreparedToPlay:)
                                                 name: NELivePlayerDidPreparedToPlayNotification
                                               object: _liveplayer];
    [self loaddata];
    [UIApplication sharedApplication].statusBarHidden = fool;


    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ALLViewBgColor;
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"13_"] style:UIBarButtonItemStylePlain target:self action:@selector(releaseInfo)];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:@"UIKeyboardWillShowNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:@"UIKeyboardWillHideNotification" object:nil];
    [[NIMSDK sharedSDK].chatManager addDelegate:self];
}

-(void)loaddata{
    if ([[APPUserDataIofo AccessToken] isEqualToString:@""]) {
        [YJShareCategory JumploginWhichVC:self andtype:@"1"];
        return;
    }
    [YJAPPNetwork LiveRoomWithAccessToken:[APPUserDataIofo AccessToken] ID:_Id success:^(NSDictionary *responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"]integerValue];
        if (code == 200) {
            datadic = [responseObject objectForKey:@"data"];
            roomdic = [datadic objectForKey:@"room"];
            coursedic = [datadic objectForKey:@"course"];
            chatdic = [datadic objectForKey:@"chat"];
            NSString *account = [chatdic objectForKey:@"accid"];
            NSString *token   = [chatdic objectForKey:@"tokenid"];
            [[[NIMSDK sharedSDK] loginManager] login:account
                                               token:token
                                          completion:^(NSError *error) {
                                              if (!error) {
                                                  NIMChatroomEnterRequest *request = [[NIMChatroomEnterRequest alloc]init];
                                                  request.roomId = [chatdic objectForKey:@"roomid"];
                                                  [[NIMSDK sharedSDK].chatroomManager enterChatroom:request completion:^(NSError * _Nullable error, NIMChatroom * _Nullable chatroom, NIMChatroomMember * _Nullable me) {
                                                      menikename = me.roomNickname;
                                                      meicon = me.roomAvatar;
                                                      isOnRoom = YES;
                                                  }];
                                              }else{
                                                  isOnRoom = NO;
                                              }
                                          }];
            courseid = [coursedic objectForKey:@"courseid"];
            [self loadList];
            [self pageview];
            [self getmainview];
        }else{
            if (code == 29) {
                [SVProgressHUD showInfoWithStatus:[responseObject objectForKey:@"msg"]];
                [self.navigationController popViewControllerAnimated:YES];
            }
            [ConventionJudge NetCode:code vc:self type:@"1"];
        }
    } failure:^(NSString *error) {
        [SVProgressHUD showInfoWithStatus:netError];
        [self.navigationController popViewControllerAnimated:YES];

    }];
}

-(void)loadList{
    NSString *userid = [[datadic objectForKey:@"course"]objectForKey:@"userid"];
    [YJAPPNetwork LiveCourseProgramWithID:userid success:^(NSDictionary *responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"]integerValue];
        if (code == 200) {
            
            dataArr = [NSArray array];
            dataArr = [responseObject objectForKey:@"data"];
            [tableview2 reloadData];
            [self loadTeapastlivecourse];
        }else{
            [ConventionJudge NetCode:code vc:self type:@"1"];
        }
    } failure:^(NSString *error) {
        [SVProgressHUD showInfoWithStatus:netError];
    }];
}

-(void)loadTeapastlivecourse{
    page1 = 1;
    NSString *pagestr = [NSString stringWithFormat:@"%ld",page1];
    NSString *userid = [[datadic objectForKey:@"course"]objectForKey:@"userid"];
    [YJAPPNetwork TeapastLiveCourseListProgramWithID:userid page:pagestr success:^(NSDictionary *responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"]integerValue];
        if (code == 200) {
            NSDictionary *dic = [responseObject objectForKey:@"data"];
            courseArr = [NSMutableArray array];
            courseArr = [dic objectForKey:@"courselist"];
            totalpage1 = [[dic objectForKey:@"totalpage"] integerValue];
            if (totalpage1>1) {
                _collectionview.mj_footer.hidden = NO;
            }
            [self.collectionview reloadData];
            if (isOnRoom == YES) {
                SVShowSuccess(@"进入聊天室");
            }else{
                SVshowInfo(@"进入聊天室失败");
            }
        }else{
            [ConventionJudge NetCode:code vc:self type:@"1"];
        }
        [_collectionview.mj_header endRefreshing];

    } failure:^(NSString *error) {
        [SVProgressHUD showInfoWithStatus:netError];
        [_collectionview.mj_header endRefreshing];

    }];
}

-(void)loadMoredata1{
    
    if (totalpage1 == 0||page1 == totalpage1) {
        [_collectionview.mj_footer setState:MJRefreshStateNoMoreData];
        return;
    }else{
        page1++;
    }
    NSString *pagestr = [NSString stringWithFormat:@"%ld",page1];
    NSString *userid = [[datadic objectForKey:@"course"]objectForKey:@"userid"];

    [YJAPPNetwork TeapastLiveCourseListProgramWithID:userid page:pagestr success:^(NSDictionary *responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"]integerValue];
        if (code == 200) {
            NSDictionary *dic = [responseObject objectForKey:@"data"];
            NSArray *arr = [dic objectForKey:@"courselist"];

            [courseArr addObjectsFromArray:arr];
            [_collectionview reloadData];
            SVDismiss;
        }else{
            [ConventionJudge NetCode:code vc:self type:@"1"];
        }
        [_collectionview.mj_footer endRefreshing];
        
    } failure:^(NSString *error) {
        [SVProgressHUD showInfoWithStatus:netError];
        [_collectionview.mj_footer endRefreshing];
    }];
}
-(void)pageview{
    _titleArray=[[NSMutableArray alloc]init];
    [_titleArray addObject:@"互动"];
    [_titleArray addObject:@"节目单"];
    [_titleArray addObject:@"往期直播课程"];
    
    cursor = [[HACursor alloc]init];
    cursor.itemTitleBtnWidth=kW/3;
    cursor.frame = CGRectMake(0, 200*SW+topiewH, kW, 45);
    cursor.scrollNavBar.linecoler = NavAndBtnColor;
    cursor.titles =_titleArray;
    cursor.pageViews = [self createPageViews];
    cursor.backgroundColor= CWHITE;
    //设置根滚动视图的高度
    cursor.rootScrollViewHeight =kH-cursor.maxY;
    //    cursor.rootScrollView.backgroundColor=Background_Color;
    cursor.rootScrollView.scrollEnabled = NO;
    //默认值是白色
    cursor.titleNormalColor = TextNoColor;
    //默认值是白色
    cursor.titleSelectedColor = NavAndBtnColor;
    //        cursor.titleSelectedColor = WYColorMain;
    //是否显示排序按钮
    cursor.showSortbutton = NO;
    //    cursor.rootScrollView.rootScrollViewDateSource = self;
    //默认的最小值是5，小于默认值的话按默认值设置
    cursor.minFontSize = 14;
    //默认的最大值是25，小于默认值的话按默认值设置，大于默认值按设置的值处理
    cursor.maxFontSize = 17;
    //cursor.isGraduallyChangFont = NO;
    //在isGraduallyChangFont为NO的时候，isGraduallyChangColor不会有效果
    //cursor.isGraduallyChangColor = NO;
    [self.view addSubview:cursor];
}

//- (NSUInteger)numberOfCellInRootScrollView:(HARootScrollView *)rootScrollView{
//    return 2;
//}


- (NSMutableArray *)createPageViews{
    
    NSMutableArray *pageViews = [NSMutableArray array];
    CGFloat bottonH = SafeAreaTopHeight - 64;
    for (NSInteger i = 0; i <_titleArray.count; i++)
    {
        if (i==0) {
            view1 = [[UIView alloc]init];
            view1.backgroundColor = [UIColor whiteColor];
            [pageViews addObject:view1];

            tableview1 = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kW, kH-200*SW - bottonH - 45-45)];
            tableview1.dataSource = self;
            tableview1.delegate = self;
            tableview1.separatorStyle = UITableViewCellSeparatorStyleNone;
            [view1 addSubview:tableview1];
            [self setupButtomView];
            
        }else if(i==1){
            UIView *view = [[UIView alloc]init];
            view.backgroundColor = ALLViewBgColor;
            tableview2 = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kW, kH  -45 - 200*SW-bottonH)];
            tableview2.dataSource = self;
            tableview2.delegate = self;
            tableview2.backgroundColor = ALLViewBgColor;
            tableview2.separatorStyle = UITableViewCellSeparatorStyleNone;
            [view addSubview:tableview2];
            
            [pageViews addObject:view];
            
        }else{
            UIView *view = [[UIView alloc]init];
            view.backgroundColor = ALLViewBgColor;
            view3 = [[UIView alloc]initWithFrame:CGRectMake(0,0, kW, kH- 200*SW-topiewH-45)];
            view3.backgroundColor = ALLViewBgColor;
            [view addSubview:view3];
            
            UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
            //设置collectionView滚动方向
            [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
            
            //    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
            
            //设置headerView的尺寸大小
            //    layout.headerReferenceSize = CGSizeMake(self.view.frame.size.width,100);
            //该方法也可以设置itemSize
            //    layout.itemSize =CGSizeMake(110, 150);
            
            //2.初始化collectionView
            self.collectionview = [[UICollectionView alloc] initWithFrame:view3.bounds collectionViewLayout:layout];
            [view3 addSubview:self.collectionview];
            //4.设置代理
            self.collectionview.delegate = self;
            self.collectionview.dataSource = self;
            self.collectionview.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadTeapastlivecourse)];
            self.collectionview.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoredata1)];
            self.collectionview.backgroundColor = [UIColor clearColor];
            
            //3.注册collectionViewCell
            //注意，此处的ReuseIdentifier 必须和 cellForItemAtIndexPath 方法中 一致 均为 cellId
            UINib *nib = [UINib nibWithNibName:NSStringFromClass([ClassCollectionViewCell class]) bundle:[NSBundle mainBundle]];
            [self.collectionview registerNib:nib forCellWithReuseIdentifier:@"classcell"];

            [pageViews addObject:view];
        }
    }
    return pageViews;
}
-(void)getmainview{
    
    UIView*topview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kW, topiewH)];
    topview.backgroundColor = ALLViewBgColor;
    [self.view addSubview:topview];
    
    liveimgview = [[UIView alloc]initWithFrame:CGRectMake(0, topview.maxY, kW, 200*SW)];
    liveimgview.backgroundColor = ALLViewBgColor;
    [self.view insertSubview:liveimgview atIndex:998];
    NSURL *url;
    if (roomdic.count) {
        url = [NSURL URLWithString:[roomdic objectForKey:@"rtmpPullUrl"]];
    }else{
        if ([ConventionJudge isNotNULL:[coursedic objectForKey:@"videourl"]]) {
            url = [NSURL URLWithString:[coursedic objectForKey:@"videourl"]];
        }else{
            url = [NSURL URLWithString:@""];
        }
    }
    
    /* 方式 二 */
    NSError *error = nil;
    self.liveplayer = [[NELivePlayerController alloc] initWithContentURL:url error:&error];
    if (self.liveplayer == nil) {
        NSLog(@"player initilize failed, please tay again.error = [%@]!", error);
    }
    self.liveplayer.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
//    **(4) 设置播放器view的相关属性**
    self.liveplayer.view.frame = liveimgview.frame;
    self.liveplayer.view.backgroundColor = ALLViewBgColor;
    [self.liveplayer setBufferStrategy:NELPLowDelay]; // 直播低延时模式
    [self.liveplayer setScalingMode:NELPMovieScalingModeFill]; // 设置画面显示模式，默认原始大小
    [self.liveplayer setShouldAutoplay:YES]; // 设置prepareToPlay完成后是否自动播放
    [self.liveplayer setHardwareDecoder:NO]; // 设置解码模式，是否开启硬件解码
    [self.liveplayer setPauseInBackground:NO]; // 设置切入后台时的状态，暂停还是继续播放
    [self.liveplayer setPlaybackTimeout:15 *1000]; // 设置拉流超时时间
    //添加显示层
    [self.view insertSubview:self.liveplayer.view atIndex:999];
    [self.liveplayer prepareToPlay];

    fool = NO;
    
    _controlView = [[NELivePlayerControlView alloc] init];
    _controlView.delegate = self;
    _controlView.videoProgress.hidden = YES;
    _controlView.frame = liveimgview.frame;
    [self.view insertSubview:_controlView atIndex:999];
    

    //    添加手势
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
}


//键盘的布局
- (void)setupButtomView{
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0,tableview1.maxY, kW, 45)];
    self.bottomView.backgroundColor = ALLViewBgColor;
    [view1 addSubview:self.bottomView];
    
    UIButton *liwubtn = [[UIButton alloc]initWithFrame:CGRectMake(15, 10, 25, 25)];
    [liwubtn setImage:[UIImage imageNamed:@"14_"] forState:UIControlStateNormal];
    [liwubtn addTarget:self action:@selector(shang) forControlEvents:UIControlEventTouchUpInside];
    
    [_bottomView addSubview:liwubtn];
    //添加textfield
    self.commentTextField = [[UITextField alloc] initWithFrame:CGRectMake(liwubtn.maxX+ 10, 5, self.view.frame.size.width - 140, 35)];
    self.commentTextField.backgroundColor = [UIColor whiteColor];
    self.commentTextField.layer.cornerRadius = 5;
    self.commentTextField.placeholder = @" 单行输入";
    [self.bottomView addSubview:self.commentTextField];
    //textField遵循协议
    self.commentTextField.delegate = self;
    //添加button
    self.commentButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.commentButton.frame = CGRectMake(self.view.frame.size.width - 80, 5, 70, 35);
    self.commentButton.backgroundColor = NavAndBtnColor;
    [self.commentButton setTitleColor:CWHITE forState:UIControlStateNormal];
    self.commentButton.layer.cornerRadius = 5;
    [self.commentButton setTitle:@"发送" forState:UIControlStateNormal];
    [self.commentButton addTarget:self action:@selector(commentButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:self.commentButton];
    //关闭button的用户交互
    self.commentButton.userInteractionEnabled = YES;
}
-(void)shang{
    [YJAPPNetwork GiftTasksuccess:^(NSDictionary *responseObject) {
        NSInteger code = [[responseObject objectForKey:@"code"]integerValue];
        if (code == 200) {
            dataarr = [NSArray array];
            dataarr = [responseObject objectForKey:@"data"];
            [self getGiftviewWithArr:dataarr];
            SVDismiss;
        }else{
            [ConventionJudge NetCode:code vc:self type:@"1"];
        }
    } failure:^(NSString *error) {
        [SVProgressHUD showInfoWithStatus:netError];
    }];
}


-(void)getGiftviewWithArr:(NSArray *)Arr{
    GiftView *Gview = [[GiftView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    Gview.GiftArr = Arr;
    [self.navigationController.view addSubview:Gview];
}



//键盘即将出现的时候
- (void)keyboardWillShow:(NSNotification *)sender{
    self.bottomView.hidden = NO;
    //    获取键盘的高度
    NSDictionary *userInfo = [sender userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    self.bottomView.transform = CGAffineTransformMakeTranslation(0, -height);
}

//键盘即将消失的时候
- (void)keyboardWillHidden:(NSNotification *)sender{
    self.bottomView.transform = CGAffineTransformIdentity;
}

-(void)keyboardHide{
    [self.commentTextField resignFirstResponder];
}
//发送按钮的回调方法
- (void)commentButtonAction:(UIButton *)sender{
    
    if (isOnRoom == NO) {
        return [SVProgressHUD showInfoWithStatus:@"发送失败"];
    }
    
    if (!self.commentTextField.text.length) {
        return [SVProgressHUD showInfoWithStatus:@"请输入聊天内容"];
    }
    NIMMessage *message = [[NIMMessage alloc]init];
    message.text = self.commentTextField.text;
    NSDate *date = [NSDate date];
    NSLog(@"%@",date);
    message.timestamp = [date timeIntervalSince1970];
    NIMSession *session = [NIMSession session:[chatdic objectForKey:@"roomid"] type:NIMSessionTypeChatroom];
    
    [[[NIMSDK sharedSDK]chatManager]sendMessage:message toSession:session error:nil];

    //取消第一响应者
    [self.commentTextField resignFirstResponder];
    
}


//点击了注册
-(void)registAction{
    
}


//点击了导航右边按钮
-(void)releaseInfo{
    
}
-(void)popAction{
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == tableview1) {
        return _chatArr.count;
    }else{
        return dataArr.count;
    }
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == tableview1) {
        RestoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"restorecell"];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([RestoreTableViewCell class]) owner:self options:nil]objectAtIndex:0];
        }
        cell.namelb.textColor = NavAndBtnColor;
        cell.namelb.font = TextFont;
        cell.conlb.font = TextFont;
        cell.timeba.font = TextFont;
        cell.resbtn.layer.borderColor = [[UIColor blackColor]CGColor];
        cell.resbtn.layer.borderWidth = 1;
        cell.resbtn.layer.cornerRadius = 3;
        cell.resbtn.layer.masksToBounds = YES;
        cell.resbtn.hidden = YES;
        
        NIMMessage *message = _chatArr[indexPath.section];
        NSTimeInterval timeInterval = message.timestamp;//获取需要转换的timeinterval
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSString *dateString = [formatter stringFromDate:date];
        
        NSLog(@"%@",dateString);
        NIMMessageChatroomExtension *ext =  message.messageExt;

        cell.iconimg.layer.cornerRadius = 25*SW;
        cell.iconimg.layer.masksToBounds = YES;
        if ([ConventionJudge isNotNULL:ext]) {
            cell.namelb.text = ext.roomNickname;
            NSURL *url = [NSURL URLWithString:ext.roomAvatar];
            [cell.iconimg sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"tuixiang"]];
        }else{
            cell.namelb.text = menikename;
            NSURL *url = [NSURL URLWithString:meicon];
            [cell.iconimg sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"tuixiang"]];
        }

        cell.conlb.text = message.text;
        cell.timeba.text = dateString;

        return cell;
    }else{
        NowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"nowcell"];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([NowTableViewCell class]) owner:self options:nil]objectAtIndex:0];
        }
        NSDictionary *dic = dataArr [indexPath.section];

        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = ALLViewBgColor;
        cell.btn.layer.cornerRadius = 3;
        cell.btn.layer.masksToBounds = YES;
        
        cell.classname.text = [dic objectForKey:@"coursename"];
        cell.teachername.text = [NSString stringWithFormat:@"讲师：%@",[dic objectForKey:@"realname"]];

        cell.btnwidth.constant = 90*SW;
        if ([[dic objectForKey:@"liveflag"]integerValue] == 1) {
            [cell.btn setTitle:@"正在直播" forState:UIControlStateNormal];
            [cell.btn setBackgroundColor:NavAndBtnColor];
        }else if([[dic objectForKey:@"liveflag"]integerValue] == 2){
            [cell.btn setTitle:@"往期直播" forState:UIControlStateNormal];
            [cell.btn setBackgroundColor:[UIColor redColor]];
        }else{
            [cell.btn setTitle:@"预告直播" forState:UIControlStateNormal];
            [cell.btn setBackgroundColor:NavAndBtnColor];
        }
        
        return cell;
    }

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == tableview1) {
        return 80;
    }else{
        return 60;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == tableview1) {
        return 1;

    }else{
        return 40;
    }
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView == tableview1) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kW, 75)];
        view.backgroundColor = LnColor;
        return view;
    }else{
        NSDictionary *dic = dataArr[section];

        UIView *view = [[UIView alloc]init];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, SW, 40)];
        label.text = @"      9:15-9:20";
        label.textColor = [UIColor redColor];
        label.backgroundColor = ALLViewBgColor;
        [view addSubview:label];
        
        return label;
    }
}

// 初始化完成通知响应
- (void)NELivePlayerDidPreparedToPlay:(NSNotification*)notification {
    NSLog(@"[NELivePlayer Demo] 收到 NELivePlayerDidPreparedToPlayNotification 通知");

//    [self.liveplayer play]; //如果设置shouldAutoplay为YES，此处可以不用调用play
}

////返回section个数
//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
//{
//    return courseArr.count;
//}

//每个section的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    //    return 21;
    return courseArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    ClassCollectionViewCell *cell = (ClassCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"classcell" forIndexPath:indexPath];
 
    NSDictionary *dic = courseArr[indexPath.row];
    cell.titlelb.text = [dic objectForKey:@"coursename"];
    cell.titlelb.font = FONT(17);
    cell.numlb.text = [NSString stringWithFormat:@"%ld",[[dic objectForKey:@"browsingcount"]integerValue]];
    cell.numlb.textColor = [UIColor redColor];
    cell.freelb.hidden = YES;
    NSURL *url = [NSURL URLWithString:[dic objectForKey:@"coursepic"]];
    [cell.img sd_setImageWithURL:url];
    return cell;
}


//设置每个item的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(kW/2 - 30*SW, 153*SW);
}


//设置每个item水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}


////设置每个item垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

//定义每个Section的四边间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 15*SW, 10*SW, 15*SW);//分别为上、左、下、右
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self.navigationController popViewControllerAnimated:YES];
        NSDictionary *dic = courseArr[indexPath.row];
    //    FreeLiveViewController *vc = [[FreeLiveViewController alloc]init];
    //    vc.Id = [dic objectForKey:@"courseid"];
    //    [self.navigationController pushViewController:vc animated:YES];
    LiveAncientlyViewControllerViewController *vc = [[LiveAncientlyViewControllerViewController alloc]init];
    vc.Id =[dic objectForKey:@"courseid"];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)controlViewOnClickQuit:(NELivePlayerControlView *)controlView{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)controlViewOnClickScale:(NELivePlayerControlView *)controlView isFill:(BOOL)isFill {
    NSLog(@"[NELivePlayer Demo] 点击屏幕缩放，当前状态: [%@]", (isFill ? @"全屏" : @"适应"));
    if (isFill) {
        fool = YES;
        [UIApplication sharedApplication].statusBarHidden = YES;
        [UIView animateWithDuration:0.3 animations:^{
            self.liveplayer.view.transform=CGAffineTransformMakeRotation(M_PI/2);
            _controlView.transform=CGAffineTransformMakeRotation(M_PI/2);
            liveimgview.transform =CGAffineTransformMakeRotation(M_PI/2);
            CGRect f = self.liveplayer.view.frame;
            f = CGRectMake(0, 0, kW, kH);
            _controlView.frame = f;
            self.liveplayer.view.frame = f;
            liveimgview.frame = f;
        }];

    } else {
        fool = NO;
        [UIApplication sharedApplication].statusBarHidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            self.liveplayer.view.transform = CGAffineTransformIdentity;
            _controlView.transform = CGAffineTransformIdentity;
            liveimgview.transform = CGAffineTransformIdentity;

            CGRect f = self.liveplayer.view.frame;
            f = CGRectMake(0, 0, kW, 200);
            _controlView.frame = f;
            self.liveplayer.view.frame = f;
            liveimgview.frame = f;

        }];
    }
}



#pragma mark -- NIMChatManagerDelegate
-(void)sendMessage:(NIMMessage *)message didCompleteWithError:(NSError *)error{
    if (!error) {
        SVShowSuccess(@"发送成功");
        [self.chatArr addObject:message];
        [tableview1 reloadData];
        self.commentTextField.text = nil;
        NSIndexPath * dayOne = [NSIndexPath indexPathForRow:0 inSection:self.chatArr.count - 1];
        [tableview1 scrollToRowAtIndexPath:dayOne atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

-(void)onRecvMessages:(NSArray<NIMMessage *> *)messages{
    for (NIMMessage *message in messages) {
        NSLog(@"%@",message.text);
        if (message.text.length) {
            [self.chatArr addObject:message];
        }
    }
    [tableview1 reloadData];
    if (self.chatArr.count) {
        NSIndexPath * dayOne = [NSIndexPath indexPathForRow:0 inSection:self.chatArr.count - 1];
        [tableview1 scrollToRowAtIndexPath:dayOne atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }

}

@end
