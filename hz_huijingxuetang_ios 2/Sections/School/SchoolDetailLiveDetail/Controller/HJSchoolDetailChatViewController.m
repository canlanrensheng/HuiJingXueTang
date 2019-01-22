//
//  HJSchoolDetailChatViewController.m
//  HuiJingSchool
//
//  Created by 张金山 on 2018/10/26.
//  Copyright © 2018年 Junier. All rights reserved.
//

#import "HJSchoolDetailChatViewController.h"
#import <NIMSDK/NIMSDK.h>
#import <NIMSDK/NIMChatroomManagerProtocol.h>

#import "HJSchoolDetailChatCell.h"
#import "HJSchoolLiveInputView.h"
#import "HJSchoolLiveDetailViewModel.h"
#import "HJTeacherChatCell.h"
#import "HJSystemNotyChatCell.h"
#define BottomViewHeight kHeight(40)
@interface HJSchoolDetailChatViewController ()<NIMChatManagerDelegate,NIMChatroomManagerDelegate,UITextFieldDelegate>

@property (nonatomic,strong) HJSchoolLiveInputView *bottomView;

@property (nonatomic,copy) NSString *icon;
@property (nonatomic,copy) NSString *nickName;
@property (nonatomic,copy) NSString *roomId;
@property (nonatomic,assign) BOOL isInRoom;


@end

@implementation HJSchoolDetailChatViewController


-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NIMSDK sharedSDK].chatManager removeDelegate:self];
}


- (void)viewDidLoad {
    self.tableViewStyle = UITableViewStyleGrouped;
    [super viewDidLoad];
    [[NIMSDK sharedSDK].chatManager addDelegate:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:@"UIKeyboardWillShowNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:@"UIKeyboardWillHideNotification" object:nil];
}

- (void)setViewModel:(HJSchoolLiveDetailViewModel *)viewModel {
    _viewModel = viewModel;
    //首先登陆自己的网易云信的账户
    [[[NIMSDK sharedSDK] loginManager] login:_viewModel.model.chat.accid
                                       token:_viewModel.model.chat.tokenid
                                  completion:^(NSError *error) {
                                      if (!error) {
                                          //进入聊天室j操作
                                          NIMChatroomEnterRequest *request = [[NIMChatroomEnterRequest alloc]init];
                                          request.roomId = _viewModel.model.chat.roomid;
                                          request.roomAvatar = [APPUserDataIofo UserIcon];
                                          request.roomNickname = [APPUserDataIofo nikename];
                                          DLog(@"进入直播室:");
                                          [[NIMSDK sharedSDK].chatroomManager enterChatroom:request completion:^(NSError * _Nullable error, NIMChatroom * _Nullable chatroom, NIMChatroomMember * _Nullable me) {
                                              if (!error) {
//                                                  ShowMessage(@"进入直播室成功");
                                                  self.nickName = me.roomNickname;
                                                  self.icon = me.roomAvatar;
                                                  self.isInRoom = YES;
                                              } else {
                                                  NSDictionary *para = error.userInfo;
//                                                  ShowMessage(@"进去直播室失败");
                                                  DLog(@"获取到的数据是:%@ %@",error.userInfo,para[@"NSLocalizedDescription"]);
                                              }

                                          }];
                                      } else {
                                          self.isInRoom = NO;
//                                          ShowMessage(@"登陆网易云信失败");
                                      }
                                  }];
}

- (void)hj_configSubViews{
    self.bottomView = [[HJSchoolLiveInputView alloc] init];
    self.bottomView.inputTextField.delegate = self;

    [self.view addSubview:self.bottomView];
    
    @weakify(self);
    __weak typeof(self)weakSelf = self;
    [weakSelf.bottomView.backSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self commentButtonAction];
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-KHomeIndicatorHeight);
        make.height.mas_equalTo(kHeight(49.0));
    }];

    [self.tableView registerClassCell:[HJSchoolDetailChatCell class]];
    [self.tableView registerClassCell:[HJTeacherChatCell class]];
    [self.tableView registerClassCell:[HJSystemNotyChatCell class]];

    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, BottomViewHeight + KHomeIndicatorHeight, 0));
    }];
    
    //键盘将要弹起的时候
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"SendChatMessageKeyboardShow" object:nil] subscribeNext:^(id x) {
        @strongify(self);
        [self.bottomView.inputTextField becomeFirstResponder];
    }];
    
    //适配iPhone X
    if(isFringeScreen) {
        UIView *bottomView = [[UIView alloc] init];
        bottomView.backgroundColor = white_color;
        [self.view addSubview:bottomView];
        [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.height.mas_equalTo(KHomeIndicatorHeight);
        }];
    }
}

- (void)hj_bindViewModel {
    //打赏支付成功之后发送打赏了什么东西的通知
    @weakify(self);
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"GiftRewardSuccessSendSystemNoty" object:nil] subscribeNext:^(NSNotification *noty) {
        @strongify(self);
        [self recieveGiftRewardSuccessSendSystemNoty:noty];
    }];
}

//收到打赏通知之后进行的操作
- (void)recieveGiftRewardSuccessSendSystemNoty:(NSNotification *)noty{
    NSDictionary *userInfo =  noty.userInfo;
    NSString *giftName = userInfo[@"giftName"];
    NIMMessage *message = [[NIMMessage alloc] init];
    message.text = self.bottomView.inputTextField.text;
    NSDictionary *extDict = @{@"systemNotyMessage" : @"1",
                              @"text" : [NSString stringWithFormat:@"“%@”打赏了一辆“%@”！",self.nickName,giftName],
                              @"giftName" : giftName.length > 0 ? giftName : @""
                              };
    message.remoteExt = extDict;

    //扩展字段
    NIMMessageChatroomExtension *ext = [[NIMMessageChatroomExtension alloc] init];
    ext.roomNickname = self.nickName;
    message.messageExt = ext;
    //聊天会话
    NIMSession *session = [NIMSession session:_viewModel.model.chat.roomid type:NIMSessionTypeChatroom];
    [[[NIMSDK sharedSDK] chatManager] sendMessage:message toSession:session error:nil];
    //取消第一响应者
    [self.bottomView.inputTextField resignFirstResponder];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row < self.viewModel.chatListArray.count) {
        NIMMessage *message = self.viewModel.chatListArray[indexPath.row];
        NSDictionary *extDict = message.remoteExt;
        NSString *systemNotyMessage = extDict[@"systemNotyMessage"];
        NSString *giftName = extDict[@"giftName"];
        NIMMessageChatroomExtension *ext =  message.messageExt;
        if(systemNotyMessage.length > 0) {
            //打赏的系统的通知cell的高度
            NSString *roomText = [NSString stringWithFormat:@"主讲人的的的的的：“%@”打赏了一辆“%@”！",ext.roomNickname,giftName];
            CGFloat height = [roomText calculateSize:CGSizeMake(Screen_Width - kWidth(20), MAXFLOAT)  font:MediumFont(font(13))].height;
            if(height + kHeight(5) > kHeight(20)) {
                return height + kHeight(5);
            }
            kHeight(20);
        } else {
            if([message.from isEqualToString:self.viewModel.model.room.accid]) {
                //学员发的消息cell的高度
                NSString *roomText = [NSString stringWithFormat:@"%@：%@",ext.roomNickname,message.text];
                CGFloat height = [roomText calculateSize:CGSizeMake(Screen_Width - kWidth(20), MAXFLOAT) font:MediumFont(font(13))].height;
                if(height + kHeight(5) > kHeight(20)) {
                    return height + kHeight(5);
                }
                kHeight(20);
            } else {
                //老师发的消息的cell的高度
                NSString *roomText = [NSString stringWithFormat:@"主讲人的的的的%@：%@",ext.roomNickname,message.text];
                CGFloat height = [roomText calculateSize:CGSizeMake(Screen_Width - kWidth(20), MAXFLOAT)  font:MediumFont(font(13))].height;
                if(height + kHeight(5) > kHeight(20)) {
                    return height + kHeight(5);
                }
                kHeight(20);
            }
        }
        
    }
    return  kHeight(50.0);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

//消息的数量
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.viewModel.chatListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row < self.viewModel.chatListArray.count) {
        NIMMessage *message = self.viewModel.chatListArray[indexPath.row];
        NSDictionary *extDict = message.remoteExt;
        NSString *systemNotyMessage = extDict[@"systemNotyMessage"];
        NSString *giftName = extDict[@"giftName"];
        NIMMessageChatroomExtension *ext =  message.messageExt;
        if(systemNotyMessage.length > 0) {
           //打赏的系统消息的通知
            HJSystemNotyChatCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HJSystemNotyChatCell class]) forIndexPath:indexPath];
            cell.backgroundColor = clear_color;
            self.tableView.separatorColor = clear_color;
            cell.hidden = NO;
            NSString *roomText = [NSString stringWithFormat:@"            ：“%@”打赏了一辆“%@”！",ext.roomNickname,giftName];
            NSString *giftN = [NSString stringWithFormat:@"“%@”",giftName];
            cell.nameLabel.attributedText = [roomText attributeWithStr:giftN color:HEXColor(@"#FF4400") font:BoldFont(font(13))];
            return cell;
        } else {
            if(![message.from isEqualToString:self.viewModel.model.room.accid]) {
                //学生发的信息cell
                HJSchoolDetailChatCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HJSchoolDetailChatCell class]) forIndexPath:indexPath];
                self.tableView.separatorColor = clear_color;
                cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
                cell.selectedBackgroundView.backgroundColor = RGBA(255, 255, 255, 0.5);
                cell.hidden = NO;
                NSString *roomText = [NSString stringWithFormat:@"%@：%@",message.senderName,message.text];
                NSString *nickName = [NSString stringWithFormat:@"%@：",message.senderName];
                cell.nameLabel.attributedText = [roomText attributeWithStr:nickName color:HEXColor(@"#999999") font:MediumFont(font(13))];
                return cell;
            } else {
                //老师回复的信息的cell
                HJTeacherChatCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HJTeacherChatCell class]) forIndexPath:indexPath];
                cell.backgroundColor = clear_color;
                self.tableView.separatorColor = clear_color;
                cell.hidden = NO;
                NSString *roomText = [NSString stringWithFormat:@"           %@：%@",ext.roomNickname,message.text];
                NSString *nickName = [NSString stringWithFormat:@"%@：",ext.roomNickname];
                cell.nameLabel.attributedText = [roomText attributeWithStr:nickName color:HEXColor(@"#22476B") font:MediumFont(font(13))];
                return cell;
            }
        }
    }
    HJSchoolDetailChatCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HJSchoolDetailChatCell class]) forIndexPath:indexPath];
    self.tableView.separatorColor = clear_color;
    cell.hidden = YES;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.000001f;
}

#pragma mark -- NIMChatManagerDelegate

//发送聊天室消息
- (void)commentButtonAction{
    if(self.viewModel.liveDetailErrorCode == 29) {
        ShowMessage(@"暂无购买课程或者课程已过期");
        return;
    }
    if (self.isInRoom == NO) {
        ShowMessage(@"进入聊天室失败");
        return;
    }
    if(self.bottomView.inputTextField.text.length <= 0 ) {
        ShowMessage(@"请输入聊天内容");
        return;
    }
    NIMMessage *message = [[NIMMessage alloc] init];
    message.text = self.bottomView.inputTextField.text;
    NSDictionary *extDict = @{@"systemNotyMessage" : @"",
                              @"text" : @"",
                              @"giftName" : @""
                              };
    message.remoteExt = extDict;
    //扩展字段
    NIMMessageChatroomExtension *ext = [[NIMMessageChatroomExtension alloc] init];
    ext.roomNickname = self.nickName;
    message.messageExt = ext;
    //聊天会话
    NIMSession *session = [NIMSession session:_viewModel.model.chat.roomid type:NIMSessionTypeChatroom];
    [[[NIMSDK sharedSDK] chatManager] sendMessage:message toSession:session error:nil];
    //取消第一响应者
    [self.bottomView.inputTextField resignFirstResponder];
}

//发送消息回掉结果
- (void)sendMessage:(NIMMessage *)message didCompleteWithError:(NSError *)error{
    if (!error) {
//        ShowMessage(@"发送成功");
        [self.viewModel.chatListArray addObject:message];
        [self.tableView reloadData];
        self.bottomView.inputTextField.text = nil;
        if(self.viewModel.chatListArray.count > 1) {
            CGFloat yOffset = 0; //设置要滚动的位置 0最顶部 CGFLOAT_MAX最底部
            if (self.tableView.contentSize.height > self.tableView.bounds.size.height) {
                yOffset = self.tableView.contentSize.height - self.tableView.bounds.size.height;
            }
            [self.tableView setContentOffset:CGPointMake(0, yOffset) animated:NO];
        }
    } else {
        DLog(@"发送消息失败:%@",error.userInfo);
    }
}

//收到消息进行的操作
- (void)onRecvMessages:(NSArray<NIMMessage *> *)messages{
    for (NIMMessage *message in messages) {
        NSLog(@"%@",message.text);
        if (message.text.length) {
            [self.viewModel.chatListArray addObject:message];
        }
    }
    [self.tableView reloadData];
}

#pragma mark 空数据的展示
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView{
    NSString *text = @" ";
    NSDictionary *attribute = @{NSFontAttributeName: MediumFont(font(15)), NSForegroundColorAttributeName: HEXColor(@"#999999")};
    return [[NSAttributedString alloc] initWithString:text attributes:attribute];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return nil;
}

- (UIImage *)buttonImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    return nil;
}

#pragma mark - 空白数据集 按钮被点击时 触发该方法：
- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button {
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.text.length > 0) {
        [self commentButtonAction];
        return YES;
    }
    return NO;
}

//键盘即将出现的时候
- (void)keyboardWillShow:(NSNotification *)sender{
    self.bottomView.hidden = NO;
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



@end

